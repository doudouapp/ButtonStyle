//
//  UIButton+ButtonStyle.h
//  ScrollviewTestDemo
//
//  Created by dangshuai on 16/11/29.
//  Copyright © 2016年 dangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SDButtonStyle) {
    SDButtonStyleNormal = 0,
    SDButtonStyleTitleLeft,
    SDButtonStyleTitleUp,
    SDButtonStyleTitleDown
};
@interface UIButton (ButtonStyle)

@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) SDButtonStyle buttonStyle;
@end
