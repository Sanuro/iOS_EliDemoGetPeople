//
//  PeopleViewController.swift
//  eliDemoHTTP
//
//  Created by Jaewon Lee on 7/12/18.
//  Copyright © 2018 Jaewon Lee. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController {
    // Hardcoded data for now
    var people:[NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(from: "http://swapi.co/api/people/")
        print(people)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // if we return - sections we won't have any sections to put our rows in
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the count of people in our data array
        return people.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a generic cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "protoCell", for: indexPath)
        // set the default cell label to the corresponding element in the people array
        cell.textLabel?.text = people[indexPath.row]["name"] as! String
        // return the cell so that it can be rendered
        return cell
    }

    func getData(from url: String){
        // specify the url that we will be sending the GET Request to
        let url = URL(string: url)
        // create a URLSession to handle the request tasks
        let session = URLSession.shared
        // create a "data task" to make the request and run the completion handler
        let task = session.dataTask(with: url!) {
            // see: Swift closure expression syntax
            data, response, error in
            print("in here")
            // see: Swift nil coalescing operator (double questionmark)
            print(data ?? "no data") // the "no data" is a default value to use if data is nil
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    let newPeople = jsonResult["results"] as! [NSDictionary]
                    self.people.append(contentsOf: newPeople)
                    
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                        
                    }
                    if let nextURL = jsonResult["next"] as? String{
                        self.getData(from: nextURL)
                        
                    }
                }
            } catch {
                print(error)
            }
           
        }
        // execute the task and wait for the response before
        // running the completion handler. This is async!
        task.resume()
            
    }
}
