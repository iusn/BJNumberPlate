# BJNumberPlate
--

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/iusn/BJNumberPlate/blob/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/BJNumberPlateOC.svg?style=flat)](http://cocoapods.org/?q= BJNumberPlateOC)&nbsp;
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/BJNumberPlateOC.svg)](https://img.shields.io/cocoapods/v/BJNumberPlateOC.svg)
[![Support](https://img.shields.io/badge/support-iOS7.0+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Support](https://img.shields.io/badge/support-Autolayout-orange.svg?style=flatt)](https://www.apple.com/)&nbsp;
[![Build Status](https://travis-ci.org/yate1996/YYStock.svg?branch=master)](https://github.com/iusn/BJNumberPlate)


BJNumberPlate is a custom number plate keyboard, it's easy to use. Support Swift 3.0 and OC.


## Screenshot

![image](https://github.com/iusn/BJNumberPlate/blob/master/gif.gif)

##how to use
To integrate BJNumberPlate into your Xcode project using CocoaPods, specify it in your `Podfile`:


###Objective-C
```ruby
platform :ios, '7.0'

target 'TargetName' do

pod 'BJNumberPlateOC'

end
```


```objective-c
BJNumberPlateOC *numberPlate = [[BJVehicleNumberPlate alloc] initWithFrame:CGRectZero];

textField.inputView = numberPlate;

```

###Swift
```ruby
platform :ios, '7.0'

target 'TargetName' do

use_frameworks!
pod 'BJNumberPlateSwift'

end
```

```swift

```






Then, run the following command:

```bash
$ pod install
```





##License
BJNumberPlate is provided under the MIT license. See LICENSE file for details.
