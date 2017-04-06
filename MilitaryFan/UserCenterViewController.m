//
//  UserCenterViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/31.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "UserCenterViewController.h"

#import "MyDetailInfoViewController.h"
#import "CollectionViewController.h"
#import "MyAskViewController.h"
#import "MyAnswerViewController.h"
#import "ModifyPasswordViewController.h"

#import "UserCenterHeadView.h"

#import "AppDelegate.h"

#define kHeadViewH 285
@interface UserCenterViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic, strong) UserCenterHeadView *headView;
@property (nonatomic) NSArray *titleList;
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
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
        //小箭头
        cell.accessoryType = 1;
        cell.textLabel.text = [self.titleList objectAtIndex:indexPath.row];
        //加一条分割线
        UIView *lineView = [[UIView alloc] init];
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.height.equalTo(0.5);
        }];
        lineView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
        
        return cell;
    }else{
        LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell"];
        [cell.logoutBtn addTarget:self action:@selector(clickLogout:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect headViewFrame = self.headView.frame;
    CGFloat newY = offsetY + 20;
    CGFloat newHeight =  -20 - offsetY + kHeadViewH;
    //    //修改头部视图frame
    headViewFrame.origin.y = newY;
    headViewFrame.size.height = newHeight;
    self.headView.frame = headViewFrame;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //左侧分割线留白
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
//        if (indexPath.row < 2) {
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.textLabel.textColor = [UIColor grayColor];
//        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        switch (row) {
                //我的资料
            case 0:
            {
                MyDetailInfoViewController *myDetailInfoVC = [[MyDetailInfoViewController alloc] init];
                [self.navigationController pushViewController:myDetailInfoVC animated:YES];
            }
                break;
                //我的收藏
            case 1:
            {
                CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
                break;
                //我的提问
            case 2:
            {
                MyAskViewController *myAskVC = [[MyAskViewController alloc] init];
                [self.navigationController pushViewController:myAskVC animated:YES];
            }
                break;
                //我的回答
            case 3:
            {
                MyAnswerViewController *myAnswerVC = [[MyAnswerViewController alloc] init];
                [self.navigationController pushViewController:myAnswerVC animated:YES];
            }
                break;
                //修改密码
            case 4:
            {
                ModifyPasswordViewController *pwdVC = [[UIStoryboard storyboardWithName:@"UserCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
                [self.navigationController pushViewController:pwdVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 50;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kHeadViewH;
    }
    return 0.01;
}
#pragma mark - 协议方法 UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = info[UIImagePickerControllerEditedImage];
    //关闭自动渲染
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置头像
    [self.headView.iconBtn setImage:image forState:UIControlStateNormal];
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
- (UserCenterHeadView *)headView{
    if (_headView == nil) {
        _headView = [[UserCenterHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kHeadViewH)];
        //如果已经设置过头像,则将其从文件中取出来
        if ([[NSFileManager defaultManager] fileExistsAtPath:kHeadImagePath]) {
            [[NSOperationQueue new] addOperationWithBlock:^{
                NSData *data = [NSData dataWithContentsOfFile:kHeadImagePath];
                UIImage *headImage = [UIImage imageWithData:data];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [_headView.iconBtn setImage:headImage forState:UIControlStateNormal];
                }];
            }];
        }else{//否则,使用默认头像
            [_headView.iconBtn setImage:[UIImage imageNamed:@"Persn_login"] forState:UIControlStateNormal];
        }
        [_headView.iconBtn addTarget:self action:@selector(changeMyIconIV) forControlEvents:UIControlEventTouchUpInside];
        [_headView.naviBackBtn addTarget:self action:@selector(naviBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(-20);
            make.left.bottom.right.equalTo(0);
        }];
        [_tableView insertSubview:self.headView atIndex:0];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NormalCell"];
        [_tableView registerClass:[LogoutCell class] forCellReuseIdentifier:@"LogoutCell"];
	}
	return _tableView;
}

- (NSArray *)titleList {
	if(_titleList == nil) {
        _titleList = @[@"我的资料", @"我的收藏", @"我的提问", @"我的回答", @"修改密码"];
	}
	return _titleList;
}

@end
@implementation LogoutCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
        [self logoutBtn];
    }
    return self;
}
- (UIButton *)logoutBtn{
    if (_logoutBtn == nil) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:_logoutBtn];
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
        }];
        
        _logoutBtn.backgroundColor = [UIColor redColor];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 5;
    }
    return _logoutBtn;
}

@end
