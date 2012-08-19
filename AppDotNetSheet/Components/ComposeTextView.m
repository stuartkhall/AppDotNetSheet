//
//  ComposeTextView.m
//  iOS-Example
//
//  Created by Stuart Hall on 18/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import "ComposeTextView.h"

@implementation ComposeTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.75 alpha:0.75].CGColor);
    CGContextSetLineWidth(context, 1.0f);

    CGContextBeginPath(context);
    
    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
    CGFloat baselineOffset = 6.0f;
    
    for (int x = 1; x < numberOfLines; x++) {
        CGContextMoveToPoint(context, self.bounds.origin.x, self.font.leading*x + 0.5f + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.font.leading*x + 0.5f + baselineOffset);
    }
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
