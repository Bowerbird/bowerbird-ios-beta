//
//  AvatarModel.h
//  BowerBird
//
//  Created by Hamish Crittenden on 7/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+NSNumber_ConvertMethods.h"
#import "BowerBirdConstants.h"
#import "RequestDataFromServer.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AvatarImageLoadCompleteDelegate.h"

@interface AvatarModel : NSObject <RequestDataFromServer>

@property (retain) ASINetworkQueue *networkQueue;

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* imageDimensionName;
@property (nonatomic,strong) NSString* fileName;
@property (nonatomic,strong) NSString* relativeUri;
@property (nonatomic,strong) NSString* format;
@property (nonatomic,strong) NSNumber* width;
@property (nonatomic,strong) NSNumber* height;
@property (nonatomic,strong) NSString* extension;
@property (nonatomic,strong) id avatarOwner;

// the binary image data to be displayed for this avatar
@property (nonatomic,strong) UIImage* image;

+(AvatarModel *)buildSingleFromJson:(NSDictionary *)properties;

+(NSDictionary *)buildManyFromJson:(NSDictionary *)properties;

// any object having an avatar can call this method to load it's image
-(void)loadImage:(id) withDelegate forAvatarOwnder:(id) avatarOwner;

@end