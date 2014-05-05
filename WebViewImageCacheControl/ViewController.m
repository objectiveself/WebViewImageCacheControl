//
//  ViewController.m
//  WebViewImageCacheControl
//
//  Created by Florin Pop on 5/5/14.
//  Copyright (c) 2014 ObjectiveSelf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UISwitch *switchCache;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self clearTemporaryImageCache];
    
    NSNumber *cacheDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"WebKitDiskImageCacheEnabled"];
    self.switchCache.on = cacheDefault ? [cacheDefault boolValue] : YES;
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.its.swinburne.edu.au/about/projects/templates/TechnicalSpecificationTemplatev1.1-[ProjectName]-[ver]-[YYYYMMDD].docx"]]];
    
    
}

- (IBAction)switchDidChange:(UISwitch*)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:self.switchCache.isOn forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (IBAction)buttonClearCacheSelected:(id)sender {
    
    [self clearTemporaryImageCache];
}

- (IBAction)buttonRefreshSelected:(id)sender {
    
    [self.webView reload];
}

- (void)clearTemporaryImageCache {
    NSArray *temporaryItems = [self temporaryImageCacheItems];
    
    for (NSString *temporaryItem in temporaryItems)
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:temporaryItem error:&error];
        
        if (error)
        {
            NSLog(@"Cannot delete item: %@. Reason: %@", temporaryItem, [error localizedDescription]);
        }
    }
}

- (NSArray*)temporaryImageCacheItems {
    NSError *error;
    NSArray *temporaryItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
    if (error)
    {
        NSLog(@"Cannot get contents of temporary directory. Reason: %@", [error localizedDescription]);
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *temporaryItem in temporaryItems)
    {
        if ([temporaryItem rangeOfString:@"DiskImageCache-"].location == 0)
        {
            [result addObject:[NSTemporaryDirectory() stringByAppendingPathComponent:temporaryItem]];
        }
    }
    
    return [NSArray arrayWithArray:result];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.labelInfo.text = [NSString stringWithFormat:@"Did receive memory warning!\nFound image cache on disk: %@.", [self temporaryImageCacheItems].count ? @"Yes" : @"No"];
}

@end
