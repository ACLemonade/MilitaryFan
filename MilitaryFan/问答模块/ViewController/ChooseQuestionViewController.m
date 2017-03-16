//
//  ChooseQuestionViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChooseQuestionViewController.h"
#import "AskQuestionViewController.h"
#import "AnswerQuestionViewController.h"
#import "MyAnswerViewController.h"
#import "MyAskViewController.h"

@interface ChooseQuestionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ChooseQuestionViewController
#pragma mark - 协议方法 UICollectionViewDelegate/DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCell" forIndexPath:indexPath];
    UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    functionBtn.frame = CGRectMake(0, 0, (kScreenW-5*2-5)/2, (kScreenW-5*2-5)/2);
    functionBtn.backgroundColor = [UIColor whiteColor];
    [functionBtn setTitle:[self.dataArray objectAtIndex:row] forState:UIControlStateNormal];
    [functionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    functionBtn.tag = 100+row;
    [functionBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:functionBtn];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}
#pragma mark - 方法 Methods
- (void)clickAction:(UIButton *)sender{
//    sender.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"%@, %@", self.questionActionType == 0 ? @"提问" : @"回答", [self.dataArray objectAtIndex:sender.tag-100]);
    NSInteger index = sender.tag - 100;
    switch (index) {
            //普通问题
        case 0:
            //积分悬赏问题
        case 1:
        {
            if (self.questionActionType == 0) {     //提问功能
                AskQuestionViewController *askQuestionVC = [[AskQuestionViewController alloc] init];
                askQuestionVC.detailType = QuestionDetailTypeNormal + index;
                [self.navigationController pushViewController:askQuestionVC animated:YES];
            } else {    //回答功能
                AnswerQuestionViewController *answerQuestionVC = [[AnswerQuestionViewController alloc] init];
                answerQuestionVC.detailType = QuestionDetailTypeNormal + index;
                [self.navigationController pushViewController:answerQuestionVC animated:YES];
            }
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
            
        default:
            break;
    }
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self collectionView];
    [Factory naviClickBackWithViewController:self];
}
#pragma mark - 懒加载 LazyLoad
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _collectionView.backgroundColor = kRGBA(239, 239, 244, 1.0);
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"NormalCell"];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)collectionViewLayout{
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        //行间距(纵向间距)
        _collectionViewLayout.minimumLineSpacing = 5;
        //列间距(横向间距)
        _collectionViewLayout.minimumInteritemSpacing = 5;
        //每个item大小
        _collectionViewLayout.itemSize = CGSizeMake((kScreenW-5*2-_collectionViewLayout.minimumInteritemSpacing)/2, (kScreenW-5*2-_collectionViewLayout.minimumInteritemSpacing)/2);
        //上下左右内边距
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake((kScreenH-5-_collectionViewLayout.itemSize.width*2)/2, 5, (kScreenH-5-_collectionViewLayout.itemSize.width*2)/2, 5);
        //滚动方向
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _collectionViewLayout;
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = @[@"普通问题", @"积分悬赏", @"我的提问", @"我的回答"];
    }
    return _dataArray;
}
@end
