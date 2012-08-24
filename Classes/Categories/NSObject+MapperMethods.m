//
//  BBNSObject+MapperMethods.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "BBModels.h"
#import "NSObject+MapperMethods.h"


@implementation NSObject (MapperMethods)

-(id) BBObject
{
    NSObject *bbObject = [[NSObject alloc]init];
    
    RKObjectMapping *payloadMap = [[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[BBSignalRPayload class]];

    bbObject = [payloadMap mappableObjectForData:self];
        
    return bbObject;
}

@end