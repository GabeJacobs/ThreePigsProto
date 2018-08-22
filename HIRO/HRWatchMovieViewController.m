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
    [self.avPlayer.currentItem seekToTime:CMTimeMakeWithSeconds(17.8, 60000)];

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
    
    self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeButton.alpha = 0.0f;
    self.homeButton.frame = CGRectMake(22, 22, 80, 80);
    [self.homeButton setImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
    [self.homeButton addTarget:self action:@selector(tappedHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeButton];

    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"SCENE%d", self.sceneNumber] withExtension:@"gif"];
    NSString *path = [imgPath path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.animatedView = [[FLAnimatedImageView alloc] init];
    self.animatedView.animatedImage = image;
    self.animatedView.frame = self.videoLayer.frame;
    self.animatedView.runLoopMode = NSDefaultRunLoopMode;
    self.animatedView.hidden = YES;
    [self.animatedView stopAnimating];
    [self.view addSubview:self.animatedView];
    
    // Do any additional setup after loading the view.
    
    /* Use this code to play an audio file */
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Soundtrack"  ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.audioPlayer.numberOfLoops = -1; //Infinite
    [self.audioPlayer play];
    
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
            [self.avPlayer play];

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
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Save Video?" andMessage:@"Would you like to save your video?"];
    
    
    [alertView addButtonWithTitle:@"Discard"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              [self.navigationController popToRootViewControllerAnimated:YES];
                          }];
    
    [alertView addButtonWithTitle:@"Save"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              if(!self.isSaved){
                                  [self askForTitle];
                              } else{
                                  [self.navigationController popToRootViewControllerAnimated:YES];
                              }
                          }];
    
    [alertView setBackgroundStyle:SIAlertViewBackgroundStyleSolid];
    [alertView setTransitionStyle:SIAlertViewTransitionStyleFade];
    [alertView show];
    
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
        [self.audioPlayer play];

        self.playingGIF = NO;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Scene%d", self.sceneNumber] ofType:@"mp4"];
        NSURL *videoURL = [NSURL fileURLWithPath:filePath];
        [self.avPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:videoURL]];
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
        [self.avPlayer play];
        
        [self performSelector:@selector(hideGif) withObject:nil afterDelay:.2];
        

    } else{
        if(self.sceneNumber == 5) {
            [self.audioPlayer pause];
            if(!self.isSaved){
                [self askForTitle];
            } else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            return;
        }
        self.playingGIF = YES;

        
        
        [self.audioPlayer pause];
        NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"SCENE%d", self.sceneNumber] withExtension:@"gif"];
        NSString *path = [imgPath path];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
        self.animatedView.animatedImage = image;
        self.animatedView.runLoopMode = NSDefaultRunLoopMode;
        self.animatedView.hidden = NO;
        [self.animatedView startAnimating];
        [self.view bringSubviewToFront:self.animatedView];
        
        
        AVPlayerItem *videoItem =[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.video objectForKey:[NSString stringWithFormat:@"video%iUrl", self.sceneNumber]]]];
        
        [self.avPlayer replaceCurrentItemWithPlayerItem:videoItem];
//        [self.avPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[self.video objectForKey:[NSString stringWithFormat:@"video4Url"]]]];
        
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
        [self.avPlayer play];


        
    }
}

-(void)hideGif{
    self.animatedView.hidden = YES;
    [self.animatedView stopAnimating];
}


@end
