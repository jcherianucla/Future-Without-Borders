//
//  PaymentsViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 11/17/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var MainImage: UIImageView!
    
    @IBOutlet var CardNumberTextField: UITextField!
    
    @IBOutlet var ExpirationDateTextField: UITextField!
    
    @IBOutlet var CVVTextfield: UITextField!
    
    @IBOutlet var SubmitButton: UIButton!
    
    @IBOutlet var BottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var AspectRatioOfGraphic: NSLayoutConstraint!
    
    //these ui elements will remain hidden until the submit button is pressed
    @IBOutlet var CardValidatedView: UIView!
    @IBOutlet var ValidatedIcon: UIImageView!
    @IBOutlet var CardConfirmedLabel: UILabel!
    @IBOutlet var NewCardLabel: UILabel!
    @IBOutlet var NewCardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.CardNumberTextField.delegate = self;
        self.ExpirationDateTextField.delegate = self;
        self.CVVTextfield.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //closes keyboard if pressed on screen off keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        ShiftKeyboard(false)
        updateCardLogo()
    }
    //shifts text fields up when editing is started
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        ShiftKeyboard(true)
        return true
    }
    
    //function animates keyboard slide up or down
    //depending on whether true or false is used
    func ShiftKeyboard(UpOrDown: Bool) {
        if UpOrDown == true {
            //slides keyboard up
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.BottomSpaceConstraint.constant = self.view.bounds.height*0.25
                self.view.layoutIfNeeded()
                return
                }, completion: nil)
        }
        else {
            //slides keyboard down
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.BottomSpaceConstraint.constant = 0
                self.view.layoutIfNeeded()
                return
                }, completion: { (finished) -> Void in
            })
        }
    }
    
    //Performs luhn validation and either display card validated page
    //or displays error
    @IBAction func SubmitButtonPressed(sender: AnyObject) {
        print("reached")
        //make sure luhn validation works
        if (performLuhnValidation()) {
            //check if cvv is right amount characters for american express and other cards
            if determineIfAmericanExpress() {
                //check that valid expiration date and valid number of cvv characters
                if (CVVTextfield.text?.characters.count == 4) && (checkIfValidExpirationDate()) {
                    ToggleConfirmationView(true)
                }
                    //didn't pass all requirements
                else {
                    //output this is invalid number
                    AspectRatioOfGraphic.constant = self.view.bounds.width * 0.4
                    MainImage.image = UIImage(named: "InvalidNumberIcon")
                }
            }
            else {
                //check that valid expiration date and valid number of cvv characters
                if (CVVTextfield.text?.characters.count == 3) && (checkIfValidExpirationDate()) {
                    ToggleConfirmationView(true)
                }
                    //didn't pass all requirements
                else {
                    //output this is invalid number
                    AspectRatioOfGraphic.constant = self.view.bounds.width * 0.4
                    MainImage.image = UIImage(named: "InvalidNumberIcon")
                }
            }
        }
        else {
            //output this is invalid number
            AspectRatioOfGraphic.constant = self.view.bounds.width * 0.4
            MainImage.image = UIImage(named: "InvalidNumberIcon")
        }
    }
    
    //returns true if the expiration text field has a valid date
    func checkIfValidExpirationDate()->Bool{
        //grab text without the /
        let expirationStr:String = ExpirationDateTextField.text!.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //make sure it's four characters
        if expirationStr.characters.count != 4 {
            print("false expiration 0")
            
            return false
        }
        let index1 = expirationStr.startIndex.advancedBy(0)
        let index2 = expirationStr.startIndex.advancedBy(1)
        print(expirationStr[index1])
        print(expirationStr[index2])
        //has to be month in range of 01 to 12
        if ((Int64(String(expirationStr[index1])) != 1) && (Int64(String(expirationStr[index1])) != 0)) {
            print("false expiration 1")
            return false
        }
        //cant be 00
        if ((Int64(String(expirationStr[index1])) == 0) && (Int64(String(expirationStr[index2])) == 0)) {
            print("false expiration 2")
            return false
        }
        //cant be greater than 12
        if ((Int64(String(expirationStr[index1])) == 1) && (Int64(String(expirationStr[index2])) > 2)) {
            print("false expiration 3")
            return false
        }
        //otherwise this is a valid expiration date
        print("true expiration")
        return true
    }
    //should refresh all settings
    @IBAction func NewCardButtonPressed(sender: AnyObject) {
        ShiftKeyboard(false)
        ToggleConfirmationView(false)
        CardNumberTextField.text = ""
        ExpirationDateTextField.text = ""
        CVVTextfield.text = ""
        MainImage.image = UIImage(named: "NoCreditCardIcon")
    }
    //shows confirmation
    func ToggleConfirmationView(ShowOrHide: Bool){
        //if true then show
        if ShowOrHide == true {
            self.view.bringSubviewToFront(CardValidatedView)
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.CardValidatedView.alpha = 1.0
                return
                }, completion: { (error) -> Void in
                    self.ValidatedIcon.alpha = 1.0
                    self.CardConfirmedLabel.alpha = 1.0
                    self.NewCardLabel.alpha = 1.0
                    self.NewCardButton.alpha = 1.0
            })
        }
        else {
            CardValidatedView.sendSubviewToBack(self.view)
            self.CardValidatedView.alpha = 0.0
            self.NewCardLabel.alpha = 0.0
            self.NewCardButton.alpha = 0.0
            self.ValidatedIcon.alpha = 0.0
            self.CardConfirmedLabel.alpha = 0.0
        }
    }
    
    func performLuhnValidation()->Bool{
        print("performing luhn validation")
        //performs luhn validation and returns true if valid otherwise return false
        var cardNumberStr: String = CardNumberTextField.text!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //next check if possible to convert the string to an int, basic check against incorrect characters
        if let CardNumber: Int64 = Int64(cardNumberStr) {
            //following steps will reverse the string
            var reverseCardNumberStr = ""
            for scalar in cardNumberStr.unicodeScalars {
                let asString = "\(scalar)"
                reverseCardNumberStr = asString + reverseCardNumberStr
            }
            //Starting with the second digit in the string, we double every other number
            //and also grab the sum of the digits, and if any doubled number is two digits we sum up individual digits
            var sum: Int64 = 0
            for (var i = 0 ; i < reverseCardNumberStr.characters.count; i++){
                let index = reverseCardNumberStr.startIndex.advancedBy(i)
                if (i % 2 == 1){
                    let doubled_value = Int(String(reverseCardNumberStr[index]))! * 2
                    if String(doubled_value).characters.count == 2 {
                        let index1 = String(doubled_value).startIndex.advancedBy(0)
                        let index2 = String(doubled_value).endIndex.advancedBy(-1)
                        sum += Int64(String(String(doubled_value)[index1]))! + Int64(String(String(doubled_value)[index2]))!
                    }
                    else {
                        sum += doubled_value
                    }
                }
                else {
                    sum += Int(String(reverseCardNumberStr[index]))!
                }
            }
            //if sum is multiple of 10 then this is a valid check sum
            if (sum % 10 == 0) {
                return true
            }
        }
        else {
            //if not a number string return false
            return false
        }
        //if sum is not multiple of 10 it will return false here
        return false
    }
    
    //upon entering a card number this will update the logo
    //if it can recognize the card otherwise it will remain as a mystery
    //mastercard is 1, visa is 2, jcb is 3, discover is 4, amex is 5, no card found is 6
    func updateCardLogo() -> Int{
        AspectRatioOfGraphic.constant = 0
        print("updating card logo")
        let CardNumber: String = CardNumberTextField.text!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if CardNumber.characters.count == 16 {
            let index1 = CardNumber.startIndex.advancedBy(1)
            let index2 = CardNumber.startIndex.advancedBy(2)
            let index3 = CardNumber.startIndex.advancedBy(3)
            let index4 = CardNumber.startIndex.advancedBy(4)
            let index6 = CardNumber.startIndex.advancedBy(6)
            
            if ((Int((CardNumber.substringToIndex(index2))) >= 51) &&
                (Int((CardNumber.substringToIndex(index2))) <= 55)) {
                    //This is a mastercard card
                    MainImage.image = UIImage(named: "MastercardLogo")
                    return 1
            }
            if (CardNumber.substringToIndex(index1) == "4") {
                //This is a visa card
                MainImage.image = UIImage(named: "VisaLogo")
                return 2
            }
            if ((Int((CardNumber.substringToIndex(index4))) >= 3528) &&
                (Int((CardNumber.substringToIndex(index4))) <= 3589)) {
                    //This is a JCB card
                    MainImage.image = UIImage(named: "JCB Logo")
                    return 3
            }
            if (((Int((CardNumber.substringToIndex(index6)))! >= 622126) &&
                (Int((CardNumber.substringToIndex(index6))) <= 622925))
                || ((Int((CardNumber.substringToIndex(index3)))! >= 644) &&
                    (Int((CardNumber.substringToIndex(index3))) <= 649))
                || (CardNumber.substringToIndex(index2) == "65")
                || (CardNumber.substringToIndex(index4) == "6011")){
                    //This is a Discover card
                    MainImage.image = UIImage(named: "DiscoverLogo")
                    return 4
            }
        }
        else if CardNumber.characters.count == 15 {
            let index1 = CardNumber.startIndex.advancedBy(2)
            if ((CardNumber.substringToIndex(index1) == "34") ||
                (CardNumber.substringToIndex(index1) == "37")) {
                    //This is an american express card
                    MainImage.image = UIImage(named: "AmexLogo")
                    return 5
            }
        }
        MainImage.image = UIImage(named: "NoCreditCardIcon")
        return 6
    }
    
    // handles when return is pressed on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //weird way of saying close the keyboard
        textField.resignFirstResponder()
        ShiftKeyboard(false)
        updateCardLogo()
        return true
    }
    
    //this is used to auto insert dashes for card number and / for expiration date
    //it also limits the number of valid characters for each text field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if string.characters.count == 0 {
            return true
        }
        switch textField {
            
        case CardNumberTextField:
            if ((CardNumberTextField.text!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).characters.count) >= 16){
                //should not have more than 16 characters for date
                ShiftKeyboard(false)
                updateCardLogo()
                return false
            }
            if (((CardNumberTextField.text!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).characters.count) % 4 == 0) && (CardNumberTextField.text?.characters.count > 0) && (CardNumberTextField.text?.characters.last != "-")) {
                CardNumberTextField.text = CardNumberTextField.text! + "-"
            }
            return true
        case ExpirationDateTextField:
            if ((ExpirationDateTextField.text!.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).characters.count) >= 4){
                //should not have more than four characters for date
                ShiftKeyboard(false)
                updateCardLogo()
                return false
            }
            if ( ExpirationDateTextField.text?.characters.count == 2) {
                ExpirationDateTextField.text = ExpirationDateTextField.text! + "/"
            }
            return true
        case CVVTextfield:
            if (determineIfAmericanExpress()) {
                //allow four characters for cvv
                if ((CVVTextfield.text!.characters.count) >= 4){
                    //should not have more than 4 characters for date
                    ShiftKeyboard(false)
                    updateCardLogo()
                    return false
                }
            }
            else {
                //only allow 3
                if ((CVVTextfield.text!.characters.count) >= 3){
                    //should not have more than 4 characters for date
                    ShiftKeyboard(false)
                    updateCardLogo()
                    return false
                }
            }
            return true
        default:
            return true
        }
    }
    
    //function determines if card number entered is American Express
    func determineIfAmericanExpress()->Bool{
        let CardNumber: String = CardNumberTextField.text!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if CardNumber.characters.count == 15 {
            let index1 = CardNumber.startIndex.advancedBy(2)
            if ((CardNumber.substringToIndex(index1) == "34") ||
                (CardNumber.substringToIndex(index1) == "37")) {
                    //This is an american express card
                    return true
            }
        }
        return false
    }
}


