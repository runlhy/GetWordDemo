
#import "LanguageListTableViewController.h"
#import "PhraseCell.h"
#import "UILabel+HYLabel.h"
#import "HYWord.h"
#import "CHMagnifierView.h"
#import "LyricHelper.h"
#import "Lyric.h"

static NSString *const reuseIdentifier = @"PhraseCell";

@interface LanguageListTableViewController ()

//存储歌词
@property (nonatomic, strong) NSArray *lrcArray;
//选中的单词
@property (nonatomic, copy)NSString *currentWord;
//单词选中view
@property (nonatomic, strong) UIView *wordView;
//放大镜
@property (strong, nonatomic) CHMagnifierView *magnifierView;


@end

@implementation LanguageListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PhraseCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    //添加长按手势
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = .5;
    [self.tableView addGestureRecognizer:longPressGr];
    
    //加载本地数据
    [self loadLocalData];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
}

//长按的方法
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self.tableView];
            //设置放大镜位置
            [self magnifierPosition:point];
            //显示放大镜
            [self.magnifierView makeKeyAndVisible];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.tableView];
            //设置放大镜位置
            [self magnifierPosition:point];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint point = [gesture locationInView:self.tableView];
            //长按结束取消放大镜
            [self.magnifierView setHidden:YES];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
            //调用系统词典显示
            if (self.wordView.isHidden == NO) {
                [self systemDictionarie:self.currentWord];
            }
            break;
        }
        default:
            break;
    }
    
}
//设置放大镜位置
-(void)magnifierPosition:(CGPoint)point
{
    //设置放大镜的位置
    CGPoint magnifierPoint = point;
    int y = magnifierPoint.y - self.tableView.contentOffset.y - 30;
    magnifierPoint.y = y;
    self.magnifierView.pointToMagnify = magnifierPoint;
}
//获取cell 及其label上的单词
- (void)wordsOnCell:(CGPoint)point
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    if(indexPath == nil)
        return ;
    PhraseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //这个方法会提供 单词的 相对父视图的位置
    NSArray *strArray = [UILabel cuttingStringInLabel:cell.phraseLabel];
    for (HYWord *hyword in strArray) {
        CGRect frame = hyword.frame;
        frame.origin.x += cell.frame.origin.x + 20;
        frame.origin.y += cell.frame.origin.y + 20;
        if ([self pointInRectangle:frame point:point]) {
            self.wordView.hidden = NO;
            self.wordView.frame = frame;
            self.wordView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:.8 alpha:.5];
            [self.tableView addSubview:self.wordView];
            self.currentWord = hyword.wordString;
            return;
        }
    }
    self.wordView.hidden = YES;
}
//调用系统词典
- (void) systemDictionarie:(NSString *)word
{

    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = .5;
    [self.tableView addSubview:view];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程
        UIReferenceLibraryViewController *referenceLibraryViewController =[[UIReferenceLibraryViewController alloc] initWithTerm:word];
        
        // 主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [view removeFromSuperview];
            
            [self presentViewController:referenceLibraryViewController
                                   animated:YES
                             completion:nil];
            self.wordView.hidden = YES;
        });
    });
}
//判断点在矩形内
- (BOOL) pointInRectangle:(CGRect )rech point:(CGPoint)clickPoint
{
    if (clickPoint.x > rech.origin.x && clickPoint.x < (rech.origin.x + rech.size.width) && clickPoint.y > rech.origin.y  &&  clickPoint.y < (rech.origin.y + rech.size.height)) {
        return YES;
    }
    return NO;
}

//加载本地数据
- (void) loadLocalData
{
    //1.从包内容获取歌词
    NSString *lrcString = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"oral8000_1" ofType:@"lrc"] encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@",textString);
    
    //2.分隔歌词
    [[LyricHelper shareLyricHelper] splitTheLyrics:lrcString];
    //获取歌词
    self.lrcArray = [NSArray arrayWithArray:[LyricHelper shareLyricHelper].allDataArray];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhraseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Lyric *lyric = self.lrcArray[indexPath.row];
    
    cell.phraseLabel.text = [lyric.lyric stringByReplacingOccurrencesOfString:@"(" withString:@"\n("];
    return cell;
}

#pragma mark -lazy
- (CHMagnifierView *)magnifierView
{
    if (!_magnifierView) {
        _magnifierView = [[CHMagnifierView alloc] init];
        _magnifierView.viewToMagnify = self.tableView.window;
    }
    return _magnifierView;
}

- (UIView *)wordView
{
    if (!_wordView) {
        _wordView = [[UIView alloc] init];
    }
    return _wordView;
}
@end
