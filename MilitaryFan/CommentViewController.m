//
//  CommentViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "CommentViewController.h"


@interface CommentViewController () <UITextViewDelegate>
@property (nonatomic) UITextView *textView;
@end

@implementation CommentViewController
#pragma mark - 协议方法 UITextViewDelegate

#pragma mark - 方法 Methods
- (void)sendComment{
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    BmobObject *obj = [BmobObject objectWithClassName:@"Comment"];
    [obj setObject:userName forKey:@"userName"];
    [obj setObject:self.aid forKey:@"Aid"];
    [obj setObject:@(self.detailType) forKey:@"Type"];
    [obj setObject:self.textView.text forKey:@"comment"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"发表成功");
        }
    }];
}
- (UIButton *)sendBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 40, 20);
    [btn setTitle:@"发表" forState:UIControlStateNormal];
    [btn setTitleColor:kRGBA(0, 122, 255, 1.0) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"发表文字";
    [Factory naviClickBackWithViewController:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self sendBtn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.textView becomeFirstResponder];
    }
#pragma mark - 懒加载 LazyLoad
- (UITextView *)textView {
	if(_textView == nil) {
        _textView = [[UITextView alloc] init];
        [self.view addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        _textView.delegate = self;
	}
	return _textView;
}

@end
