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

@interface SpellingViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *entryTF;
@property (nonatomic, strong) NIKWordObject *word;
@property (nonatomic, strong) NSArray *definitions;
@property (nonatomic, strong) NIKExample *example;
@property (nonatomic, strong) AVAudioPlayer *errorAudio;
@property (nonatomic, strong) AVAudioPlayer *correctAudio;
@end

@implementation SpellingViewController

#define kApiKey @"983709d18722cf7fea51f0e68d50bf5d8c0470461f01c312e"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.entryTF becomeFirstResponder];
    
    NSURL *errorURL = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"wav"];
    self.errorAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:errorURL error:nil];
    [self.errorAudio prepareToPlay];
    
    NSURL *correctURL = [[NSBundle mainBundle] URLForResource:@"correct" withExtension:@"m4a"];
    self.correctAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:correctURL error:nil];
    [self.correctAudio prepareToPlay];

    [self getRandomWord];
}

- (IBAction)skip:(id)sender {
    [self getRandomWord];
}

- (void)getRandomWord {
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

- (void)flashTextFieldRed {
    [self redTextField];
    [self performSelector:@selector(whiteTextField) withObject:nil afterDelay:0.05];
    [self performSelector:@selector(redTextField) withObject:nil afterDelay:0.10];
    [self performSelector:@selector(whiteTextField) withObject:nil afterDelay:0.15];
}

- (void)redTextField {
    self.entryTF.backgroundColor = [UIColor redColor];
    self.entryTF.textColor = [UIColor whiteColor];
}

- (void)whiteTextField {
    self.entryTF.backgroundColor = [UIColor whiteColor];
    self.entryTF.textColor = [UIColor blackColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([[textField.text lowercaseString] isEqualToString:[self.word.word lowercaseString]]) {
        textField.text = nil;
        [self.correctAudio play];
        [self.correctAudio prepareToPlay];
        
        [self performSelector:@selector(getRandomWord) withObject:nil afterDelay:2];
    } else {
        [self.errorAudio play];
        [self.errorAudio prepareToPlay];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self flashTextFieldRed];
    }
    return NO;
}

- (void)getDefinition {
    NIKWordApi *wordApi = [[NIKWordApi alloc] init];
    [wordApi addHeader:kApiKey forKey:@"api_key"];
    [wordApi getDefinitionsWithCompletionBlock:self.word.word partOfSpeech:nil sourceDictionaries:nil limit:nil includeRelated:nil useCanonical:nil includeTags:nil completionHandler:^(NSArray *definitions, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        } else {
            self.definitions = definitions;
//            for (NIKDefinition *defintion in definitions) {
//                NSLog(@"%@", [defintion asDictionary]);
//            }
        }
    }];
    [wordApi getTopExampleWithCompletionBlock:self.word.word useCanonical:nil completionHandler:^(NIKExample *example, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        } else {
            self.example = example;
            NSLog(@"%@", [example asDictionary]);
        }
    }];
}

- (void)speakWord {
    [self speakText:[NSString stringWithFormat:@"Your word is %@.", self.word.word]];
}

- (IBAction)example:(id)sender {
    [self speakText:self.example.text];
}

- (IBAction)partOfSpeech:(id)sender {
    NIKDefinition *definition = self.definitions.firstObject;
    [self speakText:definition.partOfSpeech];
}

- (IBAction)definition:(id)sender {
    NIKDefinition *definition = self.definitions.firstObject;
    [self speakText:[NSString stringWithFormat:@"Definition: %@.", definition.text]];
}

- (IBAction)repeat:(id)sender {
    [self speakText:self.word.word];
}

#define kSpeechSlowDownRate 5

- (void)speakText:(NSString *)text {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.rate = AVSpeechUtteranceMaximumSpeechRate / kSpeechSlowDownRate;
    [synthesizer speakUtterance:utterance];
}

- (NSArray *)loadWordList {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"latin" ofType:@"txt"];
    NSString *wordList = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [wordList componentsSeparatedByString:@"\n"];
}
@end
