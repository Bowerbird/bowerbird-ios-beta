/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBSignalRPayload.h"

@implementation BBSignalRPayload

@synthesize     hubName = _hubName,
                 method = _method,
                   args = _args,
                  state = _state;


-(void)setHubName:(NSString *)hubName
{
    _hubName = hubName;
}
-(NSString*)hubName
{
    return _hubName;
}


-(void)setMethod:(NSString *)method
{
    _method = method;
}
-(NSString*)method
{
    return _method;
}


-(void)setArgs:(NSMutableArray *)args
{
    _args = args;
}
-(NSMutableArray*)args
{
    return _args;
}
-(NSUInteger)countOfArgs
{
    return [self.args count];
}
-(id)objectInArgsAtIndex:(NSUInteger)index
{
    return [self.args objectAtIndex:index];
}
-(void)insertObject:(id)object inArgsAtIndex:(NSUInteger)index
{
    [self.args insertObject:object atIndex:index];
}
-(void)removeObjectFromArgsAtIndex:(NSUInteger)index
{
    [self.args removeObjectAtIndex:index];
}


-(void)setState:(NSMutableDictionary *)state
{
    _state = state;
}
-(NSMutableDictionary*)state
{
    if(!_state)_state = [[NSMutableDictionary alloc]init];
    return _state;
}


@end