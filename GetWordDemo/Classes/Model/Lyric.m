
#import "Lyric.h"

@implementation Lyric

- (id) initWtinLyric:(NSString *)lyric time:(NSInteger )time
{
    if (self = [super init]) {
        self.lyric = lyric;
        self.time = time;
    }
    return self;
}
- (id) lyticWtinLyric:(NSString *)lyric time:(NSInteger )time
{
    return [[Lyric alloc] initWtinLyric:lyric time:time];
}

@end
