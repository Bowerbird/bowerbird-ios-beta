/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Display the full contribution model with buttons to add notes and identifications, favourite 
 a sighting or vote on contributions
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingDetailController.h"
#import "BBActivity.h"
#import "MGHelpers.h"
#import "PhotoBox.h"
#import "BBUIControlHelper.h"
#import "MBProgressHUD.h"
#import "BBCreateSightingNoteController.h"
#import "BBIdentifySightingController.h"
#import "DWTagList.h"
#import "BBArrowView.h"
#import "PDLocation.h"
#import "MapPoint.h"
#import "BBDisplayLocationController.h"
#import "BBDisplayFullImageController.h"
#import "SVProgressHUD.h"
#import "BBSubVoteCreate.h"
#import "BBVoteController.h"
#import "BBAppDelegate.h"
#import "BBSighting.h"
#import "BBObservation.h"
#import "BBUser.h"
#import "BBObservationNote.h"
#import "BBMedia.h"
#import "BBIdentification.h"
#import "BBMediaResource.h"
#import "BBVideo.h"
#import "BBAudio.h"
#import "BBUIMediaHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "LBYouTubePlayerController.h"


static CGRect MapOriginalFrame;
static CGRect MapFullFrame;


@interface BBSightingDetailController()

@property (nonatomic,strong) BBSighting* sighting;
@property (nonatomic,strong) NSString* identifier;
-(MGBox*)displayMapInBox;
- (void)showAnnotationsOnMapWithLocations:(NSArray *)aLocations;
- (MKCoordinateRegion)regionThatFitsAllLocations:(PDLocation *)location;

@end


