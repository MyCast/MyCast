//
//  CastView.m
//  MyCast
//
//  Created by Jannes Klaas
//  Copyright 2011 JannesCode. All rights reserved.
//



#define CastURL @"http://www.lk-media.com/mycast/mycast.xml"
#define CastName @"Podcast"
#define BackroundImageName @"Background"
#define BackroundImageNameRetina @"Background@x2"

#define TableTextColorRed 1.0
#define TableTextColorGreen 1.0
#define TableTextColorBlue 1.0
#define TableTextColorAlpha 1.0

#define TableTextColorHiglitedRed 0.65
#define TableTextColorHiglitedGreen 0.65
#define TableTextColorHiglitedBlue 0.65
#define TableTextColorHiglitedAlpha 1.0

#define NavigationbarColorRed 0.0
#define NavigationbarColorGreen 0.0
#define NavigationbarColorBlue 0.0
#define NavigationbarColorAlpha 1.0

#define TabbarColorRed  0.37
#define TabbarColorGreen  1.0
#define TabbarColorBlue  0.0
#define TabbarColorAlpha  1.0



#import "CastView.h"
#import "MKInfoPanel.h"
#import "UIDevice-Reachability.h"
#import "DetailViewController.h"
#import "MyCastAppDelegate.h"

@implementation CastView

@synthesize currentlySelectedCast, nextTaskCode, isDownloading;

-(void) grabRSSFeed {
    
    // Getting the RSS feed, catching the interesting stuff, put it into Arrays, check if it is a podcast or blog entry
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray* entries = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString: CastURL];
    

    rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];

    for (CXMLElement *resultElement in resultNodes) {
				
        NSMutableDictionary *blogItem = [[[NSMutableDictionary alloc] init] autorelease];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        [entries addObject:[[blogItem copy] autorelease]];

        
    }
	
	NSMutableArray* enclosures = [[NSMutableArray alloc] init];
    
    NSArray *resultEnclosures = NULL;
    resultEnclosures = [rssParser nodesForXPath:@"//enclosure" error:nil];
    for (CXMLElement *resultEnclosure in resultEnclosures) {
		NSString *hu =[[[[resultEnclosure attributeForName:@"url"] stringValue] copy] autorelease];
		[enclosures addObject:hu];
    }
    
    // Check for Podcast
    
    for (int i = 0; i < blogEntries.count; i++) {
        int deathCounter = 0;
        if (![[blogEntries objectAtIndex:i] valueForKey:@"itunes:subtitle"]) {
            deathCounter++;
        }
        if (![[blogEntries objectAtIndex:i] valueForKey:@"itunes:keywords"]) {
            deathCounter++;
        }
        if (![[blogEntries objectAtIndex:i] valueForKey:@"itunes:duration"]) {
            deathCounter++;
        }
        if (![[blogEntries objectAtIndex:i] valueForKey:@"itunes:summary"]) {
            deathCounter++;
        }
        if (![[blogEntries objectAtIndex:i] valueForKey:@"itunes:explicit"]) {
            deathCounter++;
        }
        
        if (deathCounter >= 3) {
            [entries removeObjectAtIndex:i];
        }
    }
    
  /*  if (blogEntries.count > blogEnclosures.count) {
        int i = blogEntries.count - blogEnclosures.count;
        
        for (int x = 0; x <= i; x++) {
            [blogEntries removeLastObject];
        }
    }*/
    blogEntries = entries;
    blogEnclosures = enclosures;
    
        [allContent reloadData];
        
    NSString* entrieString = [NSString stringWithFormat:@"%@Entries",CastName];
    NSString* feedString = [NSString stringWithFormat:@"%@Feed",CastName];

    
    NSData* cachedFeed = [NSKeyedArchiver archivedDataWithRootObject:blogEnclosures];
    [[NSUserDefaults standardUserDefaults] setValue:cachedFeed forKey:feedString];
    NSData* cachedEntries = [NSKeyedArchiver archivedDataWithRootObject:blogEntries];
    [[NSUserDefaults standardUserDefaults] setValue:cachedEntries forKey:entrieString];
    
    //NSLog(@"blogEnclosures %@",blogEnclosures);
    //NSLog(@"blogEntries %@",blogEntries);
    
    NSLog(@"blogEnclosures.count %u", blogEnclosures.count);
    NSLog(@"blogEntries.count %u", blogEntries.count);
    
   
    
    [pool release];

}




