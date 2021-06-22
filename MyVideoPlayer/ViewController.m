//
//  ViewController.m
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import "ViewController.h"
#import "VideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onTapVideoPlay:(UIButton *)sender {
    VideoViewController *viewController = [[VideoViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:viewController];
    navc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navc animated:YES completion:nil];
}

@end
