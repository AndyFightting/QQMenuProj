//
//  RightMenuViewController.m
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "RightMenuViewController.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController
@synthesize rightMenuTapDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    
    for (int i=0; i<5;i++) {
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, 20+80*i, 70, 70)];
        [button setTitle:[NSString stringWithFormat:@"button %d",i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        button.tag = i;
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonTap:(UIButton*)bt{
    [rightMenuTapDelegate rightMenuTapedAtIndex:bt.tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
