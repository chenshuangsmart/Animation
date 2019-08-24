//
//  ViewController.m
//  AnimationVisualEffect_3
//
//  Created by chenshuang on 2019/8/24.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** digitViews */
@property(nonatomic, strong)NSMutableArray *digitViews;
/** timer */
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self drawUI];
    
//    [self drawCat];
    
//    [self shadowOpacity];
    
//    [self shadowOpacity1];
    
//    [self shadowPath];
    
//    [self mask];
    
//    [self clock];
    
    [self drawBtn];
}

- (void)drawUI {
    UIView *grayView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    grayView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView1];
    
    UIView *redView1 = [[UIView alloc] initWithFrame:CGRectMake(-30, -30, 60, 60)];
    redView1.backgroundColor = [UIColor redColor];
    [grayView1 addSubview:redView1];
    
    UIView *grayView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    grayView2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView2];
    
    UIView *redView2 = [[UIView alloc] initWithFrame:CGRectMake(-30, -30, 60, 60)];
    redView2.backgroundColor = [UIColor redColor];
    [grayView2 addSubview:redView2];
    
    // cornerRadius圆角
    grayView1.layer.cornerRadius = 20;
    grayView2.layer.cornerRadius = 20;
    grayView2.layer.masksToBounds = YES;
    
    // 边框
    grayView1.layer.borderWidth = 5.0;
    grayView2.layer.borderWidth = 5.0;
    
    // 阴影
    grayView1.layer.shadowOpacity = 0.5;
    grayView2.layer.shadowOpacity = 0.5;
}

- (void)drawCat {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.center = self.view.center;
    [self.view addSubview:catView];
    
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    catView.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    catView.layer.borderWidth = 5.0;
    
    catView.layer.shadowOpacity = 0.5;
}

- (void)shadowOpacity {
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.center = self.view.center;
    [self.view addSubview:blueView];
    
    blueView.layer.shadowOpacity = 0.5;
    
    // shadowColor
//    blueView.layer.shadowColor = [UIColor redColor].CGColor;
    
    // shadowOffset
//    blueView.layer.shadowOffset = CGSizeMake(10, 10);
    
    // shadowRadius
    blueView.layer.shadowRadius = 50;
}

- (void)shadowOpacity1 {
    UIView *grayView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    grayView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView1];
    
    UIView *redView1 = [[UIView alloc] initWithFrame:CGRectMake(-30, -30, 60, 60)];
    redView1.backgroundColor = [UIColor redColor];
    [grayView1 addSubview:redView1];
    
    UIView *grayView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    grayView2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView2];
    
    UIView *redView2 = [[UIView alloc] initWithFrame:CGRectMake(-30, -30, 60, 60)];
    redView2.backgroundColor = [UIColor redColor];
    [grayView2 addSubview:redView2];
    
    // cornerRadius圆角
    grayView1.layer.cornerRadius = 20;
    grayView2.layer.cornerRadius = 20;
    grayView2.layer.masksToBounds = YES;
    
    // 边框
    grayView1.layer.borderWidth = 5.0;
    grayView2.layer.borderWidth = 5.0;
    
    // add a shadow to grayView1
    grayView1.layer.shadowOpacity = 0.5;
    grayView1.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    grayView1.layer.shadowRadius = 5.0;
    
    // add same shadow to shadowView
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    shadowView.layer.shadowOpacity = 0.5;
    shadowView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    shadowView.layer.shadowRadius = 5.0;
    [grayView2 insertSubview:shadowView atIndex:0];
}

- (void)shadowPath {
    UIView *grayView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    grayView1.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:grayView1];
    
    UIView *grayView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    grayView2.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:grayView2];
    
    // enable layer shadows
    grayView1.layer.shadowOpacity = 0.5;
    grayView2.layer.shadowOpacity = 0.5;
    
    // create a square shadow
    CGMutablePathRef squarPath = CGPathCreateMutable();
    CGPathAddRect(squarPath, NULL, grayView1.bounds);
    grayView1.layer.shadowPath = squarPath;
    CGPathRelease(squarPath);
    
    // create a circle shadow
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(-50, -50, 200, 200));
    grayView2.layer.shadowPath = circlePath;
    CGPathRelease(circlePath);
}

- (void)mask {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.center = self.view.center;
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
 
    // create mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = catView.bounds;
    maskLayer.contents = (__bridge id)[UIImage imageNamed:@"aqara_logo_login"].CGImage;
    
    // apply mask to image layer
    catView.layer.mask = maskLayer;
}

#pragma mark - clock

- (void)clock {
    // get spritesheet image
    UIImage *digits = [UIImage imageNamed:@"digits"];
    
    // add img view
    for (int i = 0; i < 6; i++) {
        UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(100 + i * 30, 300, 10, 20)];
        [self.digitViews addObject:imgView];
        imgView.layer.magnificationFilter = kCAFilterNearest;
        [self.view addSubview:imgView];
    }
    
    // setup digit views
    for (UIView *imgView in self.digitViews) {
        imgView.layer.contents = (__bridge id)digits.CGImage;
        imgView.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        imgView.layer.contentsGravity = kCAGravityResizeAspect;
    }
    
    // start timer
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf tick];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self tick];
}

- (void)tick {
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    // set hours
    [self setDigit:components.hour / 10 forView:self.digitViews[0]];
    [self setDigit:components.hour % 10 forView:self.digitViews[1]];
    
    // set minutes
    [self setDigit:components.minute / 10 forView:self.digitViews[2]];
    [self setDigit:components.minute % 10 forView:self.digitViews[3]];
    
    // set seconds
    [self setDigit:components.second / 10 forView:self.digitViews[4]];
    [self setDigit:components.second % 10 forView:self.digitViews[5]];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view {
    view.layer.contentsRect = CGRectMake(digit * 0.1, 0, 0.1, 1.0);
}

#pragma mark - custom btn

- (void)drawBtn {
    self.view.backgroundColor = [UIColor grayColor];
    
    //create opaque button
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(100, 150);
    [self.view addSubview:button1];
    
    //create translucent button
    UIButton *button2 = [self customButton];
    button2.center = CGPointMake(300, 150);
    button2.alpha = 0.5;
    [self.view addSubview:button2];
    
    //enable rasterization for the translucent button
    button2.layer.shouldRasterize = NO;
    button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIButton *)customButton {
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    return button;
}

#pragma mark - lazy

- (NSMutableArray *)digitViews {
    if (!_digitViews) {
        _digitViews = [NSMutableArray array];
    }
    return _digitViews;
}

@end
