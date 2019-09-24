//
//  ViewController.m
//  AnimationBuffer_10
//
//  Created by chenshuang on 2019/9/21.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

/**
 缓冲
 */
@interface ViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *layerView;

/** contentView */
@property(nonatomic, strong)UIView *contentView;
/** hour */
@property(nonatomic, strong)UIImageView *hourImgView;
/** minute */
@property(nonatomic, strong)UIImageView *minuteImgView;
/** second */
@property(nonatomic, strong)UIImageView *secondImgView;
/** timer */
@property(nonatomic, strong)NSTimer *timer;
/** ball */
@property(nonatomic, strong)UIImageView *ballView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create contentView
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.contentView.center = self.view.center;
    [self.view addSubview:self.contentView];
    
    // create layer view
//    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    self.layerView.center = self.view.center;
//    [self.view addSubview:self.layerView];
    
    /// 1.缓冲函数的简单测试
//    [self createColorLayer];
    
    // 3.对CAKeyframeAnimation使用CAMediaTimingFunction
//    [self createColorLayer2];
    
    /// 4.使用UIBezierPath绘制CAMediaTimingFunction
//    [self useBezierPathMediaTimingFunction];
    
    /// 4.添加了自定义缓冲函数的时钟程序
//    [self createClockView];
    
    /// 5.使用关键帧实现反弹球的动画
//    [self createKeyKeyFrameAnimation];
    
    /// 6.使用插入的值创建一个关键帧动画
    [self animate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1.缓冲函数的简单测试
//    [self addColorTransaction:touches withEvent:event];
    
    // 2.使用UIKit动画的缓冲测试工程
//    [self addViewAnimation:touches withEvent:event];
    
    // 3.change color
    [self changeColor];
}

/// 1.缓冲函数的简单测试
- (void)createColorLayer {
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)addColorTransaction:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // configure the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    // set the position
    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
    
    // commit transaction
    [CATransaction commit];
}

/// 2.使用UIKit动画的缓冲测试工程
- (void)addViewAnimation:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // perform the animation
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            // set the position
                            self.colorLayer.position = [[touches anyObject] locationInView:self.view];
    } completion:NULL];
}

/// 3.对CAKeyframeAnimation使用CAMediaTimingFunction
- (void)createColorLayer2 {
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // create layer view
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.layerView.center = self.view.center;
    [self.view addSubview:self.layerView];
    
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
}

- (void)changeColor {
    // create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];
    
    // add timing function
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[fn, fn, fn];
    
    // apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
}

/// 4.使用UIBezierPath绘制CAMediaTimingFunction
- (void)useBezierPathMediaTimingFunction {
    // create timing function
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // get control points
    CGPoint controlPoint1, controlPoint2;
    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    
    // create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    // scale the path up to a reasonable size for display
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0;
    shapeLayer.path = path.CGPath;
    [self.layerView.layer addSublayer:shapeLayer];
    
    // flip geometry so that 0,0 is in the bottom-left
    self.layerView.layer.geometryFlipped = YES;
}

#pragma mark - 时钟
/// 4.添加了自定义缓冲函数的时钟程序
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

// generate transform
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
        
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
        // apply animation
        handView.layer.transform = transform;
        
        [handView.layer addAnimation:animation forKey:nil];
    } else {
        // set transform directly
        handView.layer.transform = transform;
    }
}

//- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
//    // set final position for hand view
//    UIView *handView = [anim valueForKey:@"handView"];
//    handView.layer.transform = [anim.toValue CATransform3DValue];
//}

/// 5.使用关键帧实现反弹球的动画
- (void)createKeyKeyFrameAnimation {
    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"ball"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.contentView addSubview:self.ballView];
    
    // 关键帧动画
    [self keyKeyFrameAnimation];
}

- (void)keyKeyFrameAnimation {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    
    // create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)]
                         ];
    
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    
    // apply animation
    self.ballView.layer.position = CGPointMake(150, 268);
    [self.ballView.layer addAnimation:animation forKey:nil];
}

/// 6.使用插入的值创建一个关键帧动画
- (void)createInsertValueKeyKeyFrameAnimation {
    
}

float interpolate(float from, float to, float time) {
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time {
    if ([fromValue isKindOfClass:[NSValue class]]) {
        // get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    // provide safe default implementation
    return time < 0.5 ? fromValue : toValue;
}

- (void)animate {
    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"ball"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.contentView addSubview:self.ballView];
    
    // reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    
    // set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0;
    
    // genrate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        // apply easing
        time = bounceEaseOut(time);
        // add keyFrame
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    
    // create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = frames;
    
    // apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
}

/// 7.完全定制的缓冲函数
float quadraticEaseInOut(float t) {
    return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
}

// 对我们的弹性球来说，我们可以使用bounceEaseOut函数：
float bounceEaseOut(float t) {
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

@end
