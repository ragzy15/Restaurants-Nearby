//
//  TableViewController.swift
//  EatingPlaces
//
//  Created by Raghav Ahuja on 10/01/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var places: [Places]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = places {
            return places.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        guard let places = places else {
            return cell
        }
        cell.configure(name: places[indexPath.item].name, imageURLString: places[indexPath.item].icon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var placeImageView: UIImageView!
    @IBOutlet private weak var placeNameLabel: UILabel!
    
    func configure(name: String, imageURLString: String) {
        placeNameLabel.text = name
        
        if let imageURL = URL(string: imageURLString) {
            fetchImage(url: imageURL) { (image) in
                self.placeImageView.image = image
            }
        }
    }
    
    private func fetchImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        let request = URLRequest(url: url)
        if let response = URLSession.shared.configuration.urlCache?.cachedResponse(for: request), let image = UIImage(data: response.data) {
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            } else if let data = data {
                completion(UIImage(data: data))
                return
            }
        }
    }
}
