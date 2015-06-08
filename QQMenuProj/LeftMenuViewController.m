//
//  LeftMenuViewController.m
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftMenuViewController
{
    UITableView* mainTable;
}
@synthesize leftMenuTapDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    
    // 0.7---即SGMNavigationController 中的 leftWidthScal 值
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.7, self.view.frame.size.height) style:UITableViewStylePlain];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.backgroundView = nil;
    [self.view addSubview:mainTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    static NSString *CMainCell = @"CMainCell";     //  0
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];      //   1
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];    //  2
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d",indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [leftMenuTapDelegate leftMenuTapedAtIndex:indexPath.row];

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
