/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBActivityPaginator.h"
#import "BBHelpers.h"


@interface BBActivityPaginator()
@property (nonatomic,weak) id<BBStreamControllerDelegate> controller;
@end

@implementation BBActivityPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize activities = _activities,
            controller = _controller;

-(void)setActivities:(NSArray *)activities { _activities = activities; }
-(NSArray*)activities {
    if(!_activities)_activities = [[NSArray alloc]init];
    return _activities;
}
-(NSUInteger)countOfActivities { return [self.activities count]; }
-(id)objectInActivitiesAtIndex:(NSUInteger)index { return [self.activities objectAtIndex:index]; }


#pragma mark - 
#pragma mark - Constructors


-(id)initWithRequest:(NSURLRequest *)request
   paginationMapping:(RKObjectMapping *)paginationMapping
 responseDescriptors:(NSArray *)responseDescriptors
         andDelegate:(id<BBStreamControllerDelegate>)delegate {

    self = [super initWithRequest:request
                paginationMapping:paginationMapping
              responseDescriptors:responseDescriptors
                      andDelegate:delegate];
    
    if(self){
        
    }
    
    return self;

}


//-(id)initWithPatternURL:(NSURLRequest *)patternURL
//        mappingProvider:(RKObjectMapping *)mappingProvider
//            andDelegate:(id<BBStreamControllerDelegate>)delegate {
//    
//    self = [super initWithPatternURL:patternURL mappingProvider:mappingProvider andDelegate:delegate];
//    
//    
//    return self;
//}


#pragma mark -
#pragma mark - Delegation and Event Handling for pull to refresh


-(void)dealloc {
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
}


@end