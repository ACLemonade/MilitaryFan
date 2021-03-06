//
//  AnswerQuestionDetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/10.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AnswerQuestionDetailViewController.h"
#import "QuestionDetailCell.h"
#import "AnswerCell.h"
#import "AnswerQuestionDetailViewModel.h"

#import "AnswerView.h"

#import "UIScrollView+Refresh.h"
@import CoreLocation;

#define kViewBottomY (kScreenH - STATUSBAR_AND_NAVIGATIONBAR_HEIGHT)
@interface AnswerQuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, AnswerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AnswerView *answerView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) AnswerQuestionDetailViewModel *aqDetailVM;
@end

@implementation AnswerQuestionDetailViewController
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
            NSString *location = [NSString stringWithFormat:@"%@%@", administrativeArea, locality];
            
            [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
                //将位置信息存入用户plist文件
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithContentsOfFile:kUserPlistPath];
                [userDic setObject:location forKey:@"location"];
                [userDic writeToFile:kUserPlistPath atomically:YES];
            }];
        }
    }];
}

#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.aqDetailVM.allAnswerNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        QuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionDetailCell class]) forIndexPath:indexPath];
        [cell.headIV setImageWithURL:self.aqDetailVM.headImageURL placeholderImage:kDefaultHeadImage];
        cell.askNameLb.text = self.aqDetailVM.askName;
        cell.contentLb.text = self.aqDetailVM.questionContent;
        cell.createTimeLb.text = self.aqDetailVM.createTime;
        cell.resolvedStateLb.hidden = !self.aqDetailVM.questionResolvedState;
        return cell;
    } else {
        AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerCell class]) forIndexPath:indexPath];
        [cell.headIV setImageWithURL:[self.aqDetailVM answerHeadImageURLForRow:row] placeholderImage:kDefaultHeadImage];
        cell.answerNameLb.text = [self.aqDetailVM answerNameForRow:row];
        cell.answerContentLb.text = [self.aqDetailVM answerContentForRow:row];
        cell.locationLb.text = [self.aqDetailVM answerLocationForRow:row];
        [cell.adoptBtn addTarget:self action:@selector(adoptAnswer:) forControlEvents:UIControlEventTouchUpInside];
        cell.adoptBtn.tag = 1000 + row;
        cell.adoptBtn.hidden = [self.aqDetailVM adoptionHiddenStateForRow:row];
        cell.adoptBtn.enabled = [self.aqDetailVM adoptionEnabledStateForRow:row];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark - 协议方法 AnswerViewDelegate
