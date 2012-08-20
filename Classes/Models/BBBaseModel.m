/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBBaseModel.h"

@implementation BBBaseModel

@synthesize model = _model;

-(void)setModel:(NSDictionary *)model
{
    _model = model;
}
-(NSDictionary*)model
{
    if(!_model) _model = [[NSDictionary alloc]init];
    return _model;
}
-(NSUInteger)countOfModel
{
    return [self.model count];
}
-(NSEnumerator*)enumeratorOfModel
{
    return [self.model objectEnumerator];
}
-(NSString*)memberOfModel:(NSString *)object
{
    return [self.model objectForKey:object];
}

@end