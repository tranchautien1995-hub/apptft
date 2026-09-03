#!/bin/bash
set -e
rm -rf build Payload TFTMeta18-iOS15.ipa
xcodebuild \
  -project TFTMeta18.xcodeproj \
  -scheme TFTMeta18 \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath build \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build
mkdir Payload
cp -R build/Build/Products/Release-iphoneos/TFTMeta18.app Payload/
/usr/bin/ditto -c -k --sequesterRsrc --keepParent Payload TFTMeta18-iOS15.ipa
echo "Done: TFTMeta18-iOS15.ipa"
