//
//  DetailViewController.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 04/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var listOfWeather = [Weather]()
    
    //****************************************************************************************
    //MARK: Life Cycle Method
    //****************************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listOfWeather.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfWeather[section].listOfValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:DetailTableViewCell.self), for: indexPath) as? DetailTableViewCell
        cell?.setWeatherValue(listOfWeather[indexPath.section].listOfValues[indexPath.row],indexPath.row)
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listOfWeather[section].year
    }
}

