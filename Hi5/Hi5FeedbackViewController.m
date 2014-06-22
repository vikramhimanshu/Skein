//
//  Hi5FeedbackViewController.m
//  Hi5
//
//  Created by Himanshu Tantia on 6/5/14.
//
//

#import "Hi5FeedbackViewController.h"

@interface Hi5FeedbackViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (assign, nonatomic) BOOL isFormSubmitted;
@property (strong, nonatomic) UIActivityIndicatorView *loader;

@end

@implementation Hi5FeedbackViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPageAtPath:self.urlToLoad];
    self.isFormSubmitted = NO;
    self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loader setHidesWhenStopped:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loader];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.title = self.viewTitle;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.title = @"";
}

-(void)loadHTMLAtPath:(NSString *)urlString
{
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(@"%@",[NSString stringWithUTF8String:[htmlData bytes]]);
    [self.webview loadData:htmlData
                  MIMEType:@"html"
          textEncodingName:@"utf-8"
                   baseURL:nil];
}

-(void)loadPageAtPath:(NSString *)urlString
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webview loadRequest:urlRequest];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self loadPageAtPath:self.urlToLoad];
            break;
            
        default:
            
            break;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loader stopAnimating];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Load Error"
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok", nil];
    [errorAlert show];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    self.isFormSubmitted = (navigationType == UIWebViewNavigationTypeFormSubmitted);
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loader startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loader stopAnimating];
    if (self.isFormSubmitted) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
