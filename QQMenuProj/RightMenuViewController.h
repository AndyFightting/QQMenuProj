//
//  RightMenuViewController.h
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightMenuTapProtocol <NSObject>
-(void)rightMenuTapedAtIndex:(int)index;
@end

@interface RightMenuViewController : UIViewController
@property(nonatomic,retain)id<RightMenuTapProtocol> rightMenuTapDelegate;

@end
