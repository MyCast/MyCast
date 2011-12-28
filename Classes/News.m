//
//  splash.m
//  MyCast
//
//  Created by Jannes Klaas
//  Copyright 2011 JannesCode. All rights reserved.
//
#import "News.h"
#import "MyCastAppDelegate.h"

@implementation News
@synthesize webview;


#define NewsPageURL @"http://www.lk-media.com/mycast/news/"



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NewsPageURL]]];
    	
}

- (void)viewWillAppear:(BOOL)animated {
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    navigationBar.tintColor = delegate.navigationBarColor;
}

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
