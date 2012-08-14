/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "MediaResource.h"

@interface MediaResource()

@property id delegate;

@end

@implementation MediaResource

@synthesize identifier = _identifier;
@synthesize mediaType = _mediaType;
@synthesize uploadedOn = _uploadedOn;
@synthesize metaData = _metaData;
@synthesize image = _image;
@synthesize user = _user;
@synthesize description = _description;
@synthesize licence = _licence;
@synthesize key = _key;
@synthesize isPrimaryMedia = _isPrimaryMedia;
@synthesize delegate = _delegate;
@synthesize mediaResources = _mediaResources;

#pragma mark - Initializers and JSON readers

// this actually gets passed the 'media' dictionary as it has meta data for the mediaresource as well such as licence..
-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"MediaResource.initWithJson:andNotifyDelegate:");
    
    self = [self init];
    
    self.delegate = delegate;
    self.identifier = [[dictionary objectForKey:@"MediaResource"] objectForKey:@"Id"];
    self.mediaType = [[dictionary objectForKey:@"MediaResource"] objectForKey:@"MediaType"];
    self.metaData = [[dictionary objectForKey:@"MediaResource"] objectForKey:@"Metadata"];
    self.uploadedOn = [NSDate ConvertFromJsonDate:[[dictionary objectForKey:@"MediaResource"] objectForKey:@"UploadedOn"]];
    self.key = [[dictionary objectForKey:@"MediaResource"] objectForKey:@"Key"];
    self.user = [[User alloc]initWithJson:[[dictionary objectForKey:@"MediaResource"] objectForKey:@"User"] andNotifyProjectLoaded:self];
    self.isPrimaryMedia = [[dictionary objectForKey:@"IsPrimaryMedia"] boolValue];
    self.licence = [dictionary objectForKey:@"licence"];
    self.description = [dictionary objectForKey:@"Description"];
    self.image = [[Image alloc]initWithJson:[[[dictionary objectForKey:@"MediaResource"] objectForKey:@"Image"]objectForKey:[BowerBirdConstants NameOfMediaResourceDisplayImage]]
                            havingImageName:[BowerBirdConstants NameOfMediaResourceDisplayImage]
             andNotifyImageDownloadComplete:self];
    
    return self;
}

-(void)loadMediaFromJson:(NSArray *)array
{
    if([BowerBirdConstants Trace]) NSLog(@"MediaResource.loadMediaFromJson:");
    
    NSMutableDictionary* mediaResources = [[NSMutableDictionary alloc]init];
    for (id mediaResource in array) {
        MediaResource* resource = [[MediaResource alloc]initWithJson:mediaResource andNotifyDelegate:self];
        if(resource){
            [mediaResources setObject:resource forKey: resource.identifier];
        }
    }
    
    self.mediaResources = [[NSDictionary alloc]initWithDictionary:mediaResources];
}

-(void)ImageFinishedLoading:(Image*)image;
{
    if([BowerBirdConstants Trace]) NSLog(@"MediaResource.ImageFinishedLoading:");
    
    if([self.delegate respondsToSelector:@selector(ImageFinishedLoading:)])
    {
        [self.delegate ImageFinishedLoading:self];
    }
}

@end