/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {
  
  @IBOutlet private var checkoutButton: UIButton!
  //@IBOutlet private var totalItemsLabel: UILabel!
  @IBOutlet private var totalCostLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  private let disposeBag = DisposeBag()
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Cart"
    configureFromCart()
    setupCart()
  }
  
  //MARK: Rx Setup
  private func setupCart() {
    let cart = ShoppingCart.sharedCart.chocolates.asObservable()
    cart.bindTo(
      tableView
      .rx
      .items(cellIdentifier: ShoppingCartCell.Identifier, cellType: ShoppingCartCell.self)) {
          row, chocolate, cell in
          cell.configureWithChocolate(chocolate: chocolate)
    }
    .addDisposableTo(disposeBag)
  }
  
  private func configureFromCart() {
    guard checkoutButton != nil else {
      //UI has not been instantiated yet. Bail!
      return
    }
    
    let cart = ShoppingCart.sharedCart
    //totalItemsLabel.text = cart.itemCountString()
    
    let cost = cart.totalCost()
    totalCostLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: cost)
    
    //Disable checkout if there's nothing to check out with
    checkoutButton.isEnabled = (cost > 0)
  }
  
  @IBAction func reset() {
    ShoppingCart.sharedCart.chocolates.value = []
    let _ = navigationController?.popViewController(animated: true)
  }
}
