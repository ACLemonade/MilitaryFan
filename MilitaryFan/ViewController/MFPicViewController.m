//
//  MFPicViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFPicViewController.h"
#import "MFPicViewModel.h"

#import <UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImageManager.h>

@interface MFPicViewController () <MWPhotoBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) MFPicViewModel *picVM;
@property (nonatomic) UIBarButtonItem *collectionBtn;
@property (nonatomic) UIBarButtonItem *downloadBtn;
@property (nonatomic) UIBarButtonItem *shareBtn;

@end

@implementation MFPicViewController
#pragma mark - 协议方法 MWPhotoBrowserDelegate 
//有多少张photo
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.picVM.picNumber;
}
//每张photo是什么样子
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photo = [MWPhoto photoWithURL:[self.picVM iconURLForIndex:index]];
    if (![[self.picVM pictextForIndex:index] isEqualToString:@""]) {
        photo.caption = [self.picVM pictextForIndex:index];
    }
    return photo;
}
#pragma mark - 协议方法 UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 方法 Methods
//点击收藏
- (void)collectPic:sender{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
    //    NSLog(@"%@", kDocPath);
    [queue inDatabase:^(FMDatabase *db) {
        NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
        if (resultCount) {
            BOOL success = [db executeUpdate:@"delete from Collection where Aid = ?", self.aid];
            if (success) {
                NSLog(@"取消收藏成功");
                [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
            }
        }else{
            BOOL success = [db executeUpdate:@"insert into Collection (Name, Aid, Type, Image, Title, PubDate) values (?,?,?,?,?,?)", @"Test", self.aid, @18, self.picVM.image, self.picVM.title, self.picVM.pubDate];
            if (success) {
                NSLog(@"收藏成功");
                [sender setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }
        }
    }];

}
//点击下载/保存
- (void)downloadPic:sender{
    NSURL *currentImageURL = [self.picVM iconURLForIndex:self.currentIndex];
    [[SDWebImageManager sharedManager] downloadWithURL:currentImageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //下载进度
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image && finished) {
            NSLog(@"下载完成");
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        NSLog(@"保存成功");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片已成功保存至相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *scanAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVC addAction:scanAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        NSLog(@"保存失败");
    }
}
//点击分享
- (void)sharePic:sender{

    NSArray *shareToSnsNames = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone];
    
    [UMSocialData defaultData].extConfig.title = self.picVM.title;
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.picVM.link;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.picVM.link;
    //qq好友
    [UMSocialData defaultData].extConfig.qqData.url = self.picVM.link;
    //qq空间
    [UMSocialData defaultData].extConfig.qzoneData.url = self.picVM.link;
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUMengAppKey shareText:self.picVM.desc shareImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:kDetailImagePath]] shareToSnsNames:shareToSnsNames delegate:nil];
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
    [self.picVM getDataWithMode:0 completionHandle:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }else{
            [self reloadData];
            /** 问题有待解决,image对象有时为空,有时不为空 */
            UIImageView *iv = [UIImageView new];
            [iv setImageWithURL:[NSURL URLWithString:self.picVM.image]];
            [UIImagePNGRepresentation(iv.image) writeToFile:kDetailImagePath atomically:YES];
        }
    }];
    [Factory naviClickBackWithViewController:self];
    self.navigationItem.rightBarButtonItems = @[self.shareBtn, self.downloadBtn, self.collectionBtn];
    NSLog(@"%@", kDocPath);
}
#pragma mark - 懒加载 Lazy Load
- (MFPicViewModel *)picVM {
	if(_picVM == nil) {
        _picVM = [[MFPicViewModel alloc] initWithAid:self.aid];
	}
	return _picVM;
}
- (instancetype)init{
    if (self = [super init]) {
        //是否有操作按钮--分享 复制 etc
        self.displayActionButton = NO;
        //是否左右翻页
        self.displayNavArrows = YES;
        //是否被选中
        self.displaySelectionButtons = NO;
        //是否支持缩放
        self.zoomPhotosToFill = YES;
        //是否总是显示控制界面
        self.alwaysShowControls = NO;
        //是否支持GridView
        self.enableGrid = YES;
        //是否从GridView开始
        self.startOnGrid = NO;
        //将代理设置为自身
        self.delegate = self;
    }
    return self;
}


- (UIBarButtonItem *)collectionBtn {
	if(_collectionBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, 24, 24);
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
        //点击收藏
        [btn addTarget:self action:@selector(collectPic:) forControlEvents:UIControlEventTouchUpInside];
        [queue inDatabase:^(FMDatabase *db) {
            NSInteger resultCount = [db intForQuery:@"select count(*) from Collection where Aid = ?", self.aid];
            if (resultCount) {
                //已被收藏的显示黄星星✨
                [btn setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav2"] forState:UIControlStateNormal];
            }else{
                //没被收藏的显示灰星星
                [btn setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
            }
        }];
        _collectionBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
	}
	return _collectionBtn;
}

- (UIBarButtonItem *)downloadBtn {
	if(_downloadBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, 24, 24);
        [btn setImage:[UIImage imageNamed:@"nav_img_save"] forState:UIControlStateNormal];
        //点击下载
        [btn addTarget:self action:@selector(downloadPic:) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
	}
	return _downloadBtn;
}

- (UIBarButtonItem *)shareBtn {
	if(_shareBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, 24, 24);
        [btn setImage:[UIImage imageNamed:@"nav_img_share"] forState:UIControlStateNormal];
        //点击分享
        [btn addTarget:self action:@selector(sharePic:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
	}
	return _shareBtn;
}

@end
