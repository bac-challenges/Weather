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
//	ID: 215ECE0A-7518-4933-8DF9-CC8D5B0D076F
//
//	Pkg: Weather
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

class WeatherListController: UITableViewController {
	
	let store = WeatherStore()
	var observer: NSKeyValueObservation?
	
	private lazy var searchField: UITextField = {
		let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
		textField.borderStyle = .roundedRect
		textField.clearButtonMode = .always
		textField.placeholder = "Enter location..."
		textField.addTarget(self, action: #selector(addLocation), for: .primaryActionTriggered)
		return textField
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Add KVO
		observer = store.observe(\WeatherStore.items) { [unowned self] (items, change) in
			DispatchQueue.main.sync {
				self.tableView.reloadData()
			}
		}
		
		// Fetch data
		store.fetch()
	}
}

// MARK: - Actions
extension WeatherListController {
	@objc func addLocation() {
		if let text = searchField.text {
			store.search(query: text) { [unowned self] result in
				switch result {
				case .success(let weather): self.show(message: "\(weather.name) added")
				case .failure(let error): self.show(message: "Location \(error)")
				}
			}
		}
	}
}

// MARK: - UI
extension WeatherListController {
	private func setupView() {
		navigationItem.titleView = searchField
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
															target: self,
															action: #selector(addLocation))
			
		tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
		tableView.backgroundColor = .white
		tableView.rowHeight = 80
	}
}

// MARK: - UITableViewDelegate
extension WeatherListController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let child = WeatherDetailController()
		child.item = store.items[indexPath.row]
		self.navigationController?.pushViewController(child, animated: true)
	}
}

// MARK: - UITableViewDataSource
extension WeatherListController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return store.items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else {
			return UITableViewCell()
		}
		cell.configure(store.items[indexPath.row])
		return cell
	}
}

// MARK: - Util
extension WeatherListController {
	private func show(message: String) {
		DispatchQueue.main.sync {
			let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
			alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
