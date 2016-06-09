#import "ZBFireworkLayer.h"

@implementation ZBFireworkLayer

- (instancetype)initWithHue:(CGFloat)inHue
{
	self = [super init];
	if (self != nil) {
		self.bounds = CGRectMake(0.0, 0.0, 20.0, 20.0);
		for (NSUInteger i = 0; i < 8; i++) {
			ZBLayoutLayer *aLayer = [ZBLayoutLayer layer];
			aLayer.color = [UIColor colorWithHue:inHue saturation:1.0 brightness:1.0 alpha:0.5];
			aLayer.bounds = CGRectMake(0.0, 0.0, 20.0, 20.0);
			aLayer.position = CGPointZero;
			[self addSublayer:aLayer];
		}
	}
	return self;
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	/* move動畫結束時,實作小球分散出去的動畫 'explode' */
    if ([theAnimation isEqual:[self animationForKey:@"move"]]) {
		/* 取得子layer的數量 (要分散出去的小球) */
        NSUInteger count = self.sublayers.count;
		if (!count) {
			count = 1;
		}
		NSUInteger index = 0;
		CGFloat radius = 300.0 * (random() % 100 / 100.0);
        /* 呈現要爆炸出去的小球 */
		for (ZBLayoutLayer *aLayer in self.sublayers) {
			CGFloat r = M_PI * 2 / (CGFloat)count * (CGFloat)index;
			CGFloat x = cos(r) * radius;
			CGFloat y = sin(r) * radius;
			CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
			positionAnimation.fromValue = [NSValue valueWithCGPoint:aLayer.position];
			positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];

			CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			opacityAnimation.fromValue = @0.5f;
			opacityAnimation.toValue = @0.0f;

			CAAnimationGroup *group = [CAAnimationGroup animation];
			group.duration = 0.5;
			group.animations = @[positionAnimation, opacityAnimation];
			group.delegate = self;
			group.removedOnCompletion = NO;
			group.fillMode = kCAFillModeForwards;
			[aLayer addAnimation:group forKey:@"explode"];
			index++;
		}
	}
	if ([theAnimation isEqual:[(self.sublayers).lastObject animationForKey:@"explode"]]) {
		[self removeFromSuperlayer];
	}
}

/* 實作球往上飛的動畫 'move' */
- (void)animateInLayer:(CALayer *)inSuperlayer from:(CGPoint)inFrom to:(CGPoint)inTo
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	self.position = inFrom;
	[CATransaction commit];
	[inSuperlayer addSublayer:self];

	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.duration = 0.5;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.fromValue = [NSValue valueWithCGPoint:inFrom];
	animation.toValue = [NSValue valueWithCGPoint:inTo];
	animation.delegate = self;

	[self addAnimation:animation forKey:@"move"];
}


@end

