//
//  AppDotNetComposeViewController.m
//  iOS-Example
//
//  Created by Stuart Hall on 18/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import "AppDotNetComposeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#import "AppDotNetClient.h"

@interface AppDotNetComposeViewController ()

@end

@implementation AppDotNetComposeViewController

@synthesize containerView;

@synthesize composeView;
@synthesize textView;
@synthesize characterCountLabel;
@synthesize backgroundView;
@synthesize screenshotView;
@synthesize logoutButton;

@synthesize loginView;
@synthesize webView;
@synthesize activityView;

@synthesize sendingView;

static int const kMaxCharacters = 256;

- (id)init
{
    self = [super initWithNibName:@"AppDotNetComposeViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [textView becomeFirstResponder];
    [self updateCharacterCount];
    
    // Load the login in the background
    webView.layer.masksToBounds = YES;
    webView.backgroundColor = [UIColor clearColor];
    
    // Hide the shadows
    for (UIView* shadowView in [webView.scrollView subviews]) {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            [shadowView setHidden:YES];
        }
    }
    
    // Logout button status
    logoutButton.hidden = ![AppDotNetClient hasToken];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Sneaky Background Image
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Grab a screenshot to put underneath
    UIView *parentView = self.presentingViewController.view;
    UIGraphicsBeginImageContext(parentView.bounds.size);
    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    screenshotView.image = parentViewImage;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)close
{
    // Hide the lightbox
    self.backgroundView.alpha = 0;
    
    // Slide the image with the animation
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect r = self.screenshotView.frame;
                         r.origin.y = -r.size.height;
                         self.screenshotView.frame = r;
                     }];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Buttons

- (IBAction)onSend:(id)sender
{
    if ([AppDotNetClient hasToken]) {
        // Authenticated, send away
        [self send];
    }
    else {
        // Flip to authentication view
        self.loginView.frame = self.composeView.frame;
        [UIView transitionWithView:self.containerView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.composeView removeFromSuperview];
                            [self.containerView addSubview:loginView];
                        }
                        completion:NULL];
        
        // Start the request
        [webView loadRequest:[NSURLRequest requestWithURL:[AppDotNetClient authenticationURL]]];
    }
}

- (IBAction)onCancel:(UIButton*)sender
{
    // Disable the down state before the animation
    sender.adjustsImageWhenHighlighted = NO;
    [self close];
}

- (IBAction)onCancelLogin:(id)sender
{
    // Flip back to the compose view
    [UIView transitionWithView:self.containerView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.loginView removeFromSuperview];
                        [self.containerView addSubview:composeView];
                    }
                    completion:^(BOOL finished) {
                        // Start editing again
                        if (!sendingView.superview)
                            [textView becomeFirstResponder];
                    }];
}

- (IBAction)onLogout:(id)sender
{
    [AppDotNetClient forgetToken];
    logoutButton.hidden = YES;
}

#pragma mark - Sending

- (void)send
{
    // Ensure there is some text to send
    if (self.textView.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Please enter a message"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    // Show some progress
    [self.composeView addSubview:sendingView];
    sendingView.frame = CGRectMake(composeView.frame.size.width/2 - sendingView.frame.size.width/2,
                                   composeView.frame.size.height/2 - sendingView.frame.size.height/2,
                                   sendingView.frame.size.width,
                                   sendingView.frame.size.height);
    textView.hidden = YES;
    
    // Post
    [AppDotNetClient postUpdate:self.textView.text
                      replyToId:nil
                    annotations:nil
                          links:nil
                        success:^(NSString *identifier) {
                            // Success!
                            self.sendingView.hidden = YES;
                            [self close];
                        } failure:^(NSError *error, NSNumber *errorCode, NSString *message) {
                            // http://sadtrombone.com/
                            self.sendingView.hidden = YES;
                            self.textView.hidden = NO;
                            
                            [[[UIAlertView alloc] initWithTitle:nil
                                                        message:message ?: @"Sorry, an error occured trying to post the update."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] show];
                        }];
}

#pragma mark - Character Count

- (void)updateCharacterCount
{
    int charactersRemaining = kMaxCharacters - self.textView.text.length;
    characterCountLabel.text = [NSString stringWithFormat:@"%d", charactersRemaining];
    characterCountLabel.textColor = charactersRemaining < 0 ? [UIColor colorWithRed:0.7 green:0 blue:0 alpha:1] : [UIColor colorWithWhite:0.48 alpha:1];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCharacterCount];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    if ([AppDotNetClient parseURLForToken:wv.request.URL]) {
        // We have the token!
        logoutButton.hidden = NO;
        [webView stopLoading];
        [self onCancelLogin:wv];
        [self send];
    }
    else {
        // Scroll down to the login
        [webView stringByEvaluatingJavaScriptFromString:@"$('.navbar').hide();"];
        [webView stringByEvaluatingJavaScriptFromString:@"window.scrollBy(5,157);"];
        
        [activityView stopAnimating];
        webView.hidden = NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)wv
{
    [activityView startAnimating];
    webView.hidden = YES;
}

@end
