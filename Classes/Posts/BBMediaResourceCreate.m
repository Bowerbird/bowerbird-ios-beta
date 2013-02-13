/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMediaResourceCreate.h"
#import "BBMediaEdit.h"
#import "SVProgressHUD.h"
#import "BBHelpers.h"
#import "BBJsonResponse.h"


@implementation BBMediaResourceCreate


#pragma mark -
#pragma mark - Member Accessors


@synthesize file = _file,
            usage = _usage,
            key = _key,
            type = _type,
            fileName = _fileName;


-(NSData*)file { return _file; }
-(void)setFile:(NSData *)file { _file = file; }
-(NSString*)fileName { return _fileName; }
-(void)setFileName:(NSString *)fileName { _fileName = fileName; }
-(NSString*)usage { return _usage; }
-(void)setUsage:(NSString *)usage { _usage = usage; }
-(NSString*)key { return _key; }
-(void)setKey:(NSString *)key { _key = key; }
-(NSString*)type { return _type; }
-(void)setType:(NSString *)type { _type = type; }
- (void)setValue:(id)value forUndefinedKey:(NSString *)key { if([key isEqualToString:@"Key"]) self.key = value; }


#pragma mark -
#pragma mark - Constructors


-(BBMediaResourceCreate*)initWithMedia:(BBMediaEdit*)media
                              forUsage:(NSString*)usage {
    
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
    
    [SVProgressHUD showSuccessWithStatus:@"Media Uploaded"];
    
    //BBMediaEdit *media = [_observation.media lastObject];
    //[_observationEditView addMediaItem:media];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mediaUploaded" object:nil];
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

             -(void)request:(RKRequest *)request
             didReceiveData:(NSInteger)bytesReceived
         totalBytesReceived:(NSInteger)totalBytesReceived
totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive {
    [BBLog Log:[NSString stringWithFormat:@"bytes received: %d total received: %d total to receive: %d", bytesReceived, totalBytesReceived, totalBytesExpectedToReceive]];
}

           -(void)request:(RKRequest *)request
          didSendBodyData:(NSInteger)bytesWritten
        totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    //[BBLog Log:[NSString stringWithFormat:@"bytes written: %d total written: %d total to send: %d", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite]];
    
    double progress = ((double)totalBytesWritten/(double)totalBytesExpectedToWrite)*100;
    //double fileSize = (double)totalBytesExpectedToWrite/10485760;// added additional factor of ten to bytes denomenator in MB as too big by about 10 X
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    [formatter setGeneratesDecimalNumbers:YES];
    [formatter setMaximumFractionDigits:1];
    
    [SVProgressHUD setStatus:[NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:[NSNumber numberWithDouble:progress]], @"%"]];
    
    if(progress == 100){
        [SVProgressHUD setStatus:@"File Uploaded. \nWaiting for save confirmation"];
    }    
}

-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}



@end