//
//  WordsTableViewController.m
//  Speech
//
//  Created by Minh Luu on 4/20/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "WordsTableViewController.h"

@interface WordsTableViewController ()

@property (nonatomic, strong) NSArray *words;
@end

@implementation WordsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load word list
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"latin" ofType:@"txt"];
    NSString *wordList = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.words = [wordList componentsSeparatedByString:@"\n"];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Word Cell"];
    NSString *word = [self.words objectAtIndex:indexPath.row];
    cell.textLabel.text = word;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
