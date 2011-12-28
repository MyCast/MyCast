//
//  MyCastAppDelegate.h
//  MyCast
//
//  Created by Jannes Klaas
//  Copyright 2011 JannesCode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CastView;


@interface MyCastAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    // Mainly storage of colors for all views
    
    UIWindow *window;
    UITabBarController *tabBarController;
    NSOperationQueue *queue;
	UIColor* navigationBarColor;
    NSString* backroundImagePath;
    UIColor* textColor;
    BOOL hasInternet;
    CastView* castView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, assign) UIColor* navigationBarColor;
@property (nonatomic, assign) NSString* backroundImagePath;
@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, assign) BOOL hasInternet;
@property (nonatomic, assign) CastView* castView;

-(void)handleUserInfo:(NSDictionary*)userInfo;

@end
