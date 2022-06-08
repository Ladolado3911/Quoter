//
//  UIView+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit
import Lottie

enum LottieAnimation: String {
    case flyingPaper
    case dots
    case wakeup
}

extension UIView {
    
    var initialFrame: CGRect {
        CGRect(x: bounds.width / 2, y: bounds.height / 2, width: 0, height: 0)
    }
    
//    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
//        
//        let border = UIView()
//        
//        switch edge {
//        case UIRectEdge.top:
//            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
//            
//        case UIRectEdge.bottom:
//            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
//            
//        case UIRectEdge.left:
//            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
//            
//        case UIRectEdge.right:
//            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
//            
//        default: do {}
//        }
//        
//        border.backgroundColor = color
//        
//        addSubview(border)
//    }
    
    func createAndStartLoadingLottieAnimation(animation: LottieAnimation,
                                              animationSpeed: CGFloat = 1,
                                              frame: CGRect = .zero,
                                              loopMode: LottieLoopMode = .loop,
                                              contentMode: UIView.ContentMode = .scaleAspectFit,
                                              completion: ((Bool) -> Void)?) {
        
        let lottieAnimation = AnimationView(name: animation.rawValue)
        lottieAnimation.frame = frame
        lottieAnimation.contentMode = contentMode
        lottieAnimation.loopMode = loopMode
        lottieAnimation.animationSpeed = animationSpeed
        // loading animation will always have tag of 1
        lottieAnimation.tag = 1
        addSubview(lottieAnimation)
        if let completion = completion {
            let lottieCompletion = completion
            lottieAnimation.play(completion: lottieCompletion)
        }
        else {
            lottieAnimation.play()
        }
    }
    
    func stopLoadingLottieAnimationIfExists() {
        if let lottieAnimation = loadingLottieAnimationView {
            lottieAnimation.removeFromSuperview()
            lottieAnimation.stop()
            lottieAnimation.isHidden = true
        }
    }
    
    private var loadingLottieAnimationView: AnimationView? {
        for subview in subviews {
            if let newSubview = subview as? AnimationView {
                if subview.tag == 1 {
                    return newSubview
                }
            }
        }
        return nil
    }
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }

    func takeScreenshot(completion: @escaping () -> Void) {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: bounds.width, height: bounds.height),
            false,
            2
        )
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
        completion()
    }
    
}

extension UIView {

    func drawTopBorder(lineWidth: CGFloat) {
        let path = UIBezierPath()
        path.lineWidth = lineWidth

        path.move(to: CGPoint(x: lineWidth, y: bounds.origin.y + layer.cornerRadius + lineWidth))
        path.addArc(withCenter: CGPoint(x: path.currentPoint.x + layer.cornerRadius,
                                        y: path.currentPoint.y),
                    radius: layer.cornerRadius,
                    startAngle: .pi,
                    endAngle: (3 * .pi) / 2,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: bounds.width - layer.cornerRadius, y: path.currentPoint.y))
        path.addArc(withCenter: CGPoint(x: path.currentPoint.x,
                                        y: path.currentPoint.y + layer.cornerRadius),
                    radius: layer.cornerRadius,
                    startAngle: (3 * .pi) / 2,
                    endAngle: 0,
                    clockwise: true)
        
        
        DarkModeColors.white.setStroke()
        path.stroke()
    }
}

//extension CALayer {
//    
//    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
//        
//        let border = CALayer()
//        
//        switch edge {
//        case UIRectEdge.top:
//            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
//            
//        case UIRectEdge.bottom:
//            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
//            
//        case UIRectEdge.left:
//            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
//            
//        case UIRectEdge.right:
//            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
//            
//        default: do {}
//        }
//        
//        border.backgroundColor = color.cgColor
//        
//        addSublayer(border)
//    }
//}
