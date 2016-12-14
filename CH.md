# BJNumberPlate
--

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/iusn/BJNumberPlate/blob/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/BJNumberPlateOC.svg?style=flat)](http://cocoapods.org/?q= BJNumberPlateOC)&nbsp;
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/BJNumberPlateOC.svg)](https://img.shields.io/cocoapods/v/BJNumberPlateOC.svg)
[![Support](https://img.shields.io/badge/support-iOS7.0+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Support](https://img.shields.io/badge/support-Autolayout-orange.svg?style=flatt)](https://www.apple.com/)&nbsp;
[![Build Status](https://travis-ci.org/yate1996/YYStock.svg?branch=master)](https://github.com/iusn/BJNumberPlate)

[英文](https://github.com/iusn/BJNumberPlate/blob/master/README.md)

BJNumberPlate 是用 Swift 3.0 和 OC 写的一个车牌号码键盘输入库

[swift版本](https://github.com/iusn/BJNumberPlateSwift)
[OC版本](https://github.com/iusn/BJNumberPlateOC)

## Screenshot

![image](https://github.com/iusn/BJNumberPlate/blob/master/gif.gif)

##如何使用
在`Podfile`中加入下代码

###Objective-C
```ruby
platform :ios, '7.0'

target 'TargetName' do

pod 'BJNumberPlateOC'

end
```
在项目是需要用到的地方

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
在项目用需要使用的地方

```swift
let keyboard = BJNumberPlate()
textField.inputView = keyboard;
```