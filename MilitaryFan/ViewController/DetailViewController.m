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

#import "FunctionView.h"

@interface DetailContentCell : UITableViewCell
@end


@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableview;
@property (nonatomic) MFDetailViewModel *detailVM;
@property (nonatomic) CGFloat contentCellHeight;
@property (nonatomic) FunctionView *funcView;
@property (nonatomic) FMDatabase *dataBase;

@end

@implementation DetailViewController
#pragma mark - 协议方法 UitableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            DetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailHeaderCell" forIndexPath:indexPath];
            cell.titleLb.text = self.detailVM.title;
            cell.pubDateLb.text = self.detailVM.pubDate;
            cell.authorLb.text = self.detailVM.author;
            cell.clickLb.text = self.detailVM.click;
            return cell;
            break;
        }
        case 1:
        {
            DetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailContentCell" forIndexPath:indexPath];
            //获得文字数组
            NSArray *labelArr = [[self getDetailContentWithContent:self.detailVM.content] objectAtIndex:1];
            //获得配图数组
            NSArray *ivArr = [[self getDetailImagesWithImageArray:self.detailVM.pics] objectAtIndex:1];
            //当前高度
            CGFloat currentHeight = 0;
            // 文 图 文 图 文
            for (int i = 0; i<labelArr.count; i++) {
                UILabel *label = [labelArr objectAtIndex:i];
                [cell.contentView addSubview:label];
                label.frame = CGRectMake(8, currentHeight, label.bounds.size.width, label.bounds.size.height);
                currentHeight += label.bounds.size.height;
                
                if (i<ivArr.count) {
                    UIImageView *iv = [ivArr objectAtIndex:i];
                    [cell.contentView addSubview:iv];
                    iv.frame = CGRectMake(8, currentHeight, iv.bounds.size.width, iv.bounds.size.height);
                    currentHeight += iv.bounds.size.height;
                }
            }
            return cell;
            break;
        }
        //点赞cell
        case 2:
        {
            DetailLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLikeCell" forIndexPath:indexPath];
            NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
            NSString *userName = [userDic objectForKey:@"userName"];
            __block NSInteger likeNumber;
            __block NSInteger unlikeNumber;
            //总点赞数
            BmobQuery *likeQuery = [BmobQuery queryWithClassName:@"Like"];
            [likeQuery addTheConstraintByAndOperationWithArray:@[@{@"Aid": self.aid}, @{@"likeState": @1}]];
            [likeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                cell.likeLb.text = [NSString stringWithFormat:@"%d", number];
                likeNumber = number;
            }];
//            likeNumber = [self clickLike];
//            NSLog(@"%d", __LINE__);
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
//                NSLog(@"%@, %d", [NSThread currentThread], __LINE__);
            }];
            __block NSInteger myUnlikeNumber = 0;
            //查询当前aid并且踩状态为2数据
            BmobQuery *myUnlikeQuery = [BmobQuery queryWithClassName:@"Like"];
            [myUnlikeQuery addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @2}]];
            [myUnlikeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                myUnlikeNumber = number;
            }];
