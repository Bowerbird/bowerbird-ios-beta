//
//  BBMulitipartForm.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 14/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBMultipartForm : NSObject

+ (void)addFormDataWithParameters:(NSDictionary *)parameters toURLRequest:(NSMutableURLRequest *)request;

+ (void)addMultipartDataWithParameters:(NSDictionary *)parameters toURLRequest:(NSMutableURLRequest *)request;

+ (NSData *)multipartDataWithParameters:(NSDictionary *)parameters boundary:(NSString **)boundary;

+ (void)appendToMultipartData:(NSMutableData *)data key:(NSString *)key value:(id)value;

@end