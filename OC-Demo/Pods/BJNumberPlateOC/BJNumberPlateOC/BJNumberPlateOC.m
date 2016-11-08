//
//  BJVehicleNumberPlate.m
//  BJVehicleNumberPlate
//
//  Created by Sun on 14/10/2016.
//  Copyright © 2016 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BJScreenHeight [UIScreen mainScreen].bounds.size.height
#define BJRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#pragma mark - FirstResponder
static __weak id currentFirstResponder;
@implementation UIResponder (FirstResponder)

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
+ (id)BJ_currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(BJ_findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}
- (void)BJ_findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}
@end


#pragma mark - BJKeyboardButton
@interface BJKeyboardButton : UIButton
typedef NS_ENUM(NSUInteger, BJKeyboardButtonStyle) {
    BJKeyboardButtonStyleProvince,
    BJKeyboardButtonStyleLetter,
    BJKeyboardButtonStyleDelegate,
    BJKeyboardButtonStyleChange,
};

+ (BJKeyboardButton *)keyboardButtonWithStyle:(BJKeyboardButtonStyle)style;
@property (assign, nonatomic) BJKeyboardButtonStyle style;
@end

@implementation BJKeyboardButton
+ (BJKeyboardButton *)keyboardButtonWithStyle:(BJKeyboardButtonStyle)style
{
    BJKeyboardButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.style = style;
    return button;
}

@end




#pragma mark - BJVehicleNumberPlate
#import "BJNumberPlateOC.h"

typedef NS_ENUM(NSUInteger, BJKeyboardStyle) {
    BJKeyboardStyleProvince,
    BJKeyboardStyleLetter,
};

@interface BJNumberPlateOC ()<UIInputViewAudioFeedback>
{
    BOOL isProvinceKeyBoard;
    NSArray *provinceArr;
    NSArray *letterArr;
    UIImage *buttonImage;
    BJKeyboardButton *changeBtn;
    BJKeyboardButton *deleteBtn;

    UIView *toolBarView;
    UIButton *donebutton;
    
    UIFont *buttonFont;
}
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) id <UIKeyInput> keyInput;
@end


