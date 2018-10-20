//
//  HRAnimationFileManager.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/22/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRAnimationFileManager : NSObject

+ (id)sharedManager;
- (NSArray *)getStrawFiles;
- (NSArray *)getStickFiles;
- (NSArray *)getBrickFiles;
- (NSArray *)getEndFiles;

@end
