//
//  HRWatchMovieViewController.h
//  HIRO
//
//  Created by Gabe Jacobs on 8/21/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HRWatchMovieViewController : UIViewController <UITextFieldDelegate>

- (instancetype)initWithVideo:(NSDictionary *)video alreadySaved:(BOOL)isSaved;


@property (nonatomic) NSDictionary *video;

@property (nonatomic) NSURL *videoURL;
@property (nonatomic) BOOL isSaved;

@property (nonatomic, strong) UIButton *pauseOverlayButton;

@property (nonatomic) AVPlayer *avPlayer;
@property (nonatomic) UIImageView *animatedView;
@property (nonatomic) AVPlayerLayer *videoLayer;
@property (nonatomic) int sceneNumber;

@property (nonatomic, strong) UIView *pausedOverlay;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *homeButton;

@property (nonatomic) BOOL playingGIF;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSMutableArray *imageArrayStraw;
@property (nonatomic, strong) NSMutableArray *imageArrayStick;
@property (nonatomic, strong) NSMutableArray *imageArrayBrick;
@property (nonatomic, strong) NSMutableArray *imageArrayEnd;

@property (nonatomic, strong) UIImageView *stillImageFrame;

@end
