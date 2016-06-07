#import <QuartzCore/QuartzCore.h>
#import "ZBLayoutLayer.h"

@interface ZBFireworkLayer : CALayer

//- (instancetype)ininstancetypeWithHue:(CGFloat)inHue NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithHue:(CGFloat)inHue;
- (void)animateInLayer:(CALayer *)inSuperlayer from:(CGPoint)inFrom to:(CGPoint)inTo;
@end