//            NSLog(@"%d", __LINE__);
            //------- 点赞/取消点赞 --------//
            [cell.likeBtn bk_addEventHandler:^(id sender) {
                if (myUnlikeNumber) {
                    NSLog(@"已经踩过,不能点赞");
                }else{
                    if (myLikeNumber) {
                        //取消点赞
                        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
                        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @1}]];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.firstObject) {
                                BmobObject *obj = array.firstObject;
                                [obj setObject:@0 forKey:@"likeState"];
                                [obj updateInBackground];
                                NSLog(@"取消点赞");
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    likeNumber--;
                                    myLikeNumber--;
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        cell.likeLb.text = [NSString stringWithFormat:@"%ld", likeNumber];
                                    }];
                                    
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
                                NSLog(@"点赞成功");
                                likeNumber++;
                                myLikeNumber++;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.likeLb.text = [NSString stringWithFormat:@"%ld", likeNumber];
                                }];
                                
                                
                            }
                        }];
                        
                    }

                }
            } forControlEvents:UIControlEventTouchUpInside];
            //------- 踩/取消踩 --------//
            [cell.unlikeBtn bk_addEventHandler:^(id sender) {
                if (myLikeNumber) {
                    NSLog(@"已经赞过,不能踩");
                }else{
                    //取消踩
                    if (myUnlikeNumber) {
                        BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
                        [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @2}]];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.firstObject) {
                                BmobObject *obj = array.firstObject;
                                [obj setObject:@0 forKey:@"likeState"];
                                [obj updateInBackground];
                                NSLog(@"取消踩");
                                myUnlikeNumber--;
                                unlikeNumber--;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.unlikeLb.text = [NSString stringWithFormat:@"%ld", unlikeNumber];
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
                                NSLog(@"踩成功");
                                myUnlikeNumber++;
                                unlikeNumber++;
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    cell.unlikeLb.text = [NSString stringWithFormat:@"%ld", unlikeNumber];
                                }];
                                
                            }
                        }];
                        
                    }

                }
            } forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
        default:
            return [UITableViewCell new];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 131;
            break;
        case 1:
        {
            CGFloat contentH = [[[self getDetailContentWithContent:self.detailVM.content] objectAtIndex:0] floatValue];
            CGFloat imageH = [[[self getDetailImagesWithImageArray:self.detailVM.pics] objectAtIndex:0] floatValue];
            return contentH + imageH;
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
//返回一个数组
//1.总高度
//2.存放image的数组
- (NSArray *)getDetailImagesWithImageArray:(NSArray *)imageArray{
    CGFloat totalHeight = 0;
    NSMutableArray *ivArr = [NSMutableArray array];
    for (NSString  *image in imageArray) {
        CGFloat itemW = kScreenW-16;
        CGFloat itemH = 0;
        NSURL *imageURL = [NSURL URLWithString:image];
        UIImageView *iv = [[UIImageView alloc] init];
        SDImageCache *imgCache = [SDImageCache sharedImageCache];
        [imgCache storeImage:iv.image forKey:image toDisk:YES];
        UIImage *newImg = [imgCache imageFromDiskCacheForKey:image];
        if (!newImg) {
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            newImg = [UIImage imageWithData:data];
        }
        itemH = itemW * (newImg.size.height/newImg.size.width);
        totalHeight += itemH;
        
        iv.image = newImg;
        iv.bounds = CGRectMake(0, 0, itemW, itemH);
        [ivArr addObject:iv];
    }
    return @[@(totalHeight), ivArr];
}
//返回一个数组
//总高度
//label数组
- (NSArray *)getDetailContentWithContent:(NSArray<NSString *> *)content{
    CGFloat totalHeight = 0;
    NSMutableArray *contentArr = [NSMutableArray array];
    for (NSString *word in content) {
        UILabel *label = [[UILabel alloc] init];
        label.text = word;
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        //根据固定宽度,算出字符串所占高度
        CGSize linesSz = [label.text boundingRectWithSize:CGSizeMake(kScreenW-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil].size;
        totalHeight += linesSz.height;
        label.bounds = CGRectMake(0, 0, linesSz.width, linesSz.height);
        [contentArr addObject:label];
    }
    return @[@(totalHeight), contentArr];
}
- (void)collectArticle:(UIButton *)sender{
//    FMDatabase *db = [FMDatabase databaseWithPath:kDataBasePath];
//    if ([db open]) {
//        BOOL suc = [db executeUpdate:@"create table Collection (Name text, Aid text, Type integer, Image text, Title text, PubDate text)"];
//        if (suc) {
//            NSLog(@"创建表成功");
//        }
//    }
//    [db close];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
    NSLog(@"%@", kDocPath);
    [queue inDatabase:^(FMDatabase *db) {
        NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
        if (resultCount) {
                BOOL success = [db executeUpdate:@"delete from Collection where Aid = ?", self.aid];
                if (success) {
                    NSLog(@"取消收藏成功");
                    [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
            }
        }else{
            BOOL success = [db executeUpdate:@"insert into Collection (Name, Aid, Type, Image, Title, PubDate) values (?,?,?,?,?,?)", @"Test", self.aid, @(self.detailType), self.detailVM.image, self.detailVM.title, self.detailVM.pubDate];
            if (success) {
                NSLog(@"收藏成功");
                [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }
        }
    }];
}
- (NSInteger)clickLike{
    __block NSInteger myLikeNumber = 0;
    //查询当前aid并且点赞状态为1数据
    BmobQuery *myLikeQuery = [BmobQuery queryWithClassName:@"Like"];
    [myLikeQuery addTheConstraintByAndOperationWithArray:@[@{@"Aid": self.aid}, @{@"likeState": @1}]];
    [myLikeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        [[NSOperationQueue new] addOperationWithBlock:^{
            myLikeNumber = number;
            NSLog(@"%@, %d", [NSThread currentThread], __LINE__);
        }];
    }];
    NSLog(@"%d", __LINE__);
    return myLikeNumber;
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.detailVM getDataWithMode:0 completionHandle:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }else{
            [self.tableview reloadData];
            [self.view bringSubviewToFront:self.funcView];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [Factory naviClickBackWithViewController:self];

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    BmobQuery *query = [BmobQuery queryWithClassName:@"Like"];
    [query addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0) {
            BmobObject *obj = [BmobObject objectWithClassName:@"Like"];
            [obj setObject:userName forKey:@"userName"];
            [obj setObject:self.aid forKey:@"Aid"];
            [obj setObject:@(self.detailType) forKey:@"Type"];
            [obj setObject:@0 forKey:@"likeState"];
            [obj saveInBackground];
        }
    }];
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
        [_funcView.myCommentBtn bk_addEventHandler:^(id sender) {
            CommentViewController *commentVC = [CommentViewController new];
            commentVC.aid = self.aid;
            commentVC.detailType = self.detailType;
            [self.navigationController pushViewController:commentVC animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        [_funcView.allCommentBtn bk_addEventHandler:^(id sender) {
            AllCommentsViewController *allCommentsVC = [AllCommentsViewController new];
            [self.navigationController pushViewController:allCommentsVC animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _funcView;
}
@end

@implementation DetailContentCell


@end
