//
//  BBVoteController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 25/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BBVoteController.h"
#import "BBVoteDelegateProtocol.h"

@interface BBVoteController ()
@property (nonatomic,weak) id<BBVoteDelegateProtocol> contribution;
@property (nonatomic,strong) id voteRequest;
@end

@implementation BBVoteController {
    MGLine *scoreLine, *favouriteLine;
    MGBox *ratingBox, *favoriteWrapper;
    CoolMGButton *upVoteBtn, *downVoteBtn, *favBtn;
    UIColor *votedColor, *notVotedColor;
    UILabel *scoreLabel;
    int myVoteScore, totalVoteScore;
}

@synthesize contribution = _contribution,
            voteRequest = _voteRequest;

-(id)initWithObservation:(BBObservation*)observation {

    self = [super init];
    
    if(self){
        _contribution = observation;
        myVoteScore = [observation.userVoteScore intValue];
        totalVoteScore = [observation.totalVoteScore intValue];
    }
    
    return self;
}

-(id)initWithObservationNote:(BBObservationNote*)observationNote {
    
    self = [super init];
    
    if(self){
        _contribution = observationNote;
        myVoteScore = [observationNote.userVoteScore intValue];
        totalVoteScore = [observationNote.totalVoteScore intValue];
    }
    
    return self;
}

-(id)initWithIdentification:(BBIdentification*)identification {
    
    self = [super init];
    
    if(self){
        _contribution = identification;
        myVoteScore = [identification.userVoteScore intValue];
        totalVoteScore = [identification.totalVoteScore intValue];
    }
    
    return self;
}

