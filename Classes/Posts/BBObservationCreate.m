/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBObservationCreate.h"
#import "BBHelpers.h"
#import "SVProgressHUD.h"
#import "BBJsonResponse.h"


@implementation BBObservationCreate


#pragma mark -
#pragma mark - Member Accessors


@synthesize title = _title,
            observedOn = _observedOn,
            latitude = _latitude,
            longitude = _longitude,
            address = _address,
            isIdentificationRequired = _isIdentificationRequired,
            anonymiseLocation = _anonymiseLocation,
            category = _category,
            media = _media,
            projectIds = _projectIds;


-(NSString*)title { return _title; }
-(void)setTitle:(NSString *)title { _title = title; }
-(NSDate *)observedOn { return _observedOn; }
-(void)setObservedOn:(NSDate *)observedOn { _observedOn = observedOn; }
-(NSString *)latitude { return _latitude; }
-(void)setLatitude:(NSString *)latitude { _latitude = latitude; }
-(NSString *)longitude { return _longitude; }
-(void)setLongitude:(NSString *)longitude { _longitude = longitude; }
-(NSString *)address { return _address; }
-(void)setAddress:(NSString *)address { _address = address; }
-(BOOL)isIdentificationRequired { return _isIdentificationRequired; }
-(void)setIsIdentificationRequired:(BOOL)isIdentificationRequired { _isIdentificationRequired = isIdentificationRequired; }
-(BOOL)anonymiseLocation { return _anonymiseLocation; }
-(void)setAnonymiseLocation:(BOOL)anonymiseLocation { _anonymiseLocation = anonymiseLocation; }
-(NSString *)category { return _category; }
-(void)setCategory:(NSString *)category{ _category = category; }
-(NSArray *)media { return _media; }
-(void)setMedia:(NSArray *)media{ _media = media; }
-(NSArray *)projectIds { return _projectIds; }
-(void)setProjectIds:(NSArray *)projectIds { _projectIds = projectIds; }


#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBCreateSightingController.objectLoaderDidFailWithError:"];
    
    [BBLog Log:error.localizedDescription];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    [BBLog Log:@"BBCreateSightingController.request:didFailLoadWithError:"];
    
    [BBLog Log:[NSString stringWithFormat:@"%@%@", @"ERROR:", error.localizedDescription]];
    
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

-(void)request:(RKRequest*)request
didLoadResponse:(RKResponse*)response {
    [BBLog Log:@"BBCreateSightingController.request:didLoadResponse"];
    
    [BBLog Log:response.bodyAsString];
    
    if ([response isOK] && [response isJSON])
    {
        NSError* error = nil;
        id obj = [response parsedBody:&error];
        
        //RKObjectMapping *authenticationMap = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBAuthentication class]];
        RKObjectMapping *jsonResponseMap = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
        id mappedObject = [jsonResponseMap mappableObjectForData:obj];
        
        //id mappedObject = [authenticationMap mappableObjectForData:obj];
        // we have authenticated and are set to pull down the user's profile
        
        if([mappedObject isKindOfClass:[BBJsonResponse class]] && mappedObject != nil)
        {
            BBJsonResponse *serverJson = (BBJsonResponse*)mappedObject;
            
            if(serverJson.success)
            {
                [BBLog Log:@"Success"];
            }
            else {
                [BBLog Log:@"Failure"];
            }
        }
    }
    
    if([response isKindOfClass:[BBJsonResponse class]]){
        BBJsonResponse *result = (BBJsonResponse*)response;
        
        if(result.success){
            // the request was successfully completed
        }
        else {
            // the request was unsuccessful
        }
    }
}

-(void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBCreateSightingController.objectLoaderDidLoadUnexpectedResponse"];
    
    [BBLog Log:objectLoader.response.bodyAsString];
}

-(void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBCreateSightingController.objectLoaderDidFinishLoading:"];
    
    [SVProgressHUD showSuccessWithStatus:@"Sighting Saved"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"sightingUploaded" object:nil];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    // is it a JsonResponse?
}

-(void)objectLoader:(RKObjectLoader *)objectLoader
didLoadObjectDictionary:(NSDictionary *)dictionary {
    
}

-(void)processMappingResult:(RKObjectMappingResult *)result {
    [BBLog Log:@"BBCreateSightingController.processMappingResult:"];
    
}


@end