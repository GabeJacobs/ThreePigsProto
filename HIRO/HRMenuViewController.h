//
//  ViewController.h
//  HIRO
//
//  Created by Gabe Jacobs on 6/15/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HRMenuViewController : UIViewController

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *viewVideosButton;
@property (nonatomic, retain) AVAudioPlayer *player;


@end

