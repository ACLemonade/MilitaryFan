//
//  SettingsViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cachesNumberLb;

@end

@implementation SettingsViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        loginVC.previousVC = @"settingsVC";
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
