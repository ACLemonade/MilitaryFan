//
//  AllCommentsViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsViewController.h"
#import "AllCommentsCell.h"

#import "AllCommentsViewModel.h"
#import "UIScrollView+Refresh.h"
#import <UIKit+AFNetworking.h>
@interface AllCommentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) AllCommentsViewModel *allCommentsVM;
@end

@implementation AllCommentsViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCommentsVM.commentNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    AllCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCommentsCell"];
    [cell.iconIV setImageWithURL:[self.allCommentsVM iconURLForRow:row] placeholderImage:kDefaultHeadImage];
    cell.userNameLb.text = [self.allCommentsVM userNameForRow:row];
    cell.commentLb.text = [self.allCommentsVM commentForRow:row];
    cell.commentDateLb.text = [self.allCommentsVM createDateForRow:row];
    cell.commentLocationLb.text = [self.allCommentsVM userLocationForRow:row];
    cell.likeNumberLb.text = [self.allCommentsVM likeNumberForRow:row];
    cell.likeBtn.tag = 1000 + row;
    [cell.likeBtn addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.replyBtn addTarget:self action:@selector(replyComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reportBtn addTarget:self action:@selector(reportComment:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark - 方法 Methods
- (void)likeComment:(UIButton *)sender{
    NSLog(@"点赞评论");
    //关闭用户交互,防止在异步获取数据的过程中用户再次点击而引发线程问题
    sender.userInteractionEnabled = NO;
    NSInteger row = sender.tag - 1000;
    NSString *commentId = [self.allCommentsVM commentIdForRow:row];
    NSString *commentName = [self.allCommentsVM userNameForRow:row];
    BmobQuery *likeStateQuery = [BmobQuery queryWithClassName:@"CommentLike"];
    [likeStateQuery whereKey:@"userName" equalTo:kUserName];
    [likeStateQuery whereKey:@"commentId" equalTo:commentId];
    [likeStateQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number) {
                [Factory textHUDWithVC:self text:@"您已点过赞"];
                    sender.userInteractionEnabled = YES;
            } else {
                //CommentLike表新增记录
                BmobObject *obj = [BmobObject objectWithClassName:@"CommentLike"];
                [obj setObject:kUserName forKey:@"userName"];
                [obj setObject:commentId forKey:@"commentId"];
                [obj setObject:commentName forKey:@"commentName"];
                [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //更新Comment表
                        BmobObject *commentObj = [BmobObject objectWithoutDataWithClassName:@"Comment" objectId:commentId];
                        [commentObj incrementKey:@"likeNumber"];
                        [commentObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                [Factory textHUDWithVC:self text:@"点赞成功"];
                            }
                            if (error) {
                                NSLog(@"error: %@", error);
                            }
                            sender.userInteractionEnabled = YES;
                        }];
                    }
                    if (error) {
                        NSLog(@"error: %@", error);
                        sender.userInteractionEnabled = YES;
                    }
                }];
            }
        } else {
            NSLog(@"error: %@", error);
            sender.userInteractionEnabled = YES;
        }
    }];
}
- (void)replyComment:(UIButton *)sender{
    NSLog(@"回复评论");
}
- (void)reportComment:(UIButton *)sender{
    NSLog(@"举报评论");
}
#pragma mark - 生命周期 LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Factory naviClickBackWithViewController:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所有评论";
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
//        [weakSelf.allCommentsVM commentUpdateWithComplationHandle:^(NSArray *array) {
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView endHeaderRefresh];
//        }];
        [weakSelf.allCommentsVM getAllCommentWithCompletionHandler:^(NSError *error) {
            if (!error) {
                [weakSelf.tableView reloadData];
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.tableView endHeaderRefresh];
        }];
//        [weakSelf.tableView endHeaderRefresh];
    }];
    [self.tableView beginHeaderRefresh];
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.rowHeight = 150;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"AllCommentsCell" bundle:nil] forCellReuseIdentifier:@"AllCommentsCell"];
	}
	return _tableView;
}
- (AllCommentsViewModel *)allCommentsVM {
	if(_allCommentsVM == nil) {
		_allCommentsVM = [[AllCommentsViewModel alloc] init];
	}
	return _allCommentsVM;
}
@end
