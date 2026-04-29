name: Build MoonManager IPA
on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Install Dependencies
        run: brew install ldid

      - name: Setup Theos
        run: |
          rm -rf ~/theos
          git clone --recursive https://github.com/theos/theos.git ~/theos
          echo "THEOS=~/theos" >> $GITHUB_ENV

      - name: Setup SDK
        run: |
          rm -rf ~/theos/sdks
          git clone https://github.com/theos/sdks.git ~/theos/sdks

      - name: Build Application
        run: |
          export THEOS=~/theos
          make clean all

      - name: Create IPA with Info.plist
        run: |
          mkdir -p Payload
          APP_FOLDER=$(find .theos/obj/ -name "*.app" -type d | head -n 1)
          cp -r "$APP_FOLDER" Payload/
          
          # إنشاء ملف Info.plist أساسي إذا لم يكن موجوداً (هذا يمنع الكراش)
          if [ ! -f "Payload/MoonManager.app/Info.plist" ]; then
            cat <<EOF > Payload/MoonManager.app/Info.plist
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
              <key>CFBundleExecutable</key>
              <string>MoonManager</string>
              <key>CFBundleIdentifier</key>
              <string>com.huss.moonmanager</string>
              <key>CFBundleName</key>
              <string>MoonManager</string>
              <key>CFBundlePackageType</key>
              <string>APPL</string>
              <key>CFBundleShortVersionString</key>
              <string>1.0</string>
              <key>LSRequiresIPhoneOS</key>
              <true/>
              <key>MinimumOSVersion</key>
              <string>14.0</string>
              <key>UILaunchStoryboardName</key>
              <string>LaunchScreen</string>
              <key>UIRequiredDeviceCapabilities</key>
              <array>
                  <string>arm64</string>
              </array>
          </dict>
          </plist>
          EOF
          fi

          # التوقيع المبدئي للملفات التنفيذية
          ldid -S Payload/MoonManager.app/MoonManager
          
          zip -r MoonManager.ipa Payload/

      - name: Upload Finished IPA
        uses: actions/upload-artifact@v4
        with:
          name: MoonManager-Success
          path: MoonManager.ipa
