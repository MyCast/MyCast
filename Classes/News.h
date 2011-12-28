//
//  splash.h
//  MyCast
//
//  Created by Jannes Klaas.
//  Copyright 2011 JannesCode. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface News : UIViewController {
	IBOutlet UIWebView *webview;
    IBOutlet UINavigationBar *navigationBar;
}
@property (nonatomic, retain) UIWebView *webview;

@end
