//
//  ChooseQuestionViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChooseQuestionViewController.h"

@interface ChooseQuestionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation ChooseQuestionViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 懒加载 LazyLoad
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)collectionViewLayout{
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _collectionViewLayout;
}
@end
