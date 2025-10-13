@echo off
echo Loading environment variables from .env file...

REM Read the .env file and extract the Google Maps API key
for /f "tokens=1,2 delims==" %%a in (.env) do (
    if "%%a"=="GOOGLE_MAPS_API_KEY" set GOOGLE_MAPS_API_KEY=%%b
)

if "%GOOGLE_MAPS_API_KEY%"=="" (
    echo Error: GOOGLE_MAPS_API_KEY not found in .env file
    echo Please make sure your .env file contains: GOOGLE_MAPS_API_KEY=your_api_key_here
    pause
    exit /b 1
)

echo Running Flutter app with API keys...
flutter run --dart-define=GOOGLE_MAPS_API_KEY=%GOOGLE_MAPS_API_KEY%
