/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBValidationError;


@interface BBIdentifySightingEdit : NSObject


@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSString *taxonomy;
@property BOOL isCustomIdentification;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *kingdom;
@property (nonatomic,strong) NSString *phylum;
@property (nonatomic,strong) NSString *klass;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *family;
@property (nonatomic,strong) NSString *genus;
@property (nonatomic,strong) NSString *species;
@property (nonatomic,strong) NSString *subSpecies;
@property (nonatomic,strong) NSMutableArray *commonGroupNames;
@property (nonatomic,strong) NSMutableArray *commonNames;
@property (nonatomic,strong) BBValidationError *errors;


-(BBIdentifySightingEdit*)initWithSightingId:(NSString*)sightingId;
-(void)setCustomIdentification:(NSDictionary*)customId;


@end