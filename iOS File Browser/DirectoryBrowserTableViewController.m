//
//  DirectoryBrowserTableViewController.m
//  DirectoryBrowser
//
//  Created by Marek Bell on 22/09/2011.
//  Copyright (c) 2011 Marek Bell. All rights reserved.
//

#import "DirectoryBrowserTableViewController.h"

@interface DirectoryBrowserTableViewController() 

@property (retain) NSArray *files;

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *file = [self.files objectAtIndex:indexPath.row];
	NSString *path = [self pathForFile:file];
	if ([self fileIsDirectory:file]) {
		DirectoryBrowserTableViewController *dbtvc = [[DirectoryBrowserTableViewController alloc] init];
		dbtvc.path = path;
		[self.navigationController pushViewController:dbtvc animated:YES];
	} else {
		MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
		[mcvc setSubject:@"DirectoryBrowser File"];
		[mcvc setMessageBody:[NSString stringWithFormat:@"File %@ from DirectoryBrowser is attached", file] isHTML:NO];
		mcvc.mailComposeDelegate = self;
		NSString *ext = [file pathExtension];
		NSData *data = [NSData dataWithContentsOfFile:path];
		[mcvc addAttachmentData:data mimeType:ext fileName:file];
		[self presentModalViewController:mcvc animated:YES];
	}
}

@end
