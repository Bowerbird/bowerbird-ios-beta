//
//  BBObservationMediaCreate.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 16/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBObservationMediaCreate.h"

@implementation BBObservationMediaCreate

@synthesize mediaResourceId = _mediaResourceId,
                description = _description,
             isPrimaryMedia = _isPrimaryMedia,
                    licence = _licence;


-(NSString*)mediaResourceId {
    return _mediaResourceId;
}
-(void)setMediaResourceId:(NSString *)mediaResourceId {
    _mediaResourceId = mediaResourceId;
}

-(NSString*)description {
    return _description;
}
-(void)setDescription:(NSString *)description {
    _description = description;
}

-(BOOL)isPrimaryMedia {
    return _isPrimaryMedia;
}
-(void)setIsPrimaryMedia:(BOOL)isPrimaryMedia {
    _isPrimaryMedia = isPrimaryMedia;
}

-(NSString*)licence {
    return _licence;
}
-(void)setLicence:(NSString *)licence {
    _licence = licence;
}

@end