//
//  DrawingViewController.swift
//  Sketchpad
//
//  Created by Yash Bhojgarhia on 16/07/21.
//

import UIKit
import ChromaColorPicker

class DrawingViewController: UIViewController, ChromaColorPickerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
    var currentColor = UIColor.blue.cgColor
    var brushSize: Float = 30.0
    var colorPicker: ChromaColorPicker?
    var grayedOut = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grayedOut = UIView(frame: view.frame)
        grayedOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(grayedOut)
        
        colorPicker = ChromaColorPicker(frame: CGRect(x: view.frame.size.width / 2 - 100, y: view.frame.size.height / 2 - 100, width: 200, height: 200))
        if let picker = colorPicker {
            picker.delegate = self
            picker.padding = 5
            picker.stroke = 3
            picker.hexLabel.isHidden = true
            view.addSubview(picker)
        }
        colorPicker?.isHidden = true
        grayedOut.isHidden = true
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        currentColor = color.cgColor
        colorPicker.isHidden = true
        grayedOut.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let beginPoint = touches.first?.location(in: imageView) {
            lastPoint = beginPoint
        }
    }
    
    @IBAction func colorTapped(_ sender: Any) {
        colorPicker?.adjustToColor(UIColor(cgColor: currentColor))
        colorPicker?.isHidden = false
        grayedOut.isHidden = false
    }
    
    @IBAction func sizeTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Brush", message: "\n\n\n\n\n", preferredStyle: .alert)
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
