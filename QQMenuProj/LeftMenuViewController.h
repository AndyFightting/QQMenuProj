//
//  LeftMenuViewController.h
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuTapProtocol <NSObject>
-(void)leftMenuTapedAtIndex:(int)index;
@end

@interface LeftMenuViewController : UIViewController

@property(nonatomic,retain)id<LeftMenuTapProtocol> leftMenuTapDelegate;

@end
