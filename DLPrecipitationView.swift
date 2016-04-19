//
//  DLPrecipitationView.swift
//  DLPrecipitationView
//
//  Created by Mark Hamilton on 4/13/16.
//  Copyright © 2016 dryverless. All rights reserved.
//

import UIKit

public class DLPrecipitationView: UIView {
    
    let defaultFileName: String = "snow"
    let defaultPrecipitationCount: Int = 50
    let defaultPrecipitationWidth: Float = 40.0
    let defaultPrecipitationHeight: Float = 46.0
    let defaultMinimumSize: Float = 0.4
    let defaultMaximumSize: Float = 0.8
    let defaultAnimationDurationMin: Float = 3.0
    let defaultAnimationDurationMax: Float = 6.0
    
    public var precipitationFileName: String!
    public var precipitationCount: Int!
    public var precipitationWidth: Float!
    public var precipitationHeight: Float!
    public var precipitationMinSize: Float!
    public var precipitationMaxSize: Float!
    
    public var animDurationMin: Float!
    public var animDurationMax: Float!
    
    public var precipitationArray: [UIImageView]?
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        
        clipsToBounds = true
        
        self.precipitationFileName = self.defaultFileName
        self.precipitationCount = self.defaultPrecipitationCount
        self.precipitationWidth = self.defaultPrecipitationWidth
        self.precipitationHeight = self.defaultPrecipitationHeight
        self.precipitationMinSize = self.defaultMinimumSize
        self.precipitationMaxSize = self.defaultMaximumSize
        self.animDurationMin = self.defaultAnimationDurationMin
        self.animDurationMax = self.defaultAnimationDurationMax
        
    }
    
    convenience public init(frame: CGRect, fileName: String, count: Int, width: Float, height: Float, maxSize: Float, minSize: Float, durationMin: Float, durationMax: Float) {
        
        self.init(frame: frame)
        
        clipsToBounds = true
        
        self.precipitationFileName = fileName
        self.precipitationCount = count
        self.precipitationWidth = width
        self.precipitationHeight = height
        self.precipitationMinSize = minSize
        self.precipitationMaxSize = maxSize
        self.animDurationMin = durationMin
        self.animDurationMax = durationMax
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    public func getRandomFloat() -> Float {
    
        return Float(rand()) / Float(RAND_MAX)
    
    }
    
    public func getRandomDuration() -> Float {
        
        let randomDuration: Float = (self.animDurationMax - self.animDurationMin) * getRandomFloat()
        
        return randomDuration
        
    }
    
    
    // Mark: - Creation of Precipitation
    
    public func createPrecipitation() {
        
        precipitationArray = [UIImageView]()
        
        let precipitationImage: UIImage = UIImage(named: precipitationFileName)!
        
        for _: Int in 0 ..< precipitationCount! {
         
            var viewZ: Float = 0.1 * getRandomFloat()
            
            viewZ = viewZ < precipitationMinSize ? precipitationMinSize : viewZ
            viewZ = viewZ > precipitationMaxSize ? precipitationMaxSize : viewZ
            
            let viewWidth = precipitationWidth * viewZ
            let viewHeight = precipitationHeight * viewZ
            
            var viewX = Float(frame.size.width) * getRandomFloat()
            let viewY = Float(frame.size.height) * getRandomFloat()
            
            viewX += Float(frame.size.height)
            viewZ -= viewWidth

            let imageFrame = CGRectMake(CGFloat(viewX), CGFloat(viewY), CGFloat(viewWidth), CGFloat(viewHeight))
            let imageView: UIImageView = UIImageView(image: precipitationImage)
            
            imageView.frame = imageFrame
            imageView.userInteractionEnabled = false
            
            precipitationArray?.append(imageView)
            addSubview(imageView)

 
       }
        
    }
    
    
    // Mark: - Animation Start
    
    public func startAnimation() {
        
        if precipitationArray == nil {
            
            createPrecipitation()
            
        }
        
        backgroundColor = UIColor.clearColor()
        
        let rotationalAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationalAnimation.repeatCount = Float.infinity
        rotationalAnimation.autoreverses = false
        rotationalAnimation.toValue = 6.28318531
        
        let precipAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        precipAnimation.repeatCount = Float.infinity
        precipAnimation.autoreverses = false
        
        for view: UIImageView in precipitationArray! {
            
            var point: CGPoint = view.center
            let startingYPosition = point.y
            let endingYPosition = frame.size.height
            
            point.y = endingYPosition
            
            view.center = point
            
            let timeInterval: Float = getRandomDuration()
            precipAnimation.duration = CFTimeInterval(timeInterval + self.animDurationMin)
            precipAnimation.fromValue = -startingYPosition
            
            view.layer.addAnimation(precipAnimation, forKey: "transform.translation.y")
            
            rotationalAnimation.duration = CFTimeInterval(timeInterval)
            view.layer.addAnimation(rotationalAnimation, forKey: "transform.rotation.y")
            
        }
        
    }
    
    // Mark: - Animation Stop
    
    public func stopAnimation() {
        
        for precipitation: UIImageView in precipitationArray! {
            
            precipitation.layer.removeAllAnimations()
            precipitation.removeFromSuperview() // Fix error with precip displaying near base
            
        }
        
        precipitationArray = nil
        
    }
    
    
    // Mark: - Deinit
    
    
    deinit {
    
        // deallocated
    
    }
    
}