//
//  DetailLikeCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "DetailLikeCell.h"

@interface DetailLikeCell()
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *unlikeView;


@end

@implementation DetailLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置 点赞/踩 按钮 的风格--圆角带边框
    _likeView.layer.cornerRadius = 3;
    _likeView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    _likeView.layer.borderWidth = 1;
    
    _unlikeView.layer.cornerRadius = 3;
    _unlikeView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    _unlikeView.layer.borderWidth = 1;
    
    [_likeBtn addTarget:self action:@selector(clickLike:) forControlEvents:UIControlEventTouchUpInside];
    [_unlikeBtn addTarget:self action:@selector(clickUnlike:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 方法 Methods
//点赞/取消点赞
- (void)clickLike:(UIButton *)sender{
//    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
//    NSString *userName = [userDic objectForKey:@"userName"];
//    [cell.likeBtn bk_addEventHandler:^(id sender) {
//        BmobObject *obj = [BmobObject objectWithClassName:@"Like"];
//        [obj setObject:userName forKey:@"userName"];
//        [obj setObject:self.aid forKey:@"Aid"];
//        [obj setObject:@(self.detailType) forKey:@"Type"];
//        [obj setObject:@1 forKey:@"likeState"];
//        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//            if (isSuccessful) {
//                //
//                NSLog(@"点赞成功");
//            }
//        }];
//    } forControlEvents:UIControlEventTouchUpInside];
//    BmobQuery *likeQuery = [BmobQuery queryWithClassName:@"Like"];
//    //查询当前用户,当前aid并且点赞状态为1数据
//    [likeQuery addTheConstraintByAndOperationWithArray:@[@{@"userName": userName}, @{@"Aid": self.aid}, @{@"likeState": @1}]];
//    likeQuery.limit = 1000;
//    [likeQuery sumKeys:@[@"likeState"]];
//    [likeQuery calcInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        NSLog(@"%@, %@", array, [NSThread currentThread]);
//        NSDictionary *countDic = [array objectAtIndex:0];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            cell.likeLb.text = [[countDic objectForKey:@"_sumLikeState"] stringValue];
//        }];
//        
//    }];

    
}
//踩/取消踩
- (void)clickUnlike:(UIButton *)sender{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
