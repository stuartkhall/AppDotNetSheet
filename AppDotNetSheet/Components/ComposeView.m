//
//  ComposeView.m
//  iOS-Example
//
//  Created by Stuart Hall on 18/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import "ComposeView.h"

#import <QuartzCore/QuartzCore.h>

@implementation ComposeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    // apply the border
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowOpacity = 0.25;
    
    [self setBackground];
}

- (void)setBackground {
    // Background
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = [NSArray arrayWithObjects:
                    (id)[[UIColor colorWithWhite:0xF4/255.0 alpha:1] CGColor],
                    (id)[[UIColor colorWithWhite:0xBD/255.0 alpha:1] CGColor],
                    nil];
    layer.locations = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.0f],
                       [NSNumber numberWithFloat:1.0f],
                       nil];
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    // Line
    CALayer *linelayer = [CALayer layer];
    linelayer.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    linelayer.frame = CGRectMake(0, 45, self.frame.size.width, 1);
    [self.layer addSublayer:linelayer];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [UIColor colorWithWhite:0.75 alpha:1];
    [path setLineWidth:1.0];
    [path moveToPoint:CGPointMake(0, 30)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, 30)];
    [path stroke];
}

@end
