//
//  HFBaseViewController.m
//  HFFrame
//
//  Created by jason on 12-10-20.
//  Copyright (c) 2012年 jason. All rights reserved.
//


/*********** 正则代码块******************
NSString *email = @"13068319870609101X";
bool ye =[email isMatchedByRegex:@""];
 *************************************/



#import "HFBaseViewController.h"
#import "RegexKitLite.h"

//!!! 设置tab 样式
static inline void setUITabBarStyle (UITabBarController *tabBar)
{
    for(UIView *view in tabBar.tabBar.subviews)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"teb.png"]]autorelease];
    imageView.width = tabBar.tabBar.width;
    imageView.height = tabBar.tabBar.height;
    [tabBar.tabBar insertSubview:imageView  atIndex:0];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5"))
    {
        [tabBar.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
        UIImage *img = [UIImage imageNamed:@"tab_bg.png"];
        UIImage *img1 = [img imageByScalingToSize:CGSizeMake(imageView.width/[[tabBar viewControllers]count],imageView.height)];
        [tabBar.tabBar setSelectionIndicatorImage:img1];
    }
}


@interface HFBaseViewController ()

@end




@implementation HFBaseViewController
@synthesize titleLabel,hfClient;

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self toSetTitleLable];
    
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];    
//    NSString *path = [NSString stringWithFormat:@"myapipath/?value=%@", value];
   
//    [[client operationQueue]cancelAllOperations];
}
#pragma mark  - 设置title

-(HFHttpRequest *)hfClient
{
    if (!hfClient) {
        self.hfClient = [HFHttpRequest client];
    }
    return hfClient;
}

-(void) toSetTitleLable
{
    if (!titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:self.navigationController.navigationBar.frame] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
        titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor]; // change this color
        [titleLabel setAutoresizingMask:UIViewAutoresizingNone ];
        self.navigationItem.titleView = titleLabel;

    }
}
-(void)setTitle:(NSString *)title
{
    if (title)
    {
        self.titleLabel.text = title;
    }
}

-(NSString*)title
{
    return self.titleLabel.text;
}


-(void)buttonIndexClick
{
    NSLog(@"clicked");
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    NSLog(@"su button %d",buttonIndex);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[hfClient operationQueue]cancelAllOperations];
    RELEASE_SAFELY(titleLabel);
    RELEASE_CF_SAFELY(hfClient);
    [super dealloc];
}

@end
