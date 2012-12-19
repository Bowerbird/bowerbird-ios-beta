//
//  BBSightingNoteDescription.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 23/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBSightingNoteDescription.h"


/*
 The SightingNoteDescription is a single item model representation of the JSON returned from the server when
 a request is made for the collection of descriptions that are used in a sighting note.
 
 At this point, it does NOT include the user entered text field
 */
@implementation BBSightingNoteDescription

@synthesize     identifier = _identifier,
                     group = _group,
                     label = _label,
               description = _description,
                      name = _name,
                      text = _text;


-(BBSightingNoteDescription*)initWithProperties:(NSString*)descriptionId
                                          group:(NSString*)descriptionGroup
                                     groupLabel:(NSString*)descriptionGroupLabel
                                           name:(NSString*)descriptionName
                                    description:(NSString*)descriptionDescription {
    self = [super init];
    
    _identifier = descriptionId;
    _group = descriptionGroup;
    _label = descriptionGroupLabel;
    _name = descriptionName;
    _description = descriptionDescription;
    
    return self;
}


-(NSString*)identifier {
    return _identifier;
}
-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}


-(NSString*)group {
    return _group;
}
-(void)setGroup:(NSString *)group {
    _group = group;
}


-(NSString*)label {
    return _label;
}
-(void)setLabel:(NSString *)label {
    _label = label;
}


-(NSString*)description {
    return _description;
}
-(void)setDescription:(NSString *)description {
    _description = description;
}


-(NSString*)name {
    return _name;
}
-(void)setName:(NSString *)name {
    _name = name;
}

-(NSString*)text {
    return _text;
}
-(void)setText:(NSString *)text {
    _text = text;
}


+(NSArray*)getSightingNoteDescriptions
{
    NSMutableArray *descriptions = [[NSMutableArray alloc]init];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"physicaldescription"
                                                                           group:@"lookslike"
                                                                      groupLabel:@"Looks Like"
                                                                            name:@"Physical Description"
                                                                     description:@"The physical characteristics of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"similarspecies"
                                                                           group:@"lookslike"
                                                                      groupLabel:@"Looks Like"
                                                                            name:@"Similar Species"
                                                                     description:@"How the species sighting is similar to other species"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"distribution"
                                                                           group:@"wherefound"
                                                                      groupLabel:@"Where Found"
                                                                            name:@"Distribution"
                                                                     description:@"The geographic distribution of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"habitat"
                                                                           group:@"wherefound"
                                                                      groupLabel:@"Where Found"
                                                                            name:@"Habitat"
                                                                     description:@"The habitat of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"seasonalvariation"
                                                                           group:@"wherefound"
                                                                      groupLabel:@"Where Found"
                                                                            name:@"Seasonal Variation"
                                                                     description:@"Any seasonal variation of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"conservationstatus"
                                                                           group:@"wherefound"
                                                                      groupLabel:@"Where Found"
                                                                            name:@"Conservation Status"
                                                                     description:@"The conservation status of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"behaviour"
                                                                           group:@"whatitdoes"
                                                                      groupLabel:@"What It Does"
                                                                            name:@"Behaviour"
                                                                     description:@"What is the species in the sighting doing?"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"food"
                                                                           group:@"whatitdoes"
                                                                      groupLabel:@"What It Does"
                                                                            name:@"Food"
                                                                     description:@"What is the species in the sighting eating"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"lifecycle"
                                                                           group:@"whatitdoes"
                                                                      groupLabel:@"What It Does"
                                                                            name:@"Life Cycle"
                                                                     description:@"The life cycle stage or breeding characteristic of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"indigenouscommonnames"
                                                                           group:@"cultural"
                                                                      groupLabel:@"Cultural"
                                                                            name:@"Indigenous Common Names"
                                                                     description:@"Any indigenous common names associated with the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"traditionalstories"
                                                                           group:@"cultural"
                                                                      groupLabel:@"Cultural"
                                                                            name:@"Usage in Indigenous Culture"
                                                                     description:@"Any special usage in indigenous cultures of the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"physicaldescription"
                                                                           group:@"cultural"
                                                                      groupLabel:@"Cultural"
                                                                            name:@"Traditional Stories"
                                                                     description:@"Any traditional stories associated with the species in the sighting"]];
    
    [descriptions addObject:[[BBSightingNoteDescription alloc]initWithProperties:@"general"
                                                                           group:@"other"
                                                                      groupLabel:@"Other"
                                                                            name:@"General Details"
                                                                     description:@"Any other general details"]];
    
    return descriptions;
}


+(BBSightingNoteDescription*)getDescriptionByIdentifier:(NSString*)identifier {
    NSArray *descriptions = [BBSightingNoteDescription getSightingNoteDescriptions];
    __block BBSightingNoteDescription *selectedDescription = nil;
    [descriptions enumerateObjectsUsingBlock:^(BBSightingNoteDescription *obj, NSUInteger idx, BOOL *stop) {
        if([obj.identifier isEqualToString:identifier]) {
            *stop = YES;
            selectedDescription = obj;
        }
    }];
    
    return selectedDescription;
}


@end