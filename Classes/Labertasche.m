//
//  Labertasche.m
//  Kult
//
//  Created by Paul-Vincent Roll on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Labertasche.h"
#import "SHK.h"
#import "MKInfoPanel.h"
#import "UIDevice-Reachability.h"


@implementation Labertasche
-(void) grabRSSFeed {
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    
        blogEntries = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: @"http://www.taschencasts.de/app/feed/labertasche.xml"];
    
    rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
    
    for (CXMLElement *resultElement in resultNodes) {
        
        NSMutableDictionary *blogItem = [[[NSMutableDictionary alloc] init] autorelease];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        [blogEntries addObject:[[blogItem copy] autorelease]];
        
        
    }
	
	
	blogEnclosures = [[NSMutableArray alloc] init];
    NSArray *resultEnclosures = NULL;
    resultEnclosures = [rssParser nodesForXPath:@"//enclosure" error:nil];
    for (CXMLElement *resultEnclosure in resultEnclosures) {
		NSString *hu =[[[[resultEnclosure attributeForName:@"url"] stringValue] copy] autorelease];
		[blogEnclosures addObject:hu];
    }
    
    episodes.text = [[NSString stringWithFormat: @"%d", [blogEntries count]] stringByAppendingString:@" Episoden"];
    if ([blogEntries count]>0) {
        [allContent reloadData];
        [noInternet removeFromSuperview];
    }
        
        NSData* cachedFeed = [NSKeyedArchiver archivedDataWithRootObject:blogEnclosures];
        [[NSUserDefaults standardUserDefaults] setValue:cachedFeed forKey:@"labertascheFeed"];
        
    
    
    
    
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
    //[self createStreamer];
    //[streamer start];
    
    
    if([blogEntries count] == 0) {
        
        hasInternet = [[UIDevice currentDevice] networkAvailable];
        if (hasInternet) {
            

        
        [self performSelectorInBackground:@selector(grabRSSFeed) withObject:nil];
        
        
    }
        
    } else {
        
        NSData* cachedFeed = [[NSUserDefaults standardUserDefaults] valueForKey:@"labertascheFeed"];
        if (cachedFeed) {
            blogEnclosures = [NSKeyedUnarchiver unarchiveObjectWithData:cachedFeed]; 
            [blogEnclosures retain];
        } else {
            blogEnclosures = [[NSMutableArray alloc] init];
            [MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeInfo
                                   title:@"Keine Daten"
                                subtitle:@"Es gibt weder Internet noch gespeicherte Daten"
                               hideAfter:7]; 
        }
        
    }
    
    //Erster Start
    int x = [[NSUserDefaults standardUserDefaults] integerForKey:@"tasche"];
    if( x == 1 )
    {}
    else
    {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"tasche"];
        [[NSUserDefaults standardUserDefaults]synchronize];	
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Willkommen" message:@"Das Taschencasts Team wünscht dir viel Spaß mit dieser App!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
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
}


- (void)moviePlaybackComplete:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
    [self.navigationController dismissMoviePlayerViewControllerAnimated];
    [moviePlayerController.view removeFromSuperview];
    [moviePlayerController release];
	NSLog(@"ended");
}

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
	NSMutableString *episodeTitle = [[[NSMutableString alloc] initWithString:[[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"title"]]autorelease];
	if ([episodeTitle hasPrefix: @"Kultradio"]) {
		episodeTitle  = [NSMutableString stringWithString:[episodeTitle substringFromIndex:10]];
	}
    
    
	
	NSString *searchForMe = @".m4v";
	NSRange range = [[blogEnclosures objectAtIndex:indexPath.row] rangeOfString : searchForMe];
	if (range.location != NSNotFound) {
        
		CGRect myImageRect = CGRectMake(290, 11, 20, 20);
		UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
		[myImage setImage:[UIImage imageNamed:@"video.png"]];
		myImage.opaque = YES; // explicitly opaque for performance
        
		[cell addSubview:myImage];
		[myImage release];
	}
	
	cell.textLabel.text = episodeTitle;
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	NSString *feedDateString = [[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"pubDate"];
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
	[detailText appendString:[[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"itunes:duration"]];
    
	cell.detailTextLabel.text = detailText;
	
	
	[inputFormatter release];
	[outputFormatter release];
	
	
	
	//[[blogEntries objectAtIndex: blogEntryIndex] objectForKey: @"pubDate"];
    
	//UIImage *thumbnail = [UIImage imageNamed:@"cover.png"];
	//cell.imageView.image = thumbnail;
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:indexPath.row]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
    NSLog(@"%@", localURL);
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor clearColor];
	if (indexPath.row%2==1)cell.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2f];
	tableView.separatorColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2f];;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // delete the box
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:indexPath.row]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    //NSLog(@"%@", lastURLComponent);                 
    
    
    NSString* filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:lastURLComponent];
    [allContent beginUpdates]; 
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
        }
        
        
    }       
    [allContent endUpdates];
    [allContent reloadData];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentlySelectedCast = indexPath.row;
    
    
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:currentlySelectedCast]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"Laden oder Streamen" message:@"Du kannst diese Folge Streamen oder sie auf denem Device speichern" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Laden",@"Streamen", nil];
        [alert show];
        
        
    } if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        // NSLog(@"Local URL = %@",fileName);
        [self playLocalMovie:fileName];               
    }       
}
    
    



