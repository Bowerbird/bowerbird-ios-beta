/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBProjectId.h"
#import "BBHelpers.h"
#import "BBJsonResponse.h"


@implementation BBProjectId


#pragma mark -
#pragma mark - Member Constructors


-(id)initWithProjectId:(NSString *)identifier {
    self = [super initWithId:identifier];
    
    if(self) {
        self.identifier = identifier;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Delegation and Event Handling for Project leave/join button clicking


-(void)objectLoader:(RKObjectLoader *)objectLoader
   didFailWithError:(NSError *)error {
    [BBLog Log:@"BBProjectId.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
}


-(void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
    
}


    -(void)objectLoader:(RKObjectLoader *)objectLoader
didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBProjectId.didLoadObjectDictionary"];
    
    for (NSString* key in dictionary) {
        [BBLog Log:[NSString stringWithFormat:@"%@: %@", key, [dictionary objectForKey:key]]];
    }
}


-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBProjectId.didLoadObject"];
    
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
         
            // now we can test the succeeded value for actioning the response in the context of the request, as in,
            // this was a BBProjectId object so we've either joined or left a project.
            // requires the Project List to be refetched, the Menu to be reloaded, 
        }
    }
}


-(void)dealloc {
    [[[RKClient sharedClient] requestQueue] cancelRequestsWithDelegate:(id)self];
}

@end