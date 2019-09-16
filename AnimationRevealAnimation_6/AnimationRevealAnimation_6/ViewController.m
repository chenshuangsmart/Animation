//
//  ViewController.m
//  AnimationRevealAnimation_6
//
//  Created by chenshuang on 2019/9/10.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>
/** contentView */
@property(nonatomic, weak)UIView *contentView;
/** color layer */
@property(nonatomic, strong)CALayer *colorLayer;
/** hour */
@property(nonatomic, strong)UIImageView *hourImgView;
/** minute */
@property(nonatomic, strong)UIImageView *minuteImgView;
/** second */
@property(nonatomic, strong)UIImageView *secondImgView;
/** timer */
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // create contont view
    [self createContentView];
    
    // 1.property animation
//    [self createSubLayer];
    
    // 2.时钟
//    [self createClockView];
    
    /// 沿着一个贝塞尔曲线对图层做动画
//    [self createShipView];
    
    /// 4.用transform属性对图层做动画
//    [self createTransformAnimation];
    
    /// 5.对虚拟的transform.rotation属性做动画
//    [self createTransformRotation];
    
    /// 二 动画组
    [self createMultiAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self changeColor];
    
    // 2.关键帧动画
    [self changeColor1];
}

- (void)createContentView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    contentView.center = self.view.center;
    [self.view addSubview:self.contentView = contentView];
}

- (void)createSubLayer {
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    //add it to our view
    [self.contentView.layer addSublayer:self.colorLayer];
}

- (void)changeColor {
    //create a new random color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.delegate = self;
    
    // apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimationDelegate

//- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
//    // set the backgroudColor property to match animation toValue
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
//    [CATransaction commit];
//}

#pragma mark - 时钟

- (void)createClockView {
    UIImageView *clockImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    clockImgView.image = [UIImage imageNamed:@"clock"];
    clockImgView.contentMode = UIViewContentModeScaleAspectFit;
    clockImgView.center = self.view.center;
    [self.view addSubview:clockImgView];
    
    UIImageView *secondImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 150)];
    secondImgView.image = [UIImage imageNamed:@"second"];
    secondImgView.contentMode = UIViewContentModeScaleAspectFit;
    secondImgView.center = self.view.center;
    [self.view addSubview:self.secondImgView = secondImgView];
    
    UIImageView *minuteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 120)];
    minuteImgView.image = [UIImage imageNamed:@"minute"];
    minuteImgView.contentMode = UIViewContentModeScaleAspectFill;
    minuteImgView.center = self.view.center;
    [self.view addSubview:self.minuteImgView = minuteImgView];
    
    UIImageView *hourkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 100)];
    hourkImgView.image = [UIImage imageNamed:@"hour"];
    hourkImgView.contentMode = UIViewContentModeScaleAspectFill;
    hourkImgView.center = self.view.center;
    [self.view addSubview:self.hourImgView = hourkImgView];
    
    // 改变anchorpoint属性
    self.hourImgView.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.minuteImgView.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.secondImgView.layer.anchorPoint = CGPointMake(0.5, 0.9);
    
    // setup timer
    [self setupTimer];
}

#pragma mark - timer

- (void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self updateTimer];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self updateHandsAnimated:NO];
}

- (void)updateTimer {
    [self updateHandsAnimated:YES];
}

#pragma mark - tick

- (void)updateHandsAnimated:(BOOL)animated {
    // convert time to houres minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    
    // rotate hands
    [self setAngle:hoursAngle forHand:self.hourImgView animated:animated];
    [self setAngle:minsAngle forHand:self.minuteImgView animated:animated];
    [self setAngle:secsAngle forHand:self.secondImgView animated:animated];
}

- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated {
    // generate transform
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    if (animated) {
        // create transform animation
        CABasicAnimation *animation = [CABasicAnimation animation];
        [self updateHandsAnimated:NO];
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 0.5;
        animation.delegate = self;
        [animation setValue:handView forKey:@"handView"];
        [handView.layer addAnimation:animation forKey:nil];
    } else {
        // set transform directly
        handView.layer.transform = transform;
    }
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    // set final position for hand view
    UIView *handView = [anim valueForKey:@"handView"];
    handView.layer.transform = [anim.toValue CATransform3DValue];
}

/// 2.关键帧动画
- (void)changeColor1 {
    // create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor];
    // apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
}


/// 3.沿着一个贝塞尔曲线对图层做动画
- (void)createShipView {
    // create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    // draw the4 path using a cashapelayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0;
    [self.contentView.layer addSublayer:pathLayer];
    
    // add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"plane"].CGImage;
    [self.contentView.layer addSublayer:shipLayer];
    
    // create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    // rotationMode
    animation.rotationMode = kCAAnimationRotateAuto;
    [shipLayer addAnimation:animation forKey:nil];
}

/// 4.用transform属性对图层做动画
- (void)createTransformAnimation {
    // add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 128, 128);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"plane"].CGImage;
    [self.contentView.layer addSublayer:shipLayer];
    
    // animation the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform";
    animation.duration = 2.0;
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    [shipLayer addAnimation:animation forKey:nil];
}

/// 5.对虚拟的transform.rotation属性做动画
- (void)createTransformRotation {
    // add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 128, 128);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"plane"].CGImage;
    [self.contentView.layer addSublayer:shipLayer];
    
    // animation the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    [shipLayer addAnimation:animation forKey:nil];
}

/// 二 动画组
- (void)createMultiAnimation {
    // create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    // draw the path using a cashapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0;
    [self.contentView.layer addSublayer:pathLayer];
    
    // add a colored layer
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 64, 64);
    colorLayer.position = CGPointMake(0, 150);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.contentView.layer addSublayer:colorLayer];
    
    // create the position animation
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
    
    // create the color animation
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    
    // create group animation
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0;
    
    // add the animation to the color layer
    [colorLayer addAnimation:groupAnimation forKey:nil];
}

@end
