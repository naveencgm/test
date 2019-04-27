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
        getCartData()
    }

    func configureTableView()
    {
        self.view = tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self

        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


    func getCartData()
    {
HUD.show(.progress)
        self.myMoltin.cart.include([.products]).items(forCartID: AppDelegate.cartID) { (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.tableArray = result.data ?? []
                    HUD.hide()
                    print(result.data)
                }
            case .failure(let error):
                HUD.hide()
                print("Cart error:", error)
            }
        }
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")


        let bookModel = tableArray[indexPath.row]
        cell.textLabel?.text = bookModel.name


        //its in int

        let price = 78 //Float(bookModel.price![0].amount)/100
        //not worried about the accuarcy  for now
        cell.detailTextLabel?.text = "$" + String(price)

        //cannot get url,unknownk size issue
        cell.imageView?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "bookImage"))

        let button : UIButton = UIButton(type:UIButton.ButtonType.roundedRect) as UIButton
        button.frame = CGRect(x: cell.contentView.frame.width - 65, y: 30, width: 100, height: 25)
        button.setTitleColor(UIColor.white, for:.normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        button.setTitle("Checkout", for: .normal)
        cell.addSubview(button)

        //important
        button.tag = indexPath.row
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
        let product = tableArray[sender.tag]

        HUD.show(.progress)
        self.myMoltin.cart.addProduct(withID: product.id , ofQuantity: 1, toCart: AppDelegate.cartID, completionHandler: { (_) in
            DispatchQueue.main.async {

                HUD.show(.success)
                HUD.hide()

            }
        })



    }




    @objc   func increaseCount()
    {
        let vc = CartViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }


    @objc   func decreaseCount()
    {
        let vc = CartViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }


}
