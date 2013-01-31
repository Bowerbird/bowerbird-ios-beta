/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBComment.h"


@implementation BBComment


#pragma mark -
#pragma mark - Member Accessors


@synthesize     identifier = _identifier,
                sequentialId = _sequentialId,
                commentedOn = _commentedOn,
                user = _user,
                message = _message,
                comments = _comments;


-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)identifier { return _identifier; }
-(void)setSequentialId:(NSString *)sequentialId { _sequentialId = sequentialId; }
-(NSString*)sequentialId { return _sequentialId; }
-(void)setCommentedOn:(NSDate *)commentedOn { _commentedOn = commentedOn; }
-(NSDate*)commentedOn { return _commentedOn; }
-(void)setUser:(BBUser *)user { _user = user; }
-(BBUser*)user { return _user; }
-(void)setMessage:(NSString *)message { _message = message; }
-(NSString*)message { return _message; }
-(void)setComments:(NSArray *)comments { _comments = comments; }
-(NSArray*)comments { return _comments; }
-(NSUInteger)countOfComments { return [self.comments count]; }
-(id)objectInCommentsAtIndex:(NSUInteger)index { return [self.comments objectAtIndex:index]; }


@end