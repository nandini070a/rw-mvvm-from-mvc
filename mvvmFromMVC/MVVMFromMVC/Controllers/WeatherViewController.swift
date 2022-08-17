
import UIKit

class WeatherViewController: UIViewController {
  private let weatherViewModel = WeatherViewModel()
  let defaultAddress = "McGaheysville, VA"
  
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentIcon: UIImageView!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var forecastSummary: UITextView!
  @IBOutlet weak var promptForLocation: UIButton!
  
    override func viewDidLoad() {
      setupUI(cityName: defaultAddress)
    }
  
  private func setupUI(cityName: String) {
    weatherViewModel.convertToLocation(to: cityName) { result in
      switch result {
      case .success(let weatherData):
        self.cityLabel.text = weatherData.locationName
        self.dateLabel.text = weatherData.date
        self.currentIcon.image = weatherData.icon
        self.currentSummaryLabel.text = weatherData.summary
        self.forecastSummary.text = weatherData.forecastSummary
      case .failure(let error):
          let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
          let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
      }
    }
  }
    
    @IBAction func promptForLocation(_ sender: Any) {
      let alert = UIAlertController(
        title: "Choose location",
        message: nil,
        preferredStyle: .alert)
       alert.addTextField()
      let submitAction = UIAlertAction(
        title: "Submit",
        style: .default) { [unowned alert, weak self] _ in
          guard let self = self, let newLocation = alert.textFields?.first?.text else { return }
          self.setupUI(cityName: newLocation)
      }
      alert.addAction(submitAction)
      present(alert, animated: true)
    }
}
