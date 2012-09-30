/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@interface BBUser()

@property (nonatomic,strong) NSTimer* timer;
-(void)onTimerTick:(NSTimer *)timer;
-(void)startHeartbeatTimer;

@end

@implementation BBUser

@synthesize     identifier = _identifier,
                 firstName = _firstName,
                  lastName = _lastName,
                      name = _name,
                     email = _email,
            latestActivity = _latestActivity,
           latestHeartbeat = _latestHeartbeat,
                    avatar = _avatar,
                     timer = _timer,
                userStatus = _userStatus;


-(BBUser*)initWithObject:(id)user
{
    self = [self init];

    self.identifier = [user objectForKey:@"Id"];
    self.firstName = [user objectForKey:@"FirstName"];
    self.lastName = [user objectForKey:@"LastName"];
    self.name = [user objectForKey:@"Name"];
    self.userStatus = online;
    [self updateLatestActivity:[user objectForKey:@"LatestActivity"]];
    [self updateLatestHearbeat:[user objectForKey:@"LatestHeartbeat"]];
    
    //[self setLatestHeartbeat:[NSDate date]];
    [self startHeartbeatTimer];
    
    return self;
}


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


-(void)setAvatar:(BBMediaResource *)avatar
{
    _avatar = avatar;
}


-(BBMediaResource*)avatar
{
    return _avatar;
}


-(void)updateLatestActivity:(NSString *)latestActivity
{
    // parse the passed in date and set the status...
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setFormat:ISO8601DateFormatCalendar];
    [formatter setDefaultTimeZone:timeZone];
   
	formatter.parsesStrictly = YES;
    
    NSDate* date = [formatter dateFromString:latestActivity];
    [self setLatestActivity:date];
}


-(void)setLatestActivity:(NSDate *)latestActivity
{
    _latestActivity = latestActivity;   
}


-(NSDate*)latestActivity
{
    return _latestActivity;
}


-(void)updateLatestHearbeat:(NSString *)latestHearbeat
{
    // parse the passed in date and set the status...
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    [formatter setFormat:ISO8601DateFormatCalendar];
    [formatter setDefaultTimeZone:timeZone];
	formatter.parsesStrictly = YES;

    [self setLatestHeartbeat:[formatter dateFromString:latestHearbeat]];
}


-(void)setLatestHearbeat:(NSDate *)latestHeartbeat
{
    _latestHeartbeat = latestHeartbeat;
}


-(void)startHeartbeatTimer
{
    if(!self.timer || self.timer.isValid)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                      target:self
                                                    selector:@selector(onTimerTick:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


-(void)stopHeartbeatTimer
{
    if(!self.timer || self.timer.isValid)
    {
        [self.timer invalidate];
    }
}


-(NSDate*)latestHeartbeat
{
    return _latestHeartbeat;
}


// as time passes, if the latest activity is not changing, change the status from online > away > offline.
-(void)onTimerTick:(NSTimer *)timer
{
    [self setLatestHearbeat:[NSDate date]];
    int activityInterval = [self.latestHeartbeat timeIntervalSinceDate:self.latestActivity];

    if(!activityInterval || activityInterval > 600) // ten minutes
    {
        if(self.userStatus != offline)
        {
            self.userStatus = offline;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    else if(activityInterval > 90)// a minute and a half
    {
        if(self.userStatus != away)
        {
            self.userStatus = away;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    else
    {
        if(self.userStatus != online)
        {
            self.userStatus = online;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    
    // call back to the mothership
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    if([appData.authenticatedUser.user.identifier isEqualToString:self.identifier])
    {
        [[BBUserHubClient sharedInstance] updateUserStatus:self.identifier withActivity:self.latestActivity withHeartbeat:self.latestHeartbeat];
    }
}


-(void)setNilValueForKey:(NSString *)theKey
{
//
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // Id is the serverside representation of identifier.. had to change because of keyword id.
    if([key isEqualToString:@"Id"]) self.identifier = value;
}

@end