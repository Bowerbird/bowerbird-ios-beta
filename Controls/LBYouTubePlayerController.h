//
//  LBYouTubePlayerController.h
//  LBYouTubeView
//
//  Created by Laurin Brandner on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  https://github.com/larcus94/LBYouTubeView
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LBYouTubePlayerController : UIView {
    MPMoviePlayerController* controller;
}

@property (nonatomic, strong, readonly) MPMoviePlayerController* controller;

-(void)loadYouTubeVideo:(NSURL*)URL;

@end
