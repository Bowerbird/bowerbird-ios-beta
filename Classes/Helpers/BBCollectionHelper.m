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

@end
