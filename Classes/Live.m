//
//  Live.m
//  MyCast
//
//  Created by Jannes Klaas on 22.08.11.
//  Copyright 2011 JannesCode. All rights reserved.
//

#import "Live.h"
#import "MyCastAppDelegate.h"

@implementation Live
@synthesize webview;
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
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.lk-media.com/mycast/live/"]]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    navigationBar.tintColor = delegate.navigationBarColor;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [navigationBar release];
    [super dealloc];
}


@end