//
//  ViewController.swift
//  naveenTest
//
//  Created by Naveen Chandra on 27/04/19.
//  Copyright © 2019 Naveen Chandra. All rights reserved.
//

import UIKit
import moltin

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let tableview = UITableView()
    let tableArray = [AnyObject]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        getData()

    }

    func configureTableView()
    {
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


    func getData()
    {

        let del = UIApplication.shared.delegate as! AppDelegate

        del.moltin.product.all { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")

      //  let dataDict = Dictionary<Key: Hashable, Any>()
        cell?.textLabel?.text = ""//tableArray[indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }


}

