//
//  BJNumberPlateSwift.swift
//  BJNumberPlateSwift
//
//  Created by Sun on 15/10/2016.
//  Copyright © 2016 Sun. All rights reserved.
//


import UIKit
enum BJKeyboardButtonStyle{
    case BJKeyboardButtonStyleProvince
    case BJKeyboardButtonStyleLetter
    case BJKeyboardButtonStyleDelegate
    case BJKeyboardButtonStyleChange
}

class BJKeyboardButton: UIButton {
    var style:BJKeyboardButtonStyle?
    class func keyboardButtonWithStyle(buttonStyle:BJKeyboardButtonStyle) -> (BJKeyboardButton){
          let button = BJKeyboardButton(type:UIButtonType.custom) 
          button.style = buttonStyle
          return button
    }
}

var currentFirstResponder:UIResponder?
extension UIResponder{
    
    func BJFindFirstResponder(sender:Any){
        currentFirstResponder = self 
    }
    
    class func BJCurrentFirstResponder() -> (UIResponder){
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(BJFindFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return currentFirstResponder! 
    }
}

public class BJNumberPlate: UIInputView,UIInputViewAudioFeedback {
    enum BJKeyboardStyle {
        case BJKeyboardStyleProvince
        case BJKeyboardStyleLetter
    }
    private let pArray = ["京","沪","津","渝","冀","晋","辽",
                          "吉","黑","苏","浙","皖","闽","赣",
                          "鲁","豫","鄂","湘","粤","琼","川",
                          "贵","云","陕","甘","青","蒙","桂",
                          "宁","新","藏","台","港","澳"]
    
    private let lArray = ["1", "2", "3", "4", "5", "6", "7", "8",
                          "9", "0", "Q", "W", "E", "R", "T", "Y",
                          "U", "I", "O", "P", "A", "S", "D", "F",
                          "G", "H", "J", "K", "L", "Z", "X", "C",
                          "V", "B", "N", "M"]
    
    private var isProvinceKeyBoard = true
    private let buttonImage = UIImage(named:"key")
    private var changeBtn:BJKeyboardButton?
    private var deleteBtn:BJKeyboardButton?
    private var buttonFont:UIFont?
    
    private var width:CGFloat?
    private var height:CGFloat?
    
    private var provinceArr:Array<BJKeyboardButton>
    private var letterArr:Array<BJKeyboardButton>
    
    private var toolBarView:UIView?
    private var donebutton:UIButton?
    private let toolBarViewHeight:CGFloat = 35.0 
    private let  kKeyHorizontalSpace:CGFloat = 2.0 
    private let  kKeyVerticalSpace:CGFloat = 5.0 
    