- (void)answerView:(AnswerView *)answerView contentViewDidChanged:(UITextView *)contentView{
    NSLog(@"frame: %@", NSStringFromCGRect(self.answerView.frame));
    
    CGSize size = contentView.contentSize;
    CGRect frame = answerView.frame;
    if (size.height > 112) {
        return;
    }
    frame.origin.y = CGRectGetMaxY(frame) - (size.height + 10);
    frame.size.height = size.height + 10;
    [UIView animateWithDuration:0.25 animations:^{
        self.answerView.frame = frame;
        NSLog(@"frame: %@", NSStringFromCGRect(self.answerView.frame));
        [self.answerView layoutIfNeeded];
    }];
}
#pragma mark - 方法 Methods
- (void)adoptAnswer:(UIButton *)sender{
    //关闭交互,避免线程问题
    sender.userInteractionEnabled = NO;
    NSInteger row = sender.tag - 1000;
    NSString *answerName = [self.aqDetailVM answerNameForRow:row];
    NSString *askName = self.aqDetailVM.askName;
    if ([answerName isEqualToString:askName]) {
        [Factory showAlertViewInViewController:self withTitle:@"提示" message:@"自问自答将无法获得积分,您确定要继续采纳吗?" yesActionHander:^(UIAlertAction *yesAction) {
            sender.enabled = NO;
            NSString *answerObjectId = [self.aqDetailVM answerObjectIdForRow:row];
            //更新Answer表
            BmobObject *answerObj = [BmobObject objectWithoutDataWithClassName:@"Answer" objectId:answerObjectId];
            [answerObj setObject:@1 forKey:@"adoptionState"];
            [answerObj updateInBackground];
            //更新Question表
            NSString *questionObjectId = self.aqDetailVM.questionObjectId;
            BmobObject *questionObj = [BmobObject objectWithoutDataWithClassName:@"Question" objectId:questionObjectId];
            [questionObj setObject:answerName forKey:@"answerName"];
            [questionObj setObject:@YES forKey:@"resolvedState"];
            [questionObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (!error) {
                    [Factory textHUDWithVC:self text:@"已采纳回答"];
                    [self.aqDetailVM getQuestionDetailWithObjectId:self.objectId completionHandle:^(NSError *error) {
                        if (!error) {
                            [self.tableView reloadData];
                        } else {
                            NSLog(@"error: %@", error);
                        }
                    }];
                    
                    [self.aqDetailVM getAllAnswerWithAskId:self.objectId completionHandle:^(NSError *error) {
                        if (!error) {
                            [self.tableView reloadData];
                        } else {
                            NSLog(@"error: %@", error);
                        }
                    }];
                } else {
                    NSLog(@"error: %@", error);
                    [Factory textHUDWithVC:self text:@"操作失败"];
                }
            }];
        } cancelActionHander:^(UIAlertAction *cancelAction) {
            //重新交互
            sender.userInteractionEnabled = YES;
            
        } completionHandler:^{
            ;
        }];
    } else {
        sender.enabled = NO;
        NSString *answerObjectId = [self.aqDetailVM answerObjectIdForRow:row];
        //更新Reward表
        BmobQuery *rewardQuery = [BmobQuery queryWithClassName:@"Reward"];
        rewardQuery.limit = 1;
        [rewardQuery whereKey:@"userName" equalTo:answerName];
        [rewardQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (!error) {
                BmobObject *rewardObj = array.firstObject;
                [rewardObj incrementKey:@"rewardScore" byNumber:@(self.aqDetailVM.rewardScore)];
                [rewardObj updateInBackground];
            } else {
                NSLog(@"error: %@", error);
            }
        }];
        //更新Answer表
        BmobObject *answerObj = [BmobObject objectWithoutDataWithClassName:@"Answer" objectId:answerObjectId];
        [answerObj setObject:@1 forKey:@"adoptionState"];
        [answerObj updateInBackground];
        //更新Question表
        NSString *questionObjectId = self.aqDetailVM.questionObjectId;
        BmobObject *questionObj = [BmobObject objectWithoutDataWithClassName:@"Question" objectId:questionObjectId];
        [questionObj setObject:answerName forKey:@"answerName"];
        [questionObj setObject:@YES forKey:@"resolvedState"];
        [questionObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (!error) {
                [Factory textHUDWithVC:self text:@"已采纳回答"];
                [self.aqDetailVM getQuestionDetailWithObjectId:self.objectId completionHandle:^(NSError *error) {
                    if (!error) {
                        [self.tableView reloadData];
                    } else {
                        NSLog(@"error: %@", error);
                    }
                }];
                
                [self.aqDetailVM getAllAnswerWithAskId:self.objectId completionHandle:^(NSError *error) {
                    if (!error) {
                        [self.tableView reloadData];
                    } else {
                        NSLog(@"error: %@", error);
                    }
                }];
            } else {
                NSLog(@"error: %@", error);
                [Factory textHUDWithVC:self text:@"操作失败"];
            }
        }];
    }
}
- (void)keyboardDidChanged:(NSNotification *)sender{
    NSLog(@"%@", sender.userInfo);
    CGRect rect = [[sender.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect frame = self.answerView.frame;
    frame.origin.y = rect.origin.y - frame.size.height - STATUSBAR_AND_NAVIGATIONBAR_HEIGHT;
    self.answerView.frame = frame;
    [self.answerView setNeedsDisplay];
}
- (void)sendAnswer:(UIButton *)sender{
    sender.enabled = NO;
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    NSString *location = [userDic objectForKey:@"location"];
    BmobObject *obj = [BmobObject objectWithClassName:@"Answer"];
    [obj setObject:userName forKey:@"answerName"];
    [obj setObject:location forKey:@"location"];
    [obj setObject:self.objectId forKey:@"askId"];
    [obj setObject:self.aqDetailVM.askName forKey:@"askName"];
    [obj setObject:@(self.aqDetailVM.questionType) forKey:@"Type"];
    [obj setObject:self.answerView.contentView.text forKey:@"content"];
    [obj setObject:@0 forKey:@"adoptionState"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        sender.enabled = YES;
        if (isSuccessful) {
            NSLog(@"回答成功");
            [Factory textHUDWithVC:self text:@"回答成功"];
            [self.view endEditing:YES];
            self.answerView.contentView.text = @"";
            BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"Question" objectId:self.objectId];
            [obj incrementKey:@"answerNumber"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (!error) {
                    [self.aqDetailVM getQuestionDetailWithObjectId:self.objectId completionHandle:^(NSError *error) {
                        if (!error) {
                            [self.tableView reloadData];
                        } else {
                            NSLog(@"error: %@", error);
                        }
                    }];
                    
                    [self.aqDetailVM getAllAnswerWithAskId:self.objectId completionHandle:^(NSError *error) {
                        if (!error) {
                            [self.tableView reloadData];
                        } else {
                            NSLog(@"error: %@", error);
                        }
                    }];
                } else {
                    NSLog(@"error: %@", error);
                    [Factory textHUDWithVC:self text:@"操作失败"];
                }
            }];
        } else {
            NSLog(@"error: %@", error);
            [Factory textHUDWithVC:self text:@"操作失败"];
        }
    }];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [Factory naviClickBackWithViewController:self];
    [self tableView];
    [self.locationManager startUpdatingLocation];
//    NSLog(@"viewFrame: %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"frame: %@", NSStringFromCGRect(self.answerView.frame));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.aqDetailVM getQuestionDetailWithObjectId:self.objectId completionHandle:^(NSError *error) {
        if (!error) {
            if (!self.aqDetailVM.questionResolvedState) {
                [self.view addSubview:self.answerView];
            } else {
                self.tableView.frame = CGRectMake(0, 0, kScreenW, self.view.frame.size.height);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"error: %@", error);
        }
    }];

    [self.aqDetailVM getAllAnswerWithAskId:self.objectId completionHandle:^(NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kViewBottomY - 46) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(0);
//        }];
        _tableView.estimatedRowHeight = 145;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionDetailCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnswerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnswerCell class])];
    }
    return _tableView;
}
- (AnswerView *)answerView{
    if (_answerView == nil) {
        _answerView = [[AnswerView alloc] initWithFrame:CGRectMake(0, kViewBottomY - 46, kScreenW, 46)];
//        [self.view addSubview:_answerView];
        _answerView.delegate = self;
//        _answerView.backgroundColor = [UIColor whiteColor];
        _answerView.backgroundColor = kRGBA(206, 224, 247, 1.0);
        [_answerView.sendBtn addTarget:self action:@selector(sendAnswer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerView;
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
- (AnswerQuestionDetailViewModel *)aqDetailVM{
    if (_aqDetailVM == nil) {
        _aqDetailVM = [[AnswerQuestionDetailViewModel alloc] init];
    }
    return _aqDetailVM;
}
@end