#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle

 - (void)viewDidLoad {
	 [super viewDidLoad];
	 
     
     if([blogEntries count] == 0) {
         
         
         
        /* NSString* entrieString = [NSString stringWithFormat:@"%@Entries",CastName];
         NSString* feedString = [NSString stringWithFormat:@"%@Feed",CastName];
         
         NSData* cachedFeed = [[NSUserDefaults standardUserDefaults] valueForKey:feedString];
         NSData* cachedEntries = [[NSUserDefaults standardUserDefaults] valueForKey:entrieString];
         if (cachedFeed && cachedEntries) {
             blogEnclosures = [NSKeyedUnarchiver unarchiveObjectWithData:cachedFeed]; 
             [blogEnclosures retain];
             blogEntries = [NSKeyedUnarchiver unarchiveObjectWithData:cachedEntries];
             [blogEntries retain];
             [allContent reloadData];
         }*/
         
         
         // Check if device has an internet connection
         
         if ([[UIDevice currentDevice] activeWLAN]) {
             hasInternet = YES;
         }
         if ([[UIDevice currentDevice] activeWWAN]) {
             hasInternet = YES;
         }

         
         
         if (hasInternet) {       
             
             
             [self performSelectorInBackground:@selector(grabRSSFeed) withObject:nil];
             
             
         
         
     } else {
         
         // Load cahced feed if there isno web
         
         NSString* entrieString = [NSString stringWithFormat:@"%@Entries",CastName];
         NSString* feedString = [NSString stringWithFormat:@"%@Feed",CastName];
         
         NSData* cachedFeed = [[NSUserDefaults standardUserDefaults] valueForKey:feedString];
         NSData* cachedEntries = [[NSUserDefaults standardUserDefaults] valueForKey:entrieString];
         if (cachedFeed && cachedEntries) {
             blogEnclosures = [NSKeyedUnarchiver unarchiveObjectWithData:cachedFeed]; 
             [blogEnclosures retain];
             blogEntries = [NSKeyedUnarchiver unarchiveObjectWithData:cachedEntries];
             [blogEntries retain];
             [allContent reloadData];
             
         } else {
             blogEnclosures = [[NSMutableArray alloc] init];
             [MKInfoPanel showPanelInView:self.view
                                     type:MKInfoPanelTypeInfo
                                    title:NSLocalizedString(@"Keine Daten", nil)
                                 subtitle:NSLocalizedString(@"Es gibt weder Internet noch gespeicherte Daten", nil)
                                hideAfter:7]; 
         }
         
         
     }
     
     
     // Initialisiere DetailView
       //NSString* backroundURL = @"";
     detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
     
     
     /*if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
         //iPhone 4
         backroundURL = [[NSBundle mainBundle] pathForResource:BackroundImageNameRetina ofType:@"png"];
     } else {
         backroundURL = [[NSBundle mainBundle] pathForResource:BackroundImageName ofType:@"png"];
     }
     UIImage* backroundImage = [[[UIImage alloc] initWithContentsOfFile:backroundURL] autorelease];
     [backroundImageView setImage:backroundImage];*/
     
     
    // First run
     int x = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchNumber"];
         if( x == 0 ){
     
         [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"launchNumber"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
             NSString* string = NSLocalizedString(@"Das Team wünscht dir viel Spaß mit dieser App!", nil);
              
             
         NSString* subtitle = [NSString stringWithFormat:string,CastName];
         
         [MKInfoPanel showPanelInView:self.view
                                 type:MKInfoPanelTypeInfo
                                title:NSLocalizedString(@"Herzlich Willkommen!", nil)
                             subtitle:subtitle
                            hideAfter:5];
     }
     
     CGRect rect = self.view.bounds;
     rect.origin.x = rect.size.width;
     rect.origin.y = rect.size.height;
     
     progressHUD = [[MBProgressHUD alloc] initWithFrame:rect];
     progressHUD.mode = MBProgressHUDModeDeterminate;
     progressHUD.dimBackground = YES;
     [progressHUD hide:YES];
     [self.view addSubview:progressHUD];
     
    bytesRecieved = 0;
    bytesExprected = 0;
    nextTaskCode = @"";
         
     }
     
}
 
- (void)viewWillAppear:(BOOL)animated {
    
    // Design the view
    
    
    NSString* backroundURL = @"";
    
    // Loading backround image
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        //iPhone 4(S)
        backroundURL = [[NSBundle mainBundle] pathForResource:BackroundImageNameRetina ofType:@"jpg"];
    } else {
    backroundURL = [[NSBundle mainBundle] pathForResource:BackroundImageName ofType:@"jpg"];
    }
    UIImage* backroundImage = [[[UIImage alloc] initWithContentsOfFile:backroundURL] autorelease];
    [backroundImageView setImage:backroundImage];
    
    //[detailViewController setBackroundViewImage:backroundURL];
    
    allContent.separatorColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2f];
    
    UIColor* navigationBarColor = [UIColor colorWithRed:NavigationbarColorRed green:NavigationbarColorGreen blue:NavigationbarColorBlue alpha:NavigationbarColorBlue];
    
    navigationBar.tintColor = navigationBarColor;
    navigationBar.topItem.title = CastName;
    [navigationBar setAlpha:NavigationbarColorAlpha];
    
    self.tabBarItem.title = CastName;
    
    
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    // Telling the delegate what colors are chosen so that all the other views can set them in the same color
    
    delegate.tabBar.selectedImageTintColor = [UIColor colorWithRed:TabbarColorRed green:TabbarColorGreen blue:TabbarColorBlue alpha:TabbarColorAlpha];
    delegate.navigationBarColor = navigationBarColor;
    delegate.backroundImagePath = backroundURL;
    delegate.textColor = [UIColor colorWithRed:TableTextColorRed green:TableTextColorGreen blue:TableTextColorBlue alpha:TableTextColorAlpha];
    delegate.hasInternet = hasInternet;
    
    delegate.castView = self;
        
}



