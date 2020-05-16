//
//  ViewController.swift
//  ToDo App
//
//  Created by Chandler Mathews on 5/15/20.
//  Copyright © 2020 Chandler Mathews. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 0...100{
            data.append("\(i)")
        }
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = data[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }

}

