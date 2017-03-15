//
//  UserCenterViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/31.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "UserCenterViewController.h"
#import "ModifyPasswordViewController.h"
#import "AppDelegate.h"

#define kTopViewH 350
@interface UserCenterViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *topView;
@property (nonatomic) UIButton *iconBtn;
@property (nonatomic) NSArray *dataList;
@end

@interface LogoutCell : UITableViewCell
@property (nonatomic) UIButton *logoutBtn;
@end

@implementation UserCenterViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
        cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
        //小箭头
        cell.accessoryType = 1;
        return cell;
    }else{
        LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell"];
        [cell.logoutBtn addTarget:self action:@selector(clickLogout:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetH = -kTopViewH * 0.5 - offsetY;
    if (offsetH < 0) return;
    CGRect frame = self.topView.frame;
    frame.size.height = kTopViewH + offsetH;
    self.topView.frame = frame;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    if (indexPath.section == 0 && indexPath.row < 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor grayColor];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //修改密码
    if (indexPath.section == 0 && indexPath.row == 2) {
        ModifyPasswordViewController *pwdVC = [[UIStoryboard storyboardWithName:@"UserCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
        [self.navigationController pushViewController:pwdVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 50;
    }
    return 44;
}
#pragma mark - 协议方法 UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = info[UIImagePickerControllerEditedImage];
    //关闭自动渲染
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置头像
    [_iconBtn setImage:image forState:UIControlStateNormal];
    //将存储图片放到子线程
    [[NSOperationQueue new] addOperationWithBlock:^{
        //将图片存入文件
        [UIImagePNGRepresentation(image) writeToFile:kHeadImagePath atomically:YES];
    }];
//    NSLog(@"%@", kHeadImagePath);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 方法 Methods
- (void)changeMyIconIV{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"换个头像吧!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍一张照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeOnePhoto];
    }];
    UIAlertAction *localAction = [UIAlertAction actionWithTitle:@"从本地照片选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseLocalPic];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [alertVC addAction:photoAction];
    [alertVC addAction:localAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//选取本地照片
- (void)chooseLocalPic{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    pickerVC.allowsEditing = YES;
    [self presentViewController:pickerVC animated:YES completion:nil];
}
//通过摄像头拍一张照片
- (void)takeOnePhoto{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    pickerVC.allowsEditing = YES;
    pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}
- (void)naviBack:sender{
    //将上传的头像返回前一个界面
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfFile:kHeadImagePath];
        UIImage *headImage = [UIImage imageWithData:data];
        _myBlock(headImage);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickLogout:sender{
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"" message:@"您确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithContentsOfFile:kUserPlistPath];
        [userDic setObject:@"Test" forKey:@"userName"];
        [userDic setObject:@"" forKey:@"password"];
        [userDic setObject:@(NO) forKey:@"loginState"];
        [userDic writeToFile:kUserPlistPath atomically:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alerVC addAction:yesAction];
    [alerVC addAction:cancelAction];
    [self presentViewController:alerVC animated:YES completion:nil];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    self.navigationItem.title = @"我";
//    if ([[NSFileManager defaultManager] fileExistsAtPath:kHeadImagePath]) {
//        NSLog(@"存在头像");
//    }else{
//        NSLog(@"不存在头像");
//    }
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"menu_backBlack"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn addTarget:self action:@selector(naviBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarBtn;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSMutableDictionary *meDic = [NSMutableDictionary dictionaryWithContentsOfFile:kMePlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    [[NSOperationQueue new] addOperationWithBlock:^{
        //上传头像,如果存在,则上传
        NSData *imageData = [NSData dataWithContentsOfFile:kHeadImagePath];
        if (imageData) {
            [BmobFile filesUploadBatchWithDataArray:@[@{@"filename": [NSString stringWithFormat:@"%@.png", userName], @"data": imageData}] progressBlock:nil resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //将头像信息存入云端文件库
                    BmobFile *bFile = array.firstObject;
                    [meDic setObject:bFile.url forKey:@"headImageURL"];
                    [meDic writeToFile:kMePlistPath atomically:YES];
                    //将头像信息存入云端UserInfo数据库
                    BmobQuery *userQuery = [BmobQuery queryWithClassName:@"UserInfo"];
                    userQuery.limit = 1;
                    [userQuery whereKey:@"userName" equalTo:userName];
                    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (!error) {
                            BmobObject *userObj = array.firstObject;
                            [userObj setObject:bFile.url forKey:@"headImageURL"];
                            [userObj updateInBackground];
                        } else {
                            NSLog(@"error: %@", error);
                        }
                    }];
                }
            }];
        }
    }];
}
#pragma mark - 懒加载 Lazy Load
- (UIImageView *)topView {
	if(_topView == nil) {
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kTopViewH, kScreenW, kTopViewH)];
        _topView.contentMode = UIViewContentModeScaleAspectFill;
        _topView.image = [UIImage imageNamed:@"BlackBird"];
        //打开imageView的用户交互,因为需要点击button更换头像
        _topView.userInteractionEnabled = YES;
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topView addSubview:_iconBtn];
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(75);
        }];
        _iconBtn.imageView.layer.masksToBounds = YES;
        _iconBtn.imageView.layer.cornerRadius = _iconBtn.frame.size.width/2;
        //如果已经设置过头像,则将其从文件中取出来
        if ([[NSFileManager defaultManager] fileExistsAtPath:kHeadImagePath]) {
            [[NSOperationQueue new] addOperationWithBlock:^{
                NSData *data = [NSData dataWithContentsOfFile:kHeadImagePath];
                UIImage *headImage = [UIImage imageWithData:data];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [_iconBtn setImage:headImage forState:UIControlStateNormal];
                }];
                
            }];
        }else{//否则,使用默认头像
            [_iconBtn setImage:[UIImage imageNamed:@"Persn_login"] forState:UIControlStateNormal];
        }
        
        [_iconBtn addTarget:self action:@selector(changeMyIconIV) forControlEvents:UIControlEventTouchUpInside];
	}
	return _topView;
}

- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.contentInset = UIEdgeInsetsMake(kTopViewH*0.5, 0, 0, 0);
        [_tableView insertSubview:self.topView atIndex:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NormalCell"];
        [_tableView registerClass:[LogoutCell class] forCellReuseIdentifier:@"LogoutCell"];
	}
	return _tableView;
}

- (NSArray *)dataList {
	if(_dataList == nil) {
        _dataList = @[@"个人资料(开发中)", @"我的好友(开发中)", @"修改密码"];
	}
	return _dataList;
}

@end
@implementation LogoutCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self logoutBtn];
    }
    return self;
}
- (UIButton *)logoutBtn{
    if (_logoutBtn == nil) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:_logoutBtn];
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(8);
            make.bottom.right.mas_equalTo(-8);
        }];
        
        _logoutBtn.backgroundColor = [UIColor redColor];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _logoutBtn;
}

@end
