//
//  About.m
//  Taschencasts
//
//  Created by Jannes Klaason 23.08.11.
//  Copyright 2011 JannesCode. All rights reserved.
//

#define AboutText @"MyCast, dein Podcast als App. Wir sind Podcaster, die eine App für unseren Podcast haben wollten. Doch da es so etwas nirgendwo gab haben wir beschlossen so etwas selbst anzubieten. Denn jeder Podcast hat eine App verdient. lk-media.com"
#define HeaderTitle @"Wer sind wir"
#define PodcastMail @"kontakt@lk-media.com"
#define TeamName @"Team: LK Media Dev Team"

#import "About.h"
#import "MyCastAppDelegate.h"

@implementation About
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
/*[webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"About" ofType:@"html"]isDirectory:NO]]];*/
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Get colors and backround colors
    
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    navigationBar.tintColor = delegate.navigationBarColor;

    UIImage* backroundImage = [UIImage imageWithContentsOfFile:delegate.backroundImagePath];
    [backroundImageView setImage:backroundImage];
    
    aboutTextView.textColor = delegate.textColor;
    headerLabel.textColor = delegate.textColor;
    podcastMailLabel.textColor = delegate.textColor;
    teamNameLabel.textColor = delegate.textColor; 
    
    aboutTextView.text = AboutText;
    headerLabel.text = HeaderTitle;
    podcastMailLabel.text = PodcastMail;
    teamNameLabel.text = TeamName;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [navigationBar release];
    navigationBar = nil;
    [backroundImageView release];
    backroundImageView = nil;
    [headerLabel release];
    headerLabel = nil;
    [aboutTextView release];
    aboutTextView = nil;
    [podcastMailLabel release];
    podcastMailLabel = nil;
    [teamNameLabel release];
    teamNameLabel = nil;
        
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [navigationBar release];
    [backroundImageView release];
    [headerLabel release];
    [aboutTextView release];
    [podcastMailLabel release];
    [teamNameLabel release];
   
    [super dealloc];
}


@end