//
//  ViewController.m
//  AnimatiionCoverageTime_9
//
//  Created by chenshuang on 2019/9/17.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

/**
 核心动画高级技巧 - 图层时间
 */
@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *durationField;
@property (nonatomic, strong) UITextField *repeatField;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) CALayer *shipLayer;

/// 测试timeOffset和speed属性
@property (nonatomic, weak) UILabel *speedLabel;
@property (nonatomic, weak) UILabel *timeOffsetLabel;
@property (nonatomic, weak) UISlider *speedSlider;
@property (nonatomic, weak) UISlider *timeOffsetSlider;
@property (nonatomic, strong) UIBezierPath *bezierPath;

@property (nonatomic, strong) CALayer *doorLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    self.containerView.center = self.view.center;
    [self.view addSubview:self.containerView];
    
    /// 1.测试duration和repeatCount
//    [self testDurationRepeatCount];
    
    /// 2.使用autoreverses属性实现门的摇摆
//    [self testAutoReverse];
    
    /// 3.测试timeOffset和speed属性
//    [self testTimeOffsetAndSpeed];
    
    /// 4.通过触摸手势手动控制动画
    [self createTouchMoveAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
}

/// 1.测试duration和repeatCount
- (void)testDurationRepeatCount {
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"plane"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    
    // add duration
    UITextField *durationField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    durationField.placeholder = @"duration";
    durationField.textColor = [UIColor blackColor];
    durationField.keyboardType = UIKeyboardTypeNumberPad;
    durationField.layer.borderColor = [[UIColor blackColor] CGColor];
    durationField.layer.borderWidth = 1.0;
    durationField.center = CGPointMake(150, 300);
    [self.containerView addSubview:self.durationField = durationField];
    
    // add repeatCount
    UITextField *repeatField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    repeatField.placeholder = @"repeatCount";
    repeatField.textColor = [UIColor blackColor];
    repeatField.keyboardType = UIKeyboardTypeNumberPad;
    repeatField.layer.borderColor = [[UIColor blackColor] CGColor];
    repeatField.layer.borderWidth = 1.0;
    repeatField.center = CGPointMake(150, 350);
    [self.containerView addSubview:self.repeatField = repeatField];
    
    // add start
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    startButton.center = CGPointMake(150, 400);
    [self.containerView addSubview:self.startButton = startButton];
}

- (void)setControlsEnabled:(BOOL)enabled {
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}

- (void)start {
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    // animation the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    
    // disable controls
    [self setControlsEnabled:NO];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // reenable controls
    [self setControlsEnabled:YES];
}

/// 2.使用autoreverses属性实现门的摇摆
- (void)testAutoReverse {
    // add the door
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 128, 256);
    doorLayer.position = CGPointMake(150 - 64, 150);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed: @"door"].CGImage;
    [self.containerView.layer addSublayer:doorLayer];
    
    // apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    
    // apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 2.0;
    animation.repeatDuration = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
}

/// 3.0 add slide label btn
- (void)addTestTimeOffsetAndSpeedView {
    // timeOffset
    UILabel *timeOffsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 500, 100, 20)];
    timeOffsetLabel.textColor = [UIColor blackColor];
    timeOffsetLabel.text = @"timeOffset:";
    [self.view addSubview:timeOffsetLabel];
    
    UISlider *timeOffsetSlide = [[UISlider alloc] initWithFrame:CGRectMake(150, 500, 200, 20)];
    [timeOffsetSlide addTarget:self action:@selector(timeOffsetSlideChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.timeOffsetSlider = timeOffsetSlide];
    
    UILabel *timeOffsetLbe = [[UILabel alloc] initWithFrame:CGRectMake(370, 500, 100, 20)];
    timeOffsetLbe.textColor = [UIColor blackColor];
    [self.view addSubview:self.timeOffsetLabel = timeOffsetLbe];
    
    // speed
    UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 600, 100, 20)];
    speedLabel.textColor = [UIColor blackColor];
    speedLabel.text = @"speed:";
    [self.view addSubview:speedLabel];
    
    UISlider *speedSlide = [[UISlider alloc] initWithFrame:CGRectMake(150, 600, 200, 20)];
    [speedSlide addTarget:self action:@selector(speedSlideChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.speedSlider = speedSlide];
    
    UILabel *speedLbe = [[UILabel alloc] initWithFrame:CGRectMake(370, 600, 100, 20)];
    speedLbe.textColor = [UIColor blackColor];
    [self.view addSubview:self.speedLabel = speedLbe];
    
    // btn
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 700, 100, 50)];
    playBtn.backgroundColor = [UIColor grayColor];
    [playBtn setTitle:@"Play" forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}

- (void)timeOffsetSlideChange:(UISlider *)slide {
    CFTimeInterval timeOffset = slide.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"%0.2f", timeOffset];
}

- (void)speedSlideChange:(UISlider *)slide {
    float speed = slide.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%0.2f", speed];
}

/// 3.测试timeOffset和speed属性
- (void)testTimeOffsetAndSpeed {
    // draw view
    [self addTestTimeOffsetAndSpeedView];
    
    // create a path
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(0, 150)];
    [self.bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    // draw the path using a cashapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0;
    [self.containerView.layer addSublayer:pathLayer];
    
    // add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 64, 64);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"plane"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    
    // set initial values
    [self updateSliders];
}

- (void)updateSliders {
    CFTimeInterval timeOffset = self.timeOffsetSlider.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"%0.2f", timeOffset];
    
    float speed = self.speedSlider.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%0.2f", speed];
}

- (void)play {
    // create the keyframe CABasicAnimation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.timeOffset = self.timeOffsetSlider.value;
    animation.speed = self.speedSlider.value;
    animation.duration = 1.0;
    animation.path = self.bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = NO;
    [self.shipLayer addAnimation:animation forKey:@"slide"];
}

/// 4.通过触摸手势手动控制动画
- (void)createTouchMoveAnimation {
    //add the door
    self.doorLayer = [CALayer layer];
    self.doorLayer.frame = CGRectMake(0, 0, 128, 256);
    self.doorLayer.position = CGPointMake(150 - 64, 150);
    self.doorLayer.anchorPoint = CGPointMake(0, 0.5);
    self.doorLayer.contents = (__bridge id)[UIImage imageNamed:@"door"].CGImage;
    [self.containerView.layer addSublayer:self.doorLayer];
    
    // apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    
    // add pan gesture recognizer to handle swipes
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    // pause all layer animations
    self.doorLayer.speed = 0.0;
    
    // apply swinging animation (which won't play because layer is paused)
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
    [self.doorLayer addAnimation:animation forKey:nil];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    // get horizontal component of pan gesture
    CGFloat x = [pan translationInView:self.view].x;
    
    // convert from points to animation duration
    //using a reasonable scale factor
    x /= 200.0f;
    
    // update timeOffset and clamp result
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    
    // reset pan gesture
    [pan setTranslation:CGPointZero inView:self.view];
}

@end
