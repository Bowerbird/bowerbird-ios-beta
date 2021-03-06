/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 http://stackoverflow.com/questions/8445786/how-to-draw-stars-using-quartz-core
 -----------------------------------------------------------------------------------------------*/


#import <QuartzCore/QuartzCore.h>
#import "BBStarView.h"


@implementation BBStarView {
    BBFavouriteType favouriteType;
    UIColor *backgroundColour;
    float height, width, sizeOfStar;
    CGColorRef blueColour, greenColour, blackColour;
}


- (id)initWithFrame:(CGRect)frame
   andFavouriteType:(BBFavouriteType)favourite
        andBgColour:(UIColor*)bgColour
        andStarSize:(float)starSize {
    self = [super initWithFrame:frame];
    
    if (self) {
        favouriteType = favourite;
        backgroundColour = [UIColor clearColor];
        height = self.frame.size.height;
        width = self.frame.size.width;
        sizeOfStar = starSize;
        self.backgroundColor = backgroundColour;
        float greenColor[4] = { 0.38, 0.9, 0.65, 1.0 };
        float blueColor[4] = { 0.38, 0.65, 0.9, 1.0 };
        float blackColor[4] = {0 ,0 ,0 ,1 };
        blueColour = CGColorCreate(CGColorSpaceCreateDeviceRGB(), blueColor);
        greenColour = CGColorCreate(CGColorSpaceCreateDeviceRGB(), greenColor);
        blackColour = CGColorCreate(CGColorSpaceCreateDeviceRGB(), blackColor);
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect {
    int aSize = 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, aSize);
    CGFloat xCenter = round(self.frame.size.width/2);
    CGFloat yCenter = round(self.frame.size.height/2);
    
    float  w = width;
    double r = w / 2.0;
    float flip = -1.0;
    
    switch (favouriteType) {
            default:
        case BBFavouriteSelected:
        {
            CGContextSetFillColorWithColor(context, greenColour);
            CGContextSetStrokeColorWithColor(context, blackColour);
        }
        break;
        case BBFavouriteNotSelected:
        {
            CGContextSetFillColorWithColor(context, blueColour);
            CGContextSetStrokeColorWithColor(context, blackColour);
        }
        break;
    }
    
    double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
    
    CGContextMoveToPoint(context, xCenter, r*flip+yCenter);
    
    for (NSUInteger k=1; k<5; k++)
    {
        float x = r * sin(k * theta);
        float y = r * cos(k * theta);
        CGContextAddLineToPoint(context, x+xCenter, y*flip+yCenter);
    }

    CGContextClosePath(context);
    CGContextFillPath(context);
}


@end