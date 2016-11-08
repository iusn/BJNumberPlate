//
//  ViewController.m
//  OC-Demo
//
//  Created by Sun on 24/10/2016.
//  Copyright © 2016 Sun. All rights reserved.
//

#import "ViewController.h"
#import <BJNumberPlateOC.h>

@interface ViewController ()
{

    UITextField *textField;
    UITextView *textView;
    UITextField *textField1;
    UITextView *textView1;
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BJNumberPlateOC *numberPlateView = [[BJNumberPlateOC alloc] initWithFrame:CGRectZero];
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.placeholder = @"Type something......";
    textField.inputView = numberPlateView;
    textField.font = [UIFont systemFontOfSize:20.0f];
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.layer.borderWidth = 1.0f;
    [self.view addSubview:textField];
    
    textField1 = [[UITextField alloc] initWithFrame:CGRectZero];
    textField1.placeholder = @"Type something......";
    textField1.inputView = numberPlateView;
    textField1.font = [UIFont systemFontOfSize:20.0f];
    textField1.layer.borderColor = [UIColor redColor].CGColor;
    textField1.layer.borderWidth = 1.0f;
    [self.view addSubview:textField1];
    
    textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.inputView = numberPlateView;
    textView.layer.borderColor = [UIColor greenColor].CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.font = textField.font;
    [self.view addSubview:textView];
    
    textView1 = [[UITextView alloc] init];
    textView1.backgroundColor = [UIColor clearColor];
    textView1.inputView = numberPlateView;
    textView1.layer.borderColor = [UIColor greenColor].CGColor;
    textView1.layer.borderWidth = 1.0f;
    textView1.font = textField.font;
    [self.view addSubview:textView1];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    textField.frame =CGRectMake(20,
                                30.0f,
                                CGRectGetWidth(self.view.bounds)- 40,
                                40.0f);
    
    textView.frame = CGRectMake(CGRectGetMinX(textField.frame),
                                CGRectGetMaxY(textField.frame)+30,
                                CGRectGetWidth(self.view.bounds)- 40,
                                40.0f);
    
    textField1.frame =CGRectMake(20,
                                 CGRectGetMaxY(textView.frame)+30,
                                 CGRectGetWidth(self.view.bounds)- 40,
                                 40.0f);
    
    textView1.frame = CGRectMake(CGRectGetMinX(textField.frame),
                                 CGRectGetMaxY(textField1.frame)+30,
                                 CGRectGetWidth(self.view.bounds)- 40,
                                 40.0f);
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
