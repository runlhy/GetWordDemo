//
//  LyricHelper.m
//  HYMusic
//
//  Created by iceAndFire on 15/10/13.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "LyricHelper.h"
#import "Lyric.h"

@implementation LyricHelper

+ (instancetype) shareLyricHelper
{
    static LyricHelper *lyricHelper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        lyricHelper = [LyricHelper new];
    });
    return lyricHelper;
}

// 分割歌词
- (void)splitTheLyrics:(NSString *)lyrics
{
    [[LyricHelper shareLyricHelper].allDataArray removeAllObjects];
    
    NSArray *array = [lyrics componentsSeparatedByString:@"\n"];
    
    for (NSString *str in array) {
        
        NSArray *array = [str componentsSeparatedByString:@"]"];
        
        if (str.length == 0 || array.count != 2) {
            continue;
        }
        if ([array[1] length] == 1) {
            continue;
        }
        
        //获取歌词
        Lyric *lyric = [Lyric new];
        lyric.lyric = array[1];
        //获取时间
        lyric.time = [[array[0] substringWithRange:NSMakeRange(1, 2)] intValue] * 60 + [[array[0] substringWithRange:NSMakeRange(4, 5)] intValue];
        
        [self.allDataArray addObject:lyric];
    }
    
}
// 返回合适歌词下标 参数 time
- (NSInteger)lyricsWithTime:(NSTimeInterval)time
{
    for (int i=0; i<self.allDataArray.count; i++) {
        if (time < [self.allDataArray[i] time]) {
            return (i-1) >0 ? i-1 :0;
        }
    }
    return self.allDataArray.count-1;
}

#pragma mark - 懒加载
- (NSArray *)allDataArray
{
    if (!_allDataArray) {
        self.allDataArray = [NSMutableArray new];
    }
    return _allDataArray;
}

@end
