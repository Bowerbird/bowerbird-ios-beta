/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "Comment.h"

@implementation Comment

@synthesize commentedOn = _commentedOn;
@synthesize user = _user;
@synthesize message = _message;
@synthesize comments = _comments;

-(Comment*)initWithJson:(NSDictionary*)dictionary
{
    self = [self init];
    
    self.message = [dictionary objectForKey:@"Message"];
    
    return self;
}

-(void)loadCommentsFromJson:(NSArray*)array
{
    // don't quite know the structure yet...
}

@end
