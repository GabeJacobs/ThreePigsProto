//
//  HRConfirmVideoViewController.h
//  HIRO
//
//  Created by Gabe Jacobs on 8/8/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FLAnimatedImage.h"

@interface HRConfirmVideoViewController : UIViewController

- (instancetype)initWithVideoURL:(NSURL *)video andSceneNumber:(int)sceneNumber;

@property (nonatomic) NSURL *videoURL;

@property (nonatomic, strong) UIButton *tryAgainButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic) AVPlayer *avPlayer;
@property (nonatomic) FLAnimatedImageView *animatedView;
@property (nonatomic) AVPlayerLayer *videoLayer;
@property (nonatomic) int sceneNumber;


@end
