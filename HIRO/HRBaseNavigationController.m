//
//  HRBaseNavigationController.m
//  HIRO
//
//  Created by Gabe Jacobs on 6/15/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRBaseNavigationController.h"

@interface HRBaseNavigationController ()

@end

@implementation HRBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HRMenuViewController *menu = [[HRMenuViewController alloc] init];
    [self addChildViewController:menu];
    
    [self setNavigationBarHidden:YES];
    


    
    // Do any additional setup after loading the view.
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
