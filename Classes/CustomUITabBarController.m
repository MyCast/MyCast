// CustomUITabBarController.m

#import "CustomUITabBarController.h"

@implementation CustomUITabBarController

@synthesize tabBar1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48);
    
    UIView *v = [[UIView alloc] initWithFrame:frame];
    
    [v setBackgroundColor:[[UIColor alloc] initWithRed:1.0
                                                 green:0.0
                                                  blue:0.0
                                                 alpha:0.1]];
    
    [tabBar1 insertSubview:v atIndex:0];
    [v release];
}

@end