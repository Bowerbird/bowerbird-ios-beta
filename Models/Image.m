/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> This class is called to parse avatar data and load avatar images
 
 -----------------------------------------------------------------------------------------------*/

#import "Image.h"

@interface Image()

@property (nonatomic, weak) id<ImageLoaded> imageLoadDelegate;
@property (nonatomic,strong) Image* avatar;

@end


@implementation Image

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
@synthesize avatar = _avatar;


#pragma mark - Initializers and JSON parsing methods

-(id)initWithJson:(NSDictionary *)dictionary andNotifyImageDownloadComplete:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"Image.initWithJson:andNotifiyImageDownloadComplete:");
    
    self.imageLoadDelegate = delegate;
    self.fileName = [dictionary objectForKey:@"FileName"];
    self.relativeUri = [dictionary objectForKey:@"RelativeUri"];
    self.format = [dictionary objectForKey:@"Format"];
    self.width = [NSNumber ConvertFromString:[dictionary objectForKey:@"Width"]];
    self.height = [NSNumber ConvertFromString:[dictionary objectForKey:@"Height"]];
    self.extension = [dictionary objectForKey:@"Extension"];
    self.imageDimensionName = [BowerBirdConstants NameOfAvatarImageThatGetsDisplayed];

    [self doGetRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BowerBirdConstants RootUriString], self.relativeUri]]];
        
    return self;
}


#pragma mark - Network methods for loading Image from Media Urls

- (void)doGetRequest:(NSURL *)withUrl
{
    if([BowerBirdConstants Trace]) NSLog(@"Image.doGetRequest: %@", withUrl);
    
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Image.requestFinished:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    
    self.image = [UIImage imageWithData:[request responseData]];

    if([self.imageLoadDelegate respondsToSelector:@selector(ImageFinishedLoading:)])
    {
        [self.imageLoadDelegate ImageFinishedLoading:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Image.requestFailed:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
	NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
    if([BowerBirdConstants Trace]) NSLog(@"Image.queueFinished:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}

@end