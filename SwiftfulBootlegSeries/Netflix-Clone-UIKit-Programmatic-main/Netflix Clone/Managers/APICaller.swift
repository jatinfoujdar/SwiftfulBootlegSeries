//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Aarish Khanna on 19/01/23.
//

import UIKit

struct Constants {
    static let API_KEY = "ed3c6db2f42a032f11b4672031130c12"
    static let baseURL = "https://api.themoviedb.org/"
    static let screenSize: CGRect = UIScreen.main.bounds
    static let YoutubeAPI_KEY = ""
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
//    let screenWidth = screenSize.width
//    let screenHeight = screenSize.height
    
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(results)
                
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
              //  print(results.results[0].original_name)
                
            }
            catch{
               // print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }
        
        task.resume()
        
    }
    
    func getTredingTvs(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url:url)){
           data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
              //  let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
             //   print(results)
                
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
       
//        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}

        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //print(results)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //print(results)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        task.resume()

    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        task.resume()

    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
               // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                 print(results)
            }
            catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    
}
