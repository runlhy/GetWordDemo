#import "UILabel+HYLabel.h"
#import "HYWord.h"

@implementation UILabel (HYLabel)

+ (NSArray *)cuttingStringInLabel:(UILabel *)label
{
    NSString *string = label.text;
    NSMutableArray *array = [NSMutableArray array];
    char str[strlen([string UTF8String])];
    strcpy(str, [string UTF8String]);
    char *fun = str;
    int state = 0;
    CGPoint point = CGPointMake(0, 0);
    for(;(*fun)!='\0';fun++){
        char *world = malloc(sizeof(char));
        int i = 0;
        while((isalpha(*fun) || *fun == '\'' )&&(*fun)!='\0'){
            world[i++] = *fun;
            fun++;
            state=1;
        }
        //处理完当前单词
        if(1 == state){
            world[i] = '\0';
            HYWord *hyword = [HYWord new];
            hyword.wordString = [NSString stringWithUTF8String:world];
            CGSize wordSize   = [hyword.wordString sizeWithAttributes:@{NSFontAttributeName:label.font}];

            //处理计算最后一个单词与符号是连在一起换到下一行的问题
            NSString *letterStr = [NSString stringWithFormat:@"%c", *(fun)];
            CGSize letterSize   = [letterStr sizeWithAttributes:@{NSFontAttributeName:label.font}];
            if ([letterStr isEqualToString:@" "]) {
                letterSize.width = 0;
            }
            if (point.x + wordSize.width + letterSize.width > label.bounds.size.width) {
                point.x = 0;
                point.y += wordSize.height;
            }
            hyword.frame = CGRectMake(point.x, point.y, wordSize.width, wordSize.height);
            //单词累加宽
            point.x += wordSize.width;
            [array addObject:hyword];
        }
        state=0;
        //计算至 ( 结束 因为数据 ( 后边是汉字
        if (*fun == '(') {
            break;
        }
        NSString *letterStr = [NSString stringWithFormat:@"%c", *fun];
        CGSize letterSize   = [letterStr sizeWithAttributes:@{NSFontAttributeName:label.font}];
        //非英文字符符号累加宽
        point.x += letterSize.width;
    }
    return [array copy];
}

@end
