//
//  LDUMainViewController.m
//  DynamicUtility
//
//  Created by Louis Franco on 9/29/13.
//  Copyright (c) 2013 Lou Franco. All rights reserved.
//

#import "LDUMainViewController.h"
#import "LDUSlideBehavior.h"

@interface LDUMainViewController ()

@end

@implementation LDUMainViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    
    return self;
}

-(void)addBodyView
{
    self.body = [[UIView alloc] initWithFrame:CGRectMake(155, 40, 10, 10)];
    self.body.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.body];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addBodyView];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(LDUFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(void)setUpDynamics
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
    [self.animator addBehavior:[[LDUSlideBehavior alloc] initWithItem:self.view]];
}

- (IBAction)onPan:(UIPanGestureRecognizer*)pan {
    static CGFloat startY;
    CGPoint delta = [pan translationInView:self.view.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        startY = self.view.center.y;
        [pan setTranslation:CGPointZero inView:pan.view.superview];
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat newY = self.view.center.y + delta.y;
        
        // detect a collision with the bottom
        if (newY > startY) {
            newY = startY;
        }
        // attach the pan to the view
        self.view.center = CGPointMake(self.view.center.x, newY);
        
        [pan setTranslation:CGPointZero inView:pan.view.superview];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        // gravity?
        [UIView animateWithDuration:.3 animations:^{
            self.view.center = CGPointMake(self.view.center.x, startY);
        }];
    }
}

- (IBAction)onSegmentChanged:(id)sender {
    if (self.uiStyleSegment.selectedSegmentIndex == 0) {
        self.panManualStyle.enabled = YES;
        [self.animator removeAllBehaviors];
        self.animator = nil;
    } else if (self.uiStyleSegment.selectedSegmentIndex == 1) {
        self.panManualStyle.enabled = NO;
        [self setUpDynamics];
    }
}

- (IBAction)onDemoGravity:(id)sender {
    [self onDemoGravity3:sender]; return;
    self.body.center = CGPointMake(160, 50);
    self.gravityAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.body]];
    [self.gravityAnimator addBehavior:gravityBehavior];
}

- (IBAction)onDemoGravity2:(id)sender {
    self.body.center = CGPointMake(160, 50);
    self.gravityAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.body]];
    [self.gravityAnimator addBehavior:gravityBehavior];
    
    UICollisionBehavior *viewIsBoundary = [[UICollisionBehavior alloc] initWithItems:@[self.body]];
    viewIsBoundary.translatesReferenceBoundsIntoBoundary = YES;
    [self.gravityAnimator addBehavior:viewIsBoundary];
}


- (IBAction)onDemoGravity3:(id)sender {
    self.body.center = CGPointMake(160, 50);
    self.body.transform = CGAffineTransformMakeRotation(M_PI/5.0);

    self.gravityAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.body]];
    [self.gravityAnimator addBehavior:gravityBehavior];
    
    UICollisionBehavior *viewIsBoundary = [[UICollisionBehavior alloc] initWithItems:@[self.body]];
    viewIsBoundary.translatesReferenceBoundsIntoBoundary = YES;
    [self.gravityAnimator addBehavior:viewIsBoundary];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.body]];
    itemBehavior.elasticity = .8;
    [self.gravityAnimator addBehavior:itemBehavior];
}



@end
