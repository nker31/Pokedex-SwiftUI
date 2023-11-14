//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 14/11/2566 BE.
//

import Foundation
import SwiftUI

struct Pokemon: Identifiable, Codable {
    let id: String
    let name: String
    let imageUrl: URL?
    let xDescription: String
    let yDescription: String
    let height: String
    let category: String
    let weight: String
    let types: [String]
    let weaknesses: [String]
    let evolutions: [String]
    let abilities: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int?
    let specialDefense: Int?
    let speed: Int
    let total: Int
    let malePercentage: String?
    let femalePercentage: String?
    let genderless: Int
    let cycles: String
    let eggGroups: String
    let evolvedFrom: String?
    let reason: String?
    let baseExp: String

    enum CodingKeys: String, CodingKey {
        case id, name, xDescription = "xdescription", yDescription = "ydescription"
        case height, category, weight, types = "typeofpokemon", weaknesses, evolutions, abilities
        case hp, attack, defense, specialAttack = "special_attack", specialDefense = "special_defense", speed, total
        case malePercentage = "male_percentage", femalePercentage = "female_percentage", genderless, cycles, eggGroups = "egg_groups"
        case evolvedFrom = "evolvedfrom", reason, baseExp = "base_exp", imageUrl = "imageurl"
    }
}


let MOCK_POKEMON:[Pokemon] = [
    .init(id: "#001", name: "Bulbasaur", imageUrl: URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png"), xDescription: "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger.", yDescription: "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger.", height: "2' 04\"", category: "Seed", weight: "15.2 lbs", types: ["Grass", "Poison"], weaknesses: ["Fire", "Flying", "Ice", "Psychic"], evolutions: ["#001", "#002", "#003"], abilities: ["Overgrow"], hp: 20, attack: 30, defense: 20, specialAttack: 30, specialDefense: 30, speed: 30, total: 160, malePercentage: "87.5%", femalePercentage: "12.5%", genderless: 0, cycles: "20", eggGroups: "Grass, Monster ", evolvedFrom: "", reason: "", baseExp: "64")

]
