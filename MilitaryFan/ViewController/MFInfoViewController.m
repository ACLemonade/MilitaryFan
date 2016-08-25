//
//  MFInfoViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFInfoViewController.h"
#import "DetailViewController.h"

#import "TopCell.h"
#import "NormalCell.h"
#import "RankListCell.h"
#import "PicCell.h"

#import <UIKit+AFNetworking.h>
#import "UIScrollView+Refresh.h"
#import "iCarousel.h"


@interface MFInfoViewController () <UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) MFInfoViewModel *infoVM;
/** 头部视图 */
@property (nonatomic) iCarousel *ic;
/** 头部视图页码 */
@property (nonatomic) UIPageControl *pageControl;
/** 头部视图标题 */
@property (nonatomic) UILabel *icTitleLb;
@property (nonatomic) NSTimer *timer;
@end

@implementation MFInfoViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _icTitleLb.text = [self.infoVM topTitleForIndex:carousel.currentItemIndex];
    _pageControl.currentPage = carousel.currentItemIndex;
}
//头部视图个数
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.infoVM.topNumber;
}
//每个头部视图什么样子
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:carousel.frame];
        UIImageView *iv = [UIImageView new];
        [view addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.tag = 1000;
    }
    UIImageView *iv = [view viewWithTag:1000];
    [iv setImageWithURL:[self.infoVM topIconURLForIndex:index]];
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    //循环滚动
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoVM.itemNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger index = [self.infoVM indexOfCellForRow:row];
    switch (index) {
        case 0:
        {
            NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
            [cell.iconIV setImageWithURL:[self.infoVM itemIconURLForRow:row]];
            cell.titleLb.text = [self.infoVM itemTitleForRow:row];
            cell.pubDateLb.text = [self.infoVM itemPubDateForRow:row];
            return cell;
            break;
        }
        case 1:
        {
            RankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankListCell" forIndexPath:indexPath];
            NSArray<NSURL *> *imgArr = [self.infoVM itemIconURLsForRow:row];
            [cell.iconIV_0 setImageWithURL:imgArr[0]];
            [cell.iconIV_1 setImageWithURL:imgArr[1]];
            [cell.iconIV_2 setImageWithURL:imgArr[2]];
            cell.titleLb.text = [self.infoVM itemTitleForRow:row];
            cell.pubDateLb.text = [self.infoVM itemPubDateForRow:row];
            return cell;
            break;
        }
        case 2:
        {
            TopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
            [cell.iconIV setImageWithURL:[self.infoVM itemIconURLForRow:row]];
            cell.titleLb.text = [self.infoVM itemTitleForRow:row];
            cell.authorLb.text = [self.infoVM itemAuthorForRow:row];
            cell.pubDateLb.text = [self.infoVM itemPubDateForRow:row];
            return cell;
            break;
        }
        case 3:
        {
            PicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PicCell" forIndexPath:indexPath];
            NSArray<NSURL *> *imgArr = [self.infoVM itemIconURLsForRow:row];
            [cell.iconIV_0 setImageWithURL:imgArr[0]];
            cell.iconIV_0.layer.cornerRadius = 3;
            [cell.iconIV_1 setImageWithURL:imgArr[1]];
            cell.iconIV_1.layer.cornerRadius = 3;
            [cell.iconIV_2 setImageWithURL:imgArr[2]];
            cell.iconIV_2.layer.cornerRadius = 3;
            cell.titleLb.text = [self.infoVM itemTitleForRow:row];
            cell.pubDateLb.text = [self.infoVM itemPubDateForRow:row];
            return cell;
            break;
        }
        default:
            return [UITableViewCell new];
            break;
    }
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //推荐,推广 103 排行榜 155 制高点 240
    NSInteger index = [self.infoVM indexOfCellForRow:indexPath.row];
    switch (index) {
        case 0:
            return 103;
            break;
        case 1:
            return 155;
            break;
        case 2:
            return 240;
            break;
        case 3:
            return 272;
            break;
        default:
            return 103;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    DetailViewController *dVC = [DetailViewController new];
    dVC.aid = [self.infoVM itemAidForRow:row];
    NSString *category = [self.infoVM itemCategoryForRow:row];
    if ([category isEqualToString:@"图片控"]) {
        dVC.detailType = 2;
    }else{
        dVC.detailType = 1;
    }
    [self.navigationController pushViewController:dVC animated:YES];
}

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
        [weakSelf.infoVM getDataWithMode:RequestRefresh completionHandle:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else{
                [weakSelf topRefresh];
            }
            [weakSelf.tableView endHeaderRefresh];
        }];
    }];
    [self.tableView addAutoFooterRefresh:^{
        [weakSelf.infoVM getDataWithMode:RequestGetMore completionHandle:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else{
                [weakSelf topRefresh];
            }
            [weakSelf.tableView endHeaderRefresh];
        }];
    }];
    [self.tableView beginHeaderRefresh];
}

//界面即将显示的时候,恢复网络请求任务
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.infoVM resumeTask];
}
//界面即将消失的时候,暂停网络请求任务
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.infoVM suspendTask];
}
#pragma mark - 方法 Methods
- (void)topRefresh{
    //刷新tableView
    [_tableView reloadData];
    //停止定时器
    [_timer invalidate];
    //如果存在头部视图,则加到tableView上,否则不加
    if (self.infoVM.isHasTop) {
        _tableView.tableHeaderView = self.ic;
        _pageControl.numberOfPages = self.infoVM.topNumber;
        [_ic reloadData];
        [self carouselCurrentItemIndexDidChange:self.ic];
        //开启定时器
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
            [_ic scrollToItemAtIndex:_ic.currentItemIndex+1 animated:YES];
        } repeats:YES];
    }else{
        _tableView.tableHeaderView = nil;
    }
}

#pragma mark - 懒加载 Lazy Load
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:@"NormalCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"RankListCell" bundle:nil] forCellReuseIdentifier:@"RankListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:nil] forCellReuseIdentifier:@"TopCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PicCell" bundle:nil] forCellReuseIdentifier:@"PicCell"];
        
	}
	return _tableView;
}

- (MFInfoViewModel *)infoVM {
	if(_infoVM == nil) {
        _infoVM = [[MFInfoViewModel alloc] initWithInfoType:self.infoType];
	}
	return _infoVM;
}

- (iCarousel *)ic {
    if(_ic == nil) {
        _ic = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/750*375)];
        _ic.delegate = self;
        _ic.dataSource = self;
        //页码
        _pageControl = [UIPageControl new];
        [_ic addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        //标题
        _icTitleLb = [[UILabel alloc] init];
        [_ic addSubview:_icTitleLb];
        [_icTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_pageControl.mas_top);
        }];
        _icTitleLb.font = [UIFont systemFontOfSize:15];
        
    }
    return _ic;
}

@end
