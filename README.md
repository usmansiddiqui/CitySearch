# CitySearch
Search cities from local JSON list.


Project Information:

Language Used: Swift : 4.2
Environment: XCode : 10.0
Deployment Target : iOS 12.0
Devices: Universal


Approach:

I have created a Navigation based application with couple of View Controllers. In my main view controller that is CityViewController. I am making a call to load Cities list from the json file. JSON file is local to the app. i have created a struct of "City" and made it Codable so i can use JSONDecoder decode the json into an array of City objects. I have added a property observer in this allCities array and when the deserialization is completed, i use higher order sort function on allCities to sort the array.

I have used background Queue to load the json objects into Array as its a pretty long list. once the list is populated and sorted, i am updating the tableview.

I have used Search Controller for filter and used UISearchResultsUpdating protocol to get the updates when user is typing in the filter.

For the filter, i am also using background queue to filter the result and making the call on main queue to update the UI. For filtering the results, i have this intermediate array(filteredCities) that will hold just the filtered Results. At the start before any filter, this array is replica of allCiites list i.e. containing all the same items.

For filtering the results, i am using another higher order filter function and to filter the result based on the prefix of the city name. I am using lowercased string for both search term and the city to make sure different cases are covered.

Few test cases are also added to test sorting and filtering is working fine.

Project link :
https://github.com/usmansiddiqui/CitySearch.git


