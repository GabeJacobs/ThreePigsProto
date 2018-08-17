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
#import "HRConfirmVideoViewController.h"

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
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StopMusic"
     object:self];

    
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
//    [self.camera attachToViewController:self withFrame:CGRectMake(screenRect.size.width - (screenRect.size.width*.75), screenRect.size.height - (screenRect.size.height*.75), screenRect.size.width*.75, screenRect.size.height*.75)];
        [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];

    [self.camera start];

    self.firstFrameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SC1-Back"]];
    self.firstFrameView.frame = self.view.frame;
    [self.view addSubview:self.firstFrameView];
    
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordButton setImage:[UIImage imageNamed:@"RecordButton"] forState:UIControlStateNormal];
//    self.recordButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
//    self.recordButton.imageView.layer.cornerRadius = 7.0f;
//    self.recordButton.layer.shadowOffset = CGSizeMake(0, 7);
//    self.recordButton.layer.shadowRadius = 5;
//    self.recordButton.layer.shadowOpacity = 0.25;
//    self.recordButton.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.recordButton.layer.masksToBounds = NO;
    //    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    //    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:20];
    //    [self.recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.recordButton.frame = CGRectMake(self.view.frame.size.width/2 - [UIImage imageNamed:@"RecordButton"].size.width/2, self.view.frame.size.height - 140, [UIImage imageNamed:@"RecordButton"].size.width, [UIImage imageNamed:@"RecordButton"].size.height);
    [self.recordButton addTarget:self action:@selector(tappedRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
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
    self.recordButton.userInteractionEnabled = NO;
    self.recordButton.frame = CGRectMake(25,25, [UIImage imageNamed:@"RecordButton"].size.width, [UIImage imageNamed:@"RecordButton"].size.height);
    self.recordButton.hidden = YES;

    self.firstFrameView.hidden = YES;
    
    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:@"SCENE1" withExtension:@"gif"];
    NSString *path = [imgPath path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    
    [self.view bringSubviewToFront:self.recordButton];

    [self record];
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:5.16];
}

- (void)record {
    NSURL *outputURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test1"] URLByAppendingPathExtension:@"mov"];
    
    self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:.6 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.recordButton.hidden = !self.recordButton.hidden;
    }];

    [self.camera startRecordingWithOutputUrl:outputURL didRecord:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {

        
        HRConfirmVideoViewController *confirmController = [[HRConfirmVideoViewController alloc] initWithVideoURL:outputFileUrl];
        [self.navigationController pushViewController:confirmController animated:YES];

        
    }];
    
}


- (void)stopRecord {
    [self.blinkTimer invalidate];
    [self.camera stopRecording];
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
