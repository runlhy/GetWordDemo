//
//  LyricHelper.h
//  HYMusic
//
//  Created by iceAndFire on 15/10/13.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHelper : NSObject

@property (nonatomic, strong) NSMutableArray *allDataArray;

+ (instancetype) shareLyricHelper;

/*
 写几个方法，返回歌词集合，返回合适歌词
 */

// 分割歌词
- (void)splitTheLyrics:(NSString *)lyrics;
// 返回合适歌词下标 参数 time
- (NSInteger)lyricsWithTime:(NSTimeInterval)time;

@end
