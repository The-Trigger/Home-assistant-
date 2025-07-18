#!/bin/bash

# Smart Bag Controller Setup Script
echo "🎒 Setting up Smart Bag Controller..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Check if React Native CLI is installed
if ! command -v npx &> /dev/null; then
    echo "❌ npx is not available. Please install Node.js properly."
    exit 1
fi

echo "✅ Node.js found: $(node --version)"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if Android development environment is set up
if [ ! -z "$ANDROID_HOME" ]; then
    echo "✅ Android SDK found at: $ANDROID_HOME"
else
    echo "⚠️  ANDROID_HOME not set. Please set up Android development environment."
    echo "See: https://reactnative.dev/docs/environment-setup"
fi

# Create directories if they don't exist
mkdir -p android/app/src/main/assets
mkdir -p android/app/src/main/res/values

# Create strings.xml if it doesn't exist
if [ ! -f "android/app/src/main/res/values/strings.xml" ]; then
    echo "📝 Creating strings.xml..."
    cat > android/app/src/main/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">Smart Bag Controller</string>
</resources>
EOF
fi

# Create styles.xml if it doesn't exist
if [ ! -f "android/app/src/main/res/values/styles.xml" ]; then
    echo "📝 Creating styles.xml..."
    cat > android/app/src/main/res/values/styles.xml << 'EOF'
<resources>
    <!-- Base application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.DayNight.NoActionBar">
        <!-- Customize your theme here. -->
        <item name="android:editTextBackground">@drawable/rn_edit_text_material</item>
    </style>
</resources>
EOF
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Connect your Android device or start an emulator"
echo "2. Run: npx react-native run-android"
echo "3. Upload Arduino code from arduino/smart_bag_controller/"
echo "4. Pair your Arduino Bluetooth module"
echo ""
echo "📚 For detailed instructions, see README.md"
echo ""
echo "🔧 Hardware setup:"
echo "- Arduino Mega 2560"
echo "- HC-05/HC-06 Bluetooth module"
echo "- Servo motor (umbrella control)"
echo "- LM35 temperature sensor"
echo "- Battery monitoring circuit"
echo ""
echo "Happy coding! 🚀"