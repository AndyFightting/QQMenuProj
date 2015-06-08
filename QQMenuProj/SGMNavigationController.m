//
//  SGMNavigationController.m
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "SGMNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"

#import "ViewController.h"

@interface SGMNavigationController ()<LeftMenuTapProtocol,RightMenuTapProtocol>

@end

@implementation SGMNavigationController{
    
    UIButton* backTapButton;

    CGPoint startPoint;//触摸开始坐标
    CGSize viewSize;
    
    UIView* backContainerView;//截屏view的容器view
    UIImageView* lastScreenShotView;//最近的一次截屏图片
    UIView* blackMask;//黑色半透明遮罩
    UIImageView* menuBackImg;
    NSMutableArray* screenShotsArray;
    
    //QQ左右菜单
    LeftMenuViewController* leftMenuControl;
    RightMenuViewController* rightMenuControl;
    
    float leftWidthScal;
    float rightWidthScal;
    
    //QQ menu 用
    int moveFlag;//0 未动  1 右滑完成  2 左滑完成
  
}

@synthesize isSupportPenGesture;
@synthesize animationType;
@synthesize isSupportLeftMenu;
@synthesize isSupportRightMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    //必须禁用ios7自带的手势返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
#endif

    
    screenShotsArray = [[NSMutableArray alloc]init];
    //拖动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
       
    leftMenuControl = [[LeftMenuViewController alloc]init];
    leftMenuControl.leftMenuTapDelegate = self;
    rightMenuControl = [[RightMenuViewController alloc]init];
    rightMenuControl.rightMenuTapDelegate = self;
    
    leftWidthScal = 0.7;
    rightWidthScal = 0.3;
    
    //添加背景
    viewSize = self.view.frame.size;
    backContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width , viewSize.height)];
    backContainerView.backgroundColor = [UIColor blackColor];
    
    //在backgroundView添加黑色的面罩
    blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0,viewSize.width , viewSize.height)];
    blackMask.backgroundColor = [UIColor blackColor];
    [backContainerView addSubview:blackMask];
    
    menuBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,viewSize.width , viewSize.height)];
    [menuBackImg setImage:[UIImage imageNamed:@"backImg.jpg"]];
    
    //点击还原
    backTapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [backTapButton addTarget:self action:@selector(mainViewTaped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backTapButton];
    backTapButton.hidden = YES;

}
-(void)mainViewTaped{
    if (moveFlag == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            [self showLeftQQMenue:0];
        } completion:^(BOOL finished) {
            blackMask.hidden = YES;
            backTapButton.hidden = YES;
            moveFlag = 0;
        }];
    }if (moveFlag ==2) {
        [UIView animateWithDuration:0.3 animations:^{
            [self showRightQQMenue:WINDOW_WIDTH];
        } completion:^(BOOL finished) {
            blackMask.hidden = YES;
            backTapButton.hidden = YES;
            moveFlag = 0;
        }];
    }
}
//手势处理
-(void)handlePanGesture:(UIGestureRecognizer*)sender{
    
     CGPoint translation=[sender locationInView:WINDOW];
    //顶级视图 --左右菜单
    if (self.viewControllers.count<=1) {
        float X =translation.x;
                if (sender.state == UIGestureRecognizerStateBegan) {
                    startPoint = translation;

                    if (startPoint.x<40&&moveFlag == 0) { //开始滑出左边菜单
                        [self initLeftMenuView];
                    }else if(startPoint.x>WINDOW_WIDTH-40&&moveFlag==0){//开始滑动右边菜单
                        [self initRightMenuView];
                    }

                }else if (sender.state == UIGestureRecognizerStateChanged){
                    
                    if (startPoint.x<40&&moveFlag == 0) {//左边菜单慢慢往右出现
                        [self showLeftQQMenue:X-startPoint.x];
                    }else if(startPoint.x>WINDOW_WIDTH-40&&moveFlag==0){//右边菜单慢慢往左出现
                        [self showRightQQMenue:WINDOW_WIDTH-(startPoint.x-X)];
                    }else if(startPoint.x>=WINDOW_WIDTH*leftWidthScal&&moveFlag == 1){//左边菜单慢慢收起
                        [self showLeftQQMenue:WINDOW_WIDTH*leftWidthScal-(startPoint.x-X)];
                    }else if(startPoint.x<=WINDOW_WIDTH*(1-rightWidthScal)&&moveFlag == 2){//右边菜单慢慢收起
                        [self showRightQQMenue:(X-startPoint.x)+WINDOW_WIDTH*(1-rightWidthScal)];
                    }
    
                }else if(sender.state == UIGestureRecognizerStateEnded){
                   
                    if (startPoint.x<40&&moveFlag == 0) { //左边菜单慢慢往右出现---结束判断是否成功
                        if (!isSupportLeftMenu) {
                            return;
                        }
                        if (X-startPoint.x>20) {//左菜单出现成功
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showLeftQQMenue:WINDOW_WIDTH*leftWidthScal];
                            } completion:^(BOOL finished) {
                                blackMask.hidden = YES;
                                backTapButton.hidden = NO;
                                moveFlag = 1;
                            }];
                        }else{//左菜单出现失败
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showLeftQQMenue:0];
                            } completion:^(BOOL finished) {
                                [self resetViewFrame];
                            }];
                        
                        }
                    }else if(startPoint.x>WINDOW_WIDTH-40&&moveFlag==0 ){//右边菜单慢慢往左出现---结束判断是否成功
                        if (!isSupportRightMenu) {
                            return;
                        }
                        if (startPoint.x-X>5) {//右菜单出现成功
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showRightQQMenue:WINDOW_WIDTH*(1-rightWidthScal)];
                            } completion:^(BOOL finished) {
                                blackMask.hidden = YES;
                                backTapButton.hidden = NO;
                                moveFlag = 2;
                            }];
                        }else{//右菜单出现失败
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showRightQQMenue:WINDOW_WIDTH];
                            } completion:^(BOOL finished) {
                                [self resetViewFrame];
                            }];
                            
                        }
                    }else if(startPoint.x>=WINDOW_WIDTH*leftWidthScal&&moveFlag == 1){//左边菜单慢慢收起---结束判断是否成功
                        if (!isSupportLeftMenu) {
                            return;
                        }
                        if (startPoint.x-X>30) {//左菜单收起成功
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showLeftQQMenue:0];
                            } completion:^(BOOL finished) {
                                [self resetViewFrame];
                            }];
                        }else{//左菜单收起失败
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showLeftQQMenue:WINDOW_WIDTH*leftWidthScal];
                            } completion:^(BOOL finished) {
                                blackMask.hidden = YES;
                                backTapButton.hidden = NO;
                                moveFlag = 1;
                            }];
                        }
                    }else if(startPoint.x<=WINDOW_WIDTH*(1-rightWidthScal)&&moveFlag == 2){//右边菜单慢慢收起---结束判断是否成功
                        if (!isSupportRightMenu) {
                            return;
                        }
                        if (X-startPoint.x>0) {//右菜单收起成功
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showRightQQMenue:WINDOW_WIDTH];
                            } completion:^(BOOL finished) {
                                [self resetViewFrame];
                            }];
                        }else{//右菜单收起失败
                            [UIView animateWithDuration:0.3 animations:^{
                                [self showRightQQMenue:WINDOW_WIDTH*(1-rightWidthScal)];
                            } completion:^(BOOL finished) {
                                blackMask.hidden = YES;
                                backTapButton.hidden = NO;
                                moveFlag = 2;
                            }];
                        }
                    }
                }
            }
     else{//返回手势
        if (isSupportPenGesture) {
            if (sender.state == UIGestureRecognizerStateBegan) {
            
                startPoint = translation;
                menuBackImg.hidden = YES;
                blackMask.hidden = NO;
            
                [WINDOW insertSubview:backContainerView belowSubview:self.view];
                 
                if (lastScreenShotView) {
                    [lastScreenShotView removeFromSuperview];
                }
                UIImage *lastScreenShot = [screenShotsArray lastObject];
                lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
                [backContainerView insertSubview:lastScreenShotView belowSubview:blackMask];
                
            }else if (sender.state == UIGestureRecognizerStateChanged){
                 [self moveViewWithX:translation.x - startPoint.x];
            }else if(sender.state == UIGestureRecognizerStateEnded){
                //如果结束坐标大于开始坐标50像素就动画效果移动
                if (translation.x - startPoint.x > 50) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [self moveViewWithX:WINDOW_WIDTH];
                    } completion:^(BOOL finished) {
                        [self resetViewFrame];
                        [self popViewControllerAnimated:NO];
                        
                    }];
                }else{
                    //不大于50时就移动原位
                    [UIView animateWithDuration:0.3 animations:^{
                        [self moveViewWithX:0];
                    } completion:^(BOOL finished) {
                        [self resetViewFrame];
                    }];
                }
            }else{
               [self resetViewFrame];
               
            }
        }
    }
}

