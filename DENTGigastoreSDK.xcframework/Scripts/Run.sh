############################################
# Build script for DENTGigastoreSDK.
# Author: Christian Truemper
#
# Modefiy th client info.plist
#
# Parameter: INFO_PATH - path to the info.plist from the client, ENTITLEMENTS_PATH - path to the entitlements from the client
#
############################################


INFO_PATH="$1"
ENTITLEMENTS_PATH="$2"

DOWNLOAD_PLIST="https://camelapi.io/ios-sdk/CarrierDescriptors.plist"
BASE_PLIST="/tmp/CarrierDescriptors.plist"
KEY_INFO="CarrierDescriptors"
EXISTING_KEY_INFO=`/usr/libexec/PlistBuddy -c "Print $KEY_INFO" "$INFO_PATH"`
KEY_ENTITLEMENTS="com.apple.CommCenter.fine-grained"
EXISTING_KEY_ENTITLEMENTS=`/usr/libexec/PlistBuddy -c "Print $KEY_ENTITLEMENTS" "$ENTITLEMENTS_PATH"`


echo "Modifiy the Info.Plist - Path: $INFO_PATH"

curl --url "$DOWNLOAD_PLIST" --output "$BASE_PLIST"

echo "Plist downloaded $BASE_PLIST"

if [ "" == "$EXISTING_KEY_INFO" ]
then
    echo "$KEY_INFO is not existing, adding it now to $INFO_PATH"
    /usr/libexec/PlistBuddy -c "Merge $BASE_PLIST" "$INFO_PATH"
    rm -f "$BASE_PLIST"
else
    echo "$KEY_INFO is existing, deleted and added now to $INFO_PATH"
    /usr/libexec/PlistBuddy -c "Delete :$KEY_INFO" "$INFO_PATH"
    /usr/libexec/PlistBuddy -c "Merge $BASE_PLIST" "$INFO_PATH"
    rm -f "$BASE_PLIST"
fi

echo "Modifiy the <TargetName>.Entitlements - Path: $ENTITLEMENTS_PATH"

if [ "" == "$EXISTING_KEY_ENTITLEMENTS" ]
then
    echo "$KEY_ENTITLEMENTS is not existing, adding it now to $ENTITLEMENTS_PATH"
    /usr/libexec/PlistBuddy -c "add $KEY_ENTITLEMENTS array" -c "add :$KEY_ENTITLEMENTS:0 string public-cellular-plan" "$ENTITLEMENTS_PATH"
    exit $?
else
    echo "$KEY_ENTITLEMENTS is existing in the $ENTITLEMENTS_PATH"
    
    exit $?
fi
