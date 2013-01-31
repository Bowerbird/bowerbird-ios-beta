/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBPostPaginator.h"


@implementation BBPostPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize posts = _posts;


-(void)setPosts:(NSArray *)posts { _posts  = posts; }
-(NSArray*)posts {
    if(!_posts)_posts = [[NSArray alloc]init];
    return _posts;
}
-(NSUInteger)countOfPosts { return [self.posts count]; }
-(id)objectInPostsAtIndex:(NSUInteger)index { return [self.posts objectAtIndex:index]; }


@end