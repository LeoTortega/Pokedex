//
//  ViewController.swift
//  Pokedex
//
//  Created by Leonardo Torres Ortega on 01/11/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokeballImage: UIImageView!
    
    private var pokemonListVM: PokemonsListViewModel!
    var filteredPokemons: [Pokemons]!
    private var selectedPoke: Pokemons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonCell")
        searchBar.delegate = self
        
        preparation()
        
    }
 
}

//MARK: - Table View Delegate
extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPokemons == nil {
            return 0
        } else{
            return filteredPokemons.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell)!
        
        cell.selectionStyle = .none
        cell.cellView.layer.cornerRadius = cell.frame.size.height / 5
        
        let pokemonVM = filteredPokemons[indexPath.row]
        
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
}

//MARK: - Segue
extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPoke = filteredPokemons[indexPath.row]
        
        performSegue(withIdentifier: "pokemonSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pokemonSegue" {
            if let destinationVC = segue.destination as? PokemonViewController {
                
                destinationVC.pokemon = selectedPoke
                
            }
        }
    }
}

//MARK: - Scroll View
extension ViewController {
    //Objeto gira conforme o scroll view é scrollado
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topOffset = scrollView.contentOffset.y
        let angle = -topOffset * 2 * CGFloat(Double.pi / 720)
        self.pokeballImage.transform = CGAffineTransform(rotationAngle: angle)
    }
}

//MARK: - Search Bar
extension ViewController{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredPokemons = []
        
        if searchText == "" {
            filteredPokemons = pokemonListVM.pokemons
        } else {
            for poke in pokemonListVM.pokemons {
                if poke.name.contains(searchText.lowercased()){
                    filteredPokemons.append(poke)
                }
            }
        }
                      
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

//MARK: - Outras funções
extension ViewController{
    
    
    func preparation(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let image = UIImage()
        
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        
        pokemonListVM = PokemonsListViewModel()
        
        fullfillArray()
    }
    
    func fullfillArray(){
        
        pokemonListVM.pokemons.removeAll()
        
        PokeAPI().getData { pokemon in
            for poke in pokemon{
                self.pokemonListVM.pokemons.append(poke)
                
            }
            
            self.filteredPokemons = self.pokemonListVM.pokemons
            
            self.tableView.reloadData()
        }
        
        
        
        
    }
    
}