- (void)viewDidAppear:(BOOL)animated {
    
    // Stream or download
     
    if ([nextTaskCode isEqualToString:@"StreamCurrentEpisode"]) {
        nextTaskCode = @"";
        [self streamCastNumber:currentlySelectedCast]; 
        
    }
    if ([nextTaskCode isEqualToString:@"DownloadCurrentEpisode"]) {
        nextTaskCode = @"";
        [self downloadCastNumber:currentlySelectedCast]; 
    }
    
   
}

/*- (void)moviePlaybackComplete:(NSNotification *)notification{
    
    // Close the movieplayer
    
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
    [moviePlayerController.view removeFromSuperview];
    //[moviePlayerController release];
	NSLog(@"ended");
}*/
 
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [blogEntries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       

    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];

    
    // Configure the cell...
	int blogEntryIndex = [indexPath indexAtPosition: [indexPath length] -1];
	/*NSMutableString *episodeTitle = [[[NSMutableString alloc] initWithString:[[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"title"]]autorelease];
    
    if (!episodeTitle) {
        episodeTitle = [[[NSMutableString alloc] initWithString:NSLocalizedString(@"Kein Name", nil)] autorelease];
    }*/
    
    NSString* episodeTitle = [[blogEntries objectAtIndex:blogEntryIndex] objectForKey:@"title"];
    
    if (!episodeTitle) {
        episodeTitle = NSLocalizedString(@"Kein Name", nil);
    }

	/*NSString *searchForMe = @".m4v";
	NSRange range = [[blogEnclosures objectAtIndex:indexPath.row] rangeOfString : searchForMe];
	if (range.location != NSNotFound) {

		CGRect myImageRect = CGRectMake(290, 11, 20, 20);
		UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
		[myImage setImage:[UIImage imageNamed:@"video.png"]];
		myImage.opaque = YES; // explicitly opaque for performance

		[cell addSubview:myImage];
		[myImage release];
	}*/
	
	cell.textLabel.text = episodeTitle;
    
    // filling the cell with name, date duration...
    
    UIColor* customTextColor = [[UIColor alloc] initWithRed:TableTextColorRed green:TableTextColorGreen blue:TableTextColorBlue alpha:TableTextColorAlpha];
	
    cell.textLabel.textColor = customTextColor;
	cell.detailTextLabel.textColor = customTextColor;
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	NSString *feedDateString = [[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"pubDate"];
    
    if (!feedDateString) {
        feedDateString = @"01.01.0001";
    }
    
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[inputFormatter setLocale: usLocale];
	[usLocale release];
	[inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
	NSDate *formattedDate = [inputFormatter dateFromString: feedDateString];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"dd'.'MM'.'yyyy"];
	
	NSMutableString *detailText = [NSMutableString stringWithString:[outputFormatter stringFromDate:formattedDate]];//;;
	[detailText appendString:@" Dauer: "];
    
    NSString* tmpStringToAppend = [[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"itunes:duration"];
    
    if (!tmpStringToAppend) {
        tmpStringToAppend = @"00:00";
    }
    
	[detailText appendString:tmpStringToAppend];

	cell.detailTextLabel.text = detailText;
	
	
	//[inputFormatter release];
	//[outputFormatter release];
	
	NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:indexPath.row]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
   // NSLog(@"%@", localURL);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        cell.textLabel.textColor = [UIColor colorWithRed:TableTextColorHiglitedRed green:TableTextColorHiglitedGreen blue:TableTextColorHiglitedBlue alpha:TableTextColorHiglitedAlpha];
    }
	
	//[[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"pubDate"];
    
	//UIImage *thumbnail = [UIImage imageNamed:@"cover.png"];
	//cell.imageView.image = thumbnail;
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [outputFormatter release];
    [inputFormatter release];
    
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // hasInternet = [[UIDevice currentDevice] hostAvailable:CastURL];
    
    
    // bring up the view with detail description
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentlySelectedCast = indexPath.row;
    
    
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:currentlySelectedCast]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
  //  NSLog(@"%@", localURL);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        
        /*if (!hasInternet) {
            [MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeInfo
                                   title:@"Kein Internet"
                                subtitle:@"Du kannst leider nur schon geladene Folgen ansehen"
                               hideAfter:3];
            return;
        }*/
        
        
       /* UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"Laden oder Streamen" message:@"Du kannst diese Folge Streamen oder sie auf denem Device speichern" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Laden",@"Streamen", nil];
    [alert show];*/
        
        NSString* descriptionString = [[blogEntries objectAtIndex: indexPath.row] objectForKey:@"itunes:summary"];
        if (!descriptionString) {
            descriptionString = [[blogEntries objectAtIndex: indexPath.row] objectForKey:@"description"];
            if (!descriptionString) {
                descriptionString = NSLocalizedString(@"Keine Beschreibung verfügbar", nil);
            }
            
        }
        descriptionString =  [descriptionString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        descriptionString =  [descriptionString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        descriptionString =  [descriptionString stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
        descriptionString =  [descriptionString stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
        descriptionString =  [descriptionString stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
        descriptionString =  [descriptionString stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
        
        int blogEntryIndex = [indexPath indexAtPosition: [indexPath length] -1];
        
        NSString* episodeTitle = [[blogEntries objectAtIndex:blogEntryIndex] objectForKey: @"title"];
        if (!episodeTitle) {
            episodeTitle = NSLocalizedString(@"Kein Name", nil); 
        }
        
        /*NSString* backroundURL = @"";
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            //iPhone 4
            backroundURL = [[NSBundle mainBundle] pathForResource:BackroundImageNameRetina ofType:@"png"];
        } else {
            backroundURL = [[NSBundle mainBundle] pathForResource:BackroundImageName ofType:@"png"];
        }*/
       // UIImage* backroundImage = [[[UIImage alloc] initWithContentsOfFile:backroundURL] autorelease];
        
        UIColor* color = [UIColor colorWithRed:TableTextColorRed green:TableTextColorGreen blue:TableTextColorBlue alpha:TableTextColorAlpha];
        
        
      //  [detailViewController setBackroundViewImage:backroundImage];
                
        [detailViewController setDescriptionText:descriptionString];
        
        [detailViewController setTitelLabelText:episodeTitle];
        
        [detailViewController setTextColor:color];
        
        [detailViewController setCastView:self];
        
        
        [self presentModalViewController:detailViewController animated:YES];
        
        
        
    } else {
        
        // If already downloaded: Play
        
        NSURL* movieURL = [NSURL fileURLWithPath:fileName];
        
        
        MPMoviePlayerViewController * movieView;
        
        
        movieView = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        
        MPMoviePlayerController * theMovie = [movieView moviePlayer];
        theMovie.scalingMode = MPMovieScalingModeAspectFit;
        theMovie.fullscreen = TRUE;
        theMovie.controlStyle = MPMovieControlStyleFullscreen;
        theMovie.shouldAutoplay = TRUE;
        theMovie.allowsAirPlay = YES;
        
        //theMovie.view.hidden = YES;
        
        [self presentMoviePlayerViewControllerAnimated:movieView];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(myMovieFinishedCallback:)
                                                     name: MPMoviePlayerPlaybackDidFinishNotification
                                                   object: theMovie];
        [theMovie retain];
        //[movieURL release];
    
    }
    
    
    
    
    
      
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // delete the episode
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:indexPath.row]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    //NSLog(@"%@", lastURLComponent);                 
    
    
    NSString* filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:lastURLComponent];
    [tableView beginUpdates]; 
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
        }
        
        
    }       
    [tableView endUpdates];
    [tableView reloadData];
}


