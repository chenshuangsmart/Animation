//
//  TestAnimationView.m
//  ViewAndLayer
//
//  Created by chenshuang on 2019/8/4.
//  Copyright © 2019年 wenwen. All rights reserved.
//

#import "TestAnimationView.h"
#import "TestAnimationLayer.h"

@implementation TestAnimationView

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"%s",__func__);
    }
    return self;
}

- (CGPoint)center {
    NSLog(@"%s",__func__);
    return [super center];
}

- (void)setFrame:(CGRect)frame {
    NSLog(@"%s",__func__);
    [super setFrame:frame];
}

- (void)setCenter:(CGPoint)center {
    NSLog(@"%s",__func__);
    [super setCenter:center];
}

- (void)setBounds:(CGRect)bounds {
    NSLog(@"%s",__func__);
    [super setBounds:bounds];
}

+ (Class)layerClass {
    NSLog(@"%s",__func__);
    return [TestAnimationLayer class];
}

#pragma mark - blcok动画

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    id<CAAction> obj = [super actionForLayer:layer forKey:event];
    NSLog(@"actionForLayer %@",obj);
    return obj;
}

/** 猜测内部实现
- (CGPoint)center {
    return [[self layer] position];
}

- (CGRect)bounds {
    return [[self layer] bounds];
}

- (CGRect)frame {
    return [[self layer] frame];
}

- (void)setFrame:(CGRect)frame {
    [[self layer] setFrame:frame];
}
 
- (void)setCenter:(CGPoint)center {
    [[self layer] setPosition:center];
}
 
- (void)setBounds:(CGRect)bounds {
    [[self layer] setBounds:bounds];
}

+ (Class)layerClass {
    return [TestAnimationLayer class];
}
*/

@end
