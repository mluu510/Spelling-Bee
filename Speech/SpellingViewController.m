//
//  SpellingViewController.m
//  Speech
//
//  Created by Minh Luu on 4/20/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "SpellingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SpellingViewController ()

@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSString *randomWord;
@end

@implementation SpellingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load word list
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"latin" ofType:@"txt"];
    NSString *wordList = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.words = [wordList componentsSeparatedByString:@"\n"];
    
    // Pick a random word
    int randomIndex = arc4random() % self.words.count;
    self.randomWord = [self.words objectAtIndex:randomIndex];
    NSLog(@"%@", self.randomWord);
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Your word is %@.", self.randomWord]];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 4;
    [synthesizer speakUtterance:utterance];
    
    
    
}

- (IBAction)repeat:(id)sender {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.randomWord];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 4;
    [synthesizer speakUtterance:utterance];
}

@end
