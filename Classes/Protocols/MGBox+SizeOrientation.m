//
//  NSString+MGBox_SizeOrientation.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "MGBox+SizeOrientation.h"

@implementation MGBox (SizeOrientation)

-(BOOL)phone
{
    return self.phone;
}

-(void)setPhone:(BOOL)isPhone
{
    self.phone = isPhone;
}

-(BOOL)portrait
{
    return self.portrait;
}

-(void)setPortrait:(BOOL)portrait
{
    self.portrait = portrait;
}

-(double) deviceWidth
{
    return self.deviceWidth;
}

-(double) deviceHeight
{
    return self.deviceHeight;
}

-(void)setSizeAndOrientation:(UIInterfaceOrientation)orientation
{
    UIDevice *device = UIDevice.currentDevice;
    self.phone = device.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    self.portrait = UIDeviceOrientationIsPortrait(orientation);
    
    //self.actionSize = self.phone ? self.portrait ? IPHONE_ACTION_PORTRAIT : IPHONE_ACTION_LANDSCAPE : self.portrait ? IPAD_ACTION_PORTRAIT : IPAD_ACTION_LANDSCAPE;
}

@end
