//
//  DetailViewController.m
//  MyCast
//
//  Created by Elefantos Elefantosque on 21.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "CastView.h"
#import "MyCastAppDelegate.h"
#import "MKInfoPanel.h"

@implementation DetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
}

- (void) viewWillAppear:(BOOL)animated {
    
    // Fill view with contend, set colors
    
    [titelLabel setText:episodeTitle];
    [descriptionTextField setText:episideDescription];
    [titelLabel setTextColor:textColour];
    [descriptionTextField setTextColor:textColour];
    
    [loadButton setTitle:NSLocalizedString(@"Laden", nil) forState:UIControlStateNormal];
    [loadButton setTitle:NSLocalizedString(@"Laden", nil) forState:UIControlStateHighlighted];
        
    [streamButton setTitle:NSLocalizedString(@"Streamen", nil) forState:UIControlStateNormal];
    [streamButton setTitle:NSLocalizedString(@"Streamen", nil) forState:UIControlStateHighlighted];
    
    [chancelButton setTitle:NSLocalizedString(@"Abbrechen", nil) forState:UIControlStateNormal];
    [chancelButton setTitle:NSLocalizedString(@"Abbrechen", nil) forState:UIControlStateHighlighted];
    
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    backroundImagePath = delegate.backroundImagePath;
    backroundImage = [[UIImage alloc] initWithContentsOfFile:backroundImagePath];
    [backroundView setImage:backroundImage];
    
    
    
      
}

- (void)viewDidUnload
{
    [loadButton release];
    loadButton = nil;
    [streamButton release];
    streamButton = nil;
    [chancelButton release];
    chancelButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [backroundView release];
    [titelLabel release];
    [descriptionTextField release];
    [backroundImage release];
    
    
    [loadButton release];
    [streamButton release];
    [chancelButton release];
    [super dealloc];
}
- (IBAction)pushDownload:(id)sender {
    
    // Button pushed, dismiss view and start download in cast view
    
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // No internet, no download
    if (!delegate.hasInternet) {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeInfo
                               title:NSLocalizedString(@"Kein Internet", nil)
                            subtitle:NSLocalizedString(@"Du kannst leider nur schon geladene Folgen ansehen", nil)
                           hideAfter:3];
        return;
    }
    
    
    castView.nextTaskCode = @"DownloadCurrentEpisode";
    [self dismissModalViewControllerAnimated:YES];
    //[castView downloadCastNumber:[castView currentlySelectedCast]];
     
    
}

- (IBAction)pushStream:(id)sender {
    
    // The same as downlad but with a stream
    
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!delegate.hasInternet) {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeInfo
                               title:NSLocalizedString(@"Kein Internet", nil)
                            subtitle:NSLocalizedString(@"Du kannst leider nur schon geladene Folgen ansehen", nil)
                           hideAfter:3];
        return;
    }
    
    
    castView.nextTaskCode = @"StreamCurrentEpisode";
    [self dismissModalViewControllerAnimated:YES];
    //[castView streamCastNumber:[castView currentlySelectedCast]];
   
}

- (IBAction)pushChancel:(id)sender {
    
    //Chancel, go away
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) setBackroundViewImage:(NSString*)path {
    backroundImagePath = path;
   // [backroundView setImage:image];
}

- (void) setTitelLabelText:(NSString *)text {
    episodeTitle = text;
   // [titelLabel setText:text];
}

- (void) setDescriptionText:(NSString *)text {
    episideDescription = text;
   // [descriptionTextField setText:text];
}

-(void)setTextColor:(UIColor *)color {
    textColour = color;
}

-(void)setCastView:(CastView *)cast {
    castView = cast;
}


@end
