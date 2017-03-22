//
//  DetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentViewController.h"
#import "AllCommentsViewController.h"

#import "MFDetailViewModel.h"
#import "DetailLikeCell.h"
#import "DetailHeaderCell.h"
#import <UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import <UIControl+BlocksKit.h>
#import "UIScrollView+Refresh.h"

#import "FunctionView.h"

@interface DetailContentCell : UITableViewCell
/** 文本 */
@property (nonatomic, strong) UILabel *contentLb;
/** 图片 */
@property (nonatomic, strong) UIImageView *picIV;
@end


@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableview;
@property (nonatomic) MFDetailViewModel *detailVM;
@property (nonatomic) CGFloat contentCellHeight;
@property (nonatomic) FunctionView *funcView;
@property (nonatomic) FMDatabase *dataBase;

/** 内容高度数组 */
@property (nonatomic, strong) NSArray<NSString *> *contentArray;
/** 图片高度数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *picsArray;

@end

@implementation DetailViewController
#pragma mark - 协议方法 UItableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.detailVM.content.count + self.detailVM.pics.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            DetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailHeaderCell" forIndexPath:indexPath];
            cell.titleLb.text = self.detailVM.title;
            cell.pubDateLb.text = self.detailVM.pubDate;
            cell.authorLb.text = self.detailVM.author;
            cell.clickLb.text = self.detailVM.click;
            return cell;
        }
            break;
            
        case 1:
        {

            DetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"DetailContentCell"]];
            if (row % 2 == 0) {     //文本
                [cell.picIV removeFromSuperview];
                NSString *content = [self.detailVM.content objectAtIndex:row/2];
                CGFloat height = [[self.contentArray objectAtIndex:row/2] floatValue];
                cell.contentLb.frame = CGRectMake(8, 8, kScreenW-16, height);
                NSDictionary *attributeDic = [[self attributesDictionaryArrayForContentArray:self.detailVM.content] objectAtIndex:row/2];
                cell.contentLb.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributeDic];
                [cell.contentView addSubview:cell.contentLb];
                return cell;
            } else {    //图片
                [cell.contentLb removeFromSuperview];
                __block __weak __typeof(&*cell.picIV)weakIV = cell.picIV;
                __block __weak __typeof(&*cell)weakCell = cell;
                __block CGFloat height = [[self.picsArray objectAtIndex:(row-1)/2] floatValue];
                cell.picIV.frame = CGRectMake(8, 8, kScreenW-16, height);
                [cell.picIV setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.detailVM.pics objectAtIndex:(row-1)/2]]] placeholderImage:kDefaultBigImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                    weakIV.image = image;
                    height = (kScreenW-16)*image.size.height/image.size.width;
                    [self.picsArray replaceObjectAtIndex:(row-1)/2 withObject:[@(height) stringValue]];
                    
//                    weakIV.frame = CGRectMake(8, 8, kScreenW-16, height);
//                    [tableView beginUpdates];
//                    [tableView endUpdates];
//                    [self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
//                    [self performSelector:@selector(tableView:heightForRowAtIndexPath:) withObject:tableView withObject:indexPath];
//                    [weakIV setNeedsDisplay];
//                    self.tableview.rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
//                    [weakCell setNeedsLayout];
//                    [weakCell layoutIfNeeded];
//                    NSLog(@"currentThread: %@", [NSThread currentThread]);
                } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                    NSLog(@"error: %@", error);
                }];
                [cell.contentView addSubview:cell.picIV];
                return cell;
            }
        }
            break;
        //点赞cell
        case 2:
        {
            DetailLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLikeCell" forIndexPath:indexPath];
            NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
            NSString *userName = [userDic objectForKey:@"userName"];
            __block NSInteger likeNumber;
            __block NSInteger unlikeNumber;
            //总点赞数
            [self clickLikeWithCompletionHandle:^(int number) {
//                NSLog(@"thread: %@", [NSThread currentThread]);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cell.likeLb.text = [NSString stringWithFormat:@"%d", number];
                    likeNumber = number;
                }];
            }];
            //总踩数
            BmobQuery *unlikeQuery = [BmobQuery queryWithClassName:@"Like"];
            [unlikeQuery addTheConstraintByAndOperationWithArray:@[@{@"Aid": self.aid}, @{@"likeState": @2}]];
            [unlikeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                cell.unlikeLb.text = [NSString stringWithFormat:@"%d", number];
                unlikeNumber = number;
            }];
            __block NSInteger myLikeNumber = 0;
            //查询当前aid并且点赞状态为1数据
            BmobQuery *myLikeQuery = [BmobQuery queryWithClassName:@"Like"];
            [myLikeQuery addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @1}]];
            [myLikeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                myLikeNumber = number;
            }];
            __block NSInteger myUnlikeNumber = 0;
            //查询当前aid并且踩状态为2数据
            BmobQuery *myUnlikeQuery = [BmobQuery queryWithClassName:@"Like"];
            [myUnlikeQuery addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @2}]];
            [myUnlikeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                myUnlikeNumber = number;
            }];
            //------- 点赞/取消点赞 --------//
            [cell.likeBtn bk_addEventHandler:^(id sender) {

                if (myUnlikeNumber) {
                    [Factory textHUDWithVC:self text:@"已经踩过,不能点赞"];
                }else{
                    cell.likeBtn.enabled = NO;
                    if (myLikeNumber) {
                        //取消点赞
                        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
                        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @1}]];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.firstObject) {
                                BmobObject *obj = array.firstObject;
                                [obj setObject:@0 forKey:@"likeState"];
                                [obj updateInBackground];
                                [Factory textHUDWithVC:self text:@"取消点赞"];
                                likeNumber--;
                                myLikeNumber--;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.likeBtn.enabled = YES;
                                    cell.likeLb.text = [NSString stringWithFormat:@"%ld", (long)likeNumber];
                                }];
                            }
                        }];
                        
                    }else{
                        //点赞
                        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
                        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @0}]];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.firstObject) {
                                BmobObject *obj = array.firstObject;
                                [obj setObject:@1 forKey:@"likeState"];
                                //异步更新数据
                                [obj updateInBackground];
                                [Factory textHUDWithVC:self text:@"点赞成功"];
                                likeNumber++;
                                myLikeNumber++;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.likeBtn.enabled = YES;
                                    cell.likeLb.text = [NSString stringWithFormat:@"%ld", (long)likeNumber];
                                }];
                                
                                
                            }
                        }];
                        
                    }

                }
            } forControlEvents:UIControlEventTouchUpInside];
            //------- 踩/取消踩 --------//
            [cell.unlikeBtn bk_addEventHandler:^(id sender) {
                if (myLikeNumber) {
                    [Factory textHUDWithVC:self text:@"已经赞过,不能踩"];
                }else{
                    cell.unlikeBtn.enabled = NO;
                    //取消踩
                    if (myUnlikeNumber) {
                        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
                        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @2}]];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.firstObject) {
                                BmobObject *obj = array.firstObject;
                                [obj setObject:@0 forKey:@"likeState"];
                                [obj updateInBackground];
                                [Factory textHUDWithVC:self text:@"取消踩"];
                                myUnlikeNumber--;
                                unlikeNumber--;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.unlikeBtn.enabled = YES;
                                    cell.unlikeLb.text = [NSString stringWithFormat:@"%ld", (long)unlikeNumber];
                                }];
                                
                                
                            }
                        }];
                    }else{
                        //踩
                        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
                        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @0}]];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.firstObject) {
                                BmobObject *obj = array.firstObject;
                                [obj setObject:@2 forKey:@"likeState"];
                                //异步更新数据
                                [obj updateInBackground];
                                [Factory textHUDWithVC:self text:@"踩成功"];
                                myUnlikeNumber++;
                                unlikeNumber++;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.unlikeBtn.enabled = YES;
                                    cell.unlikeLb.text = [NSString stringWithFormat:@"%ld", (long)unlikeNumber];
                                }];
                                
                            }
                        }];
                        
                    }

                }
            } forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
            return 131;
            break;
        case 1:
        {
            if (row % 2 == 0) {     //文本
                CGFloat height = [[self.contentArray objectAtIndex:row/2] floatValue]+16;
                return height;
            }else {     //图片
                CGFloat height = [[self.picsArray objectAtIndex:(row-1)/2] floatValue]+16;
                return height;
            }
            break;
        }
        case 2:
            return 78;
            break;
        default:
            return 100;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark - 方法 Methods
/** 根据文本数组获取高度数组 */
- (NSArray *)heightArrayForContentArray:(NSArray<NSString *> *)contentArray{
    NSMutableArray *heightArray = [NSMutableArray array];
    for (NSString *content in contentArray) {
        CGFloat height = [Factory heightWithContent:content font:[UIFont systemFontOfSize:16] width:kScreenW-16];
        [heightArray addObject:@(height)];
    }
    return heightArray;
}
/** 根据文本数组获得属性字典数组 */
- (NSArray<NSDictionary *> *)attributesDictionaryArrayForContentArray:(NSArray<NSString *> *)contentArray{
    NSMutableArray *attributesDictionaryArray = [NSMutableArray array];
    for (NSString *content in contentArray) {
        NSDictionary *dic = [Factory attributesDictionaryWithContent:content font:[UIFont systemFontOfSize:16] width:kScreenW-16];
        [attributesDictionaryArray addObject:dic];
    }
    return attributesDictionaryArray;
}
/** 根据图片数组获取高度数组 */
- (NSMutableArray *)heightArrayForPicsArray:(NSArray<NSString *> *)picsArray{
    NSMutableArray *heightArray = [NSMutableArray array];
    for (int i = 0; i < picsArray.count; i++) {
//        NSString *picURLString = [picsArray objectAtIndex:i];
        __block CGFloat height = 200;
//        [[NSOperationQueue new] addOperationWithBlock:^{
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURLString]];
//            UIImage *pic = [UIImage imageWithData:data];
//            height = (kScreenW-16)*pic.size.height/pic.size.width;
//            [heightArray replaceObjectAtIndex:i withObject:@(height)];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self.tableview reloadData];
//            }];
//        }];
        [heightArray addObject:@(height)];
    }
    return heightArray;
}
- (void)collectArticle:(UIButton *)sender{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
    [queue inDatabase:^(FMDatabase *db) {
        NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
        if (resultCount) {
                BOOL success = [db executeUpdate:@"delete from Collection where Aid = ?", self.aid];
                if (success) {
                    [Factory textHUDWithVC:self text:@"取消收藏成功"];
                    [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
            }
        }else{
            BOOL success = [db executeUpdate:@"insert into Collection (Name, Aid, Type, Image, Title, PubDate) values (?,?,?,?,?,?)", @"Test", self.aid, @(self.detailType), self.detailVM.image, self.detailVM.title, self.detailVM.pubDate];
            if (success) {
                [Factory textHUDWithVC:self text:@"收藏成功"];
                [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }
        }
    }];
}
- (void)clickLikeWithCompletionHandle:(void(^)(int number))completionHandle{
    //查询当前aid并且点赞状态为1数据
    BmobQuery *myLikeQuery = [BmobQuery queryWithClassName:@"Like"];
    [myLikeQuery addTheConstraintByAndOperationWithArray:@[@{@"Aid": self.aid}, @{@"likeState": @1}]];
    [myLikeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        [[NSOperationQueue new] addOperationWithBlock:^{
            completionHandle(number);
        }];
    }];
}
- (void)clickShare:sender{
    NSArray *shareToSnsNames = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone];
    
    [UMSocialData defaultData].extConfig.title = self.detailVM.title;
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.detailVM.link;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.detailVM.link;
    //qq好友
    [UMSocialData defaultData].extConfig.qqData.url = self.detailVM.link;
    //qq空间
    [UMSocialData defaultData].extConfig.qzoneData.url = self.detailVM.link;
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUMengAppKey shareText:self.detailVM.desc shareImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:kDetailImagePath]] shareToSnsNames:shareToSnsNames delegate:nil];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"军事迷";
    //是否存在缓存
