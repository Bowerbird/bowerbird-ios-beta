//
//  BBControllerBase.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBControllerBase.h"

@implementation BBControllerBase


-(BBImage*)getImageWithDimension:(NSString*)dimensionName fromArrayOf:(NSArray*)images {
    [BBLog Log:@"BBControllerBase.getImageWithDimension:fromArrayOf:"];
    
    __block BBImage *img;
    [images enumerateObjectsUsingBlock:^(BBImage* obj, NSUInteger idx, BOOL *stop)
     {
         if([obj.dimensionName isEqualToString:dimensionName])
         {
             img = obj;
             *stop = YES;
         }
     }];
    
    return img;
}


-(BBProject*)getProjectWithIdentifier:(NSString *)identifier fromArrayOf:(NSArray *)projects{
    [BBLog Log:@"BBControllerBase.getProjectWithIdentifier:fromArrayOf:"];
    
    __block BBProject *project;
    [projects enumerateObjectsUsingBlock:^(BBProject* proj, NSUInteger idx, BOOL *stop)
     {
         if([proj.identifier isEqualToString:identifier])
         {
             project = proj;
             *stop = YES;
         }
     }];
    
    return project;
}


-(CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}


-(UIColor*)backgroundColor {
    return [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
}


@end