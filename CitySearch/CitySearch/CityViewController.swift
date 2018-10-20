//
//  CityViewController.swift
//  CitySearch
//
//  Created by Usman Siddiqui on 10/19/18.
//  Copyright © 2018 Usman_Siddiqui. All rights reserved.
//

import UIKit

class CityViewController: UITableViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let cityQueue =
        DispatchQueue(
            label: "com.backbase.citySearch",
            attributes: .concurrent)
    
    var allCities = [City]() {
        didSet {
            return allCities.sort {
                $0.name < $1.name
            }
        }
    }
    var filteredCities = [City]()
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cities"
        setupSearchBar()
        addLoader()
        loadCities { cities in
            self.allCities = cities
            self.filteredCities = cities
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
    }

    func loadCities(completion: @escaping ([City]) -> Void) {
        
        cityQueue.async(flags: .barrier) {
            if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonDecoder = JSONDecoder()
                    let cities = try jsonDecoder.decode([City].self, from: data)
                    completion(cities)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.removeLoader()
                    }
                    
                }
                    
                catch let error {
                    print(error)
                }
            }
        }
        

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") {
            cell.textLabel?.text = getFormattedName(city: filteredCities[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    private func getFormattedName(city: City) -> String
    {
        return "\(city.name), \(city.country) "
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String,cities: [City],completion: @escaping ([City]) -> Void) {
        completion(cities.filter({( city : City) -> Bool in
            return city.name.lowercased().hasPrefix(searchText.lowercased())
        }))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MapViewController {
            
            if let index = selectedIndex {
                destination.city = filteredCities[index]
            }
        }
        
    }

    private func addLoader() {
        
        // Sets the view which contains the loading text and the spinner
        let viewWidth: CGFloat = 120
        let viewHeight: CGFloat = 30
        let x = (tableView.frame.width / 2) - (viewWidth / 2)
        
        if let height = navigationController?.navigationBar.frame.height {
            let y = (tableView.frame.height / 2) - (viewHeight / 2) - height
                loadingView.frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeight)
        }
        
        let loadingLabel = UILabel()
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoader() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text {
            
            cityQueue.async(flags: .barrier) {
                self.filterContentForSearchText(text,cities: self.allCities, completion: { cities in
                self.filteredCities = cities
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
}
