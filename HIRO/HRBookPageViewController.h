    //
//  HRBookPageViewController.h
//  HIRO
//
//  Created by Gabe Jacobs on 7/20/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRBookPageViewController : UIViewController

- (instancetype)initWithPage:(int)pageNumber;

@property (nonatomic) int pageNumber;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (strong, nonatomic) UIImageView *pageText;
//@property (strong, nonatomic) UIImage *nextBackground;
//@property (strong, nonatomic) UIImage *nextText;

@property (strong, nonatomic) UIButton *nextPageButton;
@property (strong, nonatomic) UIButton *prevPageButton;

@end
