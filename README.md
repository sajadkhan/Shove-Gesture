# Shove-Gesture
A custom gesture recogniser to recognise tilt/shove gesture. (Moving two parallel fingers vertically)
## How to Use

### Add Gesture to your view while setting a selector which will be called when it recognized
```Objective-C
ShoveGestureRecognizer *shoveRecognizer = [[ShoveGestureRecognizer alloc] initWithTarget:self action:@selector(respondToShoveGesture:)];
    
shoveRecognizer.delegate = self;
[self.view addGestureRecognizer:shoveRecognizer];

- (void)respondToShoveGesture:(ShoveGestureRecognizer *)shoveRecognizer {
    float displacement = [shoveRecognizer displacement];
    float tilt;
    
    switch (shoveRecognizer.state) {
            
        case UIGestureRecognizerStateBegan:
            //Gesture Began
            
        case UIGestureRecognizerStateChanged:
            //Changed
            
        case UIGestureRecognizerStateEnded:
            /Ended
            
        default:
            break;
    }
    
}
```




