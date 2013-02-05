/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCategory.h"


@interface BBCategory()

-(id)initWithIdentifier:(NSString*)identifier
                andName:(NSString*)name;

@end


@implementation BBCategory


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            name = _name,
            taxonomy = _taxonomy;


-(NSString*)identifier { return _identifier; }
-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)name { return _name; }
-(void)setName:(NSString *)name { _name = name; }
-(NSString*)taxonomy { return _taxonomy; }
-(void)setTaxonomy:(NSString *)taxonomy { _taxonomy = taxonomy; }
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"Id"]) self.identifier = value;
}


#pragma mark -
#pragma mark - Constructors


-(id)initWithIdentifier:(NSString*)identifier
                andName:(NSString*)name {
    
    BBCategory *category = [[BBCategory alloc]init];
    
    category.identifier = identifier;
    category.name = name;
    
    return category;
}


#pragma mark -
#pragma mark - Helpers and Utilities


+(NSArray*)getCategoryList {
    NSMutableArray *categories = [[NSMutableArray alloc]init];
    
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Amphibians" andName:@"Amphibians"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Birds" andName:@"Birds"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Fishes" andName:@"Fishes"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Fungi & Lichens" andName:@"Fungi & Lichens"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Invertebrates" andName:@"Invertebrates"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Others" andName:@"Others"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Plants" andName:@"Plants"]];
    [categories addObject:[[BBCategory alloc]initWithIdentifier:@"Reptiles" andName:@"Reptiles"]];
    
    return [[NSArray alloc]initWithArray:categories];
}


@end