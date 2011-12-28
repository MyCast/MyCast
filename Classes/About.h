//
//  About.h
//  Tschencasts
//
//  Created by Paul-Vincent Roll on 23.08.11.
//  Copyright 2011 JannesCode. All rights reserved.
//

@interface About : UIViewController {
	
    IBOutlet UIImageView *backroundImageView;
    IBOutlet UINavigationBar *navigationBar;
    
    IBOutlet UILabel *headerLabel;
    IBOutlet UITextView *aboutTextView;
    IBOutlet UILabel *podcastMailLabel;
    IBOutlet UILabel *teamNameLabel;
        
}


@end