//
//  SGMNavigationController.h
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOW  [[UIApplication sharedApplication]keyWindow]
#define WINDOW_WIDTH WINDOW.frame.size.width

typedef NS_ENUM(NSInteger, AnimationType) {//手势返回动画
    SGMNavigationAnimationStill, //背景静止 默认
    SGMNavigationAnimationScale, //尺寸动画
    SGMNavigationAnimationSynMove,//同步移动
    SGMNavigationAnimationAsynMove//差异化移动
};

@interface SGMNavigationController : UINavigationController


//是否开始手势返回 默认关闭
@property(nonatomic) BOOL isSupportPenGesture;
//动画类型
@property(nonatomic) AnimationType animationType;

//只有在根视图的时候才支持左右菜单
//是否支持做菜单
@property(nonatomic) BOOL isSupportLeftMenu;
//是否支持右菜单
@property(nonatomic) BOOL isSupportRightMenu;

@end
