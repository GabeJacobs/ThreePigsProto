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
    
    self.animatedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Straw House 10FPS00"]];
    self.animatedImageView.frame = self.view.frame;
    self.animatedImageView.hidden = YES;
    [self loadImages];
    [self.view addSubview:self.animatedImageView];
//   self.aniamtedImageView = [[FLAnimatedImageView alloc] init];
//    self.aniamtedImageView.animatedImage = image;
//    self.aniamtedImageView.frame = self.view.frame;
//    self.aniamtedImageView.hidden = YES;
//    [self.view addSubview:self.aniamtedImageView];
}

- (void)loadImages {
    self.imagesLoaded = [NSMutableArray array];
    NSString *prefix = @"Straw House 10FPS";
    int numImages = 52;
    if(self.sceneNumber == 2){
        prefix = @"Stick House 10 FPS";
        numImages = 51;
    } else if(self.sceneNumber == 3){
        prefix = @"Brick House 10FPS";
        numImages = 52;
    }  else if(self.sceneNumber == 4){
        prefix = @"The End 10 FPS";
        numImages = 36;
    }
    
    for (int i=0; i<numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [self.imagesLoaded addObject:image];
    }
    self.animatedImageView.animationImages = self.imagesLoaded;

}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [self reset];
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
//    [self.animatedImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Straw House 10FPS%i", self.counter]]];

    float duration = 5.2f;
    int numImages = 52;
    if(self.sceneNumber == 2){
        duration = 5.1f;
        numImages = 51;
    } else if(self.sceneNumber == 3){
        duration = 5.2f;
        numImages = 52;
    }  else if(self.sceneNumber == 4){
        duration = 3.6f;
        numImages = 36;
    }
    
    self.animatedImageView.animationDuration = duration;
    [self.animatedImageView startAnimating];
    
    self.recordButton.hidden = YES;
    self.firstFrameView.hidden = YES;
    self.animatedImageView.hidden = NO;

    [self.view bringSubviewToFront:self.recordButton];
    [self.view bringSubviewToFront:self.countdownView];
//    [self.view bringSubviewToFront:self.animatedImageView];

    [self record];
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:duration];
    
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

        
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            HRConfirmVideoViewController *confirmController = [[HRConfirmVideoViewController alloc] initWithVideoURL:outputFileUrl fileName:uniqueFileName andSceneNumber:self.sceneNumber];
            [self.navigationController pushViewController:confirmController animated:YES];
            [self reset];
            
        });
        
    }];
    
}

- (void)setCountdown {
    if(self.secondsLeftToRecord != -1){
        [self.countdownLabel setText:[NSString stringWithFormat:@"%d", self.secondsLeftToRecord--]];
        [self performSelector:@selector(setCountdown) withObject:nil afterDelay:1.0];
    }
}


- (void)stopRecord {
//    [self.aniamtedImageView stopAnimating];
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
    self.animatedImageView.hidden = YES;
}


@end
