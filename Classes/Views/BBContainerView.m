//
//  BBContainerView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 8/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBContainerView.h"

#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation BBContainerView

-(BBContainerView *)initWithSize:(CGSize)size
{
    [BBLog Log:@"BBHomeView.initWithSize:"];
    
    self = [MGBox boxWithSize:size];
    self.tag = -1;
    self.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1];
    
    UIImage *logo = [UIImage imageNamed:@"background-icon.png"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:logo];
    logoView.alpha = 0.5;
    
    logoView.center = CGPointMake(160, 220);
    
    [self addSubview:logoView];
    
    //[self rotateImage:logoView duration:4.0 curve:UIViewAnimationCurveEaseIn degrees:720];
    
    return self;
}

- (void)rotateImage:(UIImageView *)image
           duration:(NSTimeInterval)duration
              curve:(int)curve
            degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

@end