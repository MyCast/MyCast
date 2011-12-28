//
//  CastView.h
//  MyCast
//
//  Created by Jannes Klaas
//  Copyright 2011 Jannescode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPVolumeView.h>
#import "MBProgressHUD.h"
#import "DetailViewController.h"

@interface CastView : UIViewController <UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate> {

    NSMutableArray *blogEntries;
	NSMutableArray *blogEnclosures;
	CXMLDocument *rssParser;
    
    NSFileHandle* file;
    
   // IBOutlet UITableView *_tableView;
    
	MBProgressHUD* progressHUD;
    
    DetailViewController* detailViewController;
    
    IBOutlet UIImageView *backroundImageView;
	
    IBOutlet UITableView *allContent;
    
    long long bytesExprected;
    long long bytesRecieved;
    
      
    int currentlySelectedCast;
    BOOL hasInternet;
    
    IBOutlet UINavigationBar *navigationBar;
    
    NSString* nextTaskCode;
    
    NSURLConnection* loadingConnection;
	
    BOOL isDownloading;
}

@property (assign) int currentlySelectedCast;
@property (assign) NSString* nextTaskCode;
@property (assign) BOOL isDownloading;

- (void) streamCastNumber:(int) number;

- (void) downloadCastNumber:(int) number;

- (void) detectedLongPress:(UILongPressGestureRecognizer*) recognizer;

- (void) abboardDownload;

@end
