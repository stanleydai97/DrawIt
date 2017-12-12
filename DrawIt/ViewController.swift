//
//  ViewController.swift
//  DrawIt
//
//  Created by Stanley Dai on 12/3/17.
//  Copyright © 2017 Stanley Dai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    
    var brushSize:CGFloat = 5.0
    var opacityValue:CGFloat = 1.0
    
    
    var tool:UIImageView!
    var isDrawing = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }

    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
       
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        self.imageView.image = nil
    }
    
    @IBAction func save(_ sender: AnyObject) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    
    @IBAction func erase(_ sender: AnyObject) {
         (red,green,blue) = (1,1,1)
    }
    
    @IBAction func settings(_ sender: AnyObject) {
    }
    
    
    
    @IBAction func colorsPicked(_ sender: AnyObject) {
        if sender.tag == 0 {
            (red,green,blue) = (212/255,0/255,84/255)
        } else if sender.tag == 1 {
            (red,green,blue) = (255/255,95/255,0/255)
        } else if sender.tag == 2 {
            (red,green,blue) = (255/255,217/255,0/255)
        } else if sender.tag == 3 {
            (red,green,blue) = (0/255,174/255,141/255)
        } else if sender.tag == 4 {
            (red,green,blue) = (111/255,207/255,235/255)
        } else if sender.tag == 5 {
            (red,green,blue) = (193/255,154/255,222/255)
        } else if sender.tag == 6 {
            (red,green,blue) = (254/255,174/255,187/255)
        } else if sender.tag == 7 {
            (red,green,blue) = (56/255,56/255,56/255)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let settingsVC = segue.destination as! SettingsVC
        settingsVC.delegate = self
        settingsVC.red = red
        settingsVC.green = green
        settingsVC.blue = blue
        settingsVC.brushSize = brushSize
        settingsVC.opacityValue = opacityValue
    }

    }

    extension ViewController: SettingsVCDelegate {
        
        func settingsViewControllerDidFinish(_ settingsVC: SettingsVC) {
            self.red = settingsVC.red
            self.green = settingsVC.green
            self.blue = settingsVC.blue
            self.brushSize = settingsVC.brushSize
            self.opacityValue = settingsVC.opacityValue
        }
    }


