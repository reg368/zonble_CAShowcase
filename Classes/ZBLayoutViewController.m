#import "ZBLayoutViewController.h"

@implementation ZBLayoutViewController

/* 供 navigation controller 呼叫生成 */
- (instancetype)init
{
	self = [super init];
	if (self != nil) {
		self.title = @"Auto-layout";
	}
	return self;
}

/* 
   - (void)loadView
   如果使用.nid檔案建立的 view controller 則不該覆寫此方法
 
   覆寫此方法的時機：
        當你是手動建立你的view 的時候 , 當手動建立views 時,需指派一個root view , 這個 root view 必須是獨一無二的,而且也不應該給其他的 view controller 參照到 . 覆寫此方法時不應該呼叫 [super]
 */
- (void)loadView 
{
	ZBLayoutView *aView = [[ZBLayoutView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	aView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view = aView;
}

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