// When the movie is done,release the controller. 
-(void)myMovieFinishedCallback:(NSNotification*)aNotification { 
    //[[aNotification object] release];
    MPMoviePlayerController* theMovie=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [theMovie stop];
    //[theMovie release];
}

#pragma mark -
#pragma mark Alert Delegate Stream & Download

/*- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // old Method no longer in use
    
    if (buttonIndex == 1) {
        NSLog(@"Button 1");
        // Laden
        [self downloadCastNumber:currentlySelectedCast];
    }
    if (buttonIndex == 2) {
        NSLog(@"Button 2");
        // Streamen
        [self streamCastNumber:currentlySelectedCast];
    }
}*/

- (void) streamCastNumber:(int)number {
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:number]];
    
    NSLog(@"StreamURl = %@",url);
    MPMoviePlayerViewController * movieView;
    movieView = [[MPMoviePlayerViewController alloc] initWithContentURL: url];
     
     
    MPMoviePlayerController * theMovie = [movieView moviePlayer];
    theMovie.scalingMode = MPMovieScalingModeAspectFit;
    theMovie.fullscreen = TRUE;
    theMovie.controlStyle = MPMovieControlStyleFullscreen;
    theMovie.shouldAutoplay = TRUE;
    theMovie.allowsAirPlay = YES;
     
     
     //theMovie.view.hidden = YES;
     [[NSNotificationCenter defaultCenter] addObserver: self
     selector: @selector(myMovieFinishedCallback:)
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];

    [self presentMoviePlayerViewControllerAnimated:movieView];
     
}

