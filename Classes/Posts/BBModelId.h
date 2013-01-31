/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


@interface BBModelId : NSObject //: BBJsonResponder


@property (nonatomic, strong) NSString *identifier;


-(id)initWithId:(NSString*)identifier;


@end