@implementation BBSightingDetailController {
    MGScrollView* sightingView;
    UIImage *arrow, *back;
    PhotoBox *fullSizeImage;
    id contributionForVoting;
    AVAudioPlayer *audioPlayer;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize mapView = _mapView,
            sighting = _sighting,
            identifier = _identifier;


#pragma mark -
#pragma mark - Constructors


-(BBSightingDetailController*)initWithSightingIdentifier:(NSString*)identifier {

    self = [super init];
    
    _identifier = identifier;
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBSightingDetailController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [UIColor blackColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    sightingView = (MGScrollView*)self.view;
    self.mapView = [[MKMapView alloc]init];
    
    // LOAD THIS OBSERVATION FROM THE SERVER
    NSString *sightingUrl = [NSString stringWithFormat:@"%@/%@?%@", [BBConstants RootUriString], _identifier, @"X-Requested-With=XMLHttpRequest"];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager loadObjectsAtResourcePath:sightingUrl delegate:self];
    
    [SVProgressHUD showWithStatus:@"Loading Sighting"];
}

-(void)viewDidLoad {
    [BBLog Log:@"BBSightingDetailController.viewDidLoad"];
    
    [super viewDidLoad];
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
    back = [UIImage imageNamed:@"back.png"];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displaySighting {
    [BBLog Log:@"BBSightingDetailController.displaySighting"];
    
    // CONTAINER AND MODEL
    MGTableBox *info = [MGTableBox boxWithSize:[self screenSize]];
    info.backgroundColor = [UIColor whiteColor];
    
    MGTableBox *ids = [MGTableBox boxWithSize:[self screenSize]];
    ids.backgroundColor = [UIColor blackColor];
    ids.margin = UIEdgeInsetsMake(10, 0, 0, 0);
    
    MGTableBox *notes = [MGTableBox boxWithSize:[self screenSize]];
    notes.backgroundColor = [UIColor blackColor];
    notes.margin = UIEdgeInsetsMake(10, 0, 0, 0);
    
    BBObservation *observation = (BBObservation*)_sighting;

    // HEADING
    [info.topLines addObject:[self createHeaderLineWithDescription:_sighting.title]];

    // MEDIA
    [info.middleLines addObject:[self displayMedia:observation]];
    
    // CATEGORY
    [info.middleLines addObject:[self sightingCategory:observation.category]];
    
    // MAP
    [info.middleLines addObject:[self displayMapInBox]];
    
    // USER
    [info.middleLines addObject:[self sightingUser:observation]];
    
    [info.bottomLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Rating"
                                                                      forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
    
    // VOTES
    BBVoteController *voteController = [[BBVoteController alloc]initWithObservation:observation];
    [info.bottomLines addObject:voteController.view];
    
    // Add the Sighting to the View
    [sightingView.boxes addObject:info];
    
    // IDENTIFICATIONS
    for(BBIdentification *identification in observation.identifications) {
        [ids.middleLines addObject:[self addIdentification:identification]];
    }
    if(observation.identifications.count > 0) {
        NSString* identificationsCountTitle = observation.identifications.count > 1 ?
        [NSString stringWithFormat:@"Sighting has %i Identifications", observation.identifications.count] :
        [NSString stringWithFormat:@"Sighting has %i Identification", observation.identifications.count];
        
        MGLine *identificationsTitle = [MGLine lineWithLeft:identificationsCountTitle right:nil size:CGSizeMake(300, 20)];
        identificationsTitle.margin = UIEdgeInsetsMake(5, 10, 5, 0);
        identificationsTitle.textColor = [self backgroundColor];
        identificationsTitle.backgroundColor = [UIColor blackColor];
        
        [ids.topLines addObject:identificationsTitle];
        
        [sightingView.boxes addObject:ids];
    }
    
    // NOTES
    for (BBObservationNote *observationNote in observation.notes) {
        [notes.middleLines addObject:[self addObservationNote:observationNote]];
    }
    if(observation.notes.count > 0) {
        NSString* notesCountTitle = observation.notes.count > 1 ?
        [NSString stringWithFormat:@"Sighting has %i Notes", observation.identifications.count] :
        [NSString stringWithFormat:@"Sighting has %i Note", observation.identifications.count];
        
        MGLine *notesTitle = [MGLine lineWithLeft:notesCountTitle right:nil size:CGSizeMake(300, 20)];
        notesTitle.textColor = [self backgroundColor];
        notesTitle.backgroundColor = [UIColor blackColor];
        notesTitle.margin = UIEdgeInsetsMake(5, 10, 5, 0);
        
        [notes.topLines addObject:notesTitle];
        [sightingView.boxes addObject:notes];
    }
    
    // CONTROLS
    [sightingView.boxes addObject:[self addDescribeIdentifyButtons:observation]];
    
    [sightingView layoutWithSpeed:0.3 completion:nil];
}

-(MGLine*)sightingCategory:(NSString*)category {
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [category lowercaseString]];
    PhotoBox *photo = [PhotoBox mediaForImage:[UIImage imageNamed:iconPath] size:CGSizeMake(50,50)];
    MGLine *categoryNameLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"Category: %@", category] right:nil size:CGSizeMake(210, 50)];
    categoryNameLine.underlineType = MGUnderlineNone;
    categoryNameLine.font = HEADER_FONT;
    MGLine *categoryLine = [MGLine lineWithLeft:photo right:categoryNameLine size:CGSizeMake(280, 50)];
    categoryLine.margin = UIEdgeInsetsMake(0, 0, 10, 10);
    categoryLine.underlineType = MGUnderlineNone;
    
    return categoryLine;
}

-(MGLine*)sightingUser:(BBObservation*)observation {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDate dateFormatHumanReadable]];
    
    // USER
    MGLine *userWhoAddedSighting = [self createUserProfileLineForUser:observation.user
                                                      withDescription:[NSString stringWithFormat:@"%@\nsighted on %@", observation.user.name, [dateFormatter stringFromDate:observation.observedOnDate]]
                                                              forSize:CGSizeMake(IPHONE_STREAM_WIDTH-20, 60)];
    
    userWhoAddedSighting.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    userWhoAddedSighting.font = HEADER_FONT;

    return userWhoAddedSighting;
}

