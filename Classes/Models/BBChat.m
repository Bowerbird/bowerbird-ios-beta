/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBChat.h"

@implementation BBChat

@synthesize       identifier = _identifier,
                chatMessages = _chatMessages,
                   chatUsers = _chatUsers,
                       group = _group,
                   isStarted = _isStarted;


-(NSMutableArray*)chatMessages
{
    if(!_chatMessages)
    {
        _chatMessages = [[NSMutableArray alloc]init];
    }
    
    return _chatMessages;
}
-(void)setChatMessages:(NSMutableArray *)chatMessages
{
    _chatMessages = chatMessages;
}
-(void)addChatMessage:(BBChatMessage *)chatMessage
{
    [self.chatMessages addObject:chatMessage];
}

-(NSString*)chatType
{
    return self.group != nil ? @"group" : @"private";
}

@end