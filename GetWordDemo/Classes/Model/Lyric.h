
#import <Foundation/Foundation.h>

@interface Lyric : NSObject
//时间 内容
@property (nonatomic, copy) NSString *lyric;
@property (nonatomic, assign) NSInteger time;

- (id) initWtinLyric:(NSString *)lyric time:(NSInteger )time;
- (id) lyticWtinLyric:(NSString *)lyric time:(NSInteger )time;
@end
