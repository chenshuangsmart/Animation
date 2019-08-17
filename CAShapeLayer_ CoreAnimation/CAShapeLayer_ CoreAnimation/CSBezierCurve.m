//
//  CSBezierCurve.m
//  CAShapeLayer_ CoreAnimation
//
//  Created by chenshuang on 2019/8/17.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "CSBezierCurve.h"

@interface CSBezierCurve() {
    UIBezierPath *_bezierPath;
}

@property (nonatomic,strong) NSMutableArray * controlPoints;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;

@end

@implementation CSBezierCurve

- (id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end controlPoints:(NSArray <NSValue *>*)points {
    self = [super init];
    
    if (self) {
        self.startPoint = CGPointMake(start.x, start.y);
        self.endPoint = CGPointMake(end.x, end.y);
        self.controlPoints = [NSMutableArray arrayWithArray:points];
        _bezierPath = [UIBezierPath bezierPath];
        
        [self update];
    }
    
    return self;
}

#pragma mark - public

- (UIBezierPath *)bezierPath {
    return _bezierPath;
}

#pragma mark - 任意阶贝塞尔曲线

- (CGPoint)bezierPointMakeWithT:(CGFloat)t {
    CGPoint bezierPoint = CGPointZero;
    
    NSInteger rank = self.controlPoints.count + 1;
    
    bezierPoint.x = [self choose:0 in:rank] * (self.startPoint.x * pow(1-t, rank) * pow(t, 0));
    bezierPoint.y = [self choose:0 in:rank] * (self.startPoint.y * pow(1-t, rank) * pow(t, 0));
    
    for (int i = 1; i < rank; i++) {
        CGPoint p = [[self.controlPoints objectAtIndex:i - 1] CGPointValue];
        
        bezierPoint.x = bezierPoint.x + [self choose:i in:rank] * (p.x * pow(1-t, rank - i) * pow(t, i));
        bezierPoint.y = bezierPoint.y + [self choose:i in:rank] * (p.y * pow(1-t, rank - i) * pow(t, i));
    }
    
    bezierPoint.x = bezierPoint.x + [self choose:rank in:rank] * (self.endPoint.x * pow((1-t), 0)*pow(t, rank));
    bezierPoint.y = bezierPoint.y + [self choose:rank in:rank] * (self.endPoint.y * pow((1-t), 0)*pow(t, rank));
    
    return bezierPoint;
}

// update
- (void)update {
    [_bezierPath removeAllPoints];
    [_bezierPath moveToPoint:self.startPoint];
    
    if (self.controlPoints.count >= 1) {
        for (float ti = 0; ti <= 1.0 ; ti += 0.005) {
            CGPoint p = [self bezierPointMakeWithT:ti];
            [_bezierPath addLineToPoint:CGPointMake(p.x, p.y)];
        }
    }
}

- (CGFloat)choose:(CGFloat)t in:(CGFloat)n {
    if (t == 0) {
        return 1;
    }
    if (t == 1) {
        return n;
    }
    if (n == t) {
        return 1;
    }
    
    CGFloat x = 1.0f;
    CGFloat y = 1.0f;
    
    for (int i = n; i > n-t; i--) {
        x = x * i;
    }
    
    for (int i = t; i > 1; i--) {
        y = y * i;
    }
    
    return x / y;
}

@end
