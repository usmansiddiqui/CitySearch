//
//  CitySearchTests.swift
//  CitySearchTests
//
//  Created by Usman Siddiqui on 10/19/18.
//  Copyright © 2018 Usman_Siddiqui. All rights reserved.
//

import XCTest
@testable import CitySearch

class CitySearchTests: XCTestCase {

    var vc = CityViewController()
    var cities = [City]()
    
    override func setUp() {
        loadCities()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func loadCities() {
        let expectation = XCTestExpectation(description: "Load city list")
        vc.loadCities { cities in
            self.cities = cities
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSorting() {
        XCTAssertEqual(cities[0].name, "Hurzuf") //First city in the alhpabetical sorted list
    }
    
    func testFilter() {
        
        //for valid search term such as Albuquerque, list should have this item at Albuquerque index
        vc.filterContentForSearchText("Albuquerque",cities: cities, completion: { cities in
            XCTAssertEqual(cities[0].name, "Albuquerque") //First city in the alhpabetical sorted list
        })
        
        //for valid search term such as San Francisco, list should have this item at 0th index
        vc.filterContentForSearchText("Atlanta",cities: cities, completion: { cities in
            XCTAssertEqual(cities[0].name, "Atlanta") //First city in the alhpabetical sorted list
        })
        
        //for invalid search term, list should be empty
        vc.filterContentForSearchText("ABCDE",cities: cities, completion: { cities in
            XCTAssertEqual(cities.count, 0) //no items should be there
        })
        
        //for a search term like "milan", the first result shouldn't be any thing else so testing that scenario.
        vc.filterContentForSearchText("Milan",cities: cities, completion: { cities in
            XCTAssertNotEqual(cities[0].name, "Boston")
        })
        
    }

}
