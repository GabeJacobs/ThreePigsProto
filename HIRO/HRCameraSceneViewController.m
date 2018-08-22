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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.camera = [[LLSimpleCamera alloc] init];
    self.camera =  [[LLSimpleCamera alloc] initWithVideoEnabled:YES];
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
//    [self.camera attachToViewController:self withFrame:CGRectMake(screenRect.size.width - (screenRect.size.width*.75), screenRect.size.height - (screenRect.size.height*.75), screenRect.size.width*.75, screenRect.size.height*.75)];
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];

    [self.camera start];

    self.firstFrameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"SC%d-Back", self.sceneNumber]]];
    self.firstFrameView.frame = self.view.frame;
    [self.view addSubview:self.firstFrameView];
    
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordButton setImage:[UIImage imageNamed:@"RecordButton"] forState:UIControlStateNormal];
    self.recordButton.frame = CGRectMake(self.view.frame.size.width/2 - [UIImage imageNamed:@"RecordButton"].size.width/2, self.view.frame.size.height - 140, [UIImage imageNamed:@"RecordButton"].size.width, [UIImage imageNamed:@"RecordButton"].size.height);
    [self.recordButton addTarget:self action:@selector(tappedRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
    self.countdownView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 85 - 20, 26, 85,85)];
    self.countdownView.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:174.0f/255.0f blue:239.0f/255.0f alpha:1.0];
    self.countdownView.layer.cornerRadius = 85/2;
    self.countdownView.hidden = YES;
    [self.view addSubview:self.countdownView];
    
    self.countdownLabel = [[UILabel alloc] initWithFrame:self.countdownView.bounds];
    [self.countdownLabel setText:@"5"];
    [self.countdownLabel setTextAlignment:NSTextAlignmentCenter];
    [self.countdownLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:38]];
    [self.countdownLabel setTextColor:[UIColor whiteColor]];
    [self.countdownView addSubview:self.countdownLabel];
    
    NSLog(@"%d",self.sceneNumber);
    NSLog(@"%@",[NSString stringWithFormat:@"SCENE%d", self.sceneNumber]);

    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"SCENE%d", self.sceneNumber] withExtension:@"gif"];
    NSString *path = [imgPath path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.aniamtedImageView = [[FLAnimatedImageView alloc] init];
    self.aniamtedImageView.animatedImage = image;
    self.aniamtedImageView.frame = self.view.frame;
    self.aniamtedImageView.hidden = YES;
    [self.view addSubview:self.aniamtedImageView];
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
    self.recordButton.hidden = YES;
    self.firstFrameView.hidden = YES;
    self.aniamtedImageView.hidden = NO;
    [self.aniamtedImageView startAnimating];
    
    [self.view bringSubviewToFront:self.recordButton];
    [self.view bringSubviewToFront:self.countdownView];

    [self record];
    if(self.sceneNumber == 4) {
        [self performSelector:@selector(stopRecord) withObject:nil afterDelay:3.2];
    } else{
        [self performSelector:@selector(stopRecord) withObject:nil afterDelay:5.16];
    }
}

- (void)record {
    
    NSString *prefixString = @"MyFilename";
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@", prefixString, guid];
    
    NSURL *outputURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:uniqueFileName] URLByAppendingPathExtension:@"mov"];
    
    self.countdownView.hidden = NO;
    self.secondsLeftToRecord = 5;
    if(self.sceneNumber == 4){
        self.secondsLeftToRecord = 3;
    }
    [self setCountdown];


    [self.camera startRecordingWithOutputUrl:outputURL didRecord:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {

        HRConfirmVideoViewController *confirmController = [[HRConfirmVideoViewController alloc] initWithVideoURL:outputFileUrl andSceneNumber:self.sceneNumber];
        [self.navigationController pushViewController:confirmController animated:YES];
        [self reset];
        
    }];
    
    
    
}

- (void)setCountdown {
    if(self.secondsLeftToRecord != -1){
        [self.countdownLabel setText:[NSString stringWithFormat:@"%d", self.secondsLeftToRecord--]];
        [self performSelector:@selector(setCountdown) withObject:nil afterDelay:1.0];
    }
}


- (void)stopRecord {
    [self.aniamtedImageView stopAnimating];
    [self.camera stopRecording];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)reset{
    self.countdownView.hidden = YES;
    self.recordButton.hidden = NO;
    self.firstFrameView.hidden = NO;
}


@end
