//
//  VideoViewController.m
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import "VideoViewController.h"
#import "JVideoView.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    [self createVideoUI];
}

- (void)createVideoUI {
    CGSize size = self.view.frame.size;
    
    JVideoView *videoView = [[JVideoView alloc] initWithFrame:CGRectMake(0, 120, size.width, size.width * 0.6)];
    [self.view addSubview:videoView];
}

@end