-(void)loadView {

    CGSize size = [self screenSize];
    
    MGBox *voteView = [MGBox boxWithSize:CGSizeMake(size.width, 40)];
    votedColor = [UIColor colorWithRed:0.38 green:0.9 blue:0.65 alpha:1];
    notVotedColor = [UIColor colorWithRed:0.38 green:0.65 blue:0.9 alpha:1];
    [voteView.boxes addObject:[self displayVotePanel]];
    
    self.view = voteView;
    
    [((MGBox*)self.view) layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(MGLine*)displayVotePanel {
-(MGBox*)displayVotePanel {
    NSString* contributionType = NSStringFromClass([_contribution class]);
    
    MGBox *votePanel;

    // the different vote models route to different resource paths as defined at the bottom of BBMapper.m
    if([contributionType isEqualToString:@"BBObservation"]) {

        _voteRequest = [[BBVoteCreate alloc]initWithObservation:_contribution
                                                             andScore:_contribution.totalVoteScore];
        
        votePanel = [self displayVotablePanel];
    }
    else if([contributionType isEqualToString:@"BBObservationNote"] || [contributionType isEqualToString:@"BBIdentification"]) {
        
        _voteRequest = [[BBSubVoteCreate alloc]initWithObservationNote:_contribution
                                                                       andScore:_contribution.totalVoteScore];
        
        votePanel = [self displayVotablePanel];
    }
    
    return votePanel;
}

-(MGBox*)displayVotablePanel {
    
    ratingBox = [MGBox boxWithSize:CGSizeMake(320, 40)];
    ratingBox.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    __block BBVoteController *this = self;
    
    upVoteBtn = [[CoolMGButton alloc]initWithFrame:CGRectMake(0, 0, 65, 40)];
    [upVoteBtn setTitle:@"+1" forState:UIControlStateNormal];
    upVoteBtn.titleLabel.font = HEADER_FONT_XBIG;
    [upVoteBtn onControlEvent:UIControlEventTouchUpInside do:^{[this voteUpOrDown:YES];}];
    [upVoteBtn setButtonColor:(myVoteScore > 0 ? votedColor : notVotedColor)];

    scoreLine = [MGLine lineWithSize:CGSizeMake(80, 40)];
    scoreLine.font = HEADER_FONT_XBIG;
    [scoreLine.middleItems addObject:[NSString stringWithFormat:@"%i", totalVoteScore]];
    scoreLine.middleItemsTextAlignment = UITextAlignmentCenter;
    
    downVoteBtn = [[CoolMGButton alloc]initWithFrame:CGRectMake(0, 0, 65, 40)];
    [downVoteBtn setTitle:@"-1" forState:UIControlStateNormal];
    downVoteBtn.titleLabel.font = HEADER_FONT_XBIG;
    [downVoteBtn onControlEvent:UIControlEventTouchUpInside do:^{[this voteUpOrDown:NO];}];
    [downVoteBtn setButtonColor:(myVoteScore < 0 ? votedColor : notVotedColor)];
    
    ratingBox.contentLayoutMode = MGLayoutGridStyle;
    [ratingBox.boxes addObject:upVoteBtn];
    [ratingBox.boxes addObject:scoreLine];
    [ratingBox.boxes addObject:downVoteBtn];
    
    if([self.contribution respondsToSelector:@selector(favouritesCount)])
    {
        BOOL isFavorite = self.contribution.userFavourited;
        
        UIView *favouriteRating = [[BBStarView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)
                                                      andFavouriteType:(isFavorite ? BBFavouriteSelected : BBFavouriteNotSelected)
                                                           andBgColour:[UIColor clearColor]
                                                           andStarSize:15];
        
        favoriteWrapper = [MGBox boxWithSize:CGSizeMake(favouriteRating.width+20, favouriteRating.height)];
        favoriteWrapper.backgroundColor = [UIColor clearColor];
        
        // http://stackoverflow.com/questions/2264083/rounded-uiview-using-calayers-only-some-corners-how
        // Create the path (with only the top-left corner rounded)
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:favoriteWrapper.bounds
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(8.0, 8.0)];
        
        // Create the shape layer and set its path
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = favoriteWrapper.bounds;
        maskLayer.path = maskPath.CGPath;
        
        // Set the newly created shape layer as the mask for the image view's layer
        favoriteWrapper.layer.mask = maskLayer;
        
        favoriteWrapper.margin = UIEdgeInsetsMake(0, 20, 0, 0);
        favoriteWrapper.onTap = ^{[this toggleFavourite];};

        [favoriteWrapper addSubview:favouriteRating];
        [ratingBox.boxes addObject:favoriteWrapper];
    }
    
    [ratingBox layout];
    
    return ratingBox;
}

-(void)voteUpOrDown:(BOOL)isVotingUpClicked {
    switch (myVoteScore) {
        default:
        // user hasn't voted. If up clicked, increment. If down clicked, decrement.
        case 0: isVotingUpClicked ? [self incrementWith:1] : [self decrementWith:1];
        break;
        // user has voted up previously. If up clicked, revert to 0, if down clicked, decrement to -1
        case 1: isVotingUpClicked ? [self decrementWith:1] : [self decrementWith:2];
        break;
        // user has voted down previously. If up clicked, increment to 1, else reveert to 0.
        case -1: isVotingUpClicked ? [self incrementWith:2] : [self incrementWith:1];
        break;
    }
    
    [self recalibrate];
}

-(void)toggleFavourite {
    
    [_contribution toggleFavourite];
    
    BOOL isFavorite = [_contribution userFavourited];
    
    UIView *favouriteRating = [[BBStarView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)
                                                  andFavouriteType:(isFavorite ? BBFavouriteSelected : BBFavouriteNotSelected)
                                                       andBgColour:[UIColor clearColor]
                                                       andStarSize:15];

    for (UIView *view in favoriteWrapper.subviews) [view removeFromSuperview];
    [favoriteWrapper addSubview:favouriteRating];
    
    NSString *sightingId = ((BBVoteCreate*)self.voteRequest).identifier;
    BBFavouriteId *favourite = [[BBFavouriteId alloc]initWithObservationId:sightingId];
    
    [favouriteLine layout];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    [manager postObject:favourite delegate:self];
}

-(void)recalibrate {
    
    [BBLog Log:@"recalibrating votes"];
    
    [downVoteBtn setButtonColor:(myVoteScore < 0 ? votedColor : notVotedColor)];
    [upVoteBtn setButtonColor:(myVoteScore > 0 ? votedColor : notVotedColor)];
    
    [scoreLine.middleItems removeAllObjects];
    [scoreLine.middleItems addObject:[NSString stringWithFormat:@"%i", totalVoteScore]];
    
    [(MGBox*)self.view layout];
}

-(void)incrementWith:(int)number {
    myVoteScore = myVoteScore + number;
    totalVoteScore = totalVoteScore + number;
    
    [(BBVoteCreate*)_voteRequest increment];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    //[manager postObject:self.voteRequest delegate:self];
    [manager postObject:_voteRequest usingBlock:^(RKObjectLoader *loader) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:[BBConstants AjaxRequestParams] copyItems:YES];
        [parameters setObject:[NSString stringWithFormat:@"%i", myVoteScore] forKey:@"Score"];
        loader.params = parameters;
    }];
    
}

-(void)decrementWith:(int)number {
    myVoteScore = myVoteScore - number;
    totalVoteScore = totalVoteScore - number;

    [(BBVoteCreate*)_voteRequest decrement];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;

    //[manager postObject:self.voteRequest delegate:self];
    
    // trying to manually inject ajax functionality and controller action params..
    [manager postObject:_voteRequest usingBlock:^(RKObjectLoader *loader) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:[BBConstants AjaxRequestParams] copyItems:YES];
        [parameters setObject:[NSString stringWithFormat:@"%i", myVoteScore] forKey:@"Score"];
        loader.params = parameters;
    }];
    
}

@end