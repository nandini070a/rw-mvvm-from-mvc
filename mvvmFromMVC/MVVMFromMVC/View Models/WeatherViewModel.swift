
import Foundation
import UIKit.UIImage

enum NetworkError: Error {
  case technicalError
  case parsingError
  case decodingError
}

public class WeatherViewModel {
  
  static let defaultAddress = "McGaheysville, VA"
  private let geocoder = LocationGeocoder()

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter
  }()
  
  private let tempFormatter: NumberFormatter = {
    let tempFormatter = NumberFormatter()
    tempFormatter.numberStyle = .none
    return tempFormatter
  }()
  
  
  func convertToLocation(to newLocation: String, completion: @escaping (Result<WeatherDataForUI, NetworkError>) -> ()) {
    geocoder.geocode(addressString: newLocation) { [weak self] locations in
      guard let self = self else {return}
      if let location = locations.first {
          self.fetchWeatherForLocation(location) { weatherData in
            if let weatherData = weatherData {
              let locationName = location.name
              let date = self.dateFormatter.string(from: weatherData.date)
              let icon = UIImage(named: weatherData.iconName)
              let temp = self.tempFormatter
                .string(from: weatherData.currentTemp as NSNumber) ?? ""
              let summary = "\(weatherData.description) - \(temp)℉"
              let forecastSummary = "\nSummary: \(weatherData.description)"
              let weatherDataForUI = WeatherDataForUI(locationName: locationName, date: date, icon: icon ?? UIImage(), summary: summary, forecastSummary: forecastSummary)
                completion(.success(weatherDataForUI))
            } else {
              completion(.failure(.technicalError))
            }
        }
      } else {
        completion(.failure(.technicalError))
      }
    }
  }
  
  private func fetchWeatherForLocation(_ location: Location, completion: @escaping (WeatherbitData?) -> ()) {
    WeatherbitService.weatherDataForLocation(
      latitude: location.latitude,
      longitude: location.longitude) { (weatherData, error) in
        completion(weatherData)
    }
  }
}
