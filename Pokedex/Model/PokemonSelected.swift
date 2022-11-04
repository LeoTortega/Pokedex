//
//  PokemonSelected.swift
//  Pokedex
//
//  Created by Leonardo Torres Ortega on 01/11/22.
//

import Foundation

struct PokemonSelected: Codable {
    var sprites: PokemonSprites
    var height: Int
    var weight: Int
    var id: Int
    var types: [Types]
}

struct PokemonSprites: Codable{
    var front_default: String
    
}

struct Types: Codable {
    var type: Type
}

struct Type: Codable{
    var name: String
}

class PokemonSelectedApi{
    
    func getSprite(url: String, completion: @escaping (PokemonSelected) -> ()){
        guard let url = URL(string: url) else{
            return
        }
         
        URLSession.shared.dataTask(with: url) { data, _ , _ in
            guard let data = data else { return }
            
            let pokemonSprite = try! JSONDecoder().decode(PokemonSelected.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonSprite)
            }
        }.resume()
        
    }
    
}
