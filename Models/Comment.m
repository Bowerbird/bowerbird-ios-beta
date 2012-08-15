/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "Comment.h"

@implementation Comment

@synthesize identifier = _identifier;
@synthesize sequentialId = _sequentialId;
@synthesize commentedOn = _commentedOn;
@synthesize user = _user;
@synthesize message = _message;
@synthesize comments = _comments;

-(Comment*)initWithJson:(NSDictionary*)dictionary
{
    if([BowerBirdConstants Trace]) NSLog(@"Comment.initWithJson:");
    
    self = [self init];
    
    self.identifier = [[NSNumber alloc]initWithInt:[[dictionary objectForKey:@"Id"] integerValue]];
    self.sequentialId = [dictionary objectForKey:@"SequentialId"];
    self.message = [dictionary objectForKey:@"Message"];
    self.commentedOn  = [NSDate ConvertFromJsonDate:[dictionary objectForKey:@"CommentedOn"]];
    self.user = [[User alloc]initWithJson:[dictionary objectForKey:@"User"] andNotifyProjectLoaded:self];
    
    NSArray* childComments = [dictionary objectForKey:@"Comments"];
    if(childComments != nil)
    {
        Comment* commentLoader = [[Comment alloc]init];
        self.comments = [commentLoader loadCommentsFromJson:childComments];
    }
    
    return self;
}

-(NSArray*)loadCommentsFromJson:(NSArray*)array
{
    if([BowerBirdConstants Trace]) NSLog(@"Comment.loadCommentsFromJson:");
    
    NSMutableArray* comments = [[NSMutableArray alloc]init];
    
    for(NSDictionary* commentDictionary in array)
    {
        [comments addObject:[self initWithJson:commentDictionary]];
    }
    
    return [[NSArray alloc]initWithArray:comments];
}

-(void)UserLoaded:(User*)user
{
    if([BowerBirdConstants Trace]) NSLog(@"Comment.UserLoaded:");
    
    self.user = user;
    
    // this will require some kind of notification back to the UI me believes..
    
}

@end
