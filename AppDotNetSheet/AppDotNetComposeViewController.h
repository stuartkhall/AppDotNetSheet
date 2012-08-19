//
//  AppDotNetComposeViewController.h
//  iOS-Example
//
//  Created by Stuart Hall on 18/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDotNetComposeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView* containerView;

@property (nonatomic, strong) IBOutlet UIView* composeView;
@property (nonatomic, strong) IBOutlet UITextView* textView;
@property (nonatomic, strong) IBOutlet UILabel* characterCountLabel;
@property (nonatomic, strong) IBOutlet UIView* backgroundView;
@property (nonatomic, strong) IBOutlet UIImageView* screenshotView;
@property (nonatomic, strong) IBOutlet UIButton* logoutButton;

@property (nonatomic, strong) IBOutlet UIView* loginView;
@property (nonatomic, strong) IBOutlet UIWebView* webView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityView;


@property (nonatomic, strong) IBOutlet UIView* sendingView;

@end
