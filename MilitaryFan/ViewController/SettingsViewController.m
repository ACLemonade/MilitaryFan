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
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self removeDirectoryPath:kInfoCachePath];
        [self removeDirectoryPath:kDetailCachePath];
        self.cachesNumberLb.text = [self getCacheSize];
        [Factory textHUDWithVC:self text:@"清理成功"];
    }
}
#pragma mark - 方法 Methods
//根据文件夹计算所包含文件的总大小
- (NSInteger)getSizeOfFilePath:(NSString *)filePath{
    //定义记录大小
    NSInteger totalSize = 0;
    //定义一个文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取目标文件夹下所有文件的路径(耗时操作)
    NSArray *subPaths = [manager subpathsAtPath:filePath];
    //遍历所有子文件路径
    for (NSString *fileName in subPaths) {
        //拼接获取完整路径
        NSString *subPath = [filePath stringByAppendingPathComponent:fileName];
        //隐藏文件
        if ([subPath hasPrefix:@".DS"]) {
            continue;
        }
        //文件夹
        BOOL isDirectory;
        [manager fileExistsAtPath:subPath isDirectory:&isDirectory];
        if (isDirectory) {
            continue;
        }
        //获取文件属性
        NSDictionary *dic = [manager attributesOfItemAtPath:subPath error:nil];
        //获取每个文件大小 unsigned long long类型(B)
        totalSize += [dic fileSize];
    }
    return totalSize;
}
/** 根据文件路径删除文件 */
- (void)removeDirectoryPath:(NSString *)directoryPath{
    
    /** 创建文件管理者 */
    NSFileManager * manager = [NSFileManager defaultManager];
    /** 判断文件路径是否存在 */
    BOOL isDirectory;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory||!isExist) {
        /** 提示错误信息 */
        NSLog(@"文件路径错误");
        return;
    }
    /** 删除文件 */
    [manager removeItemAtPath:directoryPath error:nil];
    /** 创建文件 */
    [manager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}
- (NSString *)getCacheSize{
    NSInteger infoCacheSize = [self getSizeOfFilePath:[kDocPath stringByAppendingPathComponent:@"InfoCache"]];
    NSInteger detailCacheSize = [self getSizeOfFilePath:[kDocPath stringByAppendingPathComponent:@"DetailCache"]];
    NSInteger totalSize = infoCacheSize + detailCacheSize;
    NSString *cacheSize = nil;
    // >=1M ---- ???M
    if (totalSize >= 1048576) {
        cacheSize = [NSString stringWithFormat:@"%.1ldM", totalSize/1048576];
    }else{// <1M ---- ???K
        cacheSize = [NSString stringWithFormat:@"%ldK", totalSize/1024];
    }
    return cacheSize;
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
    self.cachesNumberLb.text = [self getCacheSize];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"viewWillDisappear");
}
@end
