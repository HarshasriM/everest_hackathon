# Fake Call Feature Setup

## Overview
The fake call feature allows users to simulate receiving a phone call with customizable caller details and timer.

## Features Implemented
1. ✅ Caller Details Setup (Name, Number, Image)
2. ✅ Preset Timer (5 sec, 10 sec, 1 min, 5 min)
3. ✅ Incoming Call Screen with ringtone
4. ✅ In-Call Screen with call duration timer
5. ✅ BLoC Pattern Implementation
6. ✅ Image picker for custom caller image

## Ringtone Setup

### Important: Add Ringtone Audio File
To enable ringtone functionality, you need to add an audio file:

1. Create the assets directory structure:
   ```
   assets/
   └── audio/
       └── ringtone.mp3
   ```

2. Add a ringtone audio file named `ringtone.mp3` to the `assets/audio/` directory
   - You can use any MP3 format ringtone
   - Recommended: Keep file size under 1MB for better performance

### Without Ringtone File
If you don't add a ringtone file, the feature will still work but without sound. The app will handle the missing file gracefully.

## How to Use

1. **Navigate to Fake Call Tab**: Tap the "FakeCall" icon in the bottom navigation

2. **Set Caller Details**:
   - Tap on "Caller Details" card
   - Add caller image (Gallery or use Preset avatar)
   - Enter caller name
   - Enter caller number
   - Select timer duration (5 sec, 10 sec, 1 min, or 5 min)
   - Tap "Save"

3. **Start Fake Call**:
   - Tap "Get a call" button
   - Wait for the countdown timer
   - The incoming call screen will appear with ringtone

4. **Incoming Call Screen**:
   - Answer: Opens the in-call screen
   - Decline: Ends the fake call

5. **In-Call Screen**:
   - Shows call duration timer
   - Has call control buttons (Keypad, Mute, Speaker, More)
   - Tap "End Call" to finish

## Architecture

### BLoC Pattern
- **FakeCallEvent**: All user actions (set details, start call, answer, decline, etc.)
- **FakeCallState**: All possible states (initial, setting up, waiting, incoming, in-call, ended)
- **FakeCallBloc**: Business logic handling state transitions and timers

### Services
- **RingtoneService**: Handles audio playback for incoming call ringtone

### Screens
1. **FakeCallScreen**: Main screen with "Get a call" button
2. **CallerDetailsScreen**: Setup caller information
3. **IncomingCallScreen**: Shows incoming call with answer/decline buttons
4. **InCallScreen**: Shows ongoing call with duration and controls

## Dependencies Added
- `image_picker: ^1.1.2` - For selecting caller image
- `audioplayers: ^6.1.0` - For playing ringtone

## Next Steps (Optional Enhancements)
- [ ] Add multiple ringtone options
- [ ] Save recent caller details
- [ ] Add vibration when call comes in
- [ ] Custom ringtone selection from device
- [ ] Schedule multiple fake calls