-(MGLine*)sightingNoteUser:(BBUser*)user
                   forNote:(BBObservationNote*)note {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDate dateFormatHumanReadable]];
    
    // USER
    MGLine *userWhoAddedSighting = [self createUserProfileLineForUser:user
                                                      withDescription:[NSString stringWithFormat:@"%@\ndescribed on %@", user.name, [dateFormatter stringFromDate:note.createdOn]]
                                                              forSize:CGSizeMake(IPHONE_STREAM_WIDTH-20, 60)];
    
    userWhoAddedSighting.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    userWhoAddedSighting.font = HEADER_FONT;
    
    return userWhoAddedSighting;
}

-(MGLine*)sightingIdentificationUser:(BBUser*)user
                   forIdentification:(BBIdentification*)identification {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDate dateFormatHumanReadable]];
    
    // USER
    MGLine *userWhoAddedIdentification = [self createUserProfileLineForUser:user
                                                      withDescription:[NSString stringWithFormat:@"%@\nidentified on %@", user.name, identification.createdOnDescription]
                                                              forSize:CGSizeMake(IPHONE_STREAM_WIDTH-20, 60)];
    
    userWhoAddedIdentification.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    //userWhoAddedIdentification.font = HEADER_FONT;
    
    return userWhoAddedIdentification;
}

-(MGLine*)createHeaderLineWithDescription:(NSString*)description {
    
    MGBox *backArrow = [self getBackArrow];
    backArrow.margin = UIEdgeInsetsMake(0, 10, 0, 0);
    
    BBObservation *observation = (BBObservation*)_sighting;
    
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = [self screenSize].width - backArrow.width - horizontalPaddingTotalWidth;
    MGLine *descriptionLine = [MGLine multilineWithText:observation.title
                                               font:HEADER_FONT
                                              width:descriptionWidth
                                            padding:UIEdgeInsetsMake(15, horizontalPaddingTotalWidth/2, 0, horizontalPaddingTotalWidth/2)];
    
    // HEADER
    MGLine *header = [MGLine lineWithLeft:backArrow
                                    right:descriptionLine
                                     size:CGSizeMake([self screenSize].width, 60)];
    
    header.underlineType = MGUnderlineNone;
    header.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];;
    header.onTap =^{
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
    };
    
    return header;
}

-(MGLine *)createUserProfileLineForUser:(BBUser*)usr
                        withDescription:(NSString*)desc
                                forSize:(CGSize)size {
    [BBLog Log:@"BBUIControlHelper.createUserProfileDescriptionForUser"];
    
    // AVATAR
    BBImage *avatarImage = [BBCollectionHelper getImageWithDimension:@"Square50" fromArrayOf:usr.avatar.imageMedia];
    PhotoBox *avatar = [PhotoBox mediaFor:avatarImage.uri size:CGSizeMake(50, 50)];
    avatar.padding = UIEdgeInsetsZero;
    avatar.margin = UIEdgeInsetsZero;
    
    // parameterise the allowable size for the description line. Allows caller to put an arrow to the left or right of the user profile.
    double horizontalPaddingTotalWidth = 10;
    double descriptionWidth = size.width - 50 - horizontalPaddingTotalWidth;
    
    // ACTIVITY DISCRIPTION
    MGLine *description = [MGLine multilineWithText:desc
                                               font:DESCRIPTOR_FONT
                                              width:descriptionWidth
                                            padding:UIEdgeInsetsMake(15, 0, 0, horizontalPaddingTotalWidth)];
    
    description.underlineType = MGUnderlineNone;
    
    // COMBINED AVATAR AND DESCRIPTION
    MGLine *user = [MGLine lineWithLeft:avatar
                                  right:description size:size];
    
    user.underlineType = MGUnderlineNone;
    
    return user;
}

