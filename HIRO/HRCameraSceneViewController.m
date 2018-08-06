//
//  HRCameraSceneViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 6/15/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRCameraSceneViewController.h"
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <LLVideoEditor.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@import MobileCoreServices;


@interface HRCameraSceneViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    AVAssetExportSession* _assetExport;
}

@end

@implementation HRCameraSceneViewController


- (instancetype)initWithSceneNumber:(int)sceneNumber {
    self = [super init];
    if (self) {
        self.sceneNumber = sceneNumber;
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ////
    //    self.timeLeft = [[UILabel alloc] init];
    //    self.timeLeft.text = @"3";
    //    self.timeLeft.font = [UIFont fontWithName:@"Noteworthy-Light" size:50.0f];
    //    self.timeLeft.textColor = [UIColor whiteColor];
    //    [self.timeLeft sizeToFit];
    //    self.timeLeft.frame = CGRectMake(self.view.frame.size.width/2 - self.timeLeft.frame.size.width/2 , 50, self.timeLeft.frame.size.width, self.timeLeft.frame.size.height);
    //    [self.view addSubview:self.timeLeft];
    //
    //    self.currentTime = 3000;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.camera = [[LLSimpleCamera alloc] init];
    self.camera =  [[LLSimpleCamera alloc] initWithVideoEnabled:YES];
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    [self.camera start];

    self.firstFrameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SC1-Back"]];
    self.firstFrameView.frame = self.view.frame;
    [self.view addSubview:self.firstFrameView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 100, 100, 50);
    [button setTitle:@"Record" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tappedRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:@"SCENE1" withExtension:@"gif"];
//    NSString *path = [imgPath path];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
//
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//    imageView.animatedImage = image;
//    imageView.frame = self.view.frame;
//    [self.view addSubview:imageView];
}



- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)tappedRecord {
    self.firstFrameView.hidden = YES;
    
    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:@"SCENE1" withExtension:@"gif"];
    NSString *path = [imgPath path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];

//    [self record];
}

- (void)record {
    NSURL *outputURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test1"] URLByAppendingPathExtension:@"mov"];
    [self.camera startRecordingWithOutputUrl:outputURL didRecord:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
//
//        AVPlayer *player = [AVPlayer playerWithURL:outputFileUrl];
//        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//        playerViewController.player = player;
//        [self.picker presentViewController:playerViewController animated:YES completion:nil];
        
        //        VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:outputFileUrl];
        //        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}



//- (void)startTimer {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
//}
//- (void)updateTimer:(NSTimer *)timer {
//    self.currentTime -= 10 ;
//    [self populateLabelwithTime:self.currentTime];
//    if(self.currentTime == 0){
//
//
//        [self.timer invalidate];
//        return;
//    }
//}
//
//- (void)populateLabelwithTime:(int)milliseconds {
//    int seconds = milliseconds/1000;
//    int minutes = seconds / 60;
//    int hours = minutes / 60;
//
//    seconds -= minutes * 60;
//    minutes -= hours * 60;
//
//    NSString * result1 = [NSString stringWithFormat:@"%2d", seconds];
//    self.timeLeft.text = result1;
//    [self.timeLeft sizeToFit];
//    self.timeLeft.frame = CGRectMake(self.view.frame.size.width/2 - self.timeLeft.frame.size.width/2 , 50, self.timeLeft.frame.size.width, self.timeLeft.frame.size.height);
//
//
//}
@end