@implementation BJNumberPlateOC
const CGFloat  kKeyHorizontalSpace = 2.0f;
const CGFloat  kKeyVerticalSpace = 5.0f;
const CGFloat  toolBarViewHeight = 35.0f;

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame inputViewStyle:UIInputViewStyleKeyboard];
    
    if (self) {
        
        self.backgroundColor = BJRGBAColor(221.0f, 225.0f, 226.0f, 1.0f);
        isProvinceKeyBoard = YES;
        buttonImage = [UIImage imageNamed:@"key"];
        buttonFont = [UIFont systemFontOfSize:18.0f];
        NSArray *pArray = @[@"京", @"沪",@"津", @"渝", @"冀", @"晋", @"辽",
                            @"吉", @"黑", @"苏", @"浙", @"皖", @"闽", @"赣",
                            @"鲁", @"豫", @"鄂", @"湘", @"粤", @"琼", @"川",
                            @"贵", @"云", @"陕", @"甘", @"青", @"蒙", @"桂",
                            @"宁", @"新", @"藏", @"台", @"港", @"澳"];
        NSArray *lArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
                            @"9", @"0", @"Q", @"W", @"E", @"R", @"T", @"Y",
                            @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F",
                            @"G", @"H", @"J", @"K", @"L", @"Z", @"X", @"C",
                            @"V", @"B", @"N", @"M"];
        
        //change Button
        changeBtn = [BJKeyboardButton keyboardButtonWithStyle:BJKeyboardButtonStyleChange];
        [changeBtn setTitle:@"ABC" forState:UIControlStateNormal];
        changeBtn = [self setButtonStyle:changeBtn];
        [self addSubview:changeBtn];
        
        //delete Button
        deleteBtn = [BJKeyboardButton keyboardButtonWithStyle:BJKeyboardButtonStyleDelegate];
        [deleteBtn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7@2x.png"] forState:UIControlStateNormal];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        deleteBtn = [self setButtonStyle:deleteBtn];
        [self addSubview:deleteBtn];
        
        NSMutableArray *temparray = [NSMutableArray array];
        for (int i = 0; i < pArray.count; i++) {
            BJKeyboardButton *btn = [BJKeyboardButton keyboardButtonWithStyle:BJKeyboardButtonStyleProvince];
            [btn setExclusiveTouch:YES];
            btn = [self setButtonStyle:btn];
            [btn setTitle:pArray[i] forState:UIControlStateNormal];
            [self addSubview:btn];
            [temparray addObject:btn];
        }
        
        provinceArr = temparray;
        temparray = [NSMutableArray array];
        for (int i = 0; i < lArray.count; i++) {
            BJKeyboardButton *btn = [BJKeyboardButton keyboardButtonWithStyle:BJKeyboardButtonStyleLetter];
            [btn setExclusiveTouch:YES];
            btn = [self setButtonStyle:btn];
            [btn setTitle:lArray[i] forState:UIControlStateNormal];
            [self addSubview:btn];
            [temparray addObject:btn];
        }
        letterArr = temparray;
        
        {
            toolBarView = [[UIView alloc] initWithFrame:CGRectZero];
            toolBarView.backgroundColor = BJRGBAColor(246.0f, 246.0f, 246.0f, 1.0f);
            [self addSubview:toolBarView];
            
            donebutton = [UIButton buttonWithType:UIButtonTypeCustom];
            donebutton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            donebutton.backgroundColor = [UIColor clearColor];
            [donebutton setTitle:@"完成" forState:UIControlStateNormal];
            [donebutton addTarget:self
                           action:@selector(doneButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
            [donebutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [toolBarView addSubview:donebutton];
        }
        
        [self sizeToFit];
    }
    return self;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect bounds = (CGRect){
        .size = self.bounds.size
    };
    
    _width = bounds.size.width;
    _height = bounds.size.height;
    
    if (isProvinceKeyBoard) {
        [self creatKeyBoardWithType:BJKeyboardStyleProvince andHidden:NO];
    }else{
        [self creatKeyBoardWithType:BJKeyboardStyleLetter andHidden:NO];
    }
    
    toolBarView.frame = CGRectMake(0,0,_width, toolBarViewHeight);
    donebutton.frame = CGRectMake(_width - 40 -10,(toolBarViewHeight - 20)/2, 40, 20);
    
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.width = [UIScreen mainScreen].bounds.size.width;
    size.height = (BJScreenHeight <= 480 ? BJScreenHeight * 0.4 : BJScreenHeight * 0.35);
    size.height +=toolBarViewHeight;
    return size;
}

- (void)creatKeyBoardWithType:(BJKeyboardStyle)type andHidden:(BOOL)buttonHidden{
    
    NSArray *array = [NSArray array];
    int buttonCount = 0;
    CGFloat tempW = 0.0;
    switch (type) {
        case BJKeyboardStyleProvince:
            array = provinceArr;
            buttonCount = 28;
            tempW = 0.0;
            break;
        case BJKeyboardStyleLetter:
            array = letterArr;
            buttonCount = 29;
            tempW = .5;
            break;
        default:
            break;
    }
    
    _height -=toolBarViewHeight;
    
    const CGFloat KeyWidth =(_width / 10.0 - kKeyHorizontalSpace * 2);
    const CGFloat KeyHeight = (_height / 4.0 - kKeyVerticalSpace * 2);
    
    for (int i = 0; i < array.count; i++) {
        BJKeyboardButton *btn = [array objectAtIndex:i];
        btn.hidden = buttonHidden;
        int k = i;
        int j = i / 10;
        if (i >= 10 && i < buttonCount) {
            k = i % 10;
        }else if (i >= buttonCount) {
            k = i - buttonCount;
            j = 3;
        }
        
        if (i < 20) {
            btn.frame = CGRectMake(kKeyHorizontalSpace + k * (_width / 10) ,
                                   toolBarViewHeight+kKeyVerticalSpace + j * (_height / 4),
                                   KeyWidth,
                                   KeyHeight);
        }else if (i < buttonCount) {
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 1-tempW) * (_width / 10),
                                   toolBarViewHeight+kKeyVerticalSpace + j * (_height / 4),
                                   KeyWidth,
                                   KeyHeight);
        }else {
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 2-tempW) * (_width / 10),
                                   toolBarViewHeight+kKeyVerticalSpace + j * (_height / 4),
                                   KeyWidth,
                                   KeyHeight);
        }
    }
    
    deleteBtn.frame = CGRectMake(_width - KeyWidth * 1.5 - kKeyHorizontalSpace,
                                 _height - KeyHeight - kKeyVerticalSpace+toolBarViewHeight,
                                 KeyWidth * 1.5,
                                 KeyHeight);
    changeBtn.frame = CGRectMake(kKeyHorizontalSpace,
                                     _height - KeyHeight - kKeyVerticalSpace+toolBarViewHeight,
                                     KeyWidth * 1.5,
                                     KeyHeight);
    
}


