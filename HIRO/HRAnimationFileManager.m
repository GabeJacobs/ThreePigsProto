//
//  HRAnimationFileManager.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/22/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRAnimationFileManager.h"
#import <UIKit/UIKit.h>

@implementation HRAnimationFileManager

+ (id)sharedManager {
    static HRAnimationFileManager *sharedFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFileManager = [[self alloc] init];
    });
    return sharedFileManager;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (NSArray *)getStrawFiles {
    
    NSMutableArray *imagesLoaded = [NSMutableArray array];
    NSString *prefix = @"Straw House 10FPS";
    int numImages = 10;
    int doorOpenFramesNum = 5;
    for (int i=0; i<=doorOpenFramesNum; i++){
        NSString *strImageName;
        strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    UIImage *openFrame = [UIImage imageNamed:@"Straw House 10FPS05"];
    while (imagesLoaded.count != 45){
        [imagesLoaded addObject:openFrame];
    }
    for (int i=5; i<=numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    return imagesLoaded;
}


- (NSArray *)getStickFiles {
    
    NSMutableArray *imagesLoaded = [NSMutableArray array];
    NSString *prefix = @"Stick House 10 FPS";
    int numImages = 10;
    int doorOpenFramesNum = 5;
    for (int i=0; i<=doorOpenFramesNum; i++){
        NSString *strImageName;
        strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    UIImage *openFrame = [UIImage imageNamed:@"Stick House 10 FPS05"];
    while (imagesLoaded.count != 45){
        [imagesLoaded addObject:openFrame];
    }
    for (int i=5; i<=numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    return imagesLoaded;
}

- (NSArray *)getBrickFiles {
    
    NSMutableArray *imagesLoaded = [NSMutableArray array];
    NSString *prefix = @"Brick House 10FPS";
    int numImages = 11;
    int doorOpenFramesNum = 6;
    for (int i=0; i<=doorOpenFramesNum; i++){
        NSString *strImageName;
        strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    UIImage *openFrame = [UIImage imageNamed:@"Brick House 10FPS06"];
    while (imagesLoaded.count != 45){
        [imagesLoaded addObject:openFrame];
    }
    for (int i=6; i<=numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    return imagesLoaded;
}

- (NSArray *)getEndFiles {

    NSMutableArray *imagesLoaded = [NSMutableArray array];
    NSString *prefix = @"The End 10 FPS";
    int numImages = 11;
    int doorOpenFramesNum = 5;
    for (int i=0; i<=doorOpenFramesNum; i++){
        NSString *strImageName;
        strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    UIImage *openFrame = [UIImage imageNamed:@"The End 10 FPS05"];
    while (imagesLoaded.count != 25){
        [imagesLoaded addObject:openFrame];
    }
    for (int i=5; i<=numImages; i++){
        NSString *strImageName;
        if(i >= 10){
            strImageName= [NSString stringWithFormat:@"%@%i",prefix, i];
        } else{
            strImageName= [NSString stringWithFormat:@"%@0%i",prefix, i];
        }
        UIImage *image= [UIImage imageNamed:strImageName];
        [imagesLoaded addObject: image];
    }
    return imagesLoaded;
}
@end
