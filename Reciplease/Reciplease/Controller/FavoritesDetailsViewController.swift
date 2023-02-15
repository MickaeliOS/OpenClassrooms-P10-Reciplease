//
//  FavoritesDetailsViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 15/02/2023.
//

import UIKit

class FavoritesDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    
    @IBAction func getDirections(_ sender: UIButton) {
        
    }
    
    @IBAction func favoritesAddOrRemove(_ sender: UIBarButtonItem) {
        
    }
    
}
