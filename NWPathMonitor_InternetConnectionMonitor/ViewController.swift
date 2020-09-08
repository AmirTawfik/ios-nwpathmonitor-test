//
//  ViewController.swift
//  NWPathMonitor_InternetConnectionMonitor
//
//  Created by Amir Tawfik on 08/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    var monitor: NWPathMonitor!
    var queue: DispatchQueue!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var startMonitoringBtn: UIButton!
    @IBOutlet var endMonitoringBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create queue for monitoring (we can use .main instead of queue if we nned to monitor in main thread)
        queue = DispatchQueue(label: "Internet Connection Monitoring")
        
        // at start, enable start monitoring button, and disable end monitoring button
        startMonitoringBtn.isEnabled = true
        endMonitoringBtn.isEnabled = false
        // init status label text and color
        self.statusLbl.textColor = .black
        self.statusLbl.text = "N/A"
    }

    func startMonitoring() {
        // Important:- we must create (re-create) monitor object after cancelling!
        monitor = NWPathMonitor()
        // set update handler
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    // update status label text and color
                    self.statusLbl.text = "ON"
                    self.statusLbl.textColor = .green
                }
            } else {
                DispatchQueue.main.async {
                    // update status label text and color
                    self.statusLbl.text = "OFF"
                    self.statusLbl.textColor = .red
                }
            }
        }
        // start monitoring
        monitor.start(queue: queue)
        
        // enable end monitoring button, and diable start monitoring button
        DispatchQueue.main.async {
            self.startMonitoringBtn.isEnabled = false
            self.endMonitoringBtn.isEnabled = true
        }
    }

    func endMonitoring() {
        monitor.cancel()
        monitor.pathUpdateHandler = nil
        
        // enable start monitoring button, and disable end monitoring button
        DispatchQueue.main.async {
            self.startMonitoringBtn.isEnabled = true
            self.endMonitoringBtn.isEnabled = false
            // reset status label text and color
            self.statusLbl.textColor = .black
            self.statusLbl.text = "N/A"
        }
    }
    
    @IBAction func startMonitoringTapped(_ sender: UIButton) {
        startMonitoring()
    }
    
    @IBAction func EndMonitoringTapped(_ sender: UIButton) {
        endMonitoring()
    }
    
}

