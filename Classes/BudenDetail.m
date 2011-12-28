//
//  BudenDetail.m
//  Kult
//
//  Created by Daniel Büchele on 03.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BudenDetail.h"


@implementation BudenDetail


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    
	
	NSArray *price = [[[list objectAtIndex:indexPath.row] objectForKey:@"price"] componentsSeparatedByString:@","];
	int yellow = 0;
	int red = 0;
	if ([price count]>1) {if ([[price objectAtIndex:1] intValue] == 5) {yellow++;}}
	if ([[price objectAtIndex:0] intValue]%2 == 1) yellow=yellow+2;
	red = [[price objectAtIndex:0] intValue]/2;
	int start = 290;
	
	if (red+yellow>4) {
		

		CGRect myImageRect = CGRectMake(start, 11, 20, 20);
		UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
		[myImage setImage:[UIImage imageNamed:@"red.png"]];
		myImage.opaque = YES; // explicitly opaque for performance
		[cell addSubview:myImage];
		[myImage release];
		start = start-20;

		if (red > 1) {
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(start, 11, 20, 20)];
			lbl.textAlignment = UITextAlignmentRight;
			lbl.textColor = [UIColor darkGrayColor];
			lbl.text = [NSString stringWithFormat:@"%dx", red];
			[cell addSubview:lbl];
            [lbl release];
			start = start-20;
		}
		
		if (yellow > 0) {
			CGRect myImageRect = CGRectMake(start, 11, 20, 20);
			UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
			[myImage setImage:[UIImage imageNamed:@"yellow.png"]];
			myImage.opaque = YES; // explicitly opaque for performance
			[cell addSubview:myImage];
			[myImage release];
			start = start-20;
			
			if (yellow > 1) {
				UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(start, 11, 20, 20)];
				lbl.textAlignment = UITextAlignmentRight;
				lbl.textColor = [UIColor darkGrayColor];
				lbl.text = [NSString stringWithFormat:@"%dx", yellow];
				[cell addSubview:lbl];
                [lbl release];
				//start = start-20;	
			}
		}
		
		
		
	} else {
		
		
		
		for (int i=0; i<red; i++) {
			CGRect myImageRect = CGRectMake(start, 11, 20, 20);
			UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
			[myImage setImage:[UIImage imageNamed:@"red.png"]];
			myImage.opaque = YES; // explicitly opaque for performance
			[cell addSubview:myImage];
			[myImage release];
			start = start-20;
			
		}
		for (int i=0; i<yellow; i++) {
			CGRect myImageRect = CGRectMake(start, 11, 20, 20);
			UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
			[myImage setImage:[UIImage imageNamed:@"yellow.png"]];
			myImage.opaque = YES; // explicitly opaque for performance
			[cell addSubview:myImage];
			[myImage release];
			start = start-20;
			
		}
		

		
	}
	

	
	
	
	
	
    // Configure the cell...
    cell.textLabel.text = [[list objectAtIndex:indexPath.row] objectForKey:@"productname"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Angebot";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor whiteColor];
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


- (void)setList:(NSArray *)lister {
	list = lister;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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

