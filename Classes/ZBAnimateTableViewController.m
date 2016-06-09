#import "ZBAnimateTableViewController.h"

@implementation ZBAnimateTableViewController

- (void)removeOutletsAndControls_ZBAnimateTableViewController
{
	transitionLayer = nil;
}

- (void)dealloc 
{
	[self removeOutletsAndControls_ZBAnimateTableViewController];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_ZBAnimateTableViewController];
}

- (instancetype)init
{
	self = [super init];
	if (self != nil) {
		self.title = @"Tableview";
	}
	return self;
}


#pragma mark -
#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	if (!transitionLayer) {
		transitionLayer = [[CALayer alloc] init];
	}
	self.tableView.rowHeight = 100.0;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
	NSString *imageName = [NSString stringWithFormat:@"banana%d.tiff", (indexPath.row % 8 + 1)];
	cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}
/* self delegate 實作當動畫結束後的程式  */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if ([theAnimation isEqual:[transitionLayer animationForKey:@"move"]]) {
		[transitionLayer removeFromSuperlayer];
		[transitionLayer removeAllAnimations];
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	transitionLayer.opacity = 1.0;
	transitionLayer.contents = (id)aCell.imageView.image.CGImage;
	transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:aCell.imageView.bounds fromView:aCell.imageView];
	/* 加入 transitionLayer  */
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
	[CATransaction commit];
	
    /* 圖像往左上方飄移走 : from : transitionLayer.position to : CGPointZero  */
	CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:transitionLayer.position];
	positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];

    /* 圖像往內部縮小直到消失 : 將自己的bounds 從初始值變成 0   */
	CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:transitionLayer.bounds];
	boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectZero];

    /* 肉眼無法看出任何動畫 : 透明度(opacity)從1.0(不透明) 變成 0.5 半透明  */
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = @1.0f;
	opacityAnimation.toValue = @0.5f;	
	
    /* 圖像順時針旋轉一圈 : 
            M_PI : 圓周率 (3.1415)
            from : @(0 * M_PI) 0 的話就是從下方開始往上旋轉
            to : 2 * M_PI : 順時針轉一圈 , 1 就是轉半圈 , 負數的話就是逆時針 , 以此類推
     */
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.fromValue = @(0 * M_PI);
	rotateAnimation.toValue = @(2 * M_PI);
	
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.beginTime = CACurrentMediaTime() + 0.25;
	group.duration = 1.0;
	group.animations = @[positionAnimation, boundsAnimation, opacityAnimation, rotateAnimation];
    //group.animations = @[rotateAnimation];
    /* 指定delegate 為自己class 用來實作當動畫結束後的callback method */
    group.delegate = self;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	
	[transitionLayer addAnimation:group forKey:@"move"];
	
	
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


@end

