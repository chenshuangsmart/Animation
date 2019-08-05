//
//  TestAnimationLayer.m
//  ViewAndLayer
//
//  Created by chenshuang on 2019/8/4.
//  Copyright © 2019年 wenwen. All rights reserved.
//

#import "TestAnimationLayer.h"

@implementation TestAnimationLayer

+ (Class)layerClass {
    NSLog(@"%s",__func__);
    return [TestAnimationLayer class];
}

- (void)setFrame:(CGRect)frame {
    NSLog(@"%s",__func__);
    [super setFrame:frame];
}

- (void)setPosition:(CGPoint)position {
    NSLog(@"%s",__func__);
    [super setPosition:position];
}

- (void)setBounds:(CGRect)bounds {
    NSLog(@"%s",__func__);
    [super setBounds:bounds];
}

- (CGPoint)position {
    NSLog(@"%s",__func__);
    return [super position];
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
    [super addAnimation:anim forKey:key];
    NSLog(@"addAnimation %@",[anim debugDescription]);
}

/** 猜测内部实现
- (CGRect)frame {
    return frameWithCenterAndBounds([self bounds], [self position]);
}

- (void)setFrame:(CGRect)frame {
    [self setBounds:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, frame.size.width, frame.size.height)];
    [self setPosition:CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2)];
}

CGRect frameWithCenterAndBounds(CGRect bounds, CGPoint center) {
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    return CGRectMake(center.x - width/2, center.y - height/2, width, height);
}
*/

/** 隐式动画
 - (void)setPosition:(CGPoint)position  {
     [super setPosition:position];
     if ([self.delegate respondsToSelector:@selector(actionForLayer:forKey:)]) {
        id obj = [self.delegate actionForLayer:self forKey:@"position"];
         if (!obj) {
            // 隐式动画
         } else if ([obj isKindOfClass:[NSNull class]]) {
            // 直接重绘（无动画）
         } else {
            // 使用obj生成CAAnimation
            CAAnimation * animation;
            [self addAnimation:animation forKey:nil];
         }
     }
 }
 */

@end
