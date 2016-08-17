//
//  ViewController.m
//  OC与JS交互之WebViewJavascriptBridge
//
//  Created by user on 16/8/17.
//  Copyright © 2016年 rrcc. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化bridge
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    //1 注册OC的方法给JS
    [self.bridge registerHandler:@"showMobile" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self showMsg:@"我是下面的小红 手机号是:18870707070"];
    }];
    [self.bridge registerHandler:@"showName" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *info = [NSString stringWithFormat:@"你好 %@, 很高兴见到你",data];
        [self showMsg:info];
    }];
    [self.bridge registerHandler:@"showSendMsg" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dict = (NSDictionary *)data;
        NSString *info = [NSString stringWithFormat:@"这是我的手机号: %@, %@ !!",dict[@"mobile"],dict[@"events"]];
        
        [self showMsg:info];
    }];
    
    //加载webView
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
}

- (void)showMsg:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

//2 调用JS注册给OC的方法
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 123) {
        [self.bridge callHandler:@"alertMobile"];
    }
    
    if (sender.tag == 234) {
        [self.bridge callHandler:@"alertName" data:@"小红"];
    }
    
    if (sender.tag == 345) {
        [self.bridge callHandler:@"alertSendMsg" data:@{@"mobile":@"18870707070",@"events":@"周末爬山真是件愉快的事情"}];
    }
}

@end
