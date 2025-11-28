#!/bin/bash

# Script to process dart-define variables for iOS builds with .env fallback
# This script extracts GOOGLE_MAPS_API_KEY from dart-define or .env file

GOOGLE_MAPS_API_KEY=""

# First try to get from dart-define
if [ -n "$DART_DEFINES" ]; then
    # Decode base64 dart defines
    DECODED_DEFINES=$(echo "$DART_DEFINES" | base64 -d)
    
    # Extract GOOGLE_MAPS_API_KEY
    GOOGLE_MAPS_API_KEY=$(echo "$DECODED_DEFINES" | grep -o 'GOOGLE_MAPS_API_KEY=[^,]*' | cut -d'=' -f2)
fi

# If not found in dart-define, try to read from .env file
if [ -z "$GOOGLE_MAPS_API_KEY" ] && [ -f "${SRCROOT}/../.env" ]; then
    GOOGLE_MAPS_API_KEY=$(grep "^GOOGLE_MAPS_API_KEY=" "${SRCROOT}/../.env" | cut -d'=' -f2)
fi

# Set the API key if found
if [ -n "$GOOGLE_MAPS_API_KEY" ]; then
    echo "GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY" >> "${SRCROOT}/Flutter/Generated.xcconfig"
fi
