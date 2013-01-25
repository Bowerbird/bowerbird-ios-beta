//
//  BBVoteController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 25/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBVoteController.h"
#import "BBVoteDelegateProtocol.h"

@interface BBVoteController ()
@property (nonatomic,weak) id<BBVoteDelegateProtocol> contribution;
@property (nonatomic,strong) NSNumber *myVoteScore;
@property (nonatomic,strong) NSNumber *totalVoteScore;
@property (nonatomic,strong) id voteRequest;
@end

@implementation BBVoteController {
    MGLine *upVote, *scoreLine, *downVote, *ratingLine;
}

@synthesize contribution = _contribution,
            myVoteScore = _myVoteScore,
            totalVoteScore = _totalVoteScore,
            voteRequest = _voteRequest;

-(id)initWithObservation:(BBObservation*)observation {

    self = [super init];
    
    if(self){
        _contribution = observation;
        _myVoteScore = observation.userVoteScore;
        _totalVoteScore = observation.totalVoteScore;
    }
    
    return self;
}

-(id)initWithObservationNote:(BBObservationNote*)observationNote {
    
    self = [super init];
    
    if(self){
        _contribution = observationNote;
        _myVoteScore = observationNote.userVoteScore;
        _totalVoteScore = observationNote.totalVoteScore;
    }
    
    return self;
}

-(id)initWithIdentification:(BBIdentification*)identification {
    
    self = [super init];
    
    if(self){
        _contribution = identification;
        _myVoteScore = identification.userVoteScore;
        _totalVoteScore = identification.totalVoteScore;
    }
    
    return self;
}

-(void)loadView {
    // set up a view to be screen sized by a reasonable height.
    CGSize size = [self screenSize];
    
    MGBox *voteView = [MGBox boxWithSize:CGSizeMake(size.width, 100)];
    
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

-(MGLine*)displayVotePanel {
    NSString* contributionType = NSStringFromClass([_contribution class]);
    
    MGLine *votePanel;

    // the different vote models route to different resource paths
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

-(MGLine*)displayVotablePanel {
    
    ratingLine = [MGLine lineWithSize:CGSizeMake(300, 40)];
    
    __block BBVoteController *this = self;
    
    upVote = [MGLine lineWithLeft:@"+1" right:nil size:CGSizeMake(90, 40)];
    scoreLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%i", [_totalVoteScore intValue]] right:nil size:CGSizeMake(90, 40)];
    downVote = [MGLine lineWithLeft:@"-1" right:nil size:CGSizeMake(90, 40)];
    
    upVote.onTap = ^{
        // if we've previously down voted, ignore, otherwise either vote up or undo upvote
        if([this.myVoteScore intValue] == 0){
            [this increment];
        }
        else if([this.myVoteScore intValue] > 0){
            [this decrement];
        }
        
        [this recalibrate];
    };
    
    downVote.onTap = ^{
        // if we've previously upvoted, ignore, otherwise either vote down or undo down vote
        if([this.myVoteScore intValue] == 0){
            [this decrement];
        }
        else if([this.myVoteScore intValue] < 0){
            [this increment];
        }
        
        [this recalibrate];
    };
    
    [ratingLine.leftItems addObject:upVote];
    [ratingLine.middleItems addObject:scoreLine];
    [ratingLine.rightItems addObject:downVote];
    
    ratingLine.leftItemsTextAlignment = NSTextAlignmentCenter;
    ratingLine.middleItemsTextAlignment = NSTextAlignmentCenter;
    ratingLine.rightItemsTextAlignment = NSTextAlignmentCenter;
    
    if([_myVoteScore intValue] > 0){
        // toggle +1 as ticked
        upVote.backgroundColor = [UIColor greenColor];
        downVote.backgroundColor = [UIColor blueColor];
    }
    else if([_myVoteScore intValue] == 0) {
        // nothing is ticked
        downVote.backgroundColor = [UIColor blueColor];
        upVote.backgroundColor = [UIColor blueColor];
    }
    else if([_myVoteScore intValue] < 0) {
        // toggle -1 is ticked
        downVote.backgroundColor = [UIColor greenColor];
        upVote.backgroundColor = [UIColor blueColor];
    }
    
    scoreLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%i", [_myVoteScore intValue]]
                               right:nil
                                size:CGSizeMake(90, 40)];
    
    return ratingLine;
}

-(void)recalibrate {
    
    [BBLog Log:@"recalibrating votes"];
    
    if([_myVoteScore intValue] > 0){
        // toggle +1 as ticked
        upVote.backgroundColor = [UIColor greenColor];
        downVote.backgroundColor = [UIColor blueColor];
    }
    else if([_myVoteScore intValue] == 0) {
        // nothing is ticked
        downVote.backgroundColor = [UIColor blueColor];
        upVote.backgroundColor = [UIColor blueColor];
    }
    else if([_myVoteScore intValue] < 0) {
        // toggle -1 is ticked
        downVote.backgroundColor = [UIColor greenColor];
        upVote.backgroundColor = [UIColor blueColor];
    }
    
    [ratingLine.middleItems removeAllObjects];
    
    scoreLine = [MGLine lineWithLeft:[NSString stringWithFormat:@"%i", [_totalVoteScore intValue]]
                               right:nil
                                size:CGSizeMake(90, 40)];
    
    [ratingLine.middleItems addObject:scoreLine];
    
    [(MGBox*)self.view layout];
}

-(void)increment {
    _myVoteScore = [[NSNumber alloc]initWithInt:([_myVoteScore intValue] + 1)];
    _totalVoteScore = [[NSNumber alloc]initWithInt:([_totalVoteScore intValue] + 1)];
    
    [(BBVoteCreate*)_voteRequest increment];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    [manager putObject:_voteRequest delegate:self];
}

-(void)decrement {
    _myVoteScore = [[NSNumber alloc]initWithInt:([_myVoteScore intValue] - 1)];
    _totalVoteScore = [[NSNumber alloc]initWithInt:([_totalVoteScore intValue] - 1)];

    [(BBVoteCreate*)_voteRequest decrement];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    [manager putObject:_voteRequest delegate:self];
}

#pragma mark -
#pragma mark - Delegation and Event Handling

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBVoteController.objectLoaderDidFailWithError:"];
    
    [BBLog Log:error.localizedDescription];
}

-(void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [BBLog Log:@"BBVoteController.request:didLoadResponse"];
       
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
    [BBLog Log:@"BBVoteController.objectLoaderDidLoadUnexpectedResponse"];
    
    [BBLog Log:objectLoader.response.bodyAsString];
}

-(void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBVoteController.objectLoaderDidFinishLoading:"];
    
}

@end