#pragma mark - Audio feedback.
- (BOOL)enableInputClicksWhenVisible{
    return YES;
}


#pragma mark - ButtonAction
- (void)buttonPlayClick:(UIButton *)button{
    [[UIDevice currentDevice] playInputClick];
}

- (void)buttonInput:(BJKeyboardButton *)button{
    
    id<UIKeyInput> keyInput = self.keyInput;
    if (!keyInput) {
        return;
    }
    
    if (button.style == BJKeyboardButtonStyleProvince || button.style == BJKeyboardButtonStyleLetter) {
        [keyInput insertText:button.titleLabel.text];
    }else if (button.style== BJKeyboardButtonStyleDelegate){
        [keyInput deleteBackward];
    }else if (button.style == BJKeyboardButtonStyleChange){
        
        isProvinceKeyBoard = !isProvinceKeyBoard;
        NSArray *array = [self subviews];
        for (BJKeyboardButton *btn in array) {
            if ([btn isKindOfClass:BJKeyboardButton.class]) {
                if (isProvinceKeyBoard) {
                    if (btn.style == BJKeyboardButtonStyleLetter) {
                        [self creatKeyBoardWithType:BJKeyboardStyleLetter andHidden:YES];
                    }else if (btn.style == BJKeyboardButtonStyleProvince){
                        [self creatKeyBoardWithType:BJKeyboardStyleProvince andHidden:NO];
                    }
                }else{
                    if (btn.style == BJKeyboardButtonStyleProvince) {
                        [self creatKeyBoardWithType:BJKeyboardStyleProvince andHidden:YES];
                    }else if (btn.style == BJKeyboardButtonStyleLetter){
                        [self creatKeyBoardWithType:BJKeyboardStyleLetter andHidden:NO];
                    }
                }
            }
        }
        
        if (isProvinceKeyBoard) {
            [changeBtn setTitle:@"ABC" forState:UIControlStateNormal];
        }else{
            [changeBtn setTitle:@"省份" forState:UIControlStateNormal];
        }
    }
}

- (void)doneButtonAction:(UIButton *)button{
    
    if ([UIResponder BJ_currentFirstResponder]) {
        [[UIResponder BJ_currentFirstResponder] resignFirstResponder];
    }else{
        DLog(@"Not Find First responder");
    }
}

#pragma mark -customButtonStyle
- (BJKeyboardButton *)setButtonStyle:(BJKeyboardButton *)btn {
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = buttonFont;
    [btn addTarget:self action:@selector(buttonInput:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(buttonPlayClick:) forControlEvents:UIControlEventTouchDown];
    return btn;
}


- (id<UIKeyInput>)keyInput{
    
    _keyInput = [UIResponder BJ_currentFirstResponder];
    if (![_keyInput conformsToProtocol:@protocol(UITextInput)]) {
        DLog(@"First responder %@ does not conform to the UIKeyInput protocol.", _keyInput);
        return nil;
    }
    return _keyInput;
}


@end
