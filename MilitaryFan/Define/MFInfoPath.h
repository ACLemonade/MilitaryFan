//
//  MFInfoPath.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#ifndef MFInfoPath_h
#define MFInfoPath_h

//推荐
#define kRecommendPath @"http://if.wap.xinjunshi.com/api2.2/app.php?mod=newslist&act=index&maxid=0&page=%ld"
//排行榜
#define kRankListPath @"http://if.wap.xinjunshi.com/api2.2/app.php?mod=rank_list&maxid=0&page=%ld"
//制高点
#define kTopPath @"http://if.wap.xinjunshi.com/api2.2/app.php?mod=newslist&act=fenghuo&maxid=0&page=%ld"
//详情页
#define kDetailPath @"http://if.wap.xinjunshi.com/api2.2/app.php?aid=%@&mod=show&type=%ld"

#endif /* MFInfoPath_h */
