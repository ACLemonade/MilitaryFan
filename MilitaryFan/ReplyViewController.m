//
//  ReplyViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/29.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ReplyViewController.h"
#import "ReplyViewModel.h"

#import "AllCommentsCell.h"
#import "ReplyCell.h"
#import "AnswerView.h"
#import "UIScrollView+Refresh.h"
#import <UIKit+AFNetworking.h>

#define kViewBottomY (kScreenH - STATUSBAR_AND_NAVIGATIONBAR_HEIGHT)

@interface ReplyViewController () <UITableViewDelegate, UITableViewDataSource, AnswerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AnswerView *answerView;
@property (nonatomic, strong) ReplyViewModel *replyVM;
@end

@implementation ReplyViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.replyVM.replyListNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {     //评论详情
        AllCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllCommentsCell class]) forIndexPath:indexPath];
        [cell.iconIV setImageWithURL:self.replyVM.headImageURL placeholderImage:kDefaultBigImage];
        cell.userNameLb.text = self.replyVM.commentName;
        cell.commentLocationLb.text = self.replyVM.commentlocation;
        cell.commentDateLb.text = self.replyVM.commentTime;
        cell.likeNumberLb.text = self.replyVM.likeNumber;
        cell.commentLb.text = self.replyVM.commentContent;
        cell.likeNumberLb.text = self.replyVM.likeNumber;
        [cell.likeBtn addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
        cell.revealReplyBtn.hidden = YES;
        [cell.reportBtn addTarget:self action:@selector(reportComment:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {    //回复详情
        ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReplyCell class]) forIndexPath:indexPath];
        cell.replyNameLb.text = [self.replyVM replyNameForRow:row];
        cell.replyTimeLb.text = [self.replyVM replyTimeForRow:row];
        cell.replyContentLb.text = [self.replyVM replyContentForRow:row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
//    cell.separatorInset = UIEdgeInsetsZero;
//    cell.layoutMargins = UIEdgeInsetsZero;
//    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (void)likeComment:(UIButton *)sender{
    NSLog(@"点赞评论");
    //关闭用户交互,防止在异步获取数据的过程中用户再次点击而引发线程问题
    sender.userInteractionEnabled = NO;
    NSString *commentId = self.replyVM.commentId;
    NSString *commentName = self.replyVM.commentName;
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

- (void)sendReply:(UIButton *)sender{
    NSLog(@"发送回复");
    sender.userInteractionEnabled = NO;
    //向reply表添加记录
    NSString *commentId = self.replyVM.commentId;
    NSString *commentName = self.replyVM.commentName;
    NSString *aid = [[NSDictionary dictionaryWithContentsOfFile:kDetailPlistPath] objectForKey:@"Aid"];
    BmobObject *replyObj = [BmobObject objectWithClassName:@"Reply"];
    [replyObj setObject:kUserName forKey:@"userName"];
    [replyObj setObject:commentId forKey:@"commentId"];
    [replyObj setObject:commentName forKey:@"commentName"];
    [replyObj setObject:aid forKey:@"Aid"];
    [replyObj setObject:self.answerView.contentView.text forKey:@"content"];
    [replyObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //更新Comment表
            BmobObject *commentObj = [BmobObject objectWithoutDataWithClassName:@"Comment" objectId:commentId];
            [commentObj incrementKey:@"replyNumber"];
            [commentObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [Factory textHUDWithVC:self text:@"回复成功"];
                    self.answerView.contentView.text = @"";
                    [self.answerView.contentView resignFirstResponder];
                    [self.tableView beginHeaderRefresh];
                } else {
                    NSLog(@"error: %@", error);
                }
                sender.userInteractionEnabled = YES;
            }];
        } else {
            NSLog(@"error: %@", error);
            sender.userInteractionEnabled = YES;
        }
    }];
}

- (void)reportComment:(UIButton *)sender{
    NSLog(@"举报评论");
}
- (void)keyboardDidChanged:(NSNotification *)sender{
    NSLog(@"%@", sender.userInfo);
    CGRect rect = [[sender.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect frame = self.answerView.frame;
    frame.origin.y = rect.origin.y - frame.size.height - STATUSBAR_AND_NAVIGATIONBAR_HEIGHT;
    self.answerView.frame = frame;
    [self.answerView setNeedsDisplay];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"所有回复(%ld)", self.commentModel.replyNumber];
    [Factory naviClickBackWithViewController:self];
    [self tableView];
    [self answerView];
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
        [weakSelf.replyVM getAllReplyWithCommentId:weakSelf.replyVM.commentId completionHandler:^(NSError *error) {
            if (!error) {
                [weakSelf.tableView reloadData];
                if (weakSelf.commentModel.replyNumber == 0) {
                    [weakSelf.answerView.contentView becomeFirstResponder];
                }
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.tableView endHeaderRefresh];
        }];
    }];
    [weakSelf.tableView beginHeaderRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kViewBottomY - 46) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        //        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.mas_equalTo(0);
        //        }];
//        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
//        _tableView.rowHeight = 65;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AllCommentsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AllCommentsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReplyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReplyCell class])];
    }
    return _tableView;
}
- (AnswerView *)answerView{
    if (_answerView == nil) {
        _answerView = [[AnswerView alloc] initWithFrame:CGRectMake(0, kViewBottomY - 46, kScreenW, 46)];
        [self.view addSubview:_answerView];
        _answerView.delegate = self;
        //        _answerView.backgroundColor = [UIColor whiteColor];
        _answerView.backgroundColor = kRGBA(206, 224, 247, 1.0);
        [_answerView.sendBtn addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerView;
}
- (ReplyViewModel *)replyVM{
    if (_replyVM == nil) {
        _replyVM = [[ReplyViewModel alloc] initWithModel:self.commentModel];
    }
    return _replyVM;
}
@end
