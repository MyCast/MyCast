//
//  Videotasche.h
//  Kult
//
//  Created by Paul-Vincent Roll on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPVolumeView.h>
#import "MBProgressHUD.h"

@interface Videotasche : UIViewController {
    
    NSMutableArray *blogEntries;
	NSMutableArray *blogEnclosures;
	CXMLDocument *rssParser;
	
    MBProgressHUD* progressHUD;
    
    NSFileHandle* file;
	
    long long bytesExprected;
    long long bytesRecieved;
    
	IBOutlet UILabel *episodes;
    IBOutlet UIView *noInternet;
    IBOutlet UITableView *allContent;

    int currentlySelectedCast;
}
- (IBAction)share:(id)sender;

- (void) streamCastNumber:(int) number;

- (void) downloadCastNumber:(int) number;


@end
