# DENTGigastoreSDK

&nbsp;
&nbsp;
## Introduction
SDK for installing DENT Gigastore eSIMs in third party apps.

### Availability
DENT Gigastore SDK is currently in closed beta for iOS. You can request access [here](https://docs.google.com/forms/d/e/1FAIpQLSeh5PnexP1y6toBaN856_KkCM1OuWW-5qm3Yu6R-Z15abDFfg/viewform).

&nbsp;
&nbsp;
## First Steps
DENT Gigastore SDK for iOS

### Prerequisites
You need a [DENT Gigastore](https://dent.giga.store/) account to use the SDK.
Make sure that your Gigastore inventory is filled up. Using this SDK you can pick (activate) an eSIM from your inventory and install eSIM profiles through your app on a user's device.
&nbsp;
For the initialization, you need an SDK Key. For now please contact us.

### Technical Requirements

>  The eSIM installation works only iOS 12.1+

- iOS 11.0+
- Xcode 12+
- Swift 5.3+

### Supported devices

- iPhone 12, iPhone 12 Pro and iPhone 12 Pro Max, iPhone 12 Mini,
- iPhone SE (2020)
- iPhone 11, iPhone 11 Pro and iPhone 11 Pro Max, 
- iPhone XR, iPhone XS and iPhone XS Max  

&nbsp;
&nbsp;
## Download SDK
You can download the SDK using one of the supported package managers.

> The SDK is currently in private beta and will be available soon.

### PackageManager

> Please set in the "Build phase" the Run script. If this is not set, your Info.plist cannot be provided with the correct information. Please also consider that the `<TargetName>.entitlements` have to be extended.
No eSIM profiles could then be installed on the device via the DENTGigastoreSDK.

### CocoaPods

> Note: This feature is only available with CocoaPods 1.10.0 or later.

In your Podfile:

```ruby
use_frameworks!

platform :ios, '11.0'

target 'TARGET_NAME' do
    pod 'DENTGigastoreSDK', :git => 'https://github.com/dentwireless/gigastore-ios-sdk.git', 
                          :tag => '1.0.1'
end

```

Replace `TARGET_NAME`. Then, in the Podfile directory, type:

```ruby
pod install

```

### Carthage

In your Cartfile:

```ruby
binary "https://camelapi.io/ios-sdk/release/DENTGigastoreSDK.json" ~> 1.0.1

```

### Swift Package Manager

> Note: This feature is only available with Swift 5.3 (Xcode 12) or later.

Add the following to your `dependencies` value of your `Package.swift` file.

```swift
dependencies: [
  .package(
    url: "https://github.com/dentwireless/gigastore-ios-sdk.git",
    from: "1.0.1")
  )
]

```

### Manually

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```ruby
  $ git init
```

- Add DENTGigastoreSDK as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

```ruby
  $ git submodule add https://github.com/dentwireless/gigastore-ios-sdk.git
```
  
- Or download the `DENTGigastoreSDK.xcframework` manually
- Open the new `DENTGigastoreSDK` folder, and drag the `DENTGigastoreSDK.xcframework` file into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Go to the "Embedded Binaries" section.
- Set the checkmark for "Code Sign On Copy" on the `DENTGigastoreSDK.xcframework`
- And that's it!

  > The `DENTGigastoreSDK.xcframework` is automatically added as a target dependency, linked framework and embedded framework in a copy files build phase. This is all you need to create a build for the simulator or a device.
  
## Add Build Phase
These steps are crucial in order to enable eSIM profile installations via the DENT Gigastore SDK.

### Info.plist and Entitlements
> Please make sure that you have a `<TargetName>.entitlements` in your project.

Your Info.plist and your `<TargetName>.entitlements` must be extended.

- In the tab bar at the top of the window, open the "Build Phases" panel.
- Above the "+" icon, add a "New Run Script Phase"
- Add this line with the path to the SDK script, the path to your info.plist, and the path to your `<TargetName>.entitlements`

```bash
"'PATH_TO_THE_SDK'/DENTGigastoreSDK.xcframework/Scripts/Run.sh" \
"${PROJECT_DIR}/${INFOPLIST_FILE}" \
"${PROJECT_DIR}/PATH_TO_THE_ENTITLEMENTS/<TargetName>.entitlements"

```

&nbsp;
&nbsp;
## Integrate SDK

### Import
  
Import the `DENTGigastoreSDK` into your file.
  
```swift
import DENTGigastoreSDK

```

### Load

The `load` function initializes the DENTGigastoreSDK. Please make sure to include your "SDK Key" here. 
You can find your SDK Key in the [DENT Gigastore](https://dent.giga.store/) under "SDK -> iOS -> Sales Channel".

```swift
let sdkKey = "SDK KEY"

Gigastore.load(withSDKKey: sdkKey)

```

### Set UserToken​

Please use an identifier from your system. You can e.g. use a self-signed JSON Web Token (JWT) as the `userToken. 
That way you are able to verify the requesting device on your server when receiving the activation request webhook from DENT.

```swift
let userToken = "USER_TOKEN_1234567"

​Gigastore.setUserToken(userToken: userToken)

```

> This parameter will be provided in the ActivationRequest Webhook to enable your server to check if the user is eligible to activate an eSIM. This parameter will not be stored on our servers.

&nbsp;
&nbsp;
## Prepare eSIM Installation

### Check for eSIM capable device
First, you need to check if the device is eSIM capable.

The `isEsimCapable` function can be used to check whether the device is eSIM capable or not.

> This query may take some time to complete.

```swift
Gigastore.isEsimCapable(completion: { (isCapable) in
    print("EsimCapable: \(isCapable)")
})

```

If a "false" is returned from the query despite the following criteria being met:

- Your device is eSIM capable
- You have added the run script for your Info.plist and your `<TargetName>.entitlements`

Then there is likely another problem.
If this problem persists, please contact support@dentwireless.com

### Activate Inventory Item
The `activateItem` can be used to activate one item from your DENT Gigastore inventory and provide an installable eSIM profile. 
Check the inventory details to find the matching Inventory IDs.
&nbsp;
You can add additional information in the metatag parameter. This information will be stored in Gigastore and is available in the "Sales History" section.

> To verify the device and user, our server will send a WebHook ActivationRequest including the passed parameters to your server. 

The method will return a profile you can install in the next step using Install Profile.

```swift
let inventoryItemId = "1GB"
let metaTag = "additional information for you"

Gigastore.activateItem(inventoryItem: inventoryItemId,
                             metaTag: metaTag
                          completion: { (profile, error) in
    print("PreparedProfile: \(profile), error: \(error)")
})

```

&nbsp;
&nbsp;
## Install eSIM

The `installProfile` method can be used to install an eSIM profile on a user's device. The device operating system will show up an installation wizard for the user.

```swift
let profile: GigastoreESIMProfile = <use activateInventory method>

Gigastore.installProfile(profile: profile,
                      completion: { (profile, error) in
    print("profile: \(profile)")
    print("error: \(error)")
})

```
This function returns either the installed profile or an error object containing the error.

&nbsp;
&nbsp;
## All Profiles
The `getAllProfiles` function can be used to return all eSIM profiles created for the device or an error.

```swift
Gigastore.getAllProfiles(completion: { (profiles, error) in
    print("Profiles: \(profiles ?? [])")
    print("Error: \(error)")
})

```

&nbsp;
&nbsp;
## Webhook
To approve an eSIM activation you need to implement this callback on your server. If the client is allowed to install an eSIM a successful response is expected from our backend. DENT is sending the webhook as POST request.

> Please provide your server URL to your DENT contact. 
Only HTTPS server URLs are allowed. 

### Request Parameters

| Attribute       | Type     | Example            | Info                        |
| ----------------- | --------- | --------- |:------------------------------:| 
| inventoryItemId    | string    | 1_GB         | The inventoryItemId from Gigastore that you provided in activateItem |
| userToken     | string    | USER_TOKEN_1234567     | The userToken you provided in setUserToken |
| metaTag | string    | myTag  | The metaTag you provided in activateItem |
| activationId | string   | 1e0da3933156  | A unique id provided for reference. |

#### Sample Request
```json
{
    "inventoryItemId": "1_GB",
    "userToken": "USER_TOKEN_1234567",
    "metaTag": myTag,
    "activationId": "1e0da3933156"
}

```

### Request Parameters

| Attribute       | Type     | Limitation            | 
| ----------------- | --------- |:------------------------------:| 
| returnCode    | string    | "SUCCESS" or "FAIL"      |
| returnMessage     | string    |  |

#### Sample Request
```json
{
    "returnCode":"SUCCESS",
    "returnMessage":null
}

```
> Your server should always return 200.

&nbsp;
&nbsp;
## Changelog

### 1.0.0

- Initial release

### 1.0.1

- Exposed iccid of profile

&nbsp;
&nbsp;
## Credits

DENTGigastoreSDK is owned and maintained by [DENT Wireless Limited](https://www.dentwireless.com).
