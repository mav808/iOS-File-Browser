//
//  DirectoryBrowserTableViewController.h
//  DirectoryBrowser
//
//  Created by Marek Bell on 22/09/2011.
//  Copyright (c) 2011 Marek Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryBrowserTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
	
@private
	
	NSString *_path;
	
	NSArray *_files;
	
}

@property (retain) NSString *path;

@end
