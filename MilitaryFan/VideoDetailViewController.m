//
//  VideoDetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "VideoDetailViewController.h"

#include "MFVideoDetailViewModel.h"
#import "UIScrollView+Refresh.h"
#import <UIKit+AFNetworking.h>

@interface VideoDetailViewController ()
@property (nonatomic) NSString *aid;
@property (nonatomic) MFVideoDetailViewModel *detailVM;
@property (nonatomic) UIWebView *webView;
@end

@implementation VideoDetailViewController

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

@end
