/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <QuartzCore/QuartzCore.h>
#import "BBPlusView.h"


@implementation BBPlusView {
    UIColor *plusColour, *backgroundColour;
    CGContextRef context;
    double plusThickness, spaceV, spaceH;
    double height,width;
}


- (id)initWithFrame:(CGRect)frame
        andBgColour:(UIColor*)bgColour
      andPlusColour:(UIColor*)forgroundColour
        andPlusSize:(float)plusSize {
    
    self = [super initWithFrame:frame];
    
    if(self){
        backgroundColour = bgColour;
        plusColour = forgroundColour;
        height = self.frame.size.height;
        width = self.frame.size.width;
        self.frame = frame;
        
        plusThickness = plusSize;
        spaceV = (width - plusSize)/2;
        spaceH = (height - plusSize)/2;
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, backgroundColour.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, width,height));
    
    // draw the vertical line of plus sign
    CGContextMoveToPoint(context, 0, spaceV);
    CGContextAddLineToPoint(context, width, spaceV);
    CGContextAddLineToPoint(context, width, height - spaceV);
    CGContextAddLineToPoint(context, 0, height - spaceV);
    CGContextClosePath(context);
    [plusColour setFill];
    [plusColour setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw the horizontal line of plus sign
    CGContextMoveToPoint(context, spaceH, 0);
    CGContextAddLineToPoint(context, spaceH + plusThickness, 0);
    CGContextAddLineToPoint(context, spaceH + plusThickness, height);
    CGContextAddLineToPoint(context, spaceH, height);
    CGContextClosePath(context);
    [plusColour setFill];
    [plusColour setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end