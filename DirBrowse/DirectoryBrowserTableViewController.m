//
//  DirectoryBrowserTableViewController.m
//  DirectoryBrowser
//
//  Created by Marek Bell on 22/09/2011.
//  Copyright (c) 2011 Marek Bell. All rights reserved.
//

#import "DirectoryBrowserTableViewController.h"
#import "TextEditViewController.h"

@interface DirectoryBrowserTableViewController() 

@property (strong) NSArray *files;

@end

@implementation DirectoryBrowserTableViewController

@synthesize path = _path;
@synthesize files = _files;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 

- (NSString *)pathForFile:(NSString *)file {
	return [self.path stringByAppendingPathComponent:file];
}

- (BOOL)fileIsDirectory:(NSString *)file {
	BOOL isdir = NO;
	NSString *path = [self pathForFile:file];
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
	return isdir;
}

- (BOOL)fileIsPlist:(NSString *)file {
    return [[file.lowercaseString pathExtension] isEqualToString:@"plist"];
}

#pragma mark - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *path = @"/private/var/mobile/Library/Preferences/com.apple.Accessibility.plist";
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@", d);
    [super viewWillAppear:animated];
	if (!self.path)
		self.path = @"/";
	self.files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil];
	self.title = self.path;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditTextFileSegue"]) {
        NSString *f = sender;
        NSString *p = [self pathForFile:f];
        UINavigationController *nc = segue.destinationViewController;
        TextEditViewController *tevc = (TextEditViewController *)nc.topViewController;
        tevc.filepath = p;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
	
	NSString *file = [self.files objectAtIndex:indexPath.row];
	NSString *path = [self pathForFile:file];
	BOOL isdir = [self fileIsDirectory:file];
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
	
	cell.textLabel.text = file;
	cell.textLabel.textColor = isdir ? [UIColor blueColor] : [UIColor darkTextColor];
	cell.accessoryType = isdir ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

	NSString *ext = [[file pathExtension] lowercaseString];
	if ([ext isEqualToString:@"png"] || [ext isEqualToString:@"jpg"]) {
		UIImage *img = [UIImage imageWithContentsOfFile:path];
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		cell.imageView.image = img;
	} else {
		cell.imageView.image = nil;
	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *file = [self.files objectAtIndex:indexPath.row];
	NSString *path = [self pathForFile:file];
//	BOOL matchesAppPattern = NO;
//	if ([file length] > 23) {
//		if ([file characterAtIndex:8] == 45 && [file characterAtIndex:13] == 45 && [file characterAtIndex:18] == 45 && [file characterAtIndex:23] == 45) {
//			matchesAppPattern = YES;
//		}
////		unichar u = [file characterAtIndex:8];
////		NSLog(@"%d", u);
//	}
//	// 8 13 18 23
	// matching app pattern doesn't work, because the dir contents you cd into is always blank... must be the sandbox protection
	if ([self fileIsDirectory:file]) {
		DirectoryBrowserTableViewController *dbtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryBrowserTableViewController"];
		dbtvc.path = path;
		[self.navigationController pushViewController:dbtvc animated:YES];
//	} else if ([self fileIsPlist:file]) {
//        [self performSegueWithIdentifier:@"EditTextFileSegue" sender:file];
    } else {
        NSURL *url = [NSURL fileURLWithPath:path];
        
        UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        [self presentViewController:avc animated:YES completion:nil];
	}
}


@end
