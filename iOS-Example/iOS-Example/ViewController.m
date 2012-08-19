//
//  ViewController.m
//  iOS-Example
//
//  Created by Stuart Hall on 18/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import "ViewController.h"
#import "AppDotNetComposeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onCompose:(UIButton*)sender
{
    AppDotNetComposeViewController* controller = [[AppDotNetComposeViewController alloc] init];
    [self presentModalViewController:controller animated:NO];
}

@end
