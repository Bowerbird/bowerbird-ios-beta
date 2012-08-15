/*
 Copyright (c) 2012 Simon B. Støvring. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@protocol BSKeyboardControlsDelegate;

/* Directions */
typedef enum
{
    KeyboardControlsDirectionPrevious,
    KeyboardControlsDirectionNext,
    KeyboardControlsDirectionSelected
} KeyboardControlsDirection;

@interface BSKeyboardControls : UIView

/*
 * Delegate
 */
@property (nonatomic, strong) id <BSKeyboardControlsDelegate> delegate;

/*
 * Text fields the controls should work on
 * The order of this, will be the order used when the next and the previous button is pressed
 */
@property (nonatomic, strong) NSArray *textFields;

/*
 * Currently active text field
 */
@property (nonatomic, strong) id activeTextField;

/*
 * Style of the bar
 */
@property (nonatomic, assign) UIBarStyle barStyle;

/*
 * Tint color of the previous and next buttons
 */
@property (nonatomic, strong) UIColor *previousNextTintColor;

/*
 * Title of the previous button
 */
@property (nonatomic, strong) NSString *previousTitle;

/*
 * Title of the next button
 */
@property (nonatomic, strong) NSString *nextTitle;

/*
 * Title of the done button
 */
@property (nonatomic, strong) NSString *doneTitle;

/*
 *  Tint color of the done button
 */
@property (nonatomic, strong) UIColor *doneTintColor;

/*
 * Reload text fields
 */
- (void)reloadTextFields;

@end

/* Delegation methods */
@protocol BSKeyboardControlsDelegate <NSObject>
@optional
/*
 * Previous or next button was pressed
 */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(UITextField *)textField;

/*
 * Done button was pressed
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls;
@end