-(MGBox*)displayMapInBox {
    MGBox *mapBox = [MGBox boxWithSize:CGSizeMake(300, [self screenSize].height/2)];
    
    mapBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.mapView = [[MKMapView alloc]initWithFrame:mapBox.frame];
    self.mapView.scrollEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
    [mapBox addSubview:self.mapView];
    
    MapOriginalFrame = self.mapView.frame;
    MapFullFrame = CGRectMake(0, 0, [self screenSize].width, [self screenSize].height);
    
    PDLocation *location = [[PDLocation alloc] initWithName:_sighting.title
                                                description:_sighting.address
                                                andLocation:CLLocationCoordinate2DMake(_sighting.latitude,_sighting.longitude)];
    
    __weak UINavigationController *nav = self.navigationController;
    mapBox.onTap = ^{
        BBDisplayLocationController *locationController = [[BBDisplayLocationController alloc]initWithLocation:location];
        [nav pushViewController:locationController animated:NO];
    };
    
    MapPoint *mapPoint = [[MapPoint alloc] initWithCoordinate:location.location title:location.name subTitle:location.description];
    [self.mapView addAnnotation:mapPoint];
    MKCoordinateRegion region = [self regionThatFitsAllLocations:location];
    [self.mapView setRegion:region];
    
    MGBox *locationBox = [MGBox boxWithSize:CGSizeMake(300, 100)];
    locationBox.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    
    BBObservation *observation = (BBObservation*)_sighting;

    // LATITUDE
    [locationBox.boxes addObject:[BBUIControlHelper createTwoColumnRowWithleftText:@"Latitude:"
                                                                     andRightText:[NSString stringWithFormat:@"%f", observation.latitude]
                                                                        andHeight:30
                                                                     andLeftWidth:100
                                                                    andRightWidth:200]];
    
    
    // LONGITUDE
    [locationBox.boxes addObject:[BBUIControlHelper createTwoColumnRowWithleftText:@"Longitude:"
                                                                     andRightText:[NSString stringWithFormat:@"%f", observation.longitude]
                                                                        andHeight:30
                                                                     andLeftWidth:100
                                                                    andRightWidth:200]];
    
    //MGLine *addressLine = [MGLine lineWithLeft:@"Address:" multilineRight:observation.address width:300 minHeight:30];
    [locationBox.boxes addObject:[BBUIControlHelper createTwoColumnRowWithleftText:@"Address:"
                                                                      andRightText:observation.address
                                                                         andHeight:30
                                                                      andLeftWidth:100
                                                                     andRightWidth:200]];
    
    MGBox *mapWrapperBox = [MGBox box];
    [mapWrapperBox.boxes addObject:mapBox];
    [mapWrapperBox.boxes addObject:locationBox];
    
    return mapWrapperBox;
}

