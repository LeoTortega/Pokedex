//
//  ViewController.swift
//  Pokedex
//
//  Created by Leonardo Torres Ortega on 01/11/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var pokemonListVM: PokemonsListViewModel!
    
    private var selectedPoke: Pokemons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonCell")
        
        preparation()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonListVM.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell)!
        
        cell.selectionStyle = .none
        cell.cellView.layer.cornerRadius = cell.frame.size.height / 5
        
        let pokemonVM = pokemonListVM.pokemons[indexPath.row]
        
        cell.pokemonName.text = pokemonVM.name.capitalized
        
        let sprite : PokemonSprites
        
        PokemonSelectedApi().getSprite(url: pokemonVM.url) { pokemonSelected in
            let poke = pokemonSelected
            let type = poke.types
            
            cell.cellView.backgroundColor = UIColor(hexString: TypeColor.callCollor(type: type[0].type.name), alpha: 1.0)
            
            cell.idLabel.text = "#\(poke.id)"
            
            cell.pokemonType1.sizeToFit()
            cell.pokemonType1.layer.cornerRadius = cell.pokemonType1.frame.size.height / 3.0
            cell.pokemonType1.layer.masksToBounds = true
            cell.pokemonType1.backgroundColor = UIColor(hexString: "#808080", alpha: 0.4)
            cell.pokemonType1.text = type[0].type.name.capitalized
            
            if type.count > 1 {
                cell.pokemonType2.sizeToFit()
                cell.pokemonType2.layer.cornerRadius = cell.pokemonType2.frame.size.height / 3.0
                cell.pokemonType2.layer.masksToBounds = true
                cell.pokemonType2.backgroundColor = UIColor(hexString: "#808080", alpha: 0.4)
                cell.pokemonType2.text = type[1].type.name.capitalized
            } else {
                cell.pokemonType2.isHidden = true
            }
            
            let url = URL(string: poke.sprites.front_default)
            
            cell.pokemonImage.downloaded(from: url!)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPoke = pokemonListVM.pokemons[indexPath.row]
        
        performSegue(withIdentifier: "pokemonSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pokemonSegue" {
            if let destinationVC = segue.destination as? PokemonViewController {
                
                let url = selectedPoke.url
                
                PokemonSelectedApi().getSprite(url: url) { poke in
                    
                    destinationVC.pokemonImage.downloaded(from: poke.sprites.front_default)
                    destinationVC.pokemonLabel.text = self.selectedPoke.name.capitalized
                    destinationVC.pokemonType1.text = poke.types[0].type.name.capitalized
                    destinationVC.pokemonType1.layer.cornerRadius = destinationVC.pokemonType1.frame.size.height / 3.0
                    destinationVC.pokemonType1.layer.masksToBounds = true
                    destinationVC.pokemonType1.backgroundColor = UIColor(hexString: "#808080", alpha: 0.4)
                    
                    if poke.types.count > 1 {
                        destinationVC.pokemonType2.text = poke.types[1].type.name.capitalized
                        destinationVC.pokemonType2.layer.cornerRadius = destinationVC.pokemonType1.frame.size.height / 3.0
                        destinationVC.pokemonType2.layer.masksToBounds = true
                        destinationVC.pokemonType2.backgroundColor = UIColor(hexString: "#808080", alpha: 0.4)
                    } else {
                        destinationVC.pokemonType2.isHidden = true
                    }
                    
                    destinationVC.view.backgroundColor = UIColor(hexString: TypeColor.callCollor(type: poke.types[0].type.name), alpha: 1.0)
                    destinationVC.pokemonId.text = "#\(poke.id)"
                    destinationVC.weightLabel.text = "\(poke.weight)lbs"
                    destinationVC.heightLabel.text = "\(poke.height * 10)cm"
                    destinationVC.aboutView.layer.cornerRadius = destinationVC.aboutView.frame.size.height / 12
                    destinationVC.aboutView.layer.masksToBounds = true
                }
                
            }
        }
        
    }
    
}


extension ViewController{
    
    func preparation(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        pokemonListVM = PokemonsListViewModel()
        
        PokeAPI().getData { pokemon in
            for poke in pokemon{
                self.pokemonListVM.pokemons.append(poke)
                
            }
            
            self.tableView.reloadData()
        }
    }
}


