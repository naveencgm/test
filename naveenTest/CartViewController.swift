//
//  CartViewController.swift
//  naveenTest
//
//  Created by Naveen Chandra on 27/04/19.
//  Copyright © 2019 Naveen Chandra. All rights reserved.
//

import UIKit
import PKHUD
import moltin

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {


    let myMoltin = Moltin(withClientID:moltinCLientId)

    let tableview = UITableView()
     var tableArray = [moltin.CartItem]()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Cart"
        configureTableView()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        getCartItems()
    }

    func configureTableView()
    {
        self.view = tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self

        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }



    func getCartItems()
    {
        let referenceId = AppDelegate.cartID

        self.myMoltin.cart.items(forCartID: referenceId) { (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.tableArray = result.data ?? []
                    self.tableview.reloadData()
                }
            case .failure(let error):
                print("Cart error:", error)
            }
        }
    }




    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        let cartItem = tableArray[indexPath.row]
        cell.textLabel?.text = cartItem.name
        //cannot get url,unknownk size issue
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {

        let checkOutCartButton =  UIButton(frame: CGRect(x: 0, y:10, width: self.view.frame.width - 20, height: 30))
        checkOutCartButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        checkOutCartButton.setTitle("Checkout", for: .normal)
        checkOutCartButton.layer.cornerRadius = 15
        checkOutCartButton.setTitleColor(UIColor.white, for:.normal)
        checkOutCartButton.backgroundColor = .blue
        checkOutCartButton.addTarget(self, action: #selector(self.checkout), for: .touchUpInside)

        return checkOutCartButton

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }

    //cart Logic

    @objc  func checkout(sender:UIButton)
    {


    }




    @objc   func increaseCount()
    {

    }


    @objc   func decreaseCount()
    {

    }


}
