//
//  HRSavedVideosViewController.h
//  HIRO
//
//  Created by Gabe Jacobs on 8/23/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRSavedVideosViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIButton *homeButton;
@property (nonatomic, strong) NSArray* savedVideos;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *pausedOverlay;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *trashButton;
@property (nonatomic, strong) UIButton *pauseOverlayButton;
@property (nonatomic) int selectedRow;


@end