//    if (self.detailVM.model) {
//        WK(weakSelf);
//        [self.tableview addHeaderRefresh:^{
//            [weakSelf.tableview endHeaderRefresh];
//        }];
//        [self.tableview beginHeaderRefresh];
//    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.detailVM getDataWithMode:0 completionHandle:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else{
                NSLog(@"请求成功");
                [self.tableview reloadData];
                NSLog(@"刷新成功");
                [self.view bringSubviewToFront:self.funcView];
                UIImageView *iv = [UIImageView new];
                [iv setImageWithURL:[NSURL URLWithString:self.detailVM.image]];
                [UIImagePNGRepresentation(iv.image) writeToFile:kDetailImagePath atomically:YES];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
//    }
    [Factory naviClickBackWithViewController:self];
//    NSLog(@"%@", kDocPath);
    NSLog(@"aid:%@", self.aid);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    [[NSOperationQueue new] addOperationWithBlock:^{
        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}]];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            [[NSOperationQueue new] addOperationWithBlock:^{
                if (number == 0) {
                    BmobObject *obj = [BmobObject objectWithClassName:@"Like"];
                    [obj setObject:userName forKey:@"userName"];
                    [obj setObject:self.aid forKey:@"Aid"];
                    [obj setObject:@(self.detailType) forKey:@"Type"];
                    [obj setObject:@0 forKey:@"likeState"];
                    [obj saveInBackground];
//                    NSLog(@"点赞初始状态完成 %@", [NSThread currentThread]);
                }
            }];
        }];
    }];
    [[NSOperationQueue new] addOperationWithBlock:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:kDetailPlistPath]) {
            NSMutableDictionary *detailDic = [NSMutableDictionary dictionaryWithContentsOfFile:kDetailPlistPath];
            [detailDic setObject:userName forKey:@"userName"];
            [detailDic setObject:self.aid forKey:@"Aid"];
            [detailDic setObject:@(self.detailType) forKey:@"Type"];
            [detailDic writeToFile:kDetailPlistPath atomically:YES];
        }else{
            NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
            [detailDic setObject:userName forKey:@"userName"];
            [detailDic setObject:self.aid forKey:@"Aid"];
            [detailDic setObject:@(self.detailType) forKey:@"Type"];
            [detailDic writeToFile:kDetailPlistPath atomically:YES];
        }
