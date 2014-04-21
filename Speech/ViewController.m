//
//  ViewController.m
//  Speech
//
//  Created by Minh Luu on 4/20/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVSpeechUtterance *utterance;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Wow, I have such a nice voice!"];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 2;
    [synthesizer speakUtterance:utterance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