-(MGBox*)displayMedia:(BBObservation*)observation {
    
    MGBox *mediaWrapperBox = [MGBox box];
    
    BBImage *fullSize, *originalSize;
    BBVideo *originalVideo;
    BBAudio *originalAudio;
    
    BBMediaType mediaType = [BBUIMediaHelper typeOfMedia:observation.primaryMedia.mediaResource.mediaType];
    
    if(mediaType == BBMediaImage) {
        fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
        originalSize = [self getImageWithDimension:@"Original" fromArrayOf:observation.primaryMedia.mediaResource.imageMedia];
    }
    else if (mediaType == BBMediaVideo) {
        fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:observation.primaryMedia.mediaResource.videoMedia];
        originalVideo = (BBVideo*)[BBUIMediaHelper getMediaOfSize:@"Original" from:observation.primaryMedia.mediaResource.videoMedia];
    }
    else if (mediaType == BBMediaAudio){
        fullSize = [BBCollectionHelper getImageWithDimension:@"Constrained240" fromArrayOf:observation.primaryMedia.mediaResource.audioMedia];
        originalAudio = (BBAudio*)[BBUIMediaHelper getMediaOfSize:@"Original" from:observation.primaryMedia.mediaResource.audioMedia];
    }
    
    MGBox* currentImageBox = [MGBox box];
    currentImageBox.width = 300;
    __weak PhotoBox *currentPic = [PhotoBox mediaFor:fullSize.uri size:CGSizeMake(300, 240)];
    
    if(mediaType == BBMediaImage){
        // do this bit if mediaType is an image:
        __weak UINavigationController *nav = self.navigationController;
        currentPic.onTap = ^{
            BBDisplayFullImageController *fullImageController = [[BBDisplayFullImageController alloc]initWithImage:originalSize];
            [nav pushViewController:fullImageController animated:NO];
        };
    }
    else if(mediaType == BBMediaVideo){
        currentPic.onTap = ^{
            [self displayVideoPlayer:originalVideo toReplace:currentPic];
        };
    }
    else if(mediaType == BBMediaAudio){
        currentPic.onTap = ^{
            [self displayAudioPlayer:originalAudio toReplace:currentPic];
        };
    }
    
    [currentImageBox.boxes addObject:currentPic];
    
    [mediaWrapperBox.boxes addObject:currentImageBox];
    MGBox *thumbs = [MGBox box];
    thumbs.width = 300;
    thumbs.contentLayoutMode = MGLayoutGridStyle;
    // add the thumb nails
    if(observation.media.count > 1)
    {
        // take the current box out - add the new box
        for (__block BBMedia* m in observation.media) {
            MGBox *thumb;
            BBMediaType mediaType = [BBUIMediaHelper typeOfMedia:m.mediaResource.mediaType];
            if(mediaType == BBMediaImage){
                thumb = [PhotoBox mediaFor:[self getImageWithDimension:@"Square100" fromArrayOf:m.mediaResource.imageMedia].uri
                                      size:(CGSizeMake(90, 90))];
                
                thumb.onTap = ^{
                    [self displayFullSizeImage:m toReplace:currentPic];
                };
            }
            else if(mediaType == BBMediaVideo){
                thumb = [PhotoBox mediaFor:[self getImageWithDimension:@"Square100" fromArrayOf:m.mediaResource.videoMedia].uri
                                      size:(CGSizeMake(90, 90))];
                
                thumb.onTap = ^{
                    BBVideo *vid = (BBVideo*)[BBUIMediaHelper getMediaOfSize:@"Original" from:m.mediaResource.videoMedia];
                    [self displayVideoPlayer:vid toReplace:currentPic];
                };
            }
            else if (mediaType == BBMediaAudio){
                thumb = [PhotoBox mediaFor:[self getImageWithDimension:@"Square100" fromArrayOf:m.mediaResource.audioMedia].uri
                                      size:(CGSizeMake(90, 90))];
                
                thumb.onTap = ^{
                    BBAudio *aud = (BBAudio*)[BBUIMediaHelper getMediaOfSize:@"Original" from:m.mediaResource.audioMedia];
                    [self displayAudioPlayer:aud toReplace:currentPic];
                };
            }
            
            [thumbs.boxes addObject:thumb];
        }
    }
    [mediaWrapperBox.boxes addObject:thumbs];

    return mediaWrapperBox;
}

-(MKCoordinateRegion)regionThatFitsAllLocations:(PDLocation *)location {
    float Lat_Min = location.location.latitude -1, Lat_Max = location.location.latitude + 1;
    float Long_Max = location.location.longitude + 1, Long_Min = location.location.longitude - 1;
    
    CLLocationCoordinate2D min = CLLocationCoordinate2DMake(Lat_Min, Long_Min);
    CLLocationCoordinate2D max = CLLocationCoordinate2DMake(Lat_Max, Long_Max);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((max.latitude + min.latitude) / 2.0, (max.longitude + min.longitude) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(max.latitude - min.latitude, max.longitude - min.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    return region;
}

-(void)displayFullSizeImage:(BBMedia*)media
                  toReplace:(PhotoBox*)content {
    [BBLog Log:@"BBSightingDetailController.displayFullSizeImage"];
    
    BBImage *fullSize = [self getImageWithDimension:@"Constrained240"
                                        fromArrayOf:media.mediaResource.imageMedia];
    
    BBImage *originalSize = [self getImageWithDimension:@"Original"
                                            fromArrayOf:media.mediaResource.imageMedia];
    
    PhotoBox *fullSizePhoto = [PhotoBox mediaFor:fullSize.uri
                                            size:CGSizeMake(300, 240)];
    
    __weak UINavigationController *nav = self.navigationController;
    fullSizePhoto.onTap = ^{
        [nav pushViewController:[[BBDisplayFullImageController alloc]initWithImage:originalSize]
                       animated:NO];
    };
    
    MGBox *section = (id)content.parentBox;
    [section.boxes removeAllObjects];
    [section.boxes addObject:fullSizePhoto];
    
    [section layoutWithSpeed:0.0 completion:nil];
}

-(void)displayAudioPlayer:(BBAudio*)audio
                toReplace:(PhotoBox*)content {

    NSError *error;
    
    NSURL *audioUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString], audio.uri]];
    
    NSData *_objectData = [NSData dataWithContentsOfURL:audioUrl];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
    
    //audioPlayer.numberOfLoops = -1;
    
    if (audioPlayer == nil){
        //NSLog(error.localizedDescription);
    }
    else 
        [audioPlayer play];
}

