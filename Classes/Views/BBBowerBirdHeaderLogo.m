//
//  BBBowerBirdHeaderLogo.m
//  BowerBird
//
//  Created by Hamish Crittenden on 8/11/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBBowerBirdHeaderLogo.h"

@implementation BBBowerBirdHeaderLogo

+(MGTableBox*)BowerBirdLogoHeading {
    
    MGTableBox *bbLogoBox = [MGTableBox boxWithSize:CGSizeMake(300, 100)];
    
//    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 288,54)];
//    bowerbirdImage.image =[UIImage imageNamed:@"logo-negative.png"];

    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-negative.png"]];
    MGLine *bowerbirdLogo = [MGLine lineWithLeft:bowerbirdImage right:nil size:CGSizeMake(300,100)];
    
    bowerbirdLogo.alpha = 0.5;
    [bowerbirdLogo.middleItems addObject:bowerbirdImage];
    
    [bbLogoBox.boxes addObject:bowerbirdLogo];
    
    return bbLogoBox;
}

@end
