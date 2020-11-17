import UIKit

var str = "Hello, playground"
//MARK: - Model
struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}
//MARK: - Model Controller
// https://swapi.dev/api/people/10/

class SwapiService {
    static let baseURL = URL(string: "https://swapi.dev/api/")
    static let peopleComponent = "people"
    static let filmComponent = "film"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        
        let peopleURL = baseURL.appendingPathComponent(peopleComponent)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        } .resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        } .resume()
    }
}
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film)
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
        
        
    }
} //MARK: - End of Class
