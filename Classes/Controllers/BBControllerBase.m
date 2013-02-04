/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 The Superclass of all VCs that are of ViewController type. Contains common helper methods
 
 -----------------------------------------------------------------------------------------------*/


#import "BBControllerBase.h"
#import "BBHelpers.h"
#import "MGHelpers.h"
#import "BBAppDelegate.h"
#import "BBImage.h"
#import "BBProject.h"
#import "BBArrowView.h"


@implementation BBControllerBase


#pragma mark -
#pragma mark - Utilities and Helpers

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

-(MGBox*)getForwardArrow {
    UIView *arrow = [[BBArrowView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)
                                         andDirection:BBArrowNext
                                       andArrowColour:[UIColor grayColor]
                                          andBgColour:[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]];
    
    MGBox *arrowWrapper = [MGBox boxWithSize:CGSizeMake(arrow.width, arrow.height)];
    [arrowWrapper addSubview:arrow];
    
    return arrowWrapper;
}


@end