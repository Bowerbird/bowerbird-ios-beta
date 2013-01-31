/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


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
        andBgColour:(UIColor*)bgColour {
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

- (void)drawRect:(CGRect)rect {
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
            break;
            
        case BBArrowBack:
            CGContextMoveToPoint(context, width, 0);
            CGContextAddLineToPoint(context, 0, height/2);
            CGContextAddLineToPoint(context, width, height);
            CGContextClosePath(context);
            [arrowColour setFill];
            [arrowColour setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
    }
}


@end