    private var keyInput:UIKeyInput?
    
    
    public init(){
        self.provinceArr = [BJKeyboardButton]()
        self.letterArr = [BJKeyboardButton]()
        
        super.init(frame:CGRect.zero, inputViewStyle: UIInputViewStyle.keyboard)
        buttonFont = UIFont.systemFont(ofSize: 18) 
        changeBtn = BJKeyboardButton(type:UIButtonType.custom)
        changeBtn?.setTitle("ABC", for: .normal)
        changeBtn?.style = .BJKeyboardButtonStyleChange
        changeBtn = self.setButtonStyle(button: changeBtn!)
        self.addSubview(changeBtn!)
        
        deleteBtn = BJKeyboardButton(type:UIButtonType.custom)
        deleteBtn?.setImage(UIImage(named:"DeleteEmoticonBtn_ios7@2x.png"), for: .normal)
        deleteBtn?.style = .BJKeyboardButtonStyleDelegate
        deleteBtn = self.setButtonStyle(button: deleteBtn!)
        self.addSubview(deleteBtn!)
        
        var tempArray = [BJKeyboardButton]() 
        for str in pArray {
            var btn = BJKeyboardButton.keyboardButtonWithStyle(buttonStyle:.BJKeyboardButtonStyleProvince)
            btn = self.setButtonStyle(button: btn)
            btn.setTitle(str, for: .normal)
            self.addSubview(btn)
            tempArray.append(btn)
        }
        
        provinceArr = tempArray 
        tempArray = [BJKeyboardButton]() 
        for str in lArray {
            var btn = BJKeyboardButton.keyboardButtonWithStyle(buttonStyle:.BJKeyboardButtonStyleLetter)
            btn = self.setButtonStyle(button: btn)
            btn.setTitle(str, for: .normal)
            self.addSubview(btn)
            tempArray.append(btn)
        }
        
        letterArr = tempArray
        toolBarView = UIView()
        toolBarView?.backgroundColor = self.RGBColor(R: 246.0, G: 246.0, B: 246.0)
        self.addSubview(toolBarView!)
        
        donebutton = UIButton(type:.custom)
        donebutton?.setTitle("完成", for: .normal)
        donebutton?.setTitleColor(UIColor.darkGray, for: .normal)
        donebutton?.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        donebutton?.backgroundColor = UIColor.clear
        donebutton?.addTarget(self, action: #selector(doneButtonAction(button:)), for: .touchUpInside)
        toolBarView?.addSubview(donebutton!)
        self.sizeToFit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let bounds = self.bounds
        self.width = bounds.size.width 
        self.height = bounds.size.height 
        toolBarView?.frame = CGRect(x:0,y:0,width:self.width!,height:toolBarViewHeight) 
        donebutton?.frame = CGRect(x:width! - 40 - 10,y:(toolBarViewHeight - 20)/2,width:40,height:20) 
        if isProvinceKeyBoard{
            self.creatKeyBoardWithType(buttonType: .BJKeyboardStyleProvince, hidenOrNot: false)
        }else{
            self.creatKeyBoardWithType(buttonType: .BJKeyboardStyleLetter, hidenOrNot: false) 
        }
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var tempSize = CGSize()
        tempSize.width = UIScreen.main.bounds.width
        tempSize.height =  UIScreen.main.bounds.height <= 480 ?
                           UIScreen.main.bounds.height*0.4 :
                           UIScreen.main.bounds.height*0.35
        tempSize.height = tempSize.height + toolBarViewHeight
        return tempSize
    }
    
  private  func creatKeyBoardWithType(buttonType type:BJKeyboardStyle , hidenOrNot hiden:Bool){
        var array = [BJKeyboardButton]() //Array<BJKeyboardButton>
        var buttonCount = 0 
        var tempW = 0.00
        
        switch type {
        case .BJKeyboardStyleProvince:
            array = provinceArr
            buttonCount = 28
            tempW = 0.0
        case .BJKeyboardStyleLetter:
            array = letterArr
            buttonCount = 29
            tempW = 0.5
        }
        
        height = height! - toolBarViewHeight
        let KeyWidth = (width!/10.0 - kKeyHorizontalSpace*2.0)
        let KeyHeight = (height!/4.0 - kKeyVerticalSpace*2.0) 
        for index in 0...(array.count-1){
            let btn = array[index]
            btn.isHidden = hiden
            var k = index
            var j = index/10
            if index >= 10 && index < buttonCount {
                k = index % 10
            }else if index >= buttonCount {
                k = index - buttonCount
                j = 3
            }
            if index < 20{
                btn.frame = CGRect(x:kKeyHorizontalSpace + CGFloat(k)*(width!/10),
                                                   y:toolBarViewHeight+kKeyVerticalSpace + CGFloat(j)*(height! / 4),
                                                   width:KeyWidth,
                                                   height:KeyHeight)
            }else if index < buttonCount{
                btn.frame  = CGRect(x:kKeyHorizontalSpace + (CGFloat(k+1)-CGFloat(tempW)) * (width!/10.0),
                                                    y:toolBarViewHeight+kKeyVerticalSpace + CGFloat(j)*(height!/4),
                                                    width:KeyWidth,
                                                    height:KeyHeight)
                
            }else{
                btn.frame = CGRect(x:kKeyHorizontalSpace + (CGFloat(k+2)-CGFloat(tempW))*(width!/10),
                                                   y:toolBarViewHeight+kKeyVerticalSpace + CGFloat(j)*(height!/4),
                                                   width:KeyWidth,
                                                   height:KeyHeight)
                
            }
        }
        deleteBtn?.frame = CGRect(x:width! - KeyWidth*1.5 - kKeyHorizontalSpace,
                                                     y:height! - KeyHeight - kKeyVerticalSpace+toolBarViewHeight,
                                                     width:KeyWidth*1.5,
                                                     height:KeyHeight)
    
        changeBtn?.frame = CGRect(x:kKeyHorizontalSpace,
                                                         y:height! - KeyHeight - kKeyVerticalSpace+toolBarViewHeight,
                                                         width:KeyWidth * 1.5,
                                                         height:KeyHeight)
    }
    
   private func setButtonStyle(button:BJKeyboardButton) -> (BJKeyboardButton){
        button.isExclusiveTouch = true
        button.backgroundColor = UIColor.clear
        button.setBackgroundImage(buttonImage, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = buttonFont
        button.addTarget(self,
                         action: #selector(buttonInput(button:)),
                            for: .touchUpInside) 
        button.addTarget(self,
                         action: #selector(buttonPlayClick(button:)),
                            for: .touchDown) 
        return button
    }
    
     func buttonInput(button:BJKeyboardButton){
        keyInput = findKeyInput()
        if keyInput == nil{
            return
        }
        if button.style == .BJKeyboardButtonStyleProvince ||
           button.style == .BJKeyboardButtonStyleLetter{
            keyInput?.insertText((button.titleLabel?.text)!)
        }else if button.style == .BJKeyboardButtonStyleDelegate{
            keyInput?.deleteBackward()
        }else if button.style == .BJKeyboardButtonStyleChange{
            isProvinceKeyBoard = !isProvinceKeyBoard
            
            for case let btn as BJKeyboardButton in self.subviews{
                if isProvinceKeyBoard{
                    if btn.style == .BJKeyboardButtonStyleLetter{
                        self.creatKeyBoardWithType(buttonType: .BJKeyboardStyleLetter, hidenOrNot: true)
                    }else if btn.style == .BJKeyboardButtonStyleProvince{
                        self.creatKeyBoardWithType(buttonType: .BJKeyboardStyleProvince, hidenOrNot: false)
                    }
                }else{
                    if btn.style == .BJKeyboardButtonStyleProvince{
                        self.creatKeyBoardWithType(buttonType: .BJKeyboardStyleProvince, hidenOrNot: true)
                    }else if btn.style == .BJKeyboardButtonStyleLetter{
                        self.creatKeyBoardWithType(buttonType: .BJKeyboardStyleLetter, hidenOrNot: false) 
                    }
                }
            }
            
            if isProvinceKeyBoard{
                changeBtn?.setTitle("ABC", for: .normal)
            }else{
                changeBtn?.setTitle("省份", for: .normal)
            }
        }
    }
    
    func findKeyInput() ->(UIKeyInput?){
        keyInput = UIResponder.BJCurrentFirstResponder() as? UIKeyInput
        if (keyInput?.conforms(to:UITextInput.self))!{
            return keyInput
        }else{
            return nil
        }
    }
    
     func buttonPlayClick(button:BJKeyboardButton){
        UIDevice.current.playInputClick()
    }
    
   public  var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    func doneButtonAction(button:UIButton){
        if UIResponder.BJCurrentFirstResponder().isFirstResponder{
           UIResponder.BJCurrentFirstResponder().resignFirstResponder()
        }else{
          print("BJNumberPlate>>>>Not Find First responder")
        }
    }
    
    private func RGBColor(R r:CGFloat,G g:CGFloat,B b:CGFloat) ->(UIColor){
        let color = UIColor(red:r/255.0,green:g/255.0,blue:b/255.0,alpha:1.0) 
        return color
    }
}