-(void)displayVideoPlayer:(BBVideo*)video
                toReplace:(PhotoBox*)content {
    
    //BBVideo *video = (BBVideo*)[BBUIMediaHelper getMediaOfSize:@"Constrained240" from:media.mediaResource.videoMedia];
    
    MGBox *videoBox = [MGBox boxWithSize:CGSizeMake(300, 240)];
    videoBox.margin = UIEdgeInsetsMake(10, 10, 0, 0);
    
    __block LBYouTubePlayerController* youtube = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:video.uri] quality:LBYouTubeVideoQualityLarge];
    youtube.delegate = self;
    youtube.view.frame = videoBox.frame;
    youtube.view.center = videoBox.center;
    [videoBox addSubview:youtube.view];
    
    videoBox.onTap = ^{
        [youtube play];
    };
    
    MGBox *section = (id)content.parentBox;
    [section.boxes removeAllObjects];
    [section.boxes addObject:videoBox];
    
    [section layoutWithSpeed:0.0 completion:nil];
}

-(MGTableBox*)addIdentification:(BBIdentification*)identification {
    MGTableBox *idBox = [MGTableBox boxWithSize:CGSizeMake(320, 100)];
    idBox.backgroundColor = [UIColor whiteColor];
    idBox.margin = UIEdgeInsetsMake(5, 0, 0, 0);
    
    // IDENTIFICATION
    if(identification) {
        [idBox.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Idenfitication"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        [idBox.middleLines addObject:[BBUIControlHelper createIdentification:identification
                                                                    forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 80)]];
    }
    
    // TAXONOMY
    if(![identification.taxonomy isEqualToString:@""]) {
        [idBox.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Taxonomy"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        MGLine *taxa = [MGLine multilineWithText:identification.taxonomy
                                            font:DESCRIPTOR_FONT
                                           width:IPHONE_STREAM_WIDTH
                                         padding:UIEdgeInsetsMake(5, 10, 5, 10)];
        taxa.underlineType = MGUnderlineNone;
        [idBox.middleLines addObject:taxa];
    }
    
    // USER
    [idBox.bottomLines addObject:[self sightingIdentificationUser:identification.user forIdentification:identification]];
    
    
    [idBox.bottomLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Rating"
                                                                     forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
    
    // VOTES
    BBVoteController *voteController = [[BBVoteController alloc]initWithIdentification:identification];
    [idBox.bottomLines addObject:voteController.view];
    
    return idBox;
}

