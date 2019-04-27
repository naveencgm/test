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
        self.title = "Naveens book Shop"
        configureTableView()
        addCheckoutButton()



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
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func addCheckoutButton()
    {
        let checkOutCartButton = UIButton(frame: CGRect(x: 0, y:100, width: self.view.frame.width, height: 30))
        checkOutCartButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        checkOutCartButton.setTitle("Checkout", for: .normal)
        checkOutCartButton.layer.cornerRadius = 2
        checkOutCartButton.setTitleColor(UIColor.white, for:.normal)
        checkOutCartButton.addTarget(self, action: #selector(self.goToCart), for: .touchUpInside)
        self.view.addSubview(checkOutCartButton)
    }
    

    func getData()
    {

        myMoltin.product.all { result in
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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")


        let bookModel = tableArray[indexPath.row]
        cell.textLabel?.text = bookModel.name


        //its in int

        let price = Float(bookModel.price![0].amount)/100
        //not worried about the accuarcy  for now
        cell.detailTextLabel?.text = "$" + String(price)

       //cannot get url,unknownk size issue
        cell.imageView?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "bookImage"))

        let addToCartButton = UIButton()
        addToCartButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.layer.cornerRadius = 2
        addToCartButton.setTitleColor(UIColor.white, for:.normal)
        addToCartButton.addTarget(self, action: #selector(self.addToCart), for: .touchUpInside)
        cell.contentView.addSubview(addToCartButton)

        //important
        addToCartButton.tag = indexPath.row

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

    //cart Logic

  @objc  func addToCart(sender:UIButton)
    {

    }


 @objc   func goToCart()
    {
        let vc = CartViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }


}

