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

- (void)setVideo1:(NSString *)video1Url;
- (void)setVideo2:(NSString *)video2Url;
- (void)setVideo3:(NSString *)video3Url;
- (void)setVideo4:(NSString *)video4Url;
- (void)setVideoTitle:(NSString *)videoTitle;
- (void)saveCurrentVideo;

- (void)saveVideoList:(NSArray *)array;
- (NSArray *)getSavedVideosList;

- (NSDictionary*)getTempVideo;

@property (nonatomic, strong) NSArray *savedVideos;
@property (nonatomic, strong) NSMutableDictionary *tempVideoDict;

@end
