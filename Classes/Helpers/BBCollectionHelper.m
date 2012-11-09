/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBCollectionHelper.h"

@implementation BBCollectionHelper

+(NSArray*)populateArrayFromDictionary:(NSDictionary*)dictionary
{
    NSMutableArray* arrayOfValues = [[NSMutableArray alloc]init];
    
    // this is causing an exception.. need to follow better example..
    //[dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        //[arrayOfValues addObject:obj];
    //}];
    
    for(id key in dictionary)
    {
        id value = [dictionary objectForKey:key];
        [arrayOfValues addObject:value];
    }
    
    return [[NSArray alloc]initWithArray:arrayOfValues];
}

+(BBImage*)getImageWithDimension:(NSString*)dimensionName fromArrayOf:(NSArray*)images {
    
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

// for each user project, grab it if it is in/not in this list
+(NSArray*)getUserProjects:(NSArray*)withIds inYesNotInNo:(BOOL)yesOrNo {
    
    BBApplication* app = [BBApplication sharedInstance];
    NSArray *userProjects = app.authenticatedUser.projects;
    __block NSMutableArray *projects = [[NSMutableArray alloc]init];
    [userProjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // if this userProject is to be incuded, add it
        if(yesOrNo && [withIds containsObject:((BBProject*)obj).identifier])
        {
            [projects addObject:obj];
        }
        // if this userProject is not to be included, add it
        else if(!yesOrNo && ![withIds containsObject:((BBProject*)obj).identifier])
        {
            [projects addObject:obj];
        }
    }];
    
    return userProjects;
}

@end