-(void)initLeftMenuView{
    if (!isSupportLeftMenu) {
        return;
    }
    
    if (lastScreenShotView) {
        [lastScreenShotView removeFromSuperview];
    }
    
    [WINDOW insertSubview:backContainerView belowSubview:self.view];
    
    blackMask.hidden = NO;
    menuBackImg.hidden = NO;
    [backContainerView addSubview:menuBackImg];
    
    [backContainerView insertSubview:leftMenuControl.view belowSubview:blackMask];
    leftMenuControl.view.hidden = NO;
    rightMenuControl.view.hidden = YES;
    
    [backContainerView sendSubviewToBack:menuBackImg];
}


-(void)initRightMenuView{
    if (!isSupportRightMenu) {
        return;
    }
    
    if (lastScreenShotView) {
        [lastScreenShotView removeFromSuperview];
    }
    
    [WINDOW insertSubview:backContainerView belowSubview:self.view];
    
    blackMask.hidden = NO;
    menuBackImg.hidden = NO;
    [backContainerView addSubview:menuBackImg];
    
    [backContainerView insertSubview:rightMenuControl.view belowSubview:blackMask];
    rightMenuControl.view.hidden = NO;
    leftMenuControl.view.hidden = YES;
    
    [backContainerView sendSubviewToBack:menuBackImg];
}

