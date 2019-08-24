//
//  ViewController.m
//  AnimationHighSkill_2
//
//  Created by chenshuang on 2019/8/23.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** hour */
@property(nonatomic, strong)UIImageView *hourImgView;
/** minute */
@property(nonatomic, strong)UIImageView *minuteImgView;
/** second */
@property(nonatomic, strong)UIImageView *secondImgView;
/** timer */
@property(nonatomic, strong)NSTimer *timer;
/** blueLayer */
@property(nonatomic, strong)CALayer *blueLayer;
/** layerView */
@property(nonatomic, strong)UIView *layerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self drawUI];
//
//    [self setupTimer];
    
//    [self zPosition];
    
    [self drawBlueView];
}

- (void)drawUI {
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
}

#pragma mark - timer

- (void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self updateTimer];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self tick];
}

- (void)updateTimer {
    [self tick];
}

- (void)stopTimer {
    
}

#pragma mark - tick

- (void)tick {
    // convert time to houres minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    
    // rotate hands
    self.hourImgView.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteImgView.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondImgView.transform = CGAffineTransformMakeRotation(secsAngle);
}

#pragma mark - zPosition

- (void)zPosition {
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(150, 250, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    greenView.layer.zPosition = 1.0;
}

#pragma mark - containsPoint

- (void)drawBlueView {
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.layerView.backgroundColor = [UIColor grayColor];
    self.layerView.center = self.view.center;
    [self.view addSubview:self.layerView];
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.blueLayer];
}

/// containsPoint:
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    // get touch position relative to main view
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//
//    // convert point to the white layers coordinates
//    point = [self.view.layer convertPoint:point toLayer:self.layerView.layer];
//
//    // get layer using containsPoint
//    if ([self.layerView.layer containsPoint:point]) {
//        // convert point to blueLayer's coordinates
//        point = [self.layerView.layer convertPoint:point toLayer:self.blueLayer];
//        if ([self.blueLayer containsPoint:point]) {
//            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
//                                        message:nil
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil] show];
//        } else {
//            [[[UIAlertView alloc] initWithTitle:@"Inside gray Layer"
//                                        message:nil
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil] show];
//        }
//    }
//}

/// hitTest:
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // get touch position
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // get touched layer
    CALayer *layer = [self.layerView.layer hitTest:point];
    
    // get layer using hitTest
    if (layer == self.blueLayer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if (layer == self.layerView.layer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside gray Layer"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
