//
//  BBMediaResourceCreate.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 14/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBMediaResourceCreate.h"

@implementation BBMediaResourceCreate

@synthesize  file = _file,
            usage = _usage,
              key = _key,
             type = _type,
         fileName = _fileName;


-(BBMediaResourceCreate*)initWithMedia:(BBMediaEdit*)media forUsage:(NSString*)usage {
    
    self = [super init];
    
    UIImage *fixedImage = [media.image normalizedImage];
    
    _file = UIImageJPEGRepresentation(fixedImage, 100);
    _type = @"file";
    _key = media.key;
    _usage = usage;
    
     // we don't have (easy) access to a native filename like the web client, so use the key.
    _fileName = [NSString stringWithFormat:@"%@.jpg", _key];
    
    return self;
}


-(NSData*)file {
    return _file;
}
-(void)setFile:(NSData *)file {
    _file = file;
}

-(NSString*)fileName {
    return _fileName;
}
-(void)setFileName:(NSString *)fileName {
    _fileName = fileName;
}

-(NSString*)usage {
    return _usage;
}
-(void)setUsage:(NSString *)usage {
    _usage = usage;
}

-(NSString*)key {
    return _key;
}
-(void)setKey:(NSString *)key {
    _key = key;
}

-(NSString*)type {
    return _type;
}
-(void)setType:(NSString *)type {
    _type = type;
}


@end