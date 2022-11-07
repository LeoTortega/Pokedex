//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Leonardo Torres Ortega on 03/11/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    var pokemon: Pokemons!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonId: UILabel!
    @IBOutlet weak var pokemonType2: UILabel!
    @IBOutlet weak var pokemonType1: UILabel!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var aboutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = pokemon.url
        
        PokemonSelectedApi().getSprite(url: url) { poke in
            
            self.pokemonImage.downloaded(from: poke.sprites.front_default)
            self.pokemonLabel.text = self.pokemon.name.capitalized
            self.pokemonType1.text = poke.types[0].type.name.capitalized
            self.pokemonType1.layer.cornerRadius = self.pokemonType1.frame.size.height / 3.0
            self.pokemonType1.layer.masksToBounds = true
            self.pokemonType1.backgroundColor = UIColor(hexString: "#808080", alpha: 0.4)
            
            if poke.types.count > 1 {
                self.pokemonType2.text = poke.types[1].type.name.capitalized
                self.pokemonType2.layer.cornerRadius = self.pokemonType1.frame.size.height / 3.0
                self.pokemonType2.layer.masksToBounds = true
                self.pokemonType2.backgroundColor = UIColor(hexString: "#808080", alpha: 0.4)
            } else {
                self.pokemonType2.isHidden = true
            }
            
            self.view.backgroundColor = UIColor(hexString: TypeColor.callCollor(type: poke.types[0].type.name), alpha: 1.0)
            self.pokemonId.text = "#\(poke.id)"
            self.weightLabel.text = "\(poke.weight)lbs"
            self.heightLabel.text = "\(poke.height * 10)cm"
            self.aboutView.layer.cornerRadius = self.aboutView.frame.size.height / 12
            self.aboutView.layer.masksToBounds = true
        }
        
    }
    

    

}