- (void) downloadCastNumber:(int)number {
    
 /*[MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeInfo
                           title:@"Apfeltasche"
                        subtitle:@"Die Apfeltasche wird geladen bitte warte einen Augenblick!"
                       hideAfter:6];*/
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    

    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[blogEnclosures objectAtIndex:number]]];

    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [urlConnection start];
    

}


#pragma mark -
#pragma mark Memory management

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    
    // Create file where to store episode...
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:currentlySelectedCast]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
 
   
    
    [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    file = [[NSFileHandle fileHandleForUpdatingAtPath:fileName] retain];
    
    if (file) {
        [file seekToEndOfFile];
    }
    bytesExprected = [response expectedContentLength];
    [progressHUD show:YES];
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(detectedLongPress:)];
    
    [self.view addGestureRecognizer:longPressRecognizer];
    isDownloading = YES;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Write data to file
   //     NSLog(@"downloading");
    if (file) { 
        [file seekToEndOfFile];
    }
    [file writeData:data]; 
    bytesRecieved += [data length];
    float progress = (float)bytesRecieved/(float)bytesExprected;
    //NSLog(@"%f",progress);
    
    NSString* progressString = [NSString stringWithFormat:@"%f Prozent",progress*100];
    [progressHUD setLabelText:@"Laden..."];
    [progressHUD setDetailsLabelText:progressString];
    [progressHUD setProgress:progress]; 
    
    loadingConnection = connection;
               
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    // Done loading close file, inform user, reload tableview
    
    NSLog(@"fertig");
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeInfo
                           title:NSLocalizedString(@"Erfolg!", nil)
                        subtitle:NSLocalizedString(@"Die Folge wurde erfolgreich runtergeladen!", nil)
                       hideAfter:6];
    [file closeFile];
    
    [progressHUD hide:YES];
    [allContent reloadData];
    isDownloading = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
}

- (void) detectedLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    // Aboard download
    
   // NSLog(@"Rocognized by %@",recognizer);
    [self.view removeGestureRecognizer:recognizer];
    [recognizer release];
    
    [loadingConnection cancel]; 

    [self abboardDownload];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

-(void)abboardDownload {
    
    // Download aboarded :( delete file, stop downloading
    
    [loadingConnection cancel];
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:currentlySelectedCast]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
    
    [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
    [progressHUD hide:YES];
    bytesRecieved = 0;
    bytesRecieved = 0;
    isDownloading = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [allContent reloadData];
}

- (void)viewDidUnload {
    [navigationBar release];
    navigationBar = nil;
    [backroundImageView release];
    backroundImageView = nil;
    [allContent release];
   
    allContent = nil;
    [detailViewController release];
    
    
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [allContent release];
    
    [backroundImageView release];
    [navigationBar release];
    [super dealloc];
    [progressHUD release];

}

@end
 
