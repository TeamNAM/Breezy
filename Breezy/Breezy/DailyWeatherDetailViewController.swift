//
//  DailyWeatherDetailViewController.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/27/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import BEMSimpleLineGraph
import ForecastIOClient
import ImageEffects
import UIKit

// TODO(nikrad): move this into the model directory
struct Temperature: CustomStringConvertible {
    let value: Double
    
    init(fromValue: Double) {
        self.value = fromValue
    }
    
    var description: String {
        let roundedTemp = Int(round(self.value))
        return "\(roundedTemp)°"
    }
}

struct PrecipitationChance: CustomStringConvertible {
    let value: Double
    
    init(fromValue: Double) {
        self.value = fromValue
    }
    
    var description: String {
        let percentage = Int(round(self.value * 100))
        return "\(percentage)%"
    }
}

class DailyWeatherDetailViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource, UITableViewDataSource {
    
    // MARK: - Static initializer
    
    static func instantiateFromStoryboard() -> DailyWeatherDetailViewController {
        let vc = UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID) as! DailyWeatherDetailViewController
        return vc
    }
    
    // MARK: - Static properties

    static let storyboardID = "DailyWeatherDetailViewController"
    
    // MARK: - Properties

    var placeType: PlaceType!
    var place: Place!
    
    private var todayHourly = [DataPoint]()
    private var suggestions = [Suggestion]()

    var forecast: Forecast?
    @IBOutlet weak var hourlyTempGraph: BEMSimpleLineGraphView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.placeType == PlaceType.Other {
            self.placeLabel.text = place.name
            self.placeAddressLabel.hidden = true
            self.summaryLabelTopConstraint.constant = 8.0
        } else {
            self.placeAddressLabel.hidden = false
            self.placeAddressLabel.text = place.name
            self.summaryLabelTopConstraint.constant = 35.0
            if self.placeType == PlaceType.Home {
                self.placeLabel.text = "Home"
            } else {
                self.placeLabel.text = "Work"
            }
        }
        
        if let forecast = self.forecast {
            let todayForecast = forecast.daily?.data?[0] as DataPoint!
            
            // Initialize suggestions
            self.suggestions = Array(Set(todayForecast.getSuggestions()))
            
            // Draw graph
            let timezone = NSTimeZone(name: forecast.timezone)!
            let calendar = NSCalendar.currentCalendar()
            let todayComponents = calendar.componentsInTimeZone(timezone, fromDate: NSDate())
            self.todayHourly = forecast.hourly!.data!.filter({ (dataPoint) -> Bool in
                let time = Double(dataPoint.time)
                let date = NSDate(timeIntervalSince1970: time)
                let dateComponents = calendar.componentsInTimeZone(timezone, fromDate: date)
                return (todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month && todayComponents.day == dateComponents.day)
            })
            self.hourlyTempGraph.dataSource = self
            self.hourlyTempGraph.delegate = self
            self.hourlyTempGraph.animationGraphStyle = .Draw
            
            let currentForecast = forecast.currently!
            
            // Draw background
            let bgRect = self.view.bounds
            let backgroundView = UIView(frame: bgRect)
            let imgView = UIImageView(frame: backgroundView.bounds)
            let img = currentForecast.getBackground()
            imgView.image = img.blurredImageWithRadius(10.0)
            imgView.contentMode = .ScaleAspectFill
            backgroundView.addSubview(imgView)
            let fillColorView = UIView(frame: bgRect)
            let temperature = currentForecast.temperature as Double!
            fillColorView.backgroundColor = ColorPalette.getAverageColorForTemp(temperature)
            fillColorView.alpha = 0.7
            backgroundView.addSubview(fillColorView)
            self.view.addSubview(backgroundView)
            self.view.sendSubviewToBack(backgroundView)

            // Add weather text
            self.currentTempLabel.text = String(Temperature(fromValue: currentForecast.temperature!))
            self.summaryLabel.text = todayForecast.summary as String!
        }
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView?.backgroundColor = UIColor.clearColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        let suggestionCellNib = UINib(nibName: DailyWeatherSuggestionCell.reuseIdentifier, bundle: NSBundle.mainBundle())
        self.tableView.registerNib(suggestionCellNib, forCellReuseIdentifier: DailyWeatherSuggestionCell.reuseIdentifier)
        self.tableView.dataSource = self
    }
    
    // MARK: - BEMSimpleLineGraphDataSource

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return self.todayHourly.count
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(todayHourly[index].temperature!)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DailyWeatherSuggestionCell.reuseIdentifier) as! DailyWeatherSuggestionCell
        cell.suggestion = self.suggestions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions.count
    }
}
