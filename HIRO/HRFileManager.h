//
//  HRFileManager.h
//  HIRO
//
//  Created by Gabe Jacobs on 8/22/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFileManager : NSObject

+ (id)sharedManager;

- (void)createTempVideo;

- (void)setVideo1:(NSURL *)video1Url;
- (void)setVideo2:(NSURL *)video2Url;
- (void)setVideo3:(NSURL *)video3Url;
- (void)setVideo4:(NSURL *)video4Url;
- (void)setVideoTitle:(NSString *)videoTitle;

- (NSDictionary*)getTempVideo;

@property (nonatomic, strong) NSArray *savedVideos;
@property (nonatomic, strong) NSMutableDictionary *tempVideoDict;

@end
