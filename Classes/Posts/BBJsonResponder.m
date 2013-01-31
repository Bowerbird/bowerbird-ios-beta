/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBJsonResponder.h"
#import "BBHelpers.h"
#import "BBJsonResponse.h"


@implementation BBJsonResponder


#pragma mark -
#pragma mark - RestKit Delegate methods


-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBJsonResponder.didLoadObject"];
    
    BOOL succeeded = NO;
    
    if ([objectLoader.response isOK] && [objectLoader.response isJSON])
    {
        NSError* error = nil;
        
        // obj is a dictionary with the keys: Model.Success = 1/0
        id obj = [objectLoader.response parsedBody:&error];
        
        RKObjectMapping *jsonResponseMap = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
        id mappedObject = [jsonResponseMap mappableObjectForData:obj];
        
        if([mappedObject isKindOfClass:[BBJsonResponse class]] && mappedObject != nil)
        {
            id success = [[obj objectForKey:@"Model"] objectForKey:@"Success"];
            
            if(success){
                succeeded = [[NSNumber numberWithInt:(int)success] boolValue];
            }

            [self dealWithResponse:succeeded];
            // now we can test the succeeded value for actioning the response in the context of the request, as in,
            // this was a BBProjectId object so we've either joined or left a project.
            // requires the Project List to be refetched, the Menu to be reloaded,
        }
    }
}


#pragma mark -
#pragma mark - Utilities


-(void)dealWithResponse:(BOOL)success {
    [BBLog Log:@"BBJsonResponder.dealWithResponse"];
    
    if(success) {
        [BBLog Log:@"Project was successfully joined/removed"];
    }
    else {
        [BBLog Log:@"Project join/remove didn't work"];
    }
}

-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}


@end