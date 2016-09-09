//
//  AppDelegate.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit+AFNetworking.h>
#import "MFInfoNetManager.h"

#import "PageController.h"
#import "LeftMenuViewController.h"
#import "VideoViewController.h"
#import "SettingsViewController.h"

#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>

@interface AppDelegate ()

@end



//微信
#define kWeChatAppId @"wx4868b35061f87885"
#define kWeChatSecret @"64020361b8ec4c99936c0e3999a9f249"

//QQ
#define kQQAppId @"100371282"
#define kQQAppKey @"aed9b0303e3ed1e27bae87c33761161d"

//新浪微博
#define kSinaAppKey @"568898243"
#define kSinaAppSecret @"38a4f8204cc784f81f9f0daaf31e02e3"

@implementation AppDelegate
#pragma mark - 懒加载 Lazy Load
-(UIWindow *)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}
- (RESideMenu *)sideMenuVC{
    if (_sideMenuVC == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
        UITabBarController *tab = [[UITabBarController alloc] init];
        
        PageController *pageVC = [PageController new];
        VideoViewController *videoVC = [VideoViewController new];
        SettingsViewController *settingsVC = [sb instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
        UINavigationController *pageNavi = [[UINavigationController alloc] initWithRootViewController:pageVC];
        UINavigationController *videoNavi = [[UINavigationController alloc] initWithRootViewController:videoVC];
        UINavigationController *settingsNavi = [[UINavigationController alloc] initWithRootViewController:settingsVC];
        
        pageNavi.tabBarItem.title = @"资讯";
        videoNavi.tabBarItem.title = @"视频";
        settingsNavi.tabBarItem.title = @"设置";
        
        pageVC.navigationItem.title = @"军事迷";
        videoVC.navigationItem.title = @"军事迷";
        settingsVC.navigationItem.title = @"军事迷";
        
        tab.viewControllers = @[pageNavi, videoNavi, settingsNavi];
        LeftMenuViewController *leftVC = [LeftMenuViewController new];
        
        self.sideMenuVC = [[RESideMenu alloc] initWithContentViewController:tab leftMenuViewController:leftVC rightMenuViewController:nil];
        
    }
    return _sideMenuVC;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.sideMenuVC;
    [UINavigationBar appearance].translucent = NO;
    [UITabBar appearance].translucent = NO;
    
    [self sideMenuVC];
    
    //电池条左上角wifi旁菊花标识
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //创建用户设置表默认配置
    if (![[NSFileManager defaultManager] fileExistsAtPath:kUserPlistPath]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"Test" forKey:@"userName"];
        [dic setObject:@"" forKey:@"password"];
        [dic setObject:@(NO) forKey:@"loginState"];
        [dic writeToFile:kUserPlistPath atomically:YES];
    }
    
    //shareSDK唯一标识符
    [SMSSDK registerApp:kSMSAppKey withSecret:kSMSAppSecret];
    //友盟唯一标识符
    [UMSocialData setAppKey:kUMengAppKey];
    
    [UMSocialWechatHandler setWXAppId:kWeChatAppId appSecret:kWeChatSecret url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppKey url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppKey secret:kSinaAppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //创建首页缓存文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:kInfoCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    //创建详情页缓存文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:kDetailCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Lemonade.MilitaryFan" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MilitaryFan" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MilitaryFan.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
