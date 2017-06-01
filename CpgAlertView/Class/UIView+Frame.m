//
//  UIView+Frame.m
//  Template
//
//  Created by zhangkai on 10/11/14.
//  Copyright (c) 2014 Kai Zhang. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)MaxX {
    return [self x] + [self width];
}

- (void)setMaxX:(CGFloat)MaxX {
    CGRect frame = self.frame;
    frame.origin.x = MaxX - [self width];
    self.frame = frame;
    return;
}

- (CGFloat)MaxY {
    return [self y] + [self height];
}

- (void)setMaxY:(CGFloat)MaxY {
    CGRect frame = self.frame;
    frame.origin.y = MaxY - [self height];
    self.frame = frame;
    return;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end
