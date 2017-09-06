//
//  KDAlertView.m
//  KDTools
//
//  Created by 斌 on 15/11/19.
//  Copyright © 2015年 斌. All rights reserved.
//

#import "KDAlertView.h"
#import "KDAnimation.h"
#define kMaxWidth ([[UIScreen mainScreen] bounds].size.width - 45)


@implementation KDAlertView{
    UILabel *messageLbl;
}

+ (void)showAlertInViewCtrl:(UIViewController *)viewCtrl title:(NSString *)title message:(NSString *)message buttonItems:(NSArray *)btnItems{

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        for (NSString *btnTitle in btnItems) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
        }
        
        [viewCtrl presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        
        for (NSString *btnTitle in btnItems) {
            
            [alert addButtonWithTitle:btnTitle];

        }
        
        [alert show];
        
    }
}

#pragma mark -
+ (void)alertWithMessage:(NSString *)message{
    
    [self alertWithMessage:message location:KDAlertViewShowLocDefault];
}

+ (void)alertWithMessage:(NSString *)message location:(KDAlertViewShowLoc)location{
    
    static UIWindow *tmpWindow;
    tmpWindow = [[UIWindow alloc] init];
    [tmpWindow makeKeyAndVisible];
    [tmpWindow setBackgroundColor:[UIColor clearColor]];
    [tmpWindow setFrame:[[UIScreen mainScreen] bounds]];
    tmpWindow.hidden = NO;
    
    
    KDAlertView *alertView;
    for (UIView *tmpView in tmpWindow.subviews) {
        
        if ([tmpView isKindOfClass:[KDAlertView class]]) {
            alertView = (KDAlertView *)tmpView;
        }
    }
    
    if (!alertView) {
        alertView = [[KDAlertView alloc]initWithMessage:message location:location];
        [tmpWindow addSubview:alertView];
    }else{
        [alertView setMessage:message location:location];
    }
    
    [self performSelector:@selector(hide:) withObject:tmpWindow afterDelay:2];
    
}

+ (void)hide:(UIWindow *)window{
    [UIView animateWithDuration:0.3 animations:^(void){
        window.alpha = 0;
    }completion:^(BOOL finished) {
        [window removeFromSuperview];
    }];
}

#pragma mark -
- (void)alertWithMessage:(NSString *)message inView:(UIView *)view{
    
    [view addSubview:self];
    [self setMessage:message location:KDAlertViewShowLocTop];
    
    [self performSelector:@selector(hideMsg) withObject:nil afterDelay:2];
    
}

- (void)hideMsg{
    [UIView animateWithDuration:0.3 animations:^(void){
        [self removeFromSuperview];
    }];
}


#pragma mark -
- (id)initWithMessage:(NSString *)message{
    
    self = [super init];
    if (self) {
        [self setMessage:message location:KDAlertViewShowLocDefault];
    }
    return self;
}

- (id)initWithMessage:(NSString *)message location:(KDAlertViewShowLoc)location{
    
    self = [super init];
    if (self) {
        [self setMessage:message location:location];
    }
    return self;
}

- (void)setMessage:(NSString *)message location:(KDAlertViewShowLoc)location{

    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObject:
                                   [UIFont systemFontOfSize:16.0f] forKey:NSFontAttributeName];
    
    CGSize size = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.00)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:tmpDic
                                        context:nil].size;
    
    if (size.width >= kMaxWidth) {
        
        size = [message boundingRectWithSize:CGSizeMake(kMaxWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:tmpDic
                                     context:nil].size;
    }
    
    if (!messageLbl) {
        messageLbl = [[UILabel alloc]init];
        messageLbl.font = [UIFont boldSystemFontOfSize:15.0f];
        messageLbl.textAlignment = NSTextAlignmentLeft;
        messageLbl.numberOfLines = 0;
        messageLbl.backgroundColor = [UIColor clearColor];
        messageLbl.textColor = [UIColor whiteColor];
        messageLbl.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:messageLbl];
    }
    messageLbl.frame = CGRectMake(15, 10, size.width, size.height);
    messageLbl.text = message;
    
    
    float viewWidth = size.width + 30;
    float viewHeight = size.height + 20;
    float viewX = 0 ,viewY = 0;
    
    viewX = [[UIScreen mainScreen] bounds].size.width/2-viewWidth/2;
    if (location == KDAlertViewShowLocDefault) {
        
        viewY = [[UIScreen mainScreen] bounds].size.height/2 - viewHeight/2 -20;
    
    }else if (location == KDAlertViewShowLocTop) {
    
        viewY = 25;
    
    }else if (location == KDAlertViewShowLocBottom){
    
        viewY = [[UIScreen mainScreen] bounds].size.height - viewHeight/2 - 49 - 30;
    }
    
    [self setFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setNeedsDisplay];
    
    [KDAnimation showAnimationWithView:self];

    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    

    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;

    CGFloat radius = (width + height) * 0.03;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, radius, 0);
    
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.75].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    

    
}


+ (CGAffineTransform)transform{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return   CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

@end
