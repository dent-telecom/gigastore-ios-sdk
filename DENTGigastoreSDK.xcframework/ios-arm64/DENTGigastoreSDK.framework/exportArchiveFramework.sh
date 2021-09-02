#!/bin/sh

SERVER_TIER="$1"

echo "Server tier: $SERVER_TIER"

###### ARCHIVE ROOT (FINAL BUILD FILES) #######

NEW_ARCHIVE_FOLDER="archives/$SERVER_TIER"

if [ -e "$NEW_ARCHIVE_FOLDER" ]
then
echo "Removing archive root folder"
rm -Rf "$NEW_ARCHIVE_FOLDER"
fi

echo "Creating new archive root folder"
mkdir "$NEW_ARCHIVE_FOLDER"

NEW_OUTPUTE_FOLDER="output/$SERVER_TIER"

if [ -e "$NEW_OUTPUTE_FOLDER" ]
then
echo "Removing output folder"
rm -Rf "$NEW_OUTPUTE_FOLDER"
fi

echo "Creating new output folder"
mkdir "$NEW_OUTPUTE_FOLDER"

###### XCODE BUILD ARCHIVE #######

xcodebuild archive -scheme "DENTGigastoreSDK" -destination "generic/platform=iOS Simulator" -archivePath "./archives/$SERVER_TIER/DENTGigastoreSDK-Simulator" SERVER_TIER="$SERVER_TIER" SKIP_INSTALL="NO" BUILD_LIBRARY_FOR_DISTRIBUTION="YES"

xcodebuild archive -scheme "DENTGigastoreSDK" -destination "generic/platform=iOS" -archivePath "./archives/$SERVER_TIER/DENTGigastoreSDK" SERVER_TIER="$SERVER_TIER" SKIP_INSTALL="NO" BUILD_LIBRARY_FOR_DISTRIBUTION="YES"
 
 
###### XCODE BUILD XCFRAMEWORK #######

xcodebuild -create-xcframework -framework "archives/$SERVER_TIER/DENTGigastoreSDK-Simulator.xcarchive/Products/Library/Frameworks/DENTGigastoreSDK.framework" -framework "archives/$SERVER_TIER/DENTGigastoreSDK.xcarchive/Products/Library/Frameworks/DENTGigastoreSDK.framework" -output "output/$SERVER_TIER/DENTGigastoreSDK.xcframework"

###### COPY SCRIPT #######

NEW_SCRIPT_FOLDER="output/$SERVER_TIER/DENTGigastoreSDK.xcframework/Scripts"

if [ -e "$NEW_SCRIPT_FOLDER" ]
then
echo "Removing script folder"
rm -Rf "$NEW_SCRIPT_FOLDER"
fi
  
echo "Creating new script folder"
mkdir "output/$SERVER_TIER/DENTGigastoreSDK.xcframework/Scripts"

echo "Copy the script into the folder"
cp "Scripts/DENTGigastoreSDKrun-$SERVER_TIER.sh" "output/$SERVER_TIER/DENTGigastoreSDK.xcframework/Scripts/Run.sh"
cp "LICENSE" "output/$SERVER_TIER"

###### ZIP #######

echo "Zipping the xcframework"
mkdir "output/$SERVER_TIER/DENTGigastoreSDK"
cp "output/$SERVER_TIER/LICENSE" "output/$SERVER_TIER/DENTGigastoreSDK/LICENSE"
cp -R "output/$SERVER_TIER/DENTGigastoreSDK.xcframework" "output/$SERVER_TIER/DENTGigastoreSDK/DENTGigastoreSDK.xcframework"

cd "output/$SERVER_TIER/"

zip -9yr "DENTGigastoreSDK.zip" "DENTGigastoreSDK"

cd "../.."
rm "output/$SERVER_TIER/LICENSE"

