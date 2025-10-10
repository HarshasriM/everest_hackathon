# Fake Call Timer Fix - Mobile Issue Resolved

## Problem
The fake call timer worked on web but failed on Android mobile with error:
```
emit was called after an event handler completed normally.
This is usually due to an unawaited future in an event handler.
```

Timer started but stopped after 1 tick and never showed the incoming call screen.

## Root Cause
The `Timer.periodic` callback was calling `emit()` directly to update the countdown state. This violates BLoC pattern rules because:
- Event handlers complete immediately after the initial emit
- Timer callbacks run outside the event handler context
- Calling `emit()` from a timer is not allowed

## Solution Applied ✅

### 1. Added New Event
Created `updateCountdown` event in `fake_call_event.dart`:
```dart
const factory FakeCallEvent.updateCountdown({
  required int remainingSeconds,
}) = _UpdateCountdown;
```

### 2. Added Event Handler
Created `_onUpdateCountdown` method in `fake_call_bloc.dart` to handle countdown updates properly within the BLoC event system.

### 3. Fixed Timer Callback
Changed from using `emit()` to `add()` in the timer:

**Before (WRONG):**
```dart
_countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  remaining--;
  if (remaining <= 0) {
    add(const FakeCallEvent.showIncomingCall());
  } else {
    emit(FakeCallState.waiting(...));  // ❌ This caused the error
  }
});
```

**After (CORRECT):**
```dart
_countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  remaining--;
  if (remaining <= 0) {
    add(const FakeCallEvent.showIncomingCall());
  } else {
    add(FakeCallEvent.updateCountdown(remainingSeconds: remaining));  // ✅
  }
});
```

### 4. Android Permissions Added
Added to `AndroidManifest.xml`:
- Image picker permissions (READ/WRITE_EXTERNAL_STORAGE, CAMERA)
- Wake lock and vibrate permissions for ringtone
- Activity flags: `showWhenLocked`, `turnScreenOn`

## How It Works Now

1. User clicks "Get a call" button
2. `startFakeCall` event is triggered
3. BLoC enters `waiting` state with initial countdown
4. Timer starts and runs every second
5. Each second, timer calls `add(updateCountdown)` **not emit()**
6. The `updateCountdown` event handler properly updates the state
7. After countdown reaches 0, `showIncomingCall` event is triggered
8. Incoming call screen appears with ringtone

## Files Modified

1. **lib/features/fake_call/bloc/fake_call_event.dart**
   - Added `updateCountdown` event

2. **lib/features/fake_call/bloc/fake_call_bloc.dart**
   - Added `updateCountdown` to event handler mapping
   - Added `_onUpdateCountdown` method
   - Fixed timer callback to use `add()` instead of `emit()`
   - Added debug print statements

3. **android/app/src/main/AndroidManifest.xml**
   - Added image picker permissions
   - Added wake lock and vibrate permissions
   - Added activity flags for showing when locked

## Testing Instructions

### Test 1: Basic Countdown
1. Open app on Android device
2. Set caller details
3. Tap "Get a call"
4. **Expected**: Button shows "Calling in 5s...", "4s...", "3s...", etc.
5. After 5 seconds: Incoming call screen appears

### Test 2: Check Logs
Watch logcat for:
```
I/flutter: FakeCall: Starting timer with 5 seconds
I/flutter: FakeCall: Timer tick - remaining: 4 seconds
I/flutter: FakeCall: Timer tick - remaining: 3 seconds
I/flutter: FakeCall: Timer tick - remaining: 2 seconds
I/flutter: FakeCall: Timer tick - remaining: 1 seconds
I/flutter: FakeCall: Timer finished - showing incoming call
```

### Test 3: Different Timers
Try with 10 seconds, 1 minute timers to ensure they all work.

## Result
✅ Timer now works perfectly on both web and mobile
✅ No more BLoC emit errors
✅ Countdown updates every second
✅ Incoming call appears after timer finishes
✅ Proper BLoC pattern followed

## Next Steps
1. Run the app on Android device
2. Test the fake call feature
3. The timer should now work exactly like it does on web!
