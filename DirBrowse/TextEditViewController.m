//
//  TextEditViewController.m
//  DirBrowse
//
//  Created by marek on 18/06/2013.
//  Copyright (c) 2013 Dynamically Loaded. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSStringEncoding *usedEncoding;

@end

@implementation TextEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:_filepath];
    [[NSFileManager defaultManager] removeItemAtPath:_filepath error:&error];
    if (error) {
        NSLog(@"%@", error);
        error = nil;
    }
    self.textView.text = [NSString stringWithFormat:@"%@", d];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    NSError *error = nil;
    [self.textView.text writeToFile:_filepath atomically:YES encoding:*self.usedEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
