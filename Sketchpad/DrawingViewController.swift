//
//  DrawingViewController.swift
//  Sketchpad
//
//  Created by Yash Bhojgarhia on 16/07/21.
//

import UIKit

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
    var currentColor = UIColor.blue.cgColor
    var brushSize: Float = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let beginPoint = touches.first?.location(in: imageView) {
            lastPoint = beginPoint
        }
    }
    
    @IBAction func colorTapped(_ sender: Any) {
    }
    
    @IBAction func sizeTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Brush", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 10, y: 50, width: 250, height: 80))
        
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = brushSize
        
        ac.view.addSubview(slider)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.brushSize = slider.value
        }
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
        
        
    }
    
    @IBAction func eraseTapped(_ sender: Any) {
        currentColor = UIColor.white.cgColor
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let movedPoint = touches.first?.location(in: imageView) {
            drawBetweenTwoPoints(point1: lastPoint, point2: movedPoint)
            lastPoint = movedPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let endPoint = touches.first?.location(in: imageView) {
            drawBetweenTwoPoints(point1: lastPoint, point2: endPoint)
        }
    }
    
    func drawBetweenTwoPoints(point1: CGPoint, point2: CGPoint) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        if let context = UIGraphicsGetCurrentContext() {
            context.move(to: point1)
            context.addLine(to: point2)
            context.setLineWidth(CGFloat(brushSize) / 3.0)
            context.setLineCap(.round)
            context.setStrokeColor(currentColor)
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
    
}
