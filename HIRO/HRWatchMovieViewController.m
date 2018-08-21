//
//  HRWatchMovieViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/21/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRWatchMovieViewController.h"

@interface HRWatchMovieViewController ()

@end

@implementation HRWatchMovieViewController


- (instancetype)initWithVideoURL:(NSURL *)video andSceneNumber:(int)sceneNumber {
    self = [super init];
    if (self) {
        self.videoURL = video;
        self.sceneNumber = sceneNumber;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.avPlayer = [AVPlayer playerWithURL:self.videoURL];
//    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//
//    self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
//    self.videoLayer.frame = CGRectMake(self.view.frame.size.width/2 - (self.view.frame.size.width * .7)/2, 50, self.view.frame.size.width * .7, self.view.frame.size.height * .7);
//    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.view.layer addSublayer:self.videoLayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
//
//    [self.avPlayer play];
    
//    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"SCENE%d", self.sceneNumber] withExtension:@"gif"];
//    NSString *path = [imgPath path];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
//
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
//    self.animatedView = [[FLAnimatedImageView alloc] init];
//    self.animatedView.animatedImage = image;
//    self.animatedView.frame = self.videoLayer.frame;
//    self.animatedView.runLoopMode = NSDefaultRunLoopMode;
//    [self.view addSubview:self.animatedView];
    
    // Do any additional setup after loading the view.
    
}


- (void)itemDidFinishPlaying:(NSNotification *)notification {
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
