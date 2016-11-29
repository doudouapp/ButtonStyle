//
//  UIButton+ButtonStyle.m
//  ScrollviewTestDemo
//
//  Created by dangshuai on 16/11/29.
//  Copyright © 2016年 dangshuai. All rights reserved.
//

#import "UIButton+ButtonStyle.h"
#import <objc/runtime.h>

@implementation UIButton (ButtonStyle)

+ (void)load {
    Method imageOriginalMethod = class_getInstanceMethod([self class], @selector(imageRectForContentRect:));
    Method imageSwizzledMethod = class_getInstanceMethod([self class], @selector(sd_imageRectForContentRect:));
    method_exchangeImplementations(imageOriginalMethod, imageSwizzledMethod);
    
    Method titleOriginalMethod = class_getInstanceMethod([self class], @selector(titleRectForContentRect:));
    Method titleSwizzledMethod = class_getInstanceMethod([self class], @selector(sd_titleRectForContentRect:));
    method_exchangeImplementations(titleOriginalMethod, titleSwizzledMethod);
}

- (CGRect)sd_imageRectForContentRect:(CGRect)contentRect {
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    
    CGRect imgRect = [self sd_imageRectForContentRect:contentRect];
    CGRect titRect = [self sd_titleRectForContentRect:contentRect];
    if (self.buttonStyle == SDButtonStyleTitleLeft) {
        imgRect.origin.x = CGRectGetMaxX(titRect) - CGRectGetWidth(imgRect);
        return imgRect;
    }
    if (self.buttonStyle == SDButtonStyleTitleDown) {
        imgRect.origin.x = (CGRectGetWidth(contentRect) - CGRectGetWidth(imgRect))/2.f;
        imgRect.origin.y = (CGRectGetHeight(contentRect) - CGRectGetHeight(titRect) - CGRectGetHeight(imgRect) ) /2.f;
        return imgRect;
    }
    if (self.buttonStyle == SDButtonStyleTitleUp) {
        imgRect.origin.x = (CGRectGetWidth(contentRect) - CGRectGetWidth(imgRect))/2.f;
        imgRect.origin.y = (CGRectGetHeight(contentRect) + CGRectGetHeight(titRect) - CGRectGetHeight(imgRect))/2.f;
        return imgRect;
    }
    return imgRect;
}

- (CGRect)sd_titleRectForContentRect:(CGRect)contentRect {
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }

    CGRect imgRect = [self sd_imageRectForContentRect:contentRect];
    CGRect titRect = CGRectZero;
    if (self.buttonStyle == SDButtonStyleTitleLeft) {
        titRect = [self sd_titleRectForContentRect:contentRect];
        titRect.origin.x = CGRectGetMinX(imgRect);
        return titRect;
    }
    
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width  = CGRectGetWidth(contentRect);
    
    if (self.buttonStyle == SDButtonStyleTitleDown) {
        titRect = [self sd_titleRectForContentRect:CGRectMake(0, 0, 3 * width, height)];
        titRect.origin.x = (width - CGRectGetWidth(titRect))/2.f;
        titRect.origin.y = (height - CGRectGetHeight(titRect) + CGRectGetHeight(imgRect))/2.f;
        return titRect;
    }
    if (self.buttonStyle == SDButtonStyleTitleUp) {
        titRect = [self sd_titleRectForContentRect:CGRectMake(0, 0, 3 * width, height)];
        titRect.origin.x = (width - CGRectGetWidth(titRect))/2.f;
        titRect.origin.y = (height - CGRectGetHeight(titRect) - CGRectGetHeight(imgRect) ) /2.f;
        return titRect;
    }
    return [self sd_titleRectForContentRect:contentRect];
}

#pragma mark --- AssociatedObject

- (void)setImageRect:(CGRect)imageRect {
    NSValue *value = [NSValue valueWithCGRect:imageRect];
    objc_setAssociatedObject(self, @selector(imageRect), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)imageRect {
    NSValue *value = objc_getAssociatedObject(self, @selector(imageRect));
    return [value CGRectValue];
}

- (void)setTitleRect:(CGRect)titleRect {
    NSValue *value = [NSValue valueWithCGRect:titleRect];
    objc_setAssociatedObject(self, @selector(titleRect), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)titleRect {
    NSValue *value = objc_getAssociatedObject(self, @selector(titleRect));
    return [value CGRectValue];
}

- (void)setButtonStyle:(SDButtonStyle)buttonStyle {
    objc_setAssociatedObject(self, @selector(buttonStyle), @(buttonStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SDButtonStyle)buttonStyle {
    return [objc_getAssociatedObject(self, @selector(buttonStyle)) integerValue];
}

@end
