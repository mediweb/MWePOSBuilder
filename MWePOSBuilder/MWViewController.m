// Copyright (C) 2013 MediWeb, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MWViewController.h"
#import "MWePOSSDK.h"

@interface MWViewController ()
@property (strong, nonatomic) UITextField *ipAddressField;
@end

@implementation MWViewController
- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.ipAddressField = [[UITextField alloc] initWithFrame:CGRectMake(
    self.view.bounds.size.width / 2.0f - 70.0f,
    self.view.bounds.size.height / 2.0f - 49.0f,
    140.0f,
    30.0f
  )];
  self.ipAddressField.placeholder = NSLocalizedString(@"xxx.xxx.xxx.xxx", nil);
  self.ipAddressField.borderStyle = UITextBorderStyleLine;
  [self.view addSubview:self.ipAddressField];

  UIButton *printButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [printButton setTitle:NSLocalizedString(@"Print", nil) forState:UIControlStateNormal];
  [printButton addTarget:self action:@selector(printButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  printButton.frame = CGRectMake(
    self.view.bounds.size.width / 2.0f - 60.0f,
    self.view.bounds.size.height / 2.0f + 5.0f,
    120.0f,
    44.0f
  );
  [self.view addSubview:printButton];
}

- (void)printButtonPressed:(id)sender {
  NSString *ipAddressURLString = [NSString stringWithFormat:@"http://%@/cgi-bin/epos/service.cgi", self.ipAddressField.text];

  MWePOSBuilder *builder = [[MWePOSBuilder alloc] init];
  [builder addText:@"MWePOS Printer Test\n"];
  [builder addText:ipAddressURLString];
  [builder addCut:@"feed"];
  
  MWePOSPrint *printService = [[MWePOSPrint alloc]
    initWithPrinterURL:[NSURL URLWithString:ipAddressURLString]];
  [printService sendData:[builder printerData] completion:^(NSData *data, NSError *error){
    if (error) {
      NSLog(@"%@", error.localizedDescription);
    }
  }];
}
@end