//显示左菜单
- (void)showLeftQQMenue:(float)x
{
    if (!isSupportLeftMenu) {
        return;
    }
    x = x>WINDOW_WIDTH*leftWidthScal?WINDOW_WIDTH*leftWidthScal:x;
    x = x<0?0:x;
    
    float alpha = 0.7 - (x/(WINDOW_WIDTH*leftWidthScal))*0.7;//透明值
    blackMask.alpha = alpha;
    blackMask.hidden = NO;
   
    float scale =1-(x/(WINDOW_WIDTH*leftWidthScal))*0.3;//缩放大小
    self.view.transform = CGAffineTransformMakeScale(scale, scale); //这个必须在设置frame之前，不然动画会有跳动！！
    self.view.center = CGPointMake(viewSize.width/2/scale+x/2, viewSize.height/2);
    
    //-----左边menu处理
   float menuScal =0.8+(x/(WINDOW_WIDTH*leftWidthScal))*0.2;//缩放大小
    leftMenuControl.view.transform = CGAffineTransformMakeScale(menuScal, menuScal);
}

-(void)showRightQQMenue:(float)x{
    if (!isSupportRightMenu) {
        return;
    }
    
    x = x>WINDOW_WIDTH?WINDOW_WIDTH:x;
    x = x<WINDOW_WIDTH*(1-rightWidthScal)?WINDOW_WIDTH*(1-rightWidthScal):x;
    
    float alpha = 0.7 - ((WINDOW_WIDTH-x)/(WINDOW_WIDTH*rightWidthScal))*0.7;//透明值
    blackMask.alpha = alpha;
    blackMask.hidden = NO;
    
    
    float scale =1-((WINDOW_WIDTH-x)/(WINDOW_WIDTH*rightWidthScal))*0.2;//缩放大小
 
    self.view.transform = CGAffineTransformMakeScale(scale, scale); //这个必须在设置frame之前，不然动画会有跳动！！
    self.view.center = CGPointMake(viewSize.width*scale/2-(WINDOW_WIDTH-x)/2, viewSize.height/2);
    
    //-----右边menu处理
    float menuScal =0.8+((WINDOW_WIDTH-x)/(WINDOW_WIDTH*rightWidthScal))*0.2;//缩放大小
    rightMenuControl.view.transform = CGAffineTransformMakeScale(menuScal, menuScal);}

- (void)moveViewWithX:(float)x
{
    //这个必须加 否则可以往左边移动
    x = x>WINDOW_WIDTH?WINDOW_WIDTH:x;
    x = x<0?0:x;
    
    float alpha = 0.5 - (x/WINDOW_WIDTH)*0.5;//透明值
    blackMask.alpha = alpha;

    CGRect frame = self.view.frame;
    CGRect frameSyn = self.view.frame;
    CGRect frameAsyn = self.view.frame;
    float scale;
    
    frame.origin.x = x;
    self.view.frame = frame;    

    switch (animationType) {
        case SGMNavigationAnimationScale://尺寸动画
            scale = (x/WINDOW_WIDTH)*0.05+0.95;//缩放大小
            lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
            break;
        case SGMNavigationAnimationSynMove://同步移动
            frameSyn.origin.x = x-WINDOW_WIDTH;
            lastScreenShotView.frame = frameSyn;
            break;
        case SGMNavigationAnimationAsynMove://差异化移动
            frameAsyn.origin.x = x/2.5-WINDOW_WIDTH/2.5;
            lastScreenShotView.frame = frameAsyn;
            break;
        default:  //背景静止 默认
            //什么都不做
            break;
    }
}
//实现截屏
- (UIImage *)viewRenderImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0); //
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * screenShotImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenShotImg;
}
-(void)resetViewFrame{
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    self.view.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    blackMask.hidden = YES;
    backTapButton.hidden = YES;
    moveFlag = 0;
}
#pragma Navigation 覆盖方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //图像数组中存放一个当前的界面截屏，然后再push
    [screenShotsArray addObject:[self viewRenderImage]];
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //移除最后一个截屏
    [screenShotsArray removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - left Menu delegate
-(void)leftMenuTapedAtIndex:(int)index{
    
    [self mainViewTaped];

    ViewController *viewcontroller = [[ViewController alloc ]init];
    viewcontroller.title = [NSString stringWithFormat:@"left cell %d",index];
    [self pushViewController:viewcontroller animated:NO];
   
}
#pragma mark - right menu delegate
-(void)rightMenuTapedAtIndex:(int)index{
    [self mainViewTaped];
    
    ViewController *viewcontroller = [[ViewController alloc ]init];
    viewcontroller.title = [NSString stringWithFormat:@"button %d",index];
    [self pushViewController:viewcontroller animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
