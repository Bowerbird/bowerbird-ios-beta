//
//  BBActivityProvider.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBActivityProvider.h"

@implementation BBActivityProvider

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@", activityType);
    
    return [super activityViewController:activityViewController
                     itemForActivityType:activityType];
}

@end