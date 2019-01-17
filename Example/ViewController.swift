//
//  ViewController.swift
//  Example
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import UIKit
import BeerKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    var messages: [MessageEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        BeerKit.onConnect { (myPeerId, peerId) in
            DispatchQueue.main.async {
                self.deviceNameLabel.text = peerId.displayName
            }
        }
        
        BeerKit.onEvent { (peerId, event, data) in
            guard let data = data,
                let message = try? JSONDecoder().decode(MessageEntity.self, from: data) else {
                    return
            }
            self.messages.append(message)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sayHiButtonTapped(_ sender: Any) {
        let message = MessageEntity(name: UIDevice.current.name, message: "Hi")
        let data: Data = try! JSONEncoder().encode(message)
        BeerKit.sendEvent("message", data: data)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = messages[indexPath.row].name
        cell.detailTextLabel?.text = messages[indexPath.row].message
        return cell
    }
}

