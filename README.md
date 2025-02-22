# DENTGigastoreSDK

&nbsp;
&nbsp;
## Introduction
SDK for installing DENT Gigastore eSIMs in third party apps.

### Availability
To download a DENT eSIM in your app through Apple’s eSIM API, DENT needs to register your app.
To start this process, follow the instructions here: https://docs.giga.store/ios/enable-direct-installation

&nbsp;
&nbsp;
## First Steps
DENT Gigastore SDK for iOS

### Prerequisites
You need a [DENT Gigastore](https://dent.giga.store/) account to use the SDK.

To download a DENT eSIM in your app through Apple’s eSIM API, DENT needs to register your app.
To start this process, follow the instructions here: https://docs.giga.store/ios/enable-direct-installation

Make sure that your Gigastore inventory is filled up. Using this SDK you can pick (activate) an eSIM from your inventory and install eSIM profiles through your app on a user's device.
&nbsp;

For the initialization, you need an SDK Key. You can find it in the Gigastore portal: https://dent.giga.store/#/sdk/ios-sdk .

### Technical Requirements

>  The eSIM installation works only iOS 12.1+

- iOS 11.0+
- Xcode 12+
- Swift 5.3+

### Supported devices

- iPhone 16, iPhone 16 Plus, iPhone 16 Pro and iPhone 16 Pro Max
- iPhone 15, iPhone 15 Plus, iPhone 15 Pro and iPhone 15 Pro Max
- iPhone 14, iPhone 14 Plus, iPhone 14 Pro and iPhone 14 Pro Max
- iPhone 13, iPhone 13 Pro, iPhone 13 Pro Max and iPhone 13 Mini
- iPhone 12, iPhone 12 Pro, iPhone 12 Pro Max and iPhone 12 Mini
- iPhone SE (2020, 2022)
- iPhone 11, iPhone 11 Pro and iPhone 11 Pro Max
- iPhone XR, iPhone XS and iPhone XS Max

&nbsp;
&nbsp;
## Download SDK
You can download the SDK using one of the supported package managers.

### PackageManager

> After installing via Package Manager, follow the instructions in "Add Build Phase"

### CocoaPods

> Note: This feature is only available with CocoaPods 1.10.0 or later.

In your Podfile:

```ruby
use_frameworks!

platform :ios, '11.0'

target 'TARGET_NAME' do
    pod 'DENTGigastoreSDK', :git => 'https://github.com/dent-telecom/gigastore-ios-sdk.git', 
                          :tag => '1.1.0'
end

```

Replace `TARGET_NAME`. Then, in the Podfile directory, type:

```ruby
pod install

```

### Carthage

In your Cartfile:

```ruby
binary "https://camelapi.io/ios-sdk/release/DENTGigastoreSDK.json" ~> 1.1.0

```

### Swift Package Manager

> Note: This feature is only available with Swift 5.3 (Xcode 12) or later.

Add the following to your `dependencies` value of your `Package.swift` file.

```swift
dependencies: [
  .package(
    url: "https://github.com/dent-telecom/gigastore-ios-sdk.git",
    from: "1.1.0")
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
  $ git submodule add https://github.com/dent-telecom/gigastore-ios-sdk.git
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
If this problem persists, please contact support@denttelecom.io

### Fetch the eSIM Profile
The `getProfile` function can be used to fetch an eSIM profile by profileUID.
Once fetched, this profile can be installed using the installProfile method. 
The profileUID will be provided by the API: https://docs.giga.store/api/first-package.

The method will return a profile you can install in the next step using Install Profile.
&nbsp;

```swift
let profileUID = "12345-abcde-fgh" // from API

Gigastore.getProfile(profileUID: profileUID,
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


```

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

- Expose iccid

### 1.0.2

- Test mode

### 1.0.3

- Added "Privacy Manifest File"

### 1.0.4

- Bugfix

### 1.1.0

- Introducing the getProfile method and deprecated existing flows
- Changed logic for test mode in the load function

&nbsp;
&nbsp;
## Credits

DENTGigastoreSDK is owned and maintained by [DENT Telecom GmbH](https://www.denttelecom.io).
