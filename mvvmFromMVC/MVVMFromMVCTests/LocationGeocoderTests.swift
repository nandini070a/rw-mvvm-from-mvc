
import XCTest
@testable import Grados

class LocationGeocoderTests: XCTestCase {
  var geocoder = LocationGeocoder()

  func testGeocodingRazewareHeadquarters() {
    let expectation = self.expectation(description: "Geocoding Results")

    geocoder.geocode(addressString: "McGaheysville, VA") { (locations: [Location])  in
      print(locations)
      XCTAssertEqual(locations.count, 1)
      XCTAssertEqual(locations.first!.name, "McGaheysville, VA")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
  }
}
