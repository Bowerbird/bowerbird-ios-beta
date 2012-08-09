/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "AvatarModel.h"

@interface AvatarModel()
@property (nonatomic, weak) id<AvatarImageLoadCompleteDelegate> imageLoadDelegate;
@end

@implementation AvatarModel

@synthesize networkQueue;
@synthesize identifier = _identifier;
@synthesize imageDimensionName = _imageDimensionName;
@synthesize fileName = _fileName;
@synthesize relativeUri = relativeUri;
@synthesize format = _format;
@synthesize width = _width;
@synthesize height = _height;
@synthesize extension = _extension;
@synthesize image = _image;
@synthesize avatarOwner = _avatarOwner;


#pragma mark - Class methods for iterating JSON blobs.

-(id)initWithJsonBlob:(NSDictionary *)jsonBlob;
{
    AvatarModel* model = [[AvatarModel alloc]init];
    
    model.identifier = [jsonBlob objectForKey:@"Id"];
    model.fileName = [jsonBlob objectForKey:@"FileName"];
    model.relativeUri = [jsonBlob objectForKey:@"RelativeUri"];
    model.format = [jsonBlob objectForKey:@"Format"];
    model.width = [NSNumber ConvertFromString:[jsonBlob objectForKey:@"Width"]];
    model.height = [NSNumber ConvertFromString:[jsonBlob objectForKey:@"Height"]];
    model.extension = [jsonBlob objectForKey:@"Extension"];
    
    return self;
}


// needs to be passed dictionary of Json object of Avatar Images
// then extracts them with known avatar image property names
+(NSDictionary *)buildManyFromJson:(NSDictionary *)properties
{
    NSMutableDictionary* avatarList;
    
    if(properties)
    {
        avatarList = [[NSMutableDictionary alloc]init];

        for (NSString* avatarType in [BowerBirdConstants AvatarTypes])
        {
            NSDictionary* avatarJson = [properties objectForKey:avatarType];
            AvatarModel* avatar = [[AvatarModel alloc]initWithJsonBlob:avatarJson];
            avatar.imageDimensionName = avatarType;
            [avatarList setObject:(avatar) forKey:avatar.imageDimensionName];
        }
    }
    
    return avatarList;
}


#pragma mark - Network methods for loading Avatar Images from Media Urls

- (void)doGetRequest:(NSURL *)withUrl
{
	[[self networkQueue] cancelAllOperations];
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:withUrl];
    [[self networkQueue] addOperation:request];
	[[self networkQueue] go];
}

// grab projects from server then display in table
- (void)requestFinished:(ASIHTTPRequest *)request
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    
    self.image = [UIImage imageWithData:[request responseData]];

    if([self.imageLoadDelegate respondsToSelector:@selector(ImageFinishedLoading:forAvatarOwner:)])
    {
        [self.imageLoadDelegate ImageFinishedLoading:(self.imageDimensionName)
                                      forAvatarOwner:(self.avatarOwner)];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    NSError * error = [request error];
	NSLog(@"Request failed: %@", [error localizedDescription]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}


#pragma mark - Callback methods to this and methods setting this as delegate
 

// set up the calling object having an avatar as the delegate to notify when the
// image for the avatar has been loaded
-(void)loadImage:(id)withDelegate
    forAvatarOwner:(id)avatarOwner
{
    self.imageLoadDelegate = withDelegate;
    self.avatarOwner = avatarOwner;
    
    [self doGetRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [BowerBirdConstants RootUriString], self.relativeUri]]];
}


@end