//
//  HomeViewController.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,Aletable {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var listOfTerritories = [Territory]()
    
    //****************************************************************************************
    //MARK: Life Cycle Method
    //****************************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner()
        getWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //****************************************************************************************
    //MARK: Custom Method
    //****************************************************************************************
    
    private func getWeatherData() {
        do {
            try WeatherViewModel().getYearOrderedStats(completion: {(status, message, list) in
                self.dissmissSpinner()
                if status {
                    DispatchQueue.main.async {
                        self.listOfTerritories = list
                        self.reloadTableView()
                    }
                } else {
                    self.showAlert(message)
                }
            })
            
        } catch {
            self.showAlert(Constants.Message.ErrorMessage.somethingWentWrong)
        }
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.detailIdentifier {
            if let controller = segue.destination as? DetailViewController {
                if let list = sender as? ArraySlice<Weather> {
                    controller.listOfWeather = Array(list)
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listOfTerritories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTerritories[section].temperature.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:HomeTableViewCell.self), for: indexPath) as? HomeTableViewCell
        cell?.setDto(Params.getWeatherParam(index: indexPath.row))
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = listOfTerritories[indexPath.section].temperature[indexPath.row].listOfTemp.count
        let subList = listOfTerritories[indexPath.section].temperature[indexPath.row].listOfTemp[count-3 ... count-1]
        performSegue(withIdentifier: Constants.Segue.detailIdentifier, sender: subList)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Params.getRegionCode(index: section)
    }
    
}

