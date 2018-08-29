//
//  HRSavedVideosViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/23/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRSavedVideosViewController.h"
#import "HRFileManager.h"
#import "HRWatchMovieViewController.h"
#import <SIAlertView.h>

@interface HRSavedVideosViewController ()

@end

@implementation HRSavedVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.savedVideos = [[HRFileManager sharedManager] getSavedVideosList];

    self.background =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SavedVideos"]];
    self.background.frame = self.view.frame;
    [self.view addSubview:self.background];
    
    self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeButton.frame = CGRectMake(22, 22, 80, 80);
    [self.homeButton setImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
    [self.homeButton addTarget:self action:@selector(tappedHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeButton];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.headerReferenceSize = CGSizeMake(0, 45);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * .8, self.view.frame.size.height * .5)  collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.center = self.view.center;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [self.collectionView registerClass:[ANActivityIndicatorCollectionViewCell class] forCellWithReuseIdentifier:kANActivityIndicatorCellId];
    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view.
    
    
    self.pausedOverlay = [[UIView alloc] init];
    self.pausedOverlay.alpha = 0.0;
    self.pausedOverlay.backgroundColor = [UIColor blackColor];
    self.pausedOverlay.frame = self.view.frame;
    [self.view addSubview:self.pausedOverlay];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = self.pausedOverlay.bounds;
    [dismissButton addTarget:self action:@selector(tappedDismissButton) forControlEvents:UIControlEventTouchUpInside];
    [self.pausedOverlay addSubview:dismissButton];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.alpha = 0.0f;
    self.playButton.frame = CGRectMake((self.view.frame.size.width/2 - 75) + 130, self.view.frame.size.height/2 - 75, 150, 150);
    [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playButton.contentMode = UIViewContentModeScaleAspectFit;
    self.playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.playButton addTarget:self action:@selector(tappedPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    self.trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.trashButton.alpha = 0.0f;
    self.trashButton.frame = CGRectMake((self.view.frame.size.width/2 - 130) - (135/2), self.view.frame.size.height/2 - (135/2), 135, 135);
    [self.trashButton setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    self.trashButton.contentMode = UIViewContentModeScaleAspectFit;
    self.trashButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.trashButton addTarget:self action:@selector(tappedTrash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.trashButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tappedHome {
    [self.navigationController popViewControllerAnimated:YES];
}



//****************************************
//****************************************
#pragma mark - UICollectionViewDelegate
//****************************************
//****************************************
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    self.selectedRow = indexPath.row;
    [self tappedPause];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.savedVideos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell =
    (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for(UIView *subview in cell.subviews){
        [subview removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Thumbnail"]];
    backgroundImage.frame = cell.bounds;
    [cell addSubview:backgroundImage];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    NSDictionary *video = self.savedVideos[indexPath.row];
    [titleLabel setText:[video objectForKey:@"Title"]];
    [titleLabel setText:[titleLabel.text uppercaseString]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:22]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.frame = cell.bounds;
    [cell addSubview:titleLabel];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.width/2 - 10, 150);
}

//////////

- (void)tappedPause{
    [self.view bringSubviewToFront:self.pausedOverlay];
    [self.view bringSubviewToFront:self.playButton];
    [self.view bringSubviewToFront:self.trashButton];

//    [self.view bringSubviewToFront:self.homeButton];

    [UIView animateWithDuration:.3 animations:^{
        self.pausedOverlay.alpha = .5f;
        self.playButton.alpha = 1.0f;
        self.trashButton.alpha = 1.0f;

//        self.homeButton.alpha = 1.0f;
    }];
    
    
}

- (void)tappedPlay {
    HRWatchMovieViewController *watch  = [[HRWatchMovieViewController alloc] initWithVideo:self.savedVideos[self.selectedRow] alreadySaved:YES];
    [self.navigationController pushViewController:watch animated:YES];
    
        [UIView animateWithDuration:.3 animations:^{
            self.pausedOverlay.alpha = 0.0f;
            self.playButton.alpha = 0.0f;
            self.trashButton.alpha = 0.0f;

        } completion:^(BOOL finished) {
   
        }];
    
}

- (void)tappedTrash {
    
    
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Are you sure?" andMessage:nil];
    
        [self tappedDismissButton];

    
        [alertView addButtonWithTitle:@"Cancel"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {

         }];
    
        [alertView addButtonWithTitle:@"Delete"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                                  NSMutableArray *savedVideosMutable = [NSMutableArray arrayWithArray:self.savedVideos];
                                  [savedVideosMutable removeObject:self.savedVideos[self.selectedRow]];
                                  self.savedVideos = [NSArray arrayWithArray:savedVideosMutable];
                                  [[HRFileManager sharedManager] saveVideoList:savedVideosMutable];
                                  [self.collectionView reloadData];
                                  [self tappedDismissButton];
                              }];
    
    
        [alertView setBackgroundStyle:SIAlertViewBackgroundStyleSolid];
        [alertView setTransitionStyle:SIAlertViewTransitionStyleFade];
        [alertView show];
    

}

- (void)tappedDismissButton {
    [UIView animateWithDuration:.3 animations:^{
        self.pausedOverlay.alpha = 0.0f;
        self.playButton.alpha = 0.0f;
        self.trashButton.alpha = 0.0f;

    } completion:^(BOOL finished) {
        
    }];
}



@end
