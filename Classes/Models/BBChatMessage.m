/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBChatMessage.h"

@implementation BBChatMessage

@synthesize      chatId = _chatId,
               userName = _userName,
              timestamp = _timestamp,
              messageId = _messageId,
                message = _message;


-(NSString*)chatId
{
    return _chatId;
}
-(void)setChatId:(NSString *)chatId
{
    _chatId = chatId;
}


-(NSString*)userName
{
    return _userName;
}
-(void)setUserName:(NSString *)userName
{
    _userName = userName;
}


-(NSDate*)timestamp
{
    return _timestamp;
}
-(void)setTimestamp:(NSDate *)timestamp
{
    _timestamp = timestamp;
}


-(NSString*)messageId
{
    return _messageId;
}
-(void)setMessageId:(NSString *)messageId
{
    _messageId = messageId;
}


-(NSString*)message
{
    return _message;
}
-(void)setMessage:(NSString *)message
{
    _message = message;
}


@end