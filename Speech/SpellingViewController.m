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
@property (nonatomic, strong) NIKWordObject *word;
@property (nonatomic, strong) NSArray *definitions;
@end

@implementation SpellingViewController

#define kApiKey @"983709d18722cf7fea51f0e68d50bf5d8c0470461f01c312e"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.entryTF becomeFirstResponder];

    // Get random word
    NIKWordsApi *wordsApi = [[NIKWordsApi alloc] init];
    [wordsApi addHeader:kApiKey forKey:@"api_key"];
    
    [wordsApi getRandomWordWithCompletionBlock:nil excludePartOfSpeech:nil hasDictionaryDef:@"true" minCorpusCount:nil maxCorpusCount:nil minDictionaryCount:nil maxDictionaryCount:nil minLength:@3 maxLength:nil completionHandler:^(NIKWordObject *word, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        } else {
            NSLog(@"Wordnik: %@", word.word);
            self.word = word;
            [self speakWord];
            [self getDefinition];
        }
    }];

}

- (void)getDefinition {
    NIKWordApi *wordApi = [[NIKWordApi alloc] init];
    [wordApi addHeader:kApiKey forKey:@"api_key"];
    [wordApi getDefinitionsWithCompletionBlock:self.word.word partOfSpeech:nil sourceDictionaries:nil limit:nil includeRelated:nil useCanonical:nil includeTags:nil completionHandler:^(NSArray *definitions, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        } else {
            self.definitions = definitions;
            for (NIKDefinition *defintion in definitions) {
                NSLog(@"%@", [defintion asDictionary]);
            }
        }
    }];
}

- (void)speakWord {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Your word is %@.", self.word.word]];
    utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4;
    [synthesizer speakUtterance:utterance];
}


- (IBAction)definition:(id)sender {
    NIKDefinition *definition = self.definitions.firstObject;
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Definition: %@.", definition.text]];
    utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4;
    [synthesizer speakUtterance:utterance];
}

- (NSArray *)loadWordList {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"latin" ofType:@"txt"];
    NSString *wordList = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [wordList componentsSeparatedByString:@"\n"];
}


- (IBAction)repeat:(id)sender {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.word.word];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 4;
    [synthesizer speakUtterance:utterance];
}

@end
