//
//  CommentViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "CommentViewController.h"
#import "LocationView.h"


@interface CommentViewController () <UITextViewDelegate, CLLocationManagerDelegate>
@property (nonatomic) UITextView *textView;
@property (nonatomic) LocationView *locationView;
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation CommentViewController
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
//发表评论
- (void)sendComment{
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSDictionary *meDic = [NSDictionary dictionaryWithContentsOfFile:kMePlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    NSString *headImageURL = [meDic objectForKey:@"headImageURL"];
    
    BmobObject *obj = [BmobObject objectWithClassName:@"Comment"];
    [obj setObject:userName forKey:@"userName"];
    [obj setObject:self.aid forKey:@"Aid"];
    [obj setObject:@(self.detailType) forKey:@"Type"];
    [obj setObject:self.textView.text forKey:@"comment"];
    [obj setObject:headImageURL forKey:@"headImageURL"];
    [obj setObject:self.locationView.locationLb.text forKey:@"location"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [Factory textHUDWithVC:self text:@"发表成功"];
                [self.navigationController popViewControllerAnimated:YES];
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
    [self locationView];
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

@end
