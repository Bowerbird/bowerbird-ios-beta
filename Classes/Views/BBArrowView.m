//
//  BBArrowView.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 9/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBArrowView.h"

@implementation BBArrowView {
    BBArrowType arrowDirection;
    UIColor *arrowColour, *backgroundColour;
    CGContextRef context;
    double height, width;
}

- (id)initWithFrame:(CGRect)frame
       andDirection:(BBArrowType)direction
     andArrowColour:(UIColor*)colour
        andBgColour:(UIColor*)bgColour
{
    self = [super initWithFrame:frame];
    
    if (self) {
        arrowDirection = direction;
        arrowColour = colour;
        backgroundColour = bgColour;
        height = self.frame.size.height;
        width = self.frame.size.width;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int internalPadding = 8;
    double internalTriangleWidth = internalPadding;// * 2 * 0.8660254; // value is ratio of height to base of equilateral triangle
    
    context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, backgroundColour.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, width,height));
    
    switch (arrowDirection) { // switch in case we create up and down later..
        case BBArrowNext:
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, width, height/2);
            CGContextAddLineToPoint(context, 0, height);
            CGContextClosePath(context);
            [arrowColour setFill];
            [arrowColour setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
            /*
            // now draw triangle within triangle
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, internalTriangleWidth, height/2);
            CGContextAddLineToPoint(context, 0, height);
            CGContextClosePath(context);
            [backgroundColour setFill];
            [backgroundColour setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
            */
            break;
        case BBArrowBack:
            CGContextMoveToPoint(context, width, 0);
            CGContextAddLineToPoint(context, 0, height/2);
            CGContextAddLineToPoint(context, width, height);
            CGContextClosePath(context);
            [arrowColour setFill];
            [arrowColour setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
            /*
            // now draw triangle within triangle
            CGContextMoveToPoint(context, width, 0);
            CGContextAddLineToPoint(context, width - internalTriangleWidth, height/2);
            CGContextAddLineToPoint(context, width, height);
            CGContextClosePath(context);
            [backgroundColour setFill];
            [backgroundColour setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
            */
            break;
    }
}

@end