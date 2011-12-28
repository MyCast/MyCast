//
//  buden.m
//  Kult
//
//  Created by Daniel Büchele on 02.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "buden.h"
#import "BudenDetail.h"


@implementation buden


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
    
    
	NSString *json = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.kulturspektakel.de/api/buden.php"] encoding:NSUTF8StringEncoding error:nil];
    
    
	if ([json length] == 0) {
        
        //reading from cache
        NSString *cachedjson = [NSString stringWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"buden.json"] encoding:NSUTF8StringEncoding error:nil];
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		list = [[parser objectWithString:cachedjson error:nil] copy];
        [parser release];
        //[cachedjson release];
		
	}else {
        //writing to cache
        [json writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"buden.json"]
               atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		list = [[parser objectWithString:json error:nil] copy];
        [parser release];
		
	}
    
    [json release];
    
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
    return [list count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [[list objectAtIndex:indexPath.row] objectForKey:@"name"];
	
    return cell;
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
	BudenDetail *nextController = [[BudenDetail alloc] initWithNibName:@"BudenDetail" bundle:nil];
	[self.navigationController pushViewController:nextController animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[nextController setList:[[list objectAtIndex:indexPath.row] objectForKey:@"products"]];
	[nextController setTitle:[[list objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [nextController release];
}


#pragma mark -
#pragma mark Memory management

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


@end

