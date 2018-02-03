//
//  Spinner.swift
//  Custom-Spinner
//
//  Created by Karan Gavali on 03/02/18.
//  Copyright © 2018 Karan Gavali. All rights reserved.
//

import UIKit

protocol Indicator {}

extension UIView: Indicator {}

class LoaderView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

class Spinner: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var animationRect = UIEdgeInsetsInsetRect(frame, .zero)
        let minEdge = min(animationRect.width, animationRect.height)
        
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        setUpAnimation(in: layer, size: animationRect.size, color: .red)
    }
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSize = size.width / 9
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.1, 0.2, 0.3, 0.4, 0.5]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.4, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw lines
        for i in 0 ..< 5 {
            let line = layerWith(size: CGSize(width: lineSize, height: size.height), color: color)
            let frame = CGRect(x: x + lineSize * 2 * CGFloat(i), y: y, width: lineSize, height: size.height)
            
            animation.beginTime = beginTime + beginTimes[i]
            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                            cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
    
}

extension Indicator where Self: UIView {
    
    mutating func showLoader(withMessage message: String = "", color: UIColor = .red) {
        
        let loader = LoaderView()
        loader.backgroundColor = UIColor(white: 0, alpha: 0)
        addSubview(loader)
        loader.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        let spinner = Spinner()
        spinner.backgroundColor = .clear
        loader.addSubview(spinner)
        
        print(frame.size.width / 6)
        
        spinner.centerView(xAxis: loader.centerXAnchor, yAxis: loader.centerYAnchor, size: .init(width: frame.size.width / 6, height: frame.size.width / 6))
        
        let label = UILabel()
        label.textColor = color
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        loader.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.anchor(top: spinner.bottomAnchor, leading: loader.leadingAnchor, bottom: loader.bottomAnchor, trailing: loader.trailingAnchor, greaterThanEqualToBottom: true, padding: .init(top: 8, left: 8, bottom: 2, right: -8))
        
    }
    
    func removeLoader() {
        subviews.forEach {
            if $0.isKind(of: LoaderView.self) {
                $0.removeFromSuperview()
            }
        }
    }
}



extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, greaterThanEqualToBottom: Bool = false, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom, !greaterThanEqualToBottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        } else if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).setLowPriority().isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
    }
    
    func centerView(xAxis: NSLayoutXAxisAnchor? , yAxis: NSLayoutYAxisAnchor?, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let xAxis = xAxis {
            centerXAnchor.constraint(equalTo: xAxis).isActive = true
        }
        
        if let yAxis = yAxis {
            centerYAnchor.constraint(equalTo: yAxis).isActive = true
        }
        
        anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: size)
    }
    
    func fillSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superView = superview {
            anchor(top: superView.topAnchor, leading: superView.leadingAnchor, bottom: superView.bottomAnchor, trailing: superView.trailingAnchor)
        }
    }
    
}

extension NSLayoutConstraint {
    func setLowPriority() -> NSLayoutConstraint {
        priority = UILayoutPriorityDefaultLow
        return self
    }
}

