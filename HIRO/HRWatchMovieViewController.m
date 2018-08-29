//
//  HRWatchMovieViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/21/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRWatchMovieViewController.h"
#import <SIAlertView.h>
#import "HRFileManager.h"

@interface HRWatchMovieViewController ()

@end

@implementation HRWatchMovieViewController


- (instancetype)initWithVideo:(NSDictionary *)video alreadySaved:(BOOL)isSaved{
    self = [super init];
    if (self) {
        self.isSaved = isSaved;
        self.video = video;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAllImages];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StopMusic"
     object:self];

    
    self.sceneNumber = 1;
    self.playingGIF = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Scene1" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:filePath];

    self.avPlayer = [AVPlayer playerWithURL:videoURL];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.videoLayer.frame = self.view.frame;
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.videoLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];

    [self.avPlayer play];
    
    self.pauseOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pauseOverlayButton.frame = self.view.frame;
    [self.pauseOverlayButton addTarget:self action:@selector(tappedPause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseOverlayButton];
    
    self.pausedOverlay = [[UIView alloc] init];
    self.pausedOverlay.alpha = 0.0;
    self.pausedOverlay.backgroundColor = [UIColor blackColor];
    self.pausedOverlay.frame = self.view.frame;
    [self.view addSubview:self.pausedOverlay];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.alpha = 0.0f;
    self.playButton.frame = CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 100, 200, 200);
    [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playButton.contentMode = UIViewContentModeCenter;
    self.playButton.imageView.contentMode = UIViewContentModeCenter;
    [self.playButton addTarget:self action:@selector(tappedPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = self.pausedOverlay.bounds;
    [dismissButton addTarget:self action:@selector(tappedDismissButton) forControlEvents:UIControlEventTouchUpInside];
    [self.pausedOverlay addSubview:dismissButton];
    
    self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeButton.alpha = 0.0f;
    self.homeButton.frame = CGRectMake(22, 22, 80, 80);
    [self.homeButton setImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
    [self.homeButton addTarget:self action:@selector(tappedHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeButton];

    self.animatedView = [[UIImageView alloc] init];
    float duration = 5.2f;
    if(self.sceneNumber == 2){
        duration = 5.1f;
    } else if(self.sceneNumber == 3){
        duration = 5.2f;
    }  else if(self.sceneNumber == 4){
        duration = 3.6f;
    }
    [self.animatedView setAnimationImages:[self getRightImageArray]];
    [self.animatedView setAnimationDuration:duration];
    self.animatedView.frame = self.videoLayer.frame;
    self.animatedView.hidden = YES;
    [self.animatedView stopAnimating];
    [self.animatedView setAnimationImages:[self getRightImageArray]];
    [self.animatedView setAnimationRepeatCount:1];
    [self.view addSubview:self.animatedView];
    
    // Do any additional setup after loading the view.
    
    /* Use this code to play an audio file */
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Soundtrack"  ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.audioPlayer.numberOfLoops = -1; //Infinite
    [self.audioPlayer play];
    
//    [self.avPlayer.currentItem seekToTime:CMTimeMakeWithSeconds(17.8, 60000)];

}

- (void)tappedPause{
    [self.view bringSubviewToFront:self.pausedOverlay];
    [self.view bringSubviewToFront:self.playButton];
    [self.view bringSubviewToFront:self.homeButton];
    [self.audioPlayer pause];
    [self.avPlayer pause];
    if(self.playingGIF){
        [self.animatedView stopAnimating];
    }
    [UIView animateWithDuration:.3 animations:^{
        self.pausedOverlay.alpha = .5f;
        self.playButton.alpha = 1.0f;
        self.homeButton.alpha = 1.0f;
    }];

   
}

- (void)tappedPlay {
    if(self.playingGIF){
        [UIView animateWithDuration:.3 animations:^{
            self.pausedOverlay.alpha = 0.0f;
            self.playButton.alpha = 0.0f;
            self.homeButton.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            [self.animatedView startAnimating];
            [self.avPlayer seekToTime:kCMTimeZero];
            [self.avPlayer play];
            [self.audioPlayer play];
        }];
    } else{
        [UIView animateWithDuration:.3 animations:^{
            self.pausedOverlay.alpha = 0.0f;
            self.playButton.alpha = 0.0f;
            self.homeButton.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            [self.avPlayer play];
            [self.audioPlayer play];

        }];
    }
   
}

- (void)tappedHome {
    if(!self.isSaved){
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Save Video?" andMessage:@"Would you like to save your video?"];
        
        
        [alertView addButtonWithTitle:@"Discard"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                                  
                                  [self.navigationController popToRootViewControllerAnimated:YES];
                              }];
        
        [alertView addButtonWithTitle:@"Save"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  [self askForTitle];
                              }];
        
        [alertView setBackgroundStyle:SIAlertViewBackgroundStyleSolid];
        [alertView setTransitionStyle:SIAlertViewTransitionStyleFade];
        [alertView show];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)askForTitle {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Video Title"
                                                                              message: @"Enter a title for your video"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Title";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

//        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSArray * textfields = alertController.textFields;
        UITextField * titleField = textfields[0];
        if(titleField.text.length <= 0){
            [self askForTitle];
        } else{
            [[HRFileManager sharedManager] setVideoTitle:titleField.text];
            [[HRFileManager sharedManager] saveCurrentVideo];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }]];
    
  
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)itemDidFinishPlaying:(NSNotification *)notification {
    if(self.playingGIF){
        self.sceneNumber++;
        [self.audioPlayer setVolume:1.0 fadeDuration:.2];

        self.playingGIF = NO;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Scene%d", self.sceneNumber] ofType:@"mp4"];
        NSURL *videoURL = [NSURL fileURLWithPath:filePath];
        [self.avPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:videoURL]];
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
        [self.avPlayer play];
        
        [self performSelector:@selector(hideGif) withObject:nil afterDelay:.4];
        

    } else{
        if(self.sceneNumber == 5) {
            [self.audioPlayer pause];
            if(!self.isSaved){
                [self askForTitle];
            } else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            return;
        }
        self.playingGIF = YES;
        
        [self.audioPlayer setVolume:.3 fadeDuration:.2];
        
        [self.animatedView setAnimationImages:[self getRightImageArray]];
        float duration = 5.2f;
        if(self.sceneNumber == 2){
            duration = 5.1f;
        } else if(self.sceneNumber == 3){
            duration = 5.2f;
        }  else if(self.sceneNumber == 4){
            duration = 3.6f;
        }
    
        [self.animatedView setAnimationDuration:duration];
        [self.animatedView startAnimating];
        self.animatedView.hidden = NO;
        if(self.sceneNumber == 1) {
            [self.animatedView setImage:[UIImage imageNamed:@"Straw House 10FPS00"]];
        } else if(self.sceneNumber == 2) {
            [self.animatedView setImage:[UIImage imageNamed:@"Stick House 10 FPS00"]];
        } else if(self.sceneNumber == 3) {
            [self.animatedView setImage:[UIImage imageNamed:@"Brick House 10FPS00"]];
        } else if(self.sceneNumber == 4) {
            [self.animatedView setImage:[UIImage imageNamed:@"The End 10 FPS00"]];
        }
        [self.view bringSubviewToFront:self.animatedView];
        

        [self performSelector:@selector(startVideo) withObject:nil afterDelay:.01];
        
    }
}