// When the movie is done,release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification { 
    //[[aNotification object] release];
     MPMoviePlayerController* theMovie=[aNotification object];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
     [theMovie release];
}

#pragma mark -
#pragma mark Alert Delegate Stream & Download

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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
}

- (void) streamCastNumber:(int)number {
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:number]];
    NSLog(@"%@",url);
    MPMoviePlayerViewController * movieView;
    movieView = [[MPMoviePlayerViewController alloc] initWithContentURL: url];
    
    
    MPMoviePlayerController * theMovie = [movieView moviePlayer];
    [theMovie retain];
    theMovie.scalingMode = MPMovieScalingModeAspectFit;
    theMovie.fullscreen = TRUE;
    theMovie.controlStyle = MPMovieControlStyleFullscreen;
    theMovie.shouldAutoplay = TRUE;
    
    
    //theMovie.view.hidden = YES;
    
    [self presentMoviePlayerViewControllerAnimated:movieView];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(myMovieFinishedCallback:)
                                                 name: MPMoviePlayerPlaybackDidFinishNotification
                                               object: theMovie];
    
}

- (void) downloadCastNumber:(int)number {
    
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeInfo
                           title:@"Apfeltasche"
                        subtitle:@"Die Apfeltasche wird geladen bitte warte einen Augenblick!"
                       hideAfter:6];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[blogEnclosures objectAtIndex:number]]];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
    
    
}

- (void) playLocalMovie:(NSString *)filename {
    
        
       
    NSURL* url = [NSURL fileURLWithPath:filename];
    
    NSLog(@"%@",filename); 
    NSLog(@"%@",url);
    
    
    MPMoviePlayerViewController * movieView;
    movieView = [[MPMoviePlayerViewController alloc] initWithContentURL: url];
    
    
    MPMoviePlayerController * theMovie = [movieView moviePlayer];
    [theMovie retain];
    theMovie.scalingMode = MPMovieScalingModeAspectFit;
    theMovie.fullscreen = TRUE;
    theMovie.controlStyle = MPMovieControlStyleFullscreen;
    theMovie.shouldAutoplay = TRUE;
    
    
    //theMovie.view.hidden = YES;
    
    [self presentMoviePlayerViewControllerAnimated:movieView];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(myMovieFinishedCallback:)
                                                 name: MPMoviePlayerPlaybackDidFinishNotification
                                               object: theMovie];
    
}

#pragma mark -
#pragma mark Memory management


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    
    NSURL *url = [NSURL URLWithString:[blogEnclosures objectAtIndex:currentlySelectedCast]];
    NSArray* array = [url pathComponents];
    NSString* lastURLComponent = [array objectAtIndex:array.count -1];
    
    
    NSString* localURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [localURL stringByAppendingPathComponent:lastURLComponent];
    NSLog(@"%@", localURL);
    
    [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    file = [[NSFileHandle fileHandleForUpdatingAtPath:fileName] retain];
    
    if (file) {
        [file seekToEndOfFile];
    }
    bytesExprected = [response expectedContentLength];
    [progressHUD show:YES];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
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
    

    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection { 
    NSLog(@"fertig");
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeInfo
                           title:@"Apfeltasche"
                        subtitle:@"Die Folge wurde erfolgreich runtergeladen !"
                       hideAfter:6];
    [file closeFile];
    
    [progressHUD hide:YES];
    [allContent reloadData];
    
    
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    
    
}

- (void)share:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/de/podcast/labertasche/id412309081"];
	SHKItem *item = [SHKItem URL:url title:@"Die Labertasche"];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showInView:self.view];
}



@end

