#import "ZBPathView.h"

@implementation ZBPathView

- (void)dealloc
{
	CGPathRelease(path);
}

- (void)_init
{
	self.backgroundColor = [UIColor whiteColor];
	/* 設定 CAKeyframeAnimation path 的路線 */
    path = CGPathCreateMutable();
    
    //開始的點
	CGPathMoveToPoint(path, NULL, 20.0, 40.0);
    //建立10個點
	for (NSUInteger i = 0; i < 10; i++) {
        //每一個點的x座標
		CGFloat x = (i % 2) ? 20.0 : self.bounds.size.width - 20.0;
        //每一個點的y座標
		CGFloat y = 40.0 + 30.0 * (i + 1);
//		CGPathAddLineToPoint(path, NULL, x, y);
        //轉彎的點
		CGPathAddArcToPoint(path, NULL, x, y, x, y + 20.0, 10.0);
	}
	spot = [[ZBLayoutLayer alloc] init];
	spot.bounds = CGRectMake(0.0, 0.0, 30.0, 30.0);
	spot.color = [UIColor redColor];
	[self.layer addSublayer:spot];

	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	animation.duration = 5.0;
	animation.path = path;
	animation.repeatCount = NSUIntegerMax;
	animation.autoreverses = YES;
    /*
     CA_EXTERN NSString * const kCAMediaTimingFunctionLinear
     __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     CA_EXTERN NSString * const kCAMediaTimingFunctionEaseIn
     __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     CA_EXTERN NSString * const kCAMediaTimingFunctionEaseOut
     __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     CA_EXTERN NSString * const kCAMediaTimingFunctionEaseInEaseOut
     __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     CA_EXTERN NSString * const kCAMediaTimingFunctionDefault
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
     */
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[spot addAnimation:animation forKey:@"move"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self _init];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self _init];
	}
	return self;
}

/* override UIView 的 drawRect method : 畫線條 */
- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGColorSpaceRef rgbColor = CGColorSpaceCreateDeviceRGB();
	CGFloat black[4] = {0.0, 0.0, 0.0, 1.0};
	CGContextSetLineWidth(ctx, 2.0);
	CGContextSetStrokeColorSpace(ctx, rgbColor);
	CGContextSetStrokeColor(ctx, black);
	CGContextAddPath(ctx, path);
	CGContextStrokePath(ctx);
	CGColorSpaceRelease(rgbColor);
}


@end
