//
//  HRFileManager.m
//  HIRO
//
//  Created by Gabe Jacobs on 8/22/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRFileManager.h"

@implementation HRFileManager

+ (id)sharedManager {
    static HRFileManager *sahredFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sahredFileManager = [[self alloc] init];
    });
    return sahredFileManager;
}

- (id)init {
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"SavedVideos"]){
            self.savedVideos = [userDefaults objectForKey:@"SavedVideos"];
            [userDefaults setObject:self.savedVideos forKey:@"SavedVideos"];
            [userDefaults synchronize];
        } else{
            self.savedVideos = [NSArray array];
            [userDefaults setObject:self.savedVideos forKey:@"SavedVideos"];
            [userDefaults synchronize];
        }

        
//        self.savedVideos = [NSArray array];
//        [userDefaults setObject:self.savedVideos forKey:@"SavedVideos"];
//        [userDefaults synchronize];
    }
    
    return self;
}

- (void)saveCurrentVideo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.savedVideos = [userDefaults objectForKey:@"SavedVideos"];
    
    NSMutableArray *currentVideos = [NSMutableArray arrayWithArray:self.savedVideos];
    [currentVideos addObject:self.tempVideoDict];
    self.savedVideos = [NSArray arrayWithArray:currentVideos];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.savedVideos];
    [userDefaults setObject:self.savedVideos forKey:@"SavedVideos"];
    [userDefaults synchronize];
}

- (void)setVideoTitle:(NSString *)title {
    [self.tempVideoDict setObject:title forKey:@"Title"];
}

-(void)createTempVideo {
    self.tempVideoDict = [NSMutableDictionary dictionary];
    NSString *timestamp = [NSString stringWithFormat:@"%lu", (long)[[NSDate date] timeIntervalSince1970]];  // to get unique name for your folder
    [self.tempVideoDict setObject:timestamp forKey:@"ID"];
}

- (void)setVideo1:(NSURL *)video1Url {
    [self.tempVideoDict setObject:[video1Url absoluteString] forKey:@"video1Url"];
    
}

- (void)setVideo2:(NSURL *)video2Url {
    [self.tempVideoDict setObject:[video2Url absoluteString] forKey:@"video2Url"];
    

}

- (void)setVideo3:(NSURL *)video3Url {
    [self.tempVideoDict setObject:[video3Url absoluteString] forKey:@"video3Url"];

}

- (void)setVideo4:(NSURL *)video4Url {
    [self.tempVideoDict setObject:[video4Url absoluteString] forKey:@"video4Url"];

}

- (NSDictionary*)getTempVideo {
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.tempVideoDict];
    return dict;
}

- (NSArray *)getSavedVideosList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.savedVideos = [userDefaults objectForKey:@"SavedVideos"];
    return self.savedVideos;
}

@end
