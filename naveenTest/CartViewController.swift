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
        let price = Float(cartItem.price![0].amount)/100
        //not worried about the accuarcy  for now
        cell.detailTextLabel?.text = "$" + String(price)
        //cannot get url,unknownk size issue
        cell.imageView?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "bookImage"))
        
        
        let button : UIButton = UIButton(type:UIButton.ButtonType.roundedRect) as UIButton
        button.frame = CGRect(x: cell.contentView.frame.width - 65, y: 30, width: 100, height: 25)
        button.setTitleColor(UIColor.white, for:.normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        button.setTitle("Delete", for: .normal)
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
        
        let customer = Customer(withEmail: "naveen@nchandra.com", withName: "Chandra Naveen")
        let address = Address(withFirstName: "Chandra", withLastName: "Naveen")
        address.line1 = "Hrbr"
        address.county = "Bangalore"
        address.country = "India"
        address.postcode = "560034"
        
        
        self.myMoltin.cart.checkout(cart: AppDelegate.cartID, withCustomer: customer, withBillingAddress: address, withShippingAddress: address) { (result) in
            switch result {
            case .success(let order):
                self.payForOrder(order)
            case .failure(let error):
                HUD.flash(.labeledError(title: "oops", subtitle: error.localizedDescription), delay: 2.0)
            default: break
            }
        }
    }
    
    
    func payForOrder(_ order: Order) {
        let paymentMethod = ManuallyAuthorizePayment()
        self.myMoltin.cart.pay(forOrderID: order.id, withPaymentMethod: paymentMethod) { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async
                    {
                        HUD.flash(.labeledSuccess(title: "Done", subtitle: "Your order has been sent"), delay: 5.0)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "oops", subtitle: error.localizedDescription), delay: 2.0)
                }
            }
        }
    }
    
    
    
    
    @objc   func increaseCount()
    {
        
    }
    
    
    @objc   func decreaseCount()
    {
        
    }
    
    
}
