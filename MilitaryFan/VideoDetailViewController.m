//
//  VideoDetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "MFVideoDetailViewModel.h"
#import "UIScrollView+Refresh.h"
#import <UIKit+AFNetworking.h>

@interface VideoDetailViewController ()
@property (nonatomic) NSString *aid;
@property (nonatomic) MFVideoDetailViewModel *detailVM;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) UIBarButtonItem *collectionBtn;
@end

@implementation VideoDetailViewController
#pragma mark - 方法 Methods
- (void)collectVideo:(UIButton *)sender{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
//    NSLog(@"%@", kDocPath);
    [queue inDatabase:^(FMDatabase *db) {
        NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
        if (resultCount) {
            BOOL success = [db executeUpdate:@"delete from Collection where Aid = ?", self.aid];
            if (success) {
                NSLog(@"取消收藏成功");
                [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
            }
        }else{
            BOOL success = [db executeUpdate:@"insert into Collection (Name, Aid, Type, Image, Title, PubDate) values (?,?,?,?,?,?)", @"Test", self.aid, @18, self.detailVM.image, self.detailVM.title, self.detailVM.pubDate];
            if (success) {
                NSLog(@"收藏成功");
                [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }
        }
    }];

}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.detailVM getDataWithMode:0 completionHandle:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else{
                [self webView];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    [Factory naviClickBackWithViewController:self];
    self.navigationItem.rightBarButtonItem = self.collectionBtn;
}
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    NSAssert(NO, @"必须使用initWithAid方法初始化, %s", __func__);
    return nil;
}
- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
}

- (MFVideoDetailViewModel *)detailVM {
	if(_detailVM == nil) {
        _detailVM = [[MFVideoDetailViewModel alloc] initWithAid:self.aid];
	}
	return _detailVM;
}



- (UIWebView *)webView {
	if(_webView == nil) {
		_webView = [[UIWebView alloc] init];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailVM.link]]];
        
	}
	return _webView;
}

- (UIBarButtonItem *)collectionBtn {
	if(_collectionBtn == nil) {
        UIButton *colBtn = [UIButton buttonWithType:UIButtonTypeCustom]
        ;
        colBtn.bounds = CGRectMake(0, 0, 24, 24);
        //点击收藏
        [colBtn addTarget:self action:@selector(collectVideo:) forControlEvents:UIControlEventTouchUpInside];
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
        [queue inDatabase:^(FMDatabase *db) {
            NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
            if (resultCount) {
                //已被收藏的显示黄星星✨
                [colBtn setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }else{
                //没被收藏的显示灰星星
                [colBtn setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
            }
        }];
        _collectionBtn = [[UIBarButtonItem alloc] initWithCustomView:colBtn];
	}
	return _collectionBtn;
}

@end
