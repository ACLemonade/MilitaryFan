//
//  DetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "DetailViewController.h"
#import "MFDetailViewModel.h"
#import "DetailLikeCell.h"
#import "DetailHeaderCell.h"
#import <UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>


@interface DetailContentCell : UITableViewCell
@end


@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableview;
@property (nonatomic) MFDetailViewModel *detailVM;
@property (nonatomic) CGFloat contentCellHeight;
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
                //    NSLog(@"imgSize: %@", NSStringFromCGSize(iv.frame.size));
                }
            }
            return cell;
            break;
        }
        case 2:
        {
            DetailLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLikeCell" forIndexPath:indexPath];
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
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        CGFloat h = [self getImagesTotalHeightWithImageArray:self.detailVM.pics];
//        NSLog(@"h: %f", h);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark - 懒加载 Lazy Load
- (MFDetailViewModel *)detailVM {
	if(_detailVM == nil) {
        _detailVM = [[MFDetailViewModel alloc] initWithAid:self.aid detailType:self.detailType];
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
            make.edges.mas_equalTo(0);
        }];
        [_tableview registerNib:[UINib nibWithNibName:@"DetailLikeCell" bundle:nil] forCellReuseIdentifier:@"DetailLikeCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"DetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"DetailHeaderCell"];
        [_tableview registerClass:[DetailContentCell class] forCellReuseIdentifier:@"DetailContentCell"];
	}
	return _tableview;
}

@end

@implementation DetailContentCell

@end