//        NSLog(@"存入plist文件完成 %@", [NSThread currentThread]);
    }];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark - 懒加载 Lazy Load
- (MFDetailViewModel *)detailVM {
	if(_detailVM == nil) {
        _detailVM = [[MFDetailViewModel alloc] initWithAid:self.aid];
	}
	return _detailVM;
}

- (UITableView *)tableview {
	if(_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self.view addSubview:_tableview];
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
            
        }];
        _tableview.allowsSelection = NO;
        _tableview.separatorStyle = 0;
        [_tableview registerNib:[UINib nibWithNibName:@"DetailLikeCell" bundle:nil] forCellReuseIdentifier:@"DetailLikeCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"DetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"DetailHeaderCell"];
        [_tableview registerClass:[DetailContentCell class] forCellReuseIdentifier:@"DetailContentCell"];
	}
	return _tableview;
}
- (FunctionView *)funcView{
    if (_funcView == nil) {
        _funcView = [[FunctionView alloc] init];
        [self.view addSubview:_funcView];
        [_funcView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        _funcView.backgroundColor = [UIColor lightGrayColor];
        //点击收藏
        [_funcView.collectionBtn addTarget:self action:@selector(collectArticle:) forControlEvents:UIControlEventTouchUpInside];
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
        [queue inDatabase:^(FMDatabase *db) {
            NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
            if (resultCount) {
                //已被收藏的显示黄星星✨
                [_funcView.collectionBtn setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }
        }];
        //点击评论
        [_funcView.myCommentBtn bk_addEventHandler:^(id sender) {
            Factory *factory = [[Factory alloc] init];
            if (factory.isUserLogin) {//如果是登录状态,则跳转至评论界面
                CommentViewController *commentVC = [CommentViewController new];
                commentVC.aid = self.aid;
                commentVC.detailType = self.detailType;
                [self.navigationController pushViewController:commentVC animated:YES];
            }else{//否则跳转至登录界面
                [self presentViewController:[[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController] animated:YES completion:nil];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        //所有评论
        [_funcView.allCommentBtn bk_addEventHandler:^(id sender) {
            AllCommentsViewController *allCommentsVC = [AllCommentsViewController new];
            [self.navigationController pushViewController:allCommentsVC animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        //分享按钮
        [_funcView.shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _funcView;
}
- (NSArray<NSString *> *)contentArray{
    if (_contentArray == nil) {
        _contentArray = [[NSArray alloc] init];
        _contentArray = [self heightArrayForContentArray:self.detailVM.content];
    }
    return _contentArray;
}
- (NSMutableArray<NSString *> *)picsArray{
    if (_picsArray == nil) {
        _picsArray = [NSMutableArray array];
        _picsArray = [self heightArrayForPicsArray:self.detailVM.pics];
        
    }
    return _picsArray;
}
@end

@implementation DetailContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self contentLb];
        [self picIV];
    }
    return self;
}
- (UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [[UILabel alloc] init];
        _contentLb.numberOfLines = 0;
        _contentLb.font = [UIFont systemFontOfSize:16];
    }
    return _contentLb;
}
- (UIImageView *)picIV{
    if (_picIV == nil) {
        _picIV = [[UIImageView alloc] init];
        _picIV.backgroundColor = kRGBA(224, 224, 224, 1.0);
    }
    return _picIV;
}
@end
