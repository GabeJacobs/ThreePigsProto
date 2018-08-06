//
//  HRCameraSceneViewController.h
//  HIRO
//
//  Created by Gabe Jacobs on 6/15/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FastttCamera.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <GPUImage.h>
#import <LLSimpleCamera.h>
#import "FLAnimatedImage.h"

@interface HRCameraSceneViewController : UIViewController

- (instancetype)initWithSceneNumber:(int)sceneNumber;
@property (nonatomic) int sceneNumber;

@property (nonatomic, strong) LLSimpleCamera *camera;
@property (nonatomic, assign) NSTimeInterval videoInterval;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UILabel *timeLeft;
@property (nonatomic) int currentTime;
@property (nonatomic, strong) NSTimer * timer;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;

@property (strong, nonatomic) UIImageView *firstFrameView;



@end
