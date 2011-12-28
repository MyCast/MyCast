//
//  DetailViewController.h
//  MyCast
//
//  Created by Elefantos Elefantosque on 21.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CastView;

@interface DetailViewController : UIViewController {

    IBOutlet UILabel *titelLabel;
  
    IBOutlet UITextView *descriptionTextField;

    IBOutlet UIImageView *backroundView;
    
    UIImage* backroundImage;
    
    NSString* episideDescription;
    
    NSString* episodeTitle;
    
    UIColor* textColour;
    
    CastView* castView;
    
    NSString* backroundImagePath;
    IBOutlet UIButton *loadButton;
    IBOutlet UIButton *streamButton;
    IBOutlet UIButton *chancelButton;
}


- (IBAction)pushDownload:(id)sender;
- (IBAction)pushStream:(id)sender;
- (IBAction)pushChancel:(id)sender;

- (void) setBackroundViewImage:(NSString*) path;
- (void) setTitelLabelText:(NSString*) text;
- (void) setDescriptionText:(NSString*) text;
- (void) setTextColor:(UIColor*) color;
- (void) setCastView:(CastView*) cast;


@end
