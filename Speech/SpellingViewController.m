//
//  SpellingViewController.m
//  Speech
//
//  Created by Minh Luu on 4/20/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "SpellingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NIKWordApi.h"
#import "NIKWordsApi.h"

@interface SpellingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *entryTF;

@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSString *randomWord;
@end

@implementation SpellingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.entryTF becomeFirstResponder];
    
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
    
//    NIKWordApi *wordApi = [[NIKWordApi alloc] init];
//    [wordApi addHeader:@"983709d18722cf7fea51f0e68d50bf5d8c0470461f01c312e" forKey:@"api_key"];

    // Get random word
    NIKWordsApi *wordsApi = [[NIKWordsApi alloc] init];
    [wordsApi addHeader:@"983709d18722cf7fea51f0e68d50bf5d8c0470461f01c312e" forKey:@"api_key"];
    
    [wordsApi getRandomWordWithCompletionBlock:nil excludePartOfSpeech:nil hasDictionaryDef:@"yes" minCorpusCount:nil maxCorpusCount:nil minDictionaryCount:nil maxDictionaryCount:nil minLength:@3 maxLength:nil completionHandler:^(NIKWordObject *word, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Wordnik: %@", word.word);
        }
    }];
}

- (IBAction)repeat:(id)sender {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.randomWord];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 4;
    [synthesizer speakUtterance:utterance];
}

@end
