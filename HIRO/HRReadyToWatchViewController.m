//
//  ReadyToWatchViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/21/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRReadyToWatchViewController.h"
#import "HRWatchMovieViewController.h"
#import <SIAlertView.h>

@interface HRReadyToWatchViewController ()

@end

@implementation HRReadyToWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReadyToWatch"]];
    self.backgroundImage.frame = self.view.frame;
    [self.view addSubview:self.backgroundImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.goHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.tryAgainButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
    [self.goHomeButton setImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
    self.goHomeButton.frame = CGRectMake((self.view.frame.size.width/2 - [UIImage imageNamed:@"Home"].size.width/2)+25, self.view.frame.size.height - 250,  [UIImage imageNamed:@"Home"].size.width,[UIImage imageNamed:@"Home"].size.height);
    [self.goHomeButton addTarget:self action:@selector(tappedGoHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goHomeButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setImage:[UIImage imageNamed:@"Confirm2"] forState:UIControlStateNormal];
    self.confirmButton.frame = CGRectMake((self.view.frame.size.width/2 - [UIImage imageNamed:@"Confirm2"].size.width/2) + 225, self.view.frame.size.height - 250, [UIImage imageNamed:@"Confirm2"].size.width,[UIImage imageNamed:@"Confirm2"].size.height);
    [self.confirmButton addTarget:self action:@selector(tappedConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    
    // Do any additional setup after loading the view.
}


- (void)tappedGoHome {
    
//    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Save Video" andMessage:@"Would you like to sa"];
//
//    [alertView addButtonWithTitle:@"Button1"
//                             type:SIAlertViewButtonTypeDefault
//                          handler:^(SIAlertView *alert) {
//                              NSLog(@"Button1 Clicked");
//                          }];
//    [alertView addButtonWithTitle:@"Button2"
//                             type:SIAlertViewButtonTypeDestructive
//                          handler:^(SIAlertView *alert) {
//                              NSLog(@"Button2 Clicked");
//                          }];
    
}

- (void)tappedConfirm{
    HRWatchMovieViewController *watch  = [[HRWatchMovieViewController alloc] init];
    [self.navigationController pushViewController:watch animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
