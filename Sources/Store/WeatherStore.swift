//	MIT License
//
//	Copyright © 2019 Emile, Blue Ant Corp
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
//	ID: 9C27E58C-5604-406A-87C3-F9B248A95E19
//
//	Pkg: Weather
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

class WeatherStore: NSObject {
	
	private let locationsKey = "locations"
	
	@objc dynamic var items: [WeatherViewModel] = []
	
	private let service = Service()
	private var locations: Set<String> = [] {
		didSet {
			save()
		}
	}
	private var locationsString: String {
		return locations.joined(separator: ",")
	}
	
	override init() {
		super.init()
		self.load()
	}
}

// MARK: - Cache
extension WeatherStore {
	private func save() {
		UserDefaults.standard.set(locationsString, forKey: locationsKey)
	}
	
	private func load() {
		if let arr = UserDefaults.standard.string(forKey: locationsKey)?.components(separatedBy: ",") {
			locations = Set(arr)
		}
	}
}


// MARK: - Network
extension WeatherStore {
	
	func search(query: String) {
		service.fetch(endpoint: WeatherEndPoint.search(city: query)) { (result: Result<Weather, ServiceError>) in
			switch result {
			case .success(let weather):
				self.locations.insert("\(weather.id)")
				self.fetch()
			case .failure(let error): print(error)
			}
		}
	}
	
	func fetch() {
		service.fetch(endpoint: WeatherEndPoint.group(id: locationsString)) { (result: Result<WeatherGroup, ServiceError>) in
			switch result {
			case .success(let group):
				self.items = group.list.map { item in
					WeatherViewModel(source: item)
				}
				.sorted { $0.name < $1.name }
			case .failure(let error): print(error)
			}
		}
	}
}
