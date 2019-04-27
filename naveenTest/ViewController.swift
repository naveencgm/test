//
//  ViewController.swift
//  naveenTest
//
//  Created by Naveen Chandra on 27/04/19.
//  Copyright © 2019 Naveen Chandra. All rights reserved.
//

import UIKit
import moltin
import SDWebImage

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    let myMoltin = Moltin(withClientID:moltinCLientId)

    let tableview = UITableView()
    var tableArray = [moltin.Product]()


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

        myMoltin.product.include([.mainImage]).all { result in
            switch result
            {
            case .success(let response):

                DispatchQueue.main.async(execute: {
                    self.tableArray = response.data ?? []
                    self.tableview.reloadData()

                })

                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell

        let bookModel = tableArray[indexPath.row]

        cell.textLabel?.text = bookModel.name



        //its in int
        let price = (bookModel.price![0].amount) / 100
        //not worried about the accuarcy  for now
        cell.detailTextLabel?.text = "$" + String(price)


        //image
        let imageLink = bookModel.mainImage?.link
        print(imageLink)

        cell.imageView?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "bookImage"))

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

