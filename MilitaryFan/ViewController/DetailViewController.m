//
//  DetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "DetailViewController.h"
#import "MFDetailViewModel.h"

@interface DetailViewController () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) MFDetailViewModel *detailVM;
@end

@implementation DetailViewController
#pragma mark - 协议方法 UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error: %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.detailVM getDataWithMode:RequestRefresh completionHandle:^(NSError *error) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.detailVM.linkURL]];
    }];
    
    
    
}
#pragma mark - 懒加载 Lazy Load

- (UIWebView *)webView {
	if(_webView == nil) {
		_webView = [[UIWebView alloc] init];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
	}
    return _webView;
}

- (MFDetailViewModel *)detailVM {
	if(_detailVM == nil) {
        _detailVM = [[MFDetailViewModel alloc] initWithAid:self.aid detailType:self.detailType];
	}
	return _detailVM;
}

@end
