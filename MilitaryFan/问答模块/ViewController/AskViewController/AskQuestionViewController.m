//
//  AskQuestionViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/7.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "LocationView.h"
#import "RewardView.h"

@import CoreLocation;

@interface AskQuestionViewController () <UITextViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) LocationView *locationView;
@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) RewardView *rewardView;
@end

@implementation AskQuestionViewController
#pragma mark - 协议方法 CLLocationManager Delegate
//定位成功以后,返回位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //    NSLog(@"location %@", locations);
    //地理反编码 经纬度-->位置
    CLLocation *myLocation = locations.firstObject;
    CLGeocoder *coder = [CLGeocoder new];
    [coder reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
        if (!mark) {
            return;
        }else{
            //            NSLog(@"%@", mark.addressDictionary);
            //市
            NSString *locality = mark.locality;
            //省
            NSString *administrativeArea = mark.administrativeArea;
            _locationView.locationLb.text = [NSString stringWithFormat:@"%@ %@", administrativeArea, locality];
        }
    }];
}
#pragma mark - 协议方法 UITextViewDelegate

#pragma mark - 方法 Methods
//发表问题
- (void)askQuestion:(UIButton *)sender{
    sender.enabled = NO;
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
//    NSDictionary *meDic = [NSDictionary dictionaryWithContentsOfFile:kMePlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
//    NSString *headImageURL = [meDic objectForKey:@"headImageURL"];
    
    BmobObject *obj = [BmobObject objectWithClassName:@"Question"];
    [obj setObject:userName forKey:@"askName"];
    //字段保留,暂无用处
    [obj setObject:@"" forKey:@"Aid"];
    [obj setObject:@(self.detailType) forKey:@"Type"];
//    [obj setObject:headImageURL forKey:@"headImageURL"];
    [obj setObject:self.locationView.locationLb.text forKey:@"location"];
    [obj setObject:self.textView.text forKey:@"question"];
    [obj setObject:@(NO) forKey:@"resolvedState"];
    [obj setObject:@"" forKey:@"answerName"];
    [obj setObject:@0 forKey:@"answerNumber"];
    if (self.detailType - 10) {
        [obj setObject:@(self.rewardView.rewardTF.text.integerValue) forKey:@"rewardScore"];
    } else {
        [obj setObject:@0 forKey:@"rewardScore"];
    }
    
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [Factory textHUDWithVC:self text:@"发表成功"];
            
            //                NSLog(@"%@", [NSThread currentThread]);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        sender.enabled = YES;
    }];
}
- (UIButton *)sendBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 40, 20);
    [btn setTitle:@"发表" forState:UIControlStateNormal];
    [btn setTitleColor:kRGBA(0, 122, 255, 1.0) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(askQuestion:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
//选择积分数值
- (void)chooseRewardScore:(UIButton *)sender{
    NSInteger score = [self.rewardView.rewardTF.text integerValue];
    if (sender.tag - 10) {  //加
        if (score == 10) {
            return;
        }
        score++;
            } else {    //减
        if (score == 1) {
            return;
        }
        score--;
    }
    self.rewardView.rewardTF.text = @(score).stringValue;
    [self.rewardView.rewardTF setNeedsLayout];
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
    self.view.backgroundColor = kRGBA(239, 239, 244, 1.0);
    [self.textView becomeFirstResponder];
    [self locationView];
    //积分问题才会显示
    if (self.detailType - 10) {
        [self rewardView];
    }
    //开始定位
    [self.locationManager startUpdatingLocation];
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
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.delegate = self;
    }
    return _textView;
}
- (LocationView *)locationView {
    if(_locationView == nil) {
        _locationView = [[LocationView alloc] init];
        [self.view addSubview:_locationView];
        [_locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView.mas_bottom).mas_equalTo(1);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        _locationView.backgroundColor = [UIColor whiteColor];
        
    }
    return _locationView;
}
- (CLLocationManager *)locationManager {
    if(_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //前台定位
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}
- (RewardView *)rewardView{
    if (_rewardView == nil) {
        _rewardView = [[RewardView alloc] init];
        [self.view addSubview:_rewardView];
        [_rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.locationView.mas_bottom).equalTo(1);
            make.left.right.equalTo(0);
            make.height.equalTo(40);
        }];
        [_rewardView.minusBtn addTarget:self action:@selector(chooseRewardScore:) forControlEvents:UIControlEventTouchUpInside];
        [_rewardView.plusBtn addTarget:self action:@selector(chooseRewardScore:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rewardView;
}
@end
