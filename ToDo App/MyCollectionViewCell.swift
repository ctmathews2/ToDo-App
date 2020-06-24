//
//  MyCollectionViewCell.swift
//  ToDo App
//
//  Created by Chandler Mathews on 5/17/20.
//  Copyright © 2020 Chandler Mathews. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    public var indexPath:IndexPath!
    
    @IBAction func testButton(_ sender: Any) {
        //let vcInstance = ViewController()
        //print(ViewController.sharedInstance.todoArray)
        //print(vcInstance.todoArray)
        //ViewController.sharedInstance.todoArray.rem
        //print("Selected position: ", indexPath.item)
         ViewController.sharedInstance.todoArray.remove(at: indexPath.item)
         ViewController.sharedInstance.myDatabase.child(ViewController.sharedInstance.username).setValue(ViewController.sharedInstance.todoArray)
         ViewController.sharedInstance.testCollectionView.deleteItems(at: [indexPath])
    }
}
