
import Foundation

struct WeatherbitData: Decodable {
  
  private static let dateFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  // JSON Decodable
  
  let observation: [Observation]
  
  struct Observation: Decodable {
    let temp: Double
    let datetime: String
    
    let weather: Weather
    
    struct Weather: Decodable {
      let icon: String
      let description: String
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case observation = "data"
  }
  
  //Used for Unit Testing
  
  var currentTemp: Double {
    observation[0].temp
  }
  
  var iconName: String {
    observation[0].weather.icon
  }
  
  var description: String {
    observation[0].weather.description
  }
  
  var date: Date {
    //strip off the time
    let dateString = String(observation[0].datetime.prefix(10))
    //use current date if unable to parse
    return Self.dateFormatter.date(from: dateString) ?? Date()
  }
  
}



