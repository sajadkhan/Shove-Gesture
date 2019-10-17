//
//  ShoveGestureRecognizer.m
//  tangram
//
//  Created by Muhammad Sajad on 19/08/2016.
//
//

#define RECOGNIZABLE_VERTICAL_GAP   100
#define RECOGNIZABLE_HORIZONTAL_GAP  70

#import "ShoveGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface ShoveGestureRecognizer()
@property (nonatomic) float lastTouchPoint;
@property (nonatomic) float startingPoint;

@end
@implementation ShoveGestureRecognizer

- (NSArray*)arrayFromSet:(NSSet<UITouch *> *)touches {
    NSEnumerator *enumerator = [touches objectEnumerator];
    return enumerator.allObjects;
}

- (BOOL)shouldRecognize:(NSSet<UITouch *> *)touches {
    NSArray *touchesArr = [self arrayFromSet:touches];
    
    UITouch *firstTouch = touchesArr[0];
    UITouch *secondTouch = touchesArr[1];
    
    UIView *view = firstTouch.view;
    CGPoint firstTouchLocation = [firstTouch locationInView:view];
    CGPoint secondTouchLocation = [secondTouch locationInView:view];
    
    float verOffset = fabs(firstTouchLocation.y - secondTouchLocation.y);
    float horOffset = fabs(firstTouchLocation.x - secondTouchLocation.x);
    
   // NSLog(@"finger vertical offset for shove gesture %f", verOffset);
   // NSLog(@"finger horizontal offset for shove gesture %f", horOffset);
    
    return  verOffset < RECOGNIZABLE_VERTICAL_GAP && horOffset > RECOGNIZABLE_HORIZONTAL_GAP;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"Shove touches begin:%lu", (unsigned long)touches.count);
    self.verticalTranslation = 0.0;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    //NSLog(@"Shove touches moved:%lu", (unsigned long)touches.count);
    
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        
        if (touches.count == 2 ) {
            
            NSArray *touchesArr = [self arrayFromSet:touches];
            
            UITouch *firstTouch = touchesArr[0];
            UITouch *secondTouch = touchesArr[1];
            
            UIView *view = firstTouch.view;
            CGPoint firstTouchLocation = [firstTouch locationInView:view];
            CGPoint secondTouchLocation = [secondTouch locationInView:view];
            
            CGPoint firstTouchPrevLocation = [firstTouch previousLocationInView:view];
            CGPoint secondTouchPrevLocation = [secondTouch previousLocationInView:view];
            
            float firstFingerDisY = firstTouchLocation.y - firstTouchPrevLocation.y;
            float secondFingerDisY = secondTouchLocation.y - secondTouchPrevLocation.y;
            
            
            if ((firstFingerDisY > 0 && secondFingerDisY > 0) || (firstFingerDisY < 0 && secondFingerDisY < 0)) {
                self.displacement = firstTouchLocation.y - self.lastTouchPoint;
                self.lastTouchPoint = firstTouchLocation.y;
                self.verticalTranslation += self.displacement;
            }
            
            else {
                self.displacement = 0.0;
            }
            
            self.state = UIGestureRecognizerStateChanged;
            //NSLog(@"Shove State Change:%d", touches.count);
            
            //NSLog(@"Gesture update to : %f", firstTouchLocation.y);
            //NSLog(@"displacement : %f", self.displacement);
        }
        else {
            //NSLog(@"Changed but do nothing");
            self.displacement = 0.0;
        }
    }
    
    else {
        
        if (touches.count == 2 ) {
            // NSLog(@"Shove State Possible/Start:%d", touches.count);
            BOOL isRecognizable = [self shouldRecognize:touches];
            if (!isRecognizable) {
                //NSLog(@"Not recognizable Failed");
                self.state = UIGestureRecognizerStateFailed;
            }
            else {
                //NSLog(@"Recognizable");
                
                NSArray *touchesArr = [self arrayFromSet:touches];
                
                UITouch *firstTouch = touchesArr[0];
                UITouch *secondTouch = touchesArr[1];
                
                UIView *view = firstTouch.view;
                CGPoint firstTouchLocation = [firstTouch locationInView:view];
                CGPoint secondTouchLocation = [secondTouch locationInView:view];
                
                CGPoint firstTouchPrevLocation = [firstTouch previousLocationInView:view];
                CGPoint secondTouchPrevLocation = [secondTouch previousLocationInView:view];
                
                float firstFingerDisY = firstTouchLocation.y - firstTouchPrevLocation.y;
                float secondFingerDisY = secondTouchLocation.y - secondTouchPrevLocation.y;
                
                float firstFingerDisX = firstTouchLocation.x - firstTouchPrevLocation.x;
                float secondFingerDisX = secondTouchLocation.x - secondTouchPrevLocation.x;
                
                //NSLog(@"First touch horizontal displacent:%f", firstFingerDisX);
                //NSLog(@"Second touch horizontal displacent:%f", secondFingerDisX);
                
                //NSLog(@"First touch vertical displacent:%f", firstFingerDisY);
                //NSLog(@"Second touch vertical displacent:%f", secondFingerDisY);
                
                
                if (fabs(firstFingerDisX) > 5 || fabs(secondFingerDisX) > 5) {
                    self.state = UIGestureRecognizerStateFailed;
                    //NSLog(@"Shove State Failed Due to hor motion:%lu", (unsigned long)touches.count);
                }
                
                else if (firstFingerDisY == 0 || secondFingerDisY == 0) {
                    //NSLog(@"Shove State possible as vertical displacement 0");
                    self.state = UIGestureRecognizerStatePossible;
                }
                    
                
                else if (((firstFingerDisY > 0 && secondFingerDisY > 0) || (firstFingerDisY < 0 && secondFingerDisY < 0)) &&
                         ((fabs(firstFingerDisY)) > 2 && (fabs(secondFingerDisY)) > 2)) {
                    self.displacement = 0.0;
                    self.verticalTranslation = 0.0;
                    
                    NSArray *touchesArr = [self arrayFromSet:touches];
                    UITouch *firstTouch = touchesArr[0];
                    UIView *view = firstTouch.view;
                    CGPoint firstTouchLocation = [firstTouch locationInView:view];
                    //NSLog(@"Gesture started at : %f", firstTouchLocation.y);
                    self.lastTouchPoint = firstTouchLocation.y;
                    self.startingPoint = firstTouchLocation.y;
                    self.state = UIGestureRecognizerStateBegan;
                    
                    //NSLog(@"Shove State Began:%d", touches.count);
                }
                
                else {
                    self.state = UIGestureRecognizerStateFailed;
                    //NSLog(@"Shove State Failed due to ver motion:%lu", (unsigned long)touches.count);
                }
            }

        }
        else {
            self.state = UIGestureRecognizerStatePossible;
             //NSLog(@"Shove State Possible:%d", touches.count);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Shove touches ended\n---------------------------\n-----------------------------");
    [super touchesEnded:touches withEvent:event];
    self.state = fabs(self.verticalTranslation) > 0.0 ? UIGestureRecognizerStateEnded :UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Shove touches cancelled");
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}

-(void)reset {
    [super reset];
    self.state = UIGestureRecognizerStatePossible;
    //NSLog(@"Reset");
}



@end
