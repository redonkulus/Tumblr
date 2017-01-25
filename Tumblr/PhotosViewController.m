//
//  ViewController.m
//  Tumblr
//
//  Created by Seth Bertalotto on 1/25/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "PhotosViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PhotoCell.h"
#import "PhotoDetailsViewController.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *photoTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoTableView.dataSource = self;
    self.photoTableView.delegate = self;
    self.photoTableView.rowHeight = 320;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.photoTableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchMovies];
}

- (void)fetchMovies
{
    NSString *apiKey = @"Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV";
    NSString *urlString =
    [@"http://api.tumblr.com/v2/blog/nba.tumblr.com/posts/photo?api_key=" stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    //NSLog(@"Response: %@", responseDictionary);
                                                    
                                                    NSArray *posts = responseDictionary[@"response"][@"posts"];
                                                    self.posts = posts;
                                                    
                                                    // update table with data
                                                    [self.photoTableView reloadData];
                                                    [self.refreshControl endRefreshing];
                                                    
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    NSDictionary *photo = [self.posts objectAtIndex:indexPath.row];
    
    // author
    cell.authorName.text = [photo objectForKey:@"blog_name"];
    
    // photo
    NSArray *photoData = photo[@"photos"];
    NSDictionary *photoOptions = [photoData firstObject];

    NSURL *photoUrl = [NSURL URLWithString:photoOptions[@"original_size"][@"url"]];
    NSLog(@"photo url: %@", photoUrl);
    cell.photoImage.contentMode = UIViewContentModeScaleAspectFill;
    [cell.photoImage setImageWithURL:photoUrl];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.photoTableView deselectRowAtIndexPath:indexPath animated:true];
}

// grab selected table view and pass model to destination controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.photoTableView indexPathForSelectedRow];
    PhotoDetailsViewController *photoDetailsViewController = segue.destinationViewController;
    
    NSDictionary *photo = [self.posts objectAtIndex:indexPath.row];

    // get photo url
    NSArray *photoData = photo[@"photos"];
    NSDictionary *photoOptions = [photoData firstObject];
    NSURL *photoUrl = [NSURL URLWithString:photoOptions[@"original_size"][@"url"]];

    photoDetailsViewController.photoUrl = photoUrl;
}


@end
