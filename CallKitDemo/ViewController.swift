//
//  ViewController.swift
//  CallKitDemo
//
//  Created by Phineas.Huang on 2020/5/7.
//  Copyright © 2020 Phineas. All rights reserved.
//

import UIKit
import CallKit

class ViewController: UIViewController {
    var callObserver: CXCallObserver!
    var message: String! = ""
    var index: Int = 0

    @IBOutlet weak var mainScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCallObserver()
    }

    func setupCallObserver() {
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
    }
    
    func updateNewMessage(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.mainScrollView.subviews.map({
                $0.removeFromSuperview()
            })
            
            let label = UILabel()
            label.numberOfLines = 0
            label.text = message
            label.font = UIFont(name: "Georgia", size: 13.0)
            let nsString: NSString = NSString(string: message)
            
            let labelSize = nsString.size(withAttributes: [.font: label.font])
            var y = 0
            label.frame = CGRect(x: 38, y: y, width: 300, height: Int(labelSize.height))
            label.backgroundColor = UIColor.clear
            self?.mainScrollView.showsVerticalScrollIndicator = false
            y += Int(self?.mainScrollView.frame.size.height ?? 0)
            self?.mainScrollView.contentSize = CGSize(width: 200, height: y+50)
            self?.mainScrollView.addSubview(label)
        }
    }
}

extension ViewController: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        var msg: String = ""
        if call.hasEnded == true {
            print("CXCallState :Disconnected")
            msg = "CXCallState :Disconnected"
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState :Dialing")
            msg = "CXCallState :Dialing"
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState :Incoming")
            msg = "CXCallState :Incoming"
        }
        if call.hasConnected == true && call.hasEnded == false {
            print("CXCallState : Connected")
            msg = "CXCallState : Connected"
        }
        msg += "\n" + call.uuid.uuidString
        
        index += 1
        message += "[\(index)]\t" + msg + " \n"
        updateNewMessage(message)
    }
}




