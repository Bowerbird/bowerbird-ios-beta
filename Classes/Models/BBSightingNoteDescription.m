//
//  BBSightingNoteDescription.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 23/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBSightingNoteDescription.h"

@implementation BBSightingNoteDescription

@synthesize     identifier = _identifier,
                     group = _group,
                     label = _label,
               description = _description,
                      text = _text;


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


-(NSString*)text {
    return _text;
}
-(void)setText:(NSString *)text {
    _text = text;
}


@end