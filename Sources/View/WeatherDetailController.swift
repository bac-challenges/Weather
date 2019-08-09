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
//	ID: 91CC2E6E-26B4-4502-AFB3-DDF5CE7CB8E3
//
//	Pkg: Weather
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

class WeatherDetailController: UIViewController {
	
	var item: WeatherViewModel?
	
	private lazy var textLabel: UILabel = {
		let label = UILabel()
		label.text = "N/A"
		label.textAlignment = .center
		label.textColor = .lightGray
		label.font = .systemFont(ofSize: 128, weight: .thin)
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
}

// MARK: - UI
extension WeatherDetailController {
	private func setupView() {
		
		view.backgroundColor = .white
		
		//
		if let item = item {
			title = item.name
		
			view.addSubview(textLabel)
			textLabel.text = item.temp
			textLabel.layout {
				$0.centerX == view.centerXAnchor
				$0.centerY == view.centerYAnchor
			}
		}
	}
}
