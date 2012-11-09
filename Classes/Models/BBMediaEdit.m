//
//  BBMediaCreate.m
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBMediaEdit.h"

@implementation BBMediaEdit

@synthesize description = _description,
                  image = _image,
         isPrimaryImage = _isPrimaryImage,
                licence = _licence;


-(NSString*)description {
    return _description;
}

-(void)setDescription:(NSString *)description {
    _description = description;
}


-(UIImage*)image {
    return _image;
}

-(void)setImage:(UIImage *)image {
    _image = image;
}


-(BOOL)isPrimaryImage {
    return _isPrimaryImage;
}

-(void)setIsPrimaryImage:(BOOL)isPrimaryImage {
    _isPrimaryImage = isPrimaryImage;
}


-(NSString*)licence {
    return _licence;
}

-(void)setLicence:(NSString *)licence {
    _licence = licence;
}

@end