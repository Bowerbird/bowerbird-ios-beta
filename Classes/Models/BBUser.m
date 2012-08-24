/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBUser

@synthesize     identifier = _identifier,
                 firstName = _firstName,
                  lastName = _lastName,
                      name = _name,
                     email = _email,
     sessionLatestActivity = _sessionLatestActivity,
                    avatar = _avatar;


-(void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
}
-(NSString*)identifier
{
    return _identifier;
}


-(void)setFirstName:(NSString *)firstName
{
    _firstName = firstName;
}
-(NSString*)firstName
{
    return _firstName;
}


-(void)setLastName:(NSString *)lastName
{
    _lastName = lastName;
}
-(NSString*)lastName
{
    return _lastName;
}


-(void)setName:(NSString *)name
{
    _name = name;
}
-(NSString*)name
{
    return _name;
}


-(void)setEmail:(NSString *)email
{
    _email = email;
}
-(NSString*)email
{
    return _email;
}


-(void)setSessionLatestActivity:(NSString *)sessionLatestActivity
{
    _sessionLatestActivity = sessionLatestActivity;
}
-(NSString*)sessionLatestActivity
{
    return _sessionLatestActivity;
}


-(void)setAvatar:(BBMediaResource *)avatar
{
    _avatar = avatar;
}
-(BBMediaResource*)avatar
{
    return _avatar;
}


- (void)setNilValueForKey:(NSString *)theKey
{
    //    if ([theKey isEqualToString:@"hidden"]) {
    //        [self setValue:@YES forKey:@"hidden"];
    //    }
    //    else {
    //        [super setNilValueForKey:theKey];
    //    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // Id is the serverside representation of identifier.. had to change because of keyword id.
    if([key isEqualToString:@"Id"]) self.identifier = value;
}

@end
