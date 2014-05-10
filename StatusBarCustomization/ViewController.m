//
//  ViewController.m
//  StatusBarCustomization
//
//  Created by Kent Sutherland on 5/8/14.
//  Copyright (c) 2014 Kent Sutherland. All rights reserved.
//

#import "ViewController.h"
#import "XCDFakeCarrier.h"

@interface ViewController () {
    BOOL _prefersStatusBarHidden;
}

@end

@implementation ViewController

- (IBAction)changeWiFi:(id)sender
{
    [XCDFakeCarrier setWiFiStrength:[sender selectedSegmentIndex]];
    
    [self updateStatusBar];
}

- (IBAction)changeCellSignal:(id)sender
{
    [XCDFakeCarrier setCellStrength:[sender selectedSegmentIndex] - 1];
    
    [self updateStatusBar];
}

- (IBAction)changeNetworkType:(id)sender
{
    NSInteger type[] = {5, 4, 2, 3, 7};
    
    [XCDFakeCarrier setNetworkType:type[[sender selectedSegmentIndex]]];
    
    [self updateStatusBar];
}

- (IBAction)changeRandom:(id)sender
{
    [XCDFakeCarrier setEnabled:arc4random_uniform(2) atIndex:arc4random_uniform(25)];
    
    [self updateStatusBar];
}

- (IBAction)changeColor:(id)sender
{
    [[self view] setBackgroundColor:[UIColor colorWithHue:(CGFloat)arc4random_uniform(100) / 100 saturation:1.0 brightness:1.0 alpha:1.0]];
}

- (void)updateStatusBar
{
    _prefersStatusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    _prefersStatusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return _prefersStatusBarHidden;
}

@end
