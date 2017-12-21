//
//  ShoppingCartCell.swift
//  Chocotastic
//
//  Created by Mira Estil on 12/20/17.
//  Copyright © 2017 RayWenderlich.com. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {
  
  static let Identifier = "ShoppingCartCell"

  @IBOutlet weak var shoppingCartLabel: UILabel!
  
  func configureWithChocolate(chocolate: Chocolate) {
      shoppingCartLabel.text = chocolate.countryName
  }
}
