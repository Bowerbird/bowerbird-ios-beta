/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBPost.h"
#import "BBGroup.h"
#import "BBUser.h"


@implementation BBPost


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            createdOnDescription = _createdOnDescription,
            group = _group,
            groupId = _groupId,
            message = _message,
            postType = _postType,
            subject = _subject,
            user = _user;


-(NSString*)identifier { return _identifier; }
-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)createdOnDescription { return _createdOnDescription; }
-(void)setCreatedOnDescription:(NSString *)createdOnDescription { _createdOnDescription = createdOnDescription; }
-(BBGroup*)group { return _group; }
-(void)setGroup:(BBGroup *)group { _group = group; }
-(NSString*)groupId { return _groupId; }
-(void)setGroupId:(NSString *)groupId { _groupId = groupId; }
-(NSString*)message { return _message; }
-(void)setMessage:(NSString *)message { _message = message; }
-(NSString*)postType { return _postType; }
-(void)setPostType:(NSString *)postType { _postType = postType; }
-(NSString*)subject { return _subject; }
-(void)setSubject:(NSString *)subject { _subject = subject; }
-(BBUser*)user { return _user; }
-(void)setUser:(BBUser *)user { _user = user; }


@end