-(MGTableBox*)addObservationNote:(BBObservationNote*)observationNote {
    MGTableBox *note = [MGTableBox boxWithSize:CGSizeMake(320, 100)];
    note.backgroundColor = [UIColor whiteColor];
    note.margin = UIEdgeInsetsMake(5, 0, 0, 0);
        
    // DESCRIPTIONS
    if(observationNote.descriptionCount > 0) {
        
        for (BBSightingNoteDescription* description in observationNote.descriptions) {
            
            [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:description.label
                                                                             forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
            
            MGLine *descriptionLine = [MGLine multilineWithText:description.text
                                                           font:DESCRIPTOR_FONT
                                                          width:IPHONE_STREAM_WIDTH
                                                        padding:UIEdgeInsetsMake(5, 10, 5, 10)];
            descriptionLine.underlineType = MGUnderlineNone;
            
            [note.middleLines addObject:descriptionLine];
        }
    }
    
    // TAGS
    if(observationNote.tagCount > 0) {
        [note.middleLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Tags"
                                                                         forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
        
        // grab tags from controller
        NSArray *tags = [observationNote.allTags componentsSeparatedByString:@","];
        MGBox *tagBox;
        
        DWTagList *tagList = [[DWTagList alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
        [tagList setTags:tags];
        
        double minHeight = tagList.fittedSize.height;
        
        tagBox = [MGBox boxWithSize:CGSizeMake(280, minHeight)];
        tagBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
        [tagBox addSubview:tagList];
        
        [note.middleLines addObject:tagBox];
    }
        
    // USER
    [note.bottomLines addObject:[self sightingNoteUser:observationNote.user forNote:observationNote]];
    
    
    [note.bottomLines addObject:[BBUIControlHelper createSubHeadingWithTitle:@"Rating"
                                                                      forSize:CGSizeMake(IPHONE_STREAM_WIDTH, 20)]];
    
    // VOTES
    BBVoteController *voteController = [[BBVoteController alloc]initWithObservationNote:observationNote];
    [note.bottomLines addObject:voteController.view];
    
    return note;
}

-(MGBox*)addDescribeIdentifyButtons:(BBObservation*)observation {
    
    CoolMGButton *describeButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 155, 60) andTitle:@"Describe" withBlock:^{
        BBCreateSightingNoteController *createNoteController = [[BBCreateSightingNoteController alloc]initWithSightingId:observation.identifier];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:createNoteController animated:NO];
    }];
    
    describeButton.margin = UIEdgeInsetsMake(5, 0, 5, 5);
    MGBox *describeBox = [MGBox boxWithSize:CGSizeMake(160, 50)];
    [describeBox.boxes addObject:describeButton];
    
    CoolMGButton *identifyButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 155, 60) andTitle:@"Identifiy" withBlock:^{
        BBIdentifySightingController *identifySightingController = [[BBIdentifySightingController alloc]initWithSightingId:observation.identifier];
        [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:identifySightingController animated:NO];
    }];
    
    identifyButton.margin = UIEdgeInsetsMake(5, 5, 5, 0);
    MGBox *identifyBox = [MGBox boxWithSize:CGSizeMake(160, 50)];
    [identifyBox.boxes addObject:identifyButton];
    
    MGBox *describeIdentifyBox = [MGBox boxWithSize:CGSizeMake(320, 50)];
    describeIdentifyBox.contentLayoutMode = MGLayoutGridStyle;
    [describeIdentifyBox.boxes addObject:describeBox];
    [describeIdentifyBox.boxes addObject:identifyBox];
    
    return describeIdentifyBox;
}


#pragma mark -
#pragma mark - Delegation and Event Handling

#pragma mark -
#pragma mark LBYouTubePlayerViewControllerDelegate


-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller failedExtractingYouTubeURLWithError:(NSError *)error {
    NSLog(@"Failed loading video due to error:%@", error);
}

-(void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBSightingDetailController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBSightingDetailController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)objectLoader:(RKObjectLoader *)objectLoader
   didFailWithError:(NSError *)error {
    [BBLog Log:@"BBSightingDetailController.objectLoader:didFailWithError:"];
    
    [SVProgressHUD showErrorWithStatus:error.description];
}

-(void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBSightingDetailController.objectLoaderDidFinishLoading:"];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBSightingDetailController.objectLoader:didLoadObject:"];
    
    [SVProgressHUD dismiss];
    
    if([object isKindOfClass:[BBObservation class]]) {
        _sighting = object;
        [self displaySighting];
    }
}

-(MGBox*)getBackArrow {
    // Set up reusable forward and back arrows
    UIView *backArrow = [[BBArrowView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)
                                         andDirection:BBArrowBack
                                       andArrowColour:[UIColor colorWithRed:0.26 green:0.57 blue:0.88 alpha:1.0]
                                          andBgColour:[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]];
    
    MGBox *arrowWrapper = [MGBox boxWithSize:CGSizeMake(backArrow.width, backArrow.height)];
    [arrowWrapper addSubview:backArrow];
    
    return arrowWrapper;
}


@end