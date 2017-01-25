//
//  PhotoDetailsViewController.m
//  Tumblr
//
//  Created by Seth Bertalotto on 1/25/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.photoImageView setImageWithURL:self.photoUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
