#import "ZBLayoutView.h"

@implementation ZBLayoutView

- (void)dealloc 
{
	[rotateTimer invalidate];
}

/* 自定義的init method , 在生成view時會被覆寫自父類別的方法(initWith...)呼叫 */
- (void)_init
{
	
    radius = 80.0;
	self.backgroundColor = [UIColor blackColor];
    /* 儲存所有圓點的集合 */
	layers = [[NSMutableArray alloc] init];
    /* 要顯示圓點的數量 */
	NSUInteger count = 24;
    /* 依數量產生圓點,並存放到集合中 */
	for (int i = 0; i < count; i++) {
        /* 圓點layer初始化 */
		ZBLayoutLayer *aLayer = [ZBLayoutLayer layer];
        /* 圓點的顏色和大小設定 */
		aLayer.color = [UIColor colorWithWhite:(0.5 + 0.5 * ((float)i/count)) alpha:1.0];
		aLayer.bounds = CGRectMake(0.0, 0.0, 15.0, 15.0);
		[layers addObject:aLayer];
	}
    /* 建立完圓點後,呼叫此方法 ,此方法會呼叫 - (void)layoutSubviews (覆寫自UIView父類別的方法) Update View Drawing Cycle */
	[self setNeedsLayout];
}

/* 透過nid產生view時,會呼叫此方法 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self _init];
	}
	return self;
}

/* 手動產生view時,會呼叫此方法 */
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self _init];
	}	
    return self;
}

/*讓圓點旋轉  */
- (void)timerMethod:(NSTimer *)t
{
	if (animationFlag) {
		if ((radius += 5) > 100) {
			animationFlag = NO;
		}			
	}
	else {
		if ((radius -= 5) < 60) {
			animationFlag = YES;
		}
	}
		
	if (++rotateIndex >= layers.count) {
		rotateIndex = 0;
	}
	[self setNeedsLayout];
}

/* 執行 ： [self setNeedsLayout] 後執行此方法 Update View Drawing Cycle */
- (void)layoutSubviews
{
    /* 當使用者點擊畫面 */
	if (self.currentTouch) {
        /* 建立NSTimer 每0.1秒呼叫 timerMethod: 自定義方法 */
		if (!rotateTimer) {
			rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
		}
        /* 取得使用者點擊的座標點 */
		CGPoint p = [self.currentTouch locationInView:self];
		 /* 控制圓點的計數器 , 
            這邊是讓每個圓點依照使用者點擊的座標,在該座標外圍圍成一個圓圈圈 (更改圓點的位置) */
        NSUInteger index = rotateIndex;
		for (ZBLayoutLayer *aLayer in layers) {
			CGFloat r = M_PI * 2 * index / layers.count;
			CGFloat x = p.x + cos(r) * radius * -1;
			CGFloat y = p.y + sin(r) * radius * -1;
			aLayer.position = CGPointMake(x, y);
			index++;
		}
		return;
	}
    
    /* 當使用者沒有點擊畫面 */
	
    radius = 80.0;
	/* 
        如果 rotateTimer 已建立 (代表剛剛使用者有點擊過畫面)
        便把剛剛建立的 rotateTimer 取消掉計數器歸0（圓點變回原本的排列方式呈現）
     */
	if (rotateTimer) {
		rotateIndex = 0;
		[rotateTimer invalidate];
		rotateTimer = nil;
	}
	
     /* 每一個圓點的計數器 */
	NSUInteger index = 0;
     /* 每一列要幾個圓點 */
	NSUInteger itemsPerRow = 4;
    /*
      計算總共要呈現幾行圓點
      roundf : 四捨五入
      ceilf : 無條件進位
     */
	NSUInteger rows = (NSUInteger)ceilf((float)layers.count / (float)itemsPerRow);
	if (!rows) {
		rows = 1;
	}
	for (ZBLayoutLayer *aLayer in layers) {
         /* x 座標  求：餘數 依照現在的圓點index 去算是要分成4等份的點中的哪一個
            index % itemsPerRow = indexInRow
            0 % 4 = 0
            1 % 4 = 1
            2 % 4 = 2
            3 % 4 = 3
            4 % 4 = 0
            5 % 4 = 1
            6 % 4 = 2
            ....
          */
		NSUInteger indexInRow = index % itemsPerRow;
        //NSLog(@"indexInRow(x) : %d in index : %d",indexInRow,index);
        /* y 座標 求：商 依照現在的圓點index 去算是第幾列
         index / itemsPerRow = indexInRow
         0 % 4 = 0
         1 % 4 = 0
         2 % 4 = 0
         3 % 4 = 0
         4 % 4 = 1
         5 % 4 = 1
         6 % 4 = 1
         ....
         */
		NSUInteger row = index / itemsPerRow;
        //NSLog(@"row(y) : %d in index : %d",row,index);
        /* 把螢幕寬度依照一列要顯示幾個圓點去分成幾等份 */
		aLayer.position = CGPointMake((indexInRow + 1) * (self.bounds.size.width / (itemsPerRow  + 1)) ,
									  (row + 1) * (self.bounds.size.height / (rows +1)));
		if (!aLayer.superlayer) {
			[self.layer addSublayer:aLayer];
		}
		index++;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"%s", __PRETTY_FUNCTION__);
	self.currentTouch = touches.allObjects.lastObject;
	[self setNeedsLayout];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"%s", __PRETTY_FUNCTION__);
	self.currentTouch = touches.allObjects.lastObject;
	[self setNeedsLayout];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"%s", __PRETTY_FUNCTION__);
	self.currentTouch = nil;
	[self setNeedsLayout];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.currentTouch = nil;
	[self setNeedsLayout];
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

@synthesize currentTouch;

@end
