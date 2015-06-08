//
//  ViewController.m
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [self randomColor];
    
    UILabel* hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70,320,100)];
    hintLabel.text = @"模仿QQ菜单，在根页面可以通过左右边框的滑动调出菜单。如果进入push页面则可以通过手势返回。ios6和ios7以上都可使用。";
    hintLabel.numberOfLines = 0;
    hintLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hintLabel];
    
    UIButton* pushBt = [[UIButton alloc]initWithFrame:CGRectMake(130, 170, 60, 40)];
    [pushBt setTitle:@"PUSH" forState:UIControlStateNormal];
    pushBt.backgroundColor = [UIColor lightGrayColor];
    [pushBt addTarget:self action:@selector(pushTaped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBt];
    
    
}
- (void)pushTaped {
    
    ViewController *viewcontroller = [[ViewController alloc ]init];
     viewcontroller.title =@"gesture back";
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (UIColor *)randomColor {
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
