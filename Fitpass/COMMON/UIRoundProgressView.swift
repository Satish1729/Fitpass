//
//  UIRoundProgressView.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

@IBDesignable

class UIRoundProgressView: UIView {
    
    // Color Declarations
    @IBInspectable var percent:CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressColor:UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressBackgroundColor:UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var titleColor:UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    fileprivate var startAngle: CGFloat = CGFloat(-90 * M_PI / 180)
    fileprivate var endAngle: CGFloat = CGFloat(270 * M_PI / 180)
    var totalProgressValue : CGFloat = CGFloat(0);
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    
    override func draw(_ rect: CGRect) {
        // General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        // Shadow Declarations
        let innerShadow = UIColor.black.withAlphaComponent(0.0)
        let innerShadowOffset = CGSize(width: 3.1, height: 3.1)
        let innerShadowBlurRadius = CGFloat(4)
        
        // Background Drawing
        let backgroundPath = UIBezierPath(ovalIn: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height))
        backgroundColor?.setFill()
        backgroundPath.fill()
        
        // Background Inner Shadow
        context?.saveGState();
        UIRectClip(backgroundPath.bounds);
        context?.setShadow(offset: CGSize.zero, blur: 0, color: nil);
        
        context?.setAlpha(innerShadow.cgColor.alpha)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let opaqueShadow = innerShadow.withAlphaComponent(1)
        context?.setShadow(offset: innerShadowOffset, blur: innerShadowBlurRadius, color: opaqueShadow.cgColor)
        context?.setBlendMode(CGBlendMode.sourceOut)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        
        opaqueShadow.setFill()
        backgroundPath.fill()
        context?.endTransparencyLayer();
        
        context?.endTransparencyLayer();
        context?.restoreGState();
        
        // ProgressBackground Drawing
        let kMFPadding = CGFloat(15)
        
        let progressBackgroundPath = UIBezierPath(ovalIn: CGRect(x: rect.minX + kMFPadding/2, y: rect.minY + kMFPadding/2, width: rect.size.width - kMFPadding, height: rect.size.height - kMFPadding))
        progressBackgroundColor.setStroke()
        progressBackgroundPath.lineWidth = 5
        progressBackgroundPath.stroke()
        
        // Progress Drawing
        let progressRect = CGRect(x: rect.minX + kMFPadding/2, y: rect.minY + kMFPadding/2, width: rect.size.width - kMFPadding, height: rect.size.height - kMFPadding)
        let progressPath = UIBezierPath()
        progressPath.addArc(withCenter: CGPoint(x: progressRect.midX, y: progressRect.midY), radius: progressRect.width / 2, startAngle: startAngle, endAngle: (endAngle - startAngle) * (percent / totalProgressValue) + startAngle, clockwise: true)
        progressColor.setStroke()
        progressPath.lineWidth = 4
        progressPath.lineCapStyle = CGLineCap.round
        progressPath.stroke()
        
        // Text Drawing
        let textRect = CGRect(x: rect.minX, y: rect.minY, width: rect.size.width, height: rect.size.height)
        let textContent = NSString(string: "\(Int(percent))")
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .center
        
        let textFontAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: rect.width / 4)!,
            NSForegroundColorAttributeName: titleColor,
            NSParagraphStyleAttributeName: textStyle] as [String : Any]
        
        let textHeight = textContent.boundingRect(with: CGSize(width: textRect.width, height: textRect.height), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        
        context?.saveGState()
        context?.clip(to: textRect)
        textContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textHeight) / 3, width: textRect.width, height: textHeight), withAttributes: textFontAttributes)
        context?.restoreGState();
        
        // Sub Text Drawing
        let subTextRect = CGRect(x: rect.minX, y: rect.minY + (rect.size.height/9), width: rect.size.width, height: rect.size.height)
        let subTextContent = NSString(string: "Days")
        let subTextStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        subTextStyle.alignment = .center
        
        let subTextFontAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: (rect.width / 3)/3)!,
            NSForegroundColorAttributeName: titleColor,
            NSParagraphStyleAttributeName: subTextStyle] as [String : Any]
        
        let subTextHeight = subTextContent.boundingRect(with: CGSize(width: subTextRect.width, height: subTextRect.height), options: .usesLineFragmentOrigin, attributes: subTextFontAttributes, context: nil).height
        
        context?.saveGState()
        context?.clip(to: subTextRect)
        subTextContent.draw(in: CGRect(x: subTextRect.minX, y: subTextRect.minY + (subTextRect.height - subTextHeight)/2, width: subTextRect.width, height: subTextHeight), withAttributes: subTextFontAttributes)
        context?.restoreGState();
        
        
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
