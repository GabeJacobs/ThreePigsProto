//
//  ReadyToWatchViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/21/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRReadyToWatchViewController.h"
#import "HRWatchMovieViewController.h"
#import "HRFileManager.h"
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


- (void)tappedConfirm{
    NSDictionary *videoDict = [[HRFileManager sharedManager] getTempVideo];
    HRWatchMovieViewController *watch  = [[HRWatchMovieViewController alloc] initWithVideo:videoDict alreadySaved:NO];
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
