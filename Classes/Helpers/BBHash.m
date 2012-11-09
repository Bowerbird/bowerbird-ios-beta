/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBHash.h"

@implementation BBHash

+(NSString*)GenerateHash:(NSString*)value
{
    long hash = 0;
    
    if([value length] == 0) return [[NSNumber numberWithLong:hash] stringValue];
    
    for(int i = 0; i < [value length]; i++)
    {
        char ch = [value characterAtIndex:i];
        hash = ((hash << 5) - hash) + ch;
        hash = hash & hash;
    }
    
    return [[NSNumber numberWithLong:hash] stringValue];
}

+(NSString*)GenerateHashFromArray:(NSArray *)array
{
    NSMutableArray* sortableArray = [NSMutableArray arrayWithArray:array];
    
    NSArray* sortedIds = [sortableArray sortedArrayUsingSelector:@selector(compare:)];
    
    __block NSString* joinedIds;
    [sortedIds enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        joinedIds = [joinedIds stringByAppendingString:obj];
    }];
    
    NSString* hashedId = [BBHash GenerateHash:joinedIds];
    
    return hashedId;
}

@end