//
//  HRBookPageViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 7/20/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRBookPageViewController.h"
#import "FLAnimatedImage.h"
#import "HRCameraSceneViewController.h"

@interface HRBookPageViewController ()

@end

@implementation HRBookPageViewController

- (instancetype)initWithPage:(int)pageNumber {
    self = [super init];
    if (self) {
        self.pageNumber = pageNumber;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"P%d-Back", self.pageNumber]]];
    self.backgroundImage.frame = self.view.frame;
    [self.view addSubview:self.backgroundImage];
    
    self.pageText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"P%d-Text", self.pageNumber]]];
    self.pageText.alpha = 0.0;
    self.pageText.frame = self.view.frame;
    [self.backgroundImage addSubview:self.pageText];
    
    [self performSelector:@selector(showText) withObject:nil afterDelay:0.8f];
    self.nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextPageButton setImage:[UIImage imageNamed:@"NextPage"] forState:UIControlStateNormal];
    self.nextPageButton.frame = CGRectMake(self.view.frame.size.width - 15 - [UIImage imageNamed:@"NextPage"].size.width, self.view.frame.size.height - 10 - [UIImage imageNamed:@"NextPage"].size.height, [UIImage imageNamed:@"NextPage"].size.width, [UIImage imageNamed:@"NextPage"].size.height);
    [self.nextPageButton addTarget:self action:@selector(tappedNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextPageButton];
    
    self.prevPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prevPageButton setImage:[UIImage imageNamed:@"PrevPage"] forState:UIControlStateNormal];
    self.prevPageButton.frame = CGRectMake(15, self.view.frame.size.height - 10 - [UIImage imageNamed:@"PrevPage"].size.height, [UIImage imageNamed:@"PrevPage"].size.width, [UIImage imageNamed:@"PrevPage"].size.height);
    [self.prevPageButton addTarget:self action:@selector(tappedPrevPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.prevPageButton];

    [self disableButtons];
    if(self.pageNumber !=1){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"StartMusic"
         object:self];
    }
    
}

- (void)showText {
    
   
    
    self.pageText.image = [UIImage imageNamed:[NSString stringWithFormat:@"P%d-Text", self.pageNumber]];
    self.pageText.alpha = 0.0;
    [UIView animateWithDuration:1.25 animations:^{
        self.pageText.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self enableButtons];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fadeContentNoImageChange {
    [UIView animateWithDuration:1.25  animations:^{
        self.pageText.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self showText];
    }];
}
- (void)fadeContent{
    
    
    [UIView animateWithDuration:1.25  animations:^{
        self.pageText.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [UIView transitionWithView:self.backgroundImage
                          duration:1.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.backgroundImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"P%d-Back", self.pageNumber]]];
                        } completion:^(BOOL finished) {
                            [self showText];
                        }];
        
    
    }];
}

- (void)tappedNextPage {
    
    [self disableButtons];
    self.pageNumber++;
    if(self.pageNumber == 3 || self.pageNumber == 6 || self.pageNumber == 9){
        [self fadeContentNoImageChange];
    } else if(self.pageNumber == 4){
        [self showRecordingScene:1];
    } else if(self.pageNumber == 7){
        [self showRecordingScene:2];
    } else if(self.pageNumber == 10){
        [self showRecordingScene:3];
    }  else if(self.pageNumber == 13){
        [self showRecordingScene:4];
    }else{
        [self fadeContent];
        
    }
    NSLog(@"%i", self.pageNumber);

    
}
- (void)tappedPrevPage {
    
    if(self.pageNumber != 1 && self.pageNumber != 3){
        self.pageNumber--;
        [self fadeContent];
    } else if(self.pageNumber == 3){
        self.pageNumber--;
        [self fadeContentNoImageChange];
    }  else{
        [self.navigationController popViewControllerAnimated:YES];
    }

    NSLog(@"%i", self.pageNumber);

}

- (void)enableButtons {
    self.nextPageButton.userInteractionEnabled = YES;
    self.prevPageButton.userInteractionEnabled = YES;
}

- (void)disableButtons {
    self.nextPageButton.userInteractionEnabled = NO;
    self.prevPageButton.userInteractionEnabled = NO;
}

-(void)showRecordingScene:(int)sceneNumber {
    HRCameraSceneViewController *camera = [[HRCameraSceneViewController alloc] initWithSceneNumber:sceneNumber];
    [self.navigationController pushViewController:camera animated:YES];
}

@end