- (void)startVideoMainthread {
    NSURL *fileURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithString:[self.video objectForKey:[NSString stringWithFormat:@"video%iUrl", self.sceneNumber]]]] URLByAppendingPathExtension:@"mov"];
    if(fileURL){
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
        
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
    } else {
        NSAssert(fileURL, @"must have file");
    }
}

- (void)startVideo {
    [self performSelectorOnMainThread:@selector(startVideoMainthread) withObject:nil waitUntilDone:YES];
}
-(void)hideGif{
    self.animatedView.hidden = YES;
    [self.animatedView stopAnimating];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
- (void)getAllImages {
    self.imageArrayStraw =[NSMutableArray array];
    NSString *prefix = @"Straw House 10FPS";
    int numImages = 52;
    for (int i=0; i<numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [self.imageArrayStraw addObject:image];
    }

    self.imageArrayStick =[NSMutableArray array];
    prefix = @"Stick House 10 FPS";
    numImages = 51;
    for (int i=0; i<numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [self.imageArrayStick addObject:image];
    }
    self.imageArrayBrick =[NSMutableArray array];
    prefix = @"Brick House 10FPS";
    numImages = 52;
    for (int i=0; i<numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [self.imageArrayBrick addObject:image];
    }
    self.imageArrayEnd =[NSMutableArray array];
    prefix = @"The End 10 FPS";
    numImages = 36;
    for (int i=0; i<numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [self.imageArrayEnd addObject:image];
    }
}

- (NSArray *)getRightImageArray {
    if(self.sceneNumber == 2){
        return self.imageArrayStick;
    } else if(self.sceneNumber == 3){
        return self.imageArrayBrick;
    }  else if(self.sceneNumber == 4){
        return self.imageArrayEnd;
    }
    return self.imageArrayStraw;
}

- (void)tappedDismissButton {
    [self tappedPlay];
}

@end
