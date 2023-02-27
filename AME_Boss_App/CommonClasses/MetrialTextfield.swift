//
//  MetrialTextfield.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 15/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//


import Foundation
import UIKit


class MetrialTextfield: UITextField {

    @IBInspectable public var cornerRadius:CGFloat  = 10.0
    @IBInspectable public var activeBorderColor     = UIColorFromRGB(0x45a247).cgColor
    @IBInspectable public var inactiveColor:UIColor = UIColorFromRGB(0x45a247)
    @IBInspectable public var leftSideIcon:UIImage?


       // for padding
    @IBInspectable let padding                      = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)


    override open func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override open func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }


       // For Floating Lable
       var floatingLabel: UILabel!
       var placeHolderText: String!

    var isTextFiledActive                           = false

    var floatingLabelColor                          = UIColorFromRGB(0x45a247).cgColor {
           didSet {
    self.floatingLabel.textColor                    = UIColor(cgColor: floatingLabelColor)
           }
       }

    var floatingLabelFont: UIFont                   = UIFont(name: "Roboto-Regular", size: 13)! {
           didSet {
    self.floatingLabel.font                         = floatingLabelFont
               //self.floatingLabel.font = .boldSystemFont(ofSize: 16)
           }
       }
    var floatingLabelHeight: CGFloat                = 30
       //New Custom drawing Vars
    var leftSideFloatingLablePaddding:CGFloat       = 20.0
       var mainBorderOutline:CAShapeLayer!
       var hiddenBorderOtline:CAShapeLayer!


       override public func awakeFromNib() {
           super.awakeFromNib()
           addborderLayerOnView()

       }
    
       // junaid is fast more then normal speed in
    

       override public func draw(_ rect: CGRect) {
           super.draw(rect)


       }


       override public func layoutSubviews() {
           super.layoutSubviews()
           addborderLayerOnView()
           //decideBorderStrokeColor()
       }



       open  func addborderLayerOnView()
       {

           self.layer.sublayers?.forEach { if $0.name == "dhiru_border_main" || $0.name == "dhiru_border_hidden"
           {$0.removeFromSuperlayer()} }

    let initialPoint                                = (leftSideFloatingLablePaddding + placeHolderText.dk_width(withConstrainedHeight: floatingLabelHeight, font:self.floatingLabelFont))

    let path                                        = UIBezierPath()
           path.move(to:CGPoint(x:initialPoint,y:0))
           path.addLine(to:CGPoint(x: self.frame.size.width - cornerRadius, y: 0))
           // Corner Radius Right Top
           path.addQuadCurve(to: CGPoint(x: self.frame.size.width, y: cornerRadius), controlPoint: CGPoint(x: self.frame.size.width, y: 0))
           path.addLine(to:CGPoint(x: self.frame.size.width, y: self.frame.size.height - cornerRadius))

           // Corner Radius Right Bottom
           path.addQuadCurve(to: CGPoint(x: self.frame.size.width-cornerRadius, y: self.frame.size.height), controlPoint: CGPoint(x: self.frame.size.width, y: self.frame.size.height))

           path.addLine(to:CGPoint(x: cornerRadius, y: self.frame.size.height))
           // Corner Radius Left  Bottom
           path.addQuadCurve(to: CGPoint(x: 0, y: self.frame.size.height - cornerRadius), controlPoint: CGPoint(x: 0, y: self.frame.size.height))

           path.addLine(to:CGPoint(x: 0, y: cornerRadius))

           // Corner Radius Left  Top
           path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))


    mainBorderOutline                               = CAShapeLayer()
    mainBorderOutline.name                          = "dhiru_border_main"
    mainBorderOutline.path                          = path.cgPath
    mainBorderOutline.fillColor                     = UIColor.clear.cgColor
    mainBorderOutline.lineCap                       = .round
   self.layer.addSublayer(mainBorderOutline)


    let path2                                       = UIBezierPath()
           path2.move(to: CGPoint(x: cornerRadius, y:0))
           path2.addLine(to: CGPoint(x: initialPoint, y: 0))

    hiddenBorderOtline                              = CAShapeLayer()
    hiddenBorderOtline.name                         = "dhiru_border_hidden"
    hiddenBorderOtline.path                         = path2.cgPath
    hiddenBorderOtline.fillColor                    = UIColor.clear.cgColor
    hiddenBorderOtline.lineCap                      = .round//kCALineCapRound
    self.layer.addSublayer(hiddenBorderOtline)



           Done()

           decideBorderStrokeColor()

       }

       func decideBorderStrokeColor()
       {
           if isTextFiledActive
           {
               // set ative border color
    mainBorderOutline.strokeColor                   = activeBorderColor
    hiddenBorderOtline.strokeColor                  = UIColor.clear.cgColor

    self.floatingLabel.frame                        = CGRect(x: self.cornerRadius + 5.0, y: -self.floatingLabelHeight/2, width: (self.placeHolderText?.dk_width(withConstrainedHeight: self.floatingLabelHeight, font: self.floatingLabelFont))!, height: self.floatingLabelHeight)

           }else
           {

               if  (self.text?.isEmpty)!
               {
    mainBorderOutline.strokeColor                   = inactiveColor.cgColor
    hiddenBorderOtline.strokeColor                  = inactiveColor.cgColor
               }else
               {
    mainBorderOutline.strokeColor                   = inactiveColor.cgColor
    hiddenBorderOtline.strokeColor                  = UIColor.clear.cgColor

    self.floatingLabel.frame                        = CGRect(x: self.cornerRadius + 5.0, y: -self.floatingLabelHeight/2, width: (self.placeHolderText?.dk_width(withConstrainedHeight: self.floatingLabelHeight, font: self.floatingLabelFont))!, height: self.floatingLabelHeight)
               }
           }
       }


       override init(frame: CGRect) {
           super.init(frame: frame)
       }

       required init?(coder aDecoder: NSCoder) {

           super.init(coder: aDecoder)


    let flotingLabelFrame                           = CGRect(x: 0, y: 0, width: (placeHolderText?.dk_width(withConstrainedHeight: self.floatingLabelHeight, font: self.floatingLabelFont)) ?? 0, height: 0)

    floatingLabel                                   = UILabel(frame: flotingLabelFrame)
    floatingLabel.textColor                         = UIColor(cgColor: floatingLabelColor)
    floatingLabel.font                              = floatingLabelFont
    floatingLabel.text                              = self.placeholder
    floatingLabel.backgroundColor                   = UIColor.white
    floatingLabel.textColor                         = UIColor(cgColor: activeBorderColor)
           self.addSubview(floatingLabel)
    placeHolderText                                 = placeholder


           NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)

           NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)

           self.bringSubviewToFront(self.floatingLabel)

       }

       @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
    self.floatingLabel.textColor                    = UIColor(cgColor: activeBorderColor)
    isTextFiledActive                               = true
           layoutSubviews()
           if self.text == "" {
               UIView.animate(withDuration: 0.3) {
    self.floatingLabel.frame                        = CGRect(x: self.cornerRadius + 5.0, y: -self.floatingLabelHeight/2, width: (self.placeHolderText?.dk_width(withConstrainedHeight: self.floatingLabelHeight, font: self.floatingLabelFont))!, height: self.floatingLabelHeight)
               }
    self.placeholder                                = ""
           }
       }

       @objc public func textFieldDidEndEditing(_ textField: UITextField) {
    self.floatingLabel.textColor                    = inactiveColor
    isTextFiledActive                               = false
           layoutSubviews()
           if self.text == "" {
               UIView.animate(withDuration: 0.2) {
    self.floatingLabel.frame                        = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
               }
    self.placeholder                                = placeHolderText
           }
       }

       deinit {

           NotificationCenter.default.removeObserver(self)

       }



       // DoneButton Function
       func Done()
       {
           if self.tag == 9
           {
    self.returnKeyType                              = UIReturnKeyType.done

           }
       }

   }

func UIColorFromRGB(_ rgbValue: UInt) -> UIColor
{
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


   extension String {
       func dk_height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect                              = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox                                 = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

           return ceil(boundingBox.height)
       }

       func dk_width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect                              = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox                                 = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

           return ceil(boundingBox.width)
       }



   }
