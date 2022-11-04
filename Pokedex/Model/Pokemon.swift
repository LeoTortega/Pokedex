//
//  Pokemon.swift
//  Pokedex
//
//  Created by Leonardo Torres Ortega on 01/11/22.
//

import Foundation

struct Pokedex: Codable {
    
    let results: [Pokemons]
    
}

class Pokemons: Codable, Identifiable{
    
    let id = UUID()
    let name: String
    let url: String
    
}

class PokeAPI {
    
    func getData(completion: @escaping ([Pokemons]) -> ()){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _ , _ in
            guard let data = data else { return }
            
            let pokemonList = try! JSONDecoder().decode(Pokedex.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonList.results)
            }
            
        }.resume()
        
    }
    
}
