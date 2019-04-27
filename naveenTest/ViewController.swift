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
    var tableArray = [AnyObject]()

    let moltin = Moltin(withClientID:moltinCLientId)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureTableView()

        self.title = "Naveen book shop"

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        getData()

    }

    func configureTableView()
    {
        self.view = tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


    func getData()
    {
        moltin.product.all { (Result<PaginatedResponse<Array<Decodable & Encodable>>>
            ) in
            <#code#>
        }

        moltin.product.all { result in
            switch result
            {
            case .success(let response):

                self.tableArray = response.data ?? []

                print(response.data)
            case .failure(let error):
                print(error)
            }
        }
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell


      //  let dataDict = Dictionary<Key: Hashable, Any>()
        cell.textLabel?.text = ""//tableArray[indexPath.row]
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

