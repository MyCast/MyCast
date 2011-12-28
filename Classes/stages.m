//
//  stages.m
//  Kult
//
//  Created by Daniel Büchele on 27.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "stages.h"
#import "NextViewController.h"


@implementation stages



- (void) segmentAction:(id)sender {
	[self.tableView reloadData];
}

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
	/*
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	Reachability* internetReachable = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachable startNotifier];
	// check if a pathway to a random host exists
	Reachability* hostReachable = [[Reachability reachabilityWithHostName: @"kulturspektakel.de"] retain];
	[hostReachable startNotifier];
	*/
	// segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
								   NSLocalizedString(@"Freitag", @""),
								   NSLocalizedString(@"Samstag", @""),
								   NSLocalizedString(@"Sonntag", @""),
								   nil];
	control = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	control.selectedSegmentIndex = 0;
	control.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	control.segmentedControlStyle = UISegmentedControlStyleBar;
	control.frame = CGRectMake(0, 0, 400, 30);
	[control addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = control;
	//[control release];
	
	
	
	NSString *json = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://kulturspektakel.de/api/stages.php?year=2010"] encoding:NSUTF8StringEncoding error:nil];
    
    
	if ([json length] == 0) {
        
        //reading from cache
        NSString *cachedjson = [NSString stringWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"stages.json"] encoding:NSUTF8StringEncoding error:nil];
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		list = [[parser objectWithString:cachedjson error:nil] copy];
        [parser release];
        //[cachedjson release];
		
	}else {
        //writing to cache
        [json writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"stages.json"]
               atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		list = [[parser objectWithString:json error:nil] copy];
        [parser release];
		
	}
    
    [json release];
    
    
    

	
	
}

- (NSString *)dataFilePath{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    return [documentsDirectory stringByAppendingPathComponent:@"stages.txt"];
	
}


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
	
	NSString *tag = [[NSString alloc] init];
	if ([control selectedSegmentIndex]==0) tag = @"freitag";
	else if ([control selectedSegmentIndex]==1) tag = @"samstag";
	else if ([control selectedSegmentIndex]==2) tag = @"sonntag";

	return [[list objectForKey:tag] count];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSString *tag = [[NSString alloc] init];
	if ([control selectedSegmentIndex]==0) tag = @"freitag";
	else if ([control selectedSegmentIndex]==1) tag = @"samstag";
	else if ([control selectedSegmentIndex]==2) tag = @"sonntag";

	return [[[[list objectForKey:tag] objectAtIndex:section] objectForKey:@"bands"] count];

    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	headerLabel.shadowColor = [UIColor blackColor];
	
	// If you want to align the header text as centered
	//headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	//headerLabel.text = titleForHeaderInSection(section);
	
	NSString *tag = [[NSString alloc] init];
	if ([control selectedSegmentIndex]==0) tag = @"freitag";
	else if ([control selectedSegmentIndex]==1) tag = @"samstag";
	else if ([control selectedSegmentIndex]==2) tag = @"sonntag";

	NSDictionary *bands = [[list objectForKey:tag] objectAtIndex:section];
    

    
	headerLabel.text =  [bands objectForKey:@"stagename"];
	
	[customView addSubview:headerLabel];
    //[headerLabel release];
    //[customView release];
	
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}

// Customize the appearance of table view cells.


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tag = [[NSString alloc] init];
	if ([control selectedSegmentIndex]==0) tag = @"freitag";
	else if ([control selectedSegmentIndex]==1) tag = @"samstag";
	else if ([control selectedSegmentIndex]==2) tag = @"sonntag";


	
	NSDictionary *bands = [[[[list objectForKey:tag] objectAtIndex:indexPath.section] objectForKey:@"bands"] objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellView"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableCellView" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }

    
	[cell setIndex:indexPath.row];
	[cell setLabelText:[bands objectForKey:@"bandname"]];
	[cell setDetailLabelText:[bands objectForKey:@"genre"]];
	[cell setAccessoryLabelText:[self formatDate:[bands objectForKey:@"time"]]];
	[cell setUhrzeit:[bands objectForKey:@"time"]];
	
	


	

	
	
    return cell;	
}


- (NSString *)formatDate:(NSString *)stringer {

	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *myDate = [df dateFromString:stringer];
	[df setDateFormat:@"HH:mm"];
	
    return [df stringFromDate:myDate];

}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *tag = [[NSString alloc] init];
	if ([control selectedSegmentIndex]==0) tag = @"freitag";
	else if ([control selectedSegmentIndex]==1) tag = @"samstag";
	else if ([control selectedSegmentIndex]==2) tag = @"sonntag";


	NSDictionary *bands = [[[[list objectForKey:tag] objectAtIndex:indexPath.section] objectForKey:@"bands"] objectAtIndex:indexPath.row];
	
	NextViewController *nextController = [[NextViewController alloc] initWithNibName:@"NextView" bundle:nil];
	
	[nextController setBandInfo:bands];
    [nextController setDay:tag];
	[nextController setStaging:[[[list objectForKey:tag] objectAtIndex:indexPath.section] objectForKey:@"stagename"]];

	[self.navigationController pushViewController:nextController animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}








- (void)dealloc {
    [super dealloc];
	[NextViewController release];

}


@end
