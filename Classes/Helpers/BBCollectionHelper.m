/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCollectionHelper.h"
#import "BBAuthenticatedUser.h"


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
    
    __block NSMutableArray *projectsInObservationIds = [[NSMutableArray alloc]init];
    [withIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [projectsInObservationIds addObject:((BBProject*)obj).identifier];
    }];
    
    __block NSMutableArray *projects = [[NSMutableArray alloc]init];
    [userProjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // if this userProject is to be incuded, add it
        if(yesOrNo && [projectsInObservationIds containsObject:((BBProject*)obj).identifier])
        {
            [projects addObject:obj];
        }
        // if this userProject is not to be included, add it
        else if(!yesOrNo && ![projectsInObservationIds containsObject:((BBProject*)obj).identifier])
        {
            [projects addObject:obj];
        }
    }];
    
    return projects;
}


+(BBProject*)getUserProjectById:(NSString*)identifier {
    
    BBApplication* app = [BBApplication sharedInstance];
    __block BBProject *proj;
    [app.authenticatedUser.projects enumerateObjectsUsingBlock:^(BBProject* obj, NSUInteger idx, BOOL *stop) {
        if([((BBProject*)obj).identifier isEqualToString:identifier])
        {
            proj = obj;
            *stop = YES;
        }
    }];
    
    return proj;
}

+(NSArray*)getObjectsFromCollection:(NSArray*)array withKeyName:(NSString*)key equalToValue:(NSString*)val {
    
    __block NSMutableArray *values = [[NSMutableArray alloc]init];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([[obj valueForKey:key] isEqualToString:val]) {
            [values addObject:obj];
        }
    }];
    
    return [[NSArray alloc]initWithArray:values];
}


@end