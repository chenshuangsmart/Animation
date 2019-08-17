//
//  CSBezierCurve.h
//  CAShapeLayer_ CoreAnimation
//
//  Created by chenshuang on 2019/8/17.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSBezierCurve : NSObject

- (id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end controlPoints:(NSArray <NSValue *>*)points;

// return bezier path
- (UIBezierPath *)bezierPath;

@end

NS_ASSUME_NONNULL_END
