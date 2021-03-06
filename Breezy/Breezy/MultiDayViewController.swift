//
//  TripDetailViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/26/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph

class MultiDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource, NewTripViewControllerDelegate {
    static let storyboardID = "MultiDayViewController"
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    @IBOutlet weak var graphView: BEMSimpleLineGraphView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var packLabel: UILabel!
    var dateFormatter: NSDateFormatter!
    
    var trip: Trip? {
        didSet {
            if self.isViewLoaded() {
                weatherTableView.reloadData()
                setupDetailView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
        self.edgesForExtendedLayout = UIRectEdge.None
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        graphView.dataSource = self
        graphView.delegate = self
        weatherTableView.rowHeight = UITableViewAutomaticDimension
        weatherTableView.estimatedRowHeight = 50
        weatherTableView.backgroundColor = UIColor.clearColor()
        detailsContainerView.backgroundColor = UIColor.clearColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"gear"), style: .Plain, target: self, action: "editTrip:")
    
        setupBackgroundView()
    }
    
    func setupBackgroundView() {
        let bgRect = self.view.bounds
        let backgroundView = UIView(frame: bgRect)
        let imgView = UIImageView(frame: backgroundView.bounds)
        if let trip = trip {
            let firstDay = trip.dateRange![0]
            let forecast = trip.forecast
            print(firstDay)
            let point = forecast[firstDay]!.daily!.data!.first!
            
            let img = point.getBackground()
            imgView.image = img.blurredImageWithRadius(10.0)
            imgView.contentMode = .ScaleAspectFill
            backgroundView.addSubview(imgView)
            let fillColorView = UIView(frame: bgRect)
            let temperature = trip.averageTemp as Double!
            fillColorView.backgroundColor = ColorPalette.getAverageColorForTemp(temperature)
            fillColorView.alpha = 0.7
            backgroundView.addSubview(fillColorView)
            self.view.addSubview(backgroundView)
            self.view.sendSubviewToBack(backgroundView)
        
        }
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionCell", forIndexPath: indexPath) as! SuggestionCell
            cell.suggestion = trip!.suggestions![indexPath.row]
            setCellBorderColor(cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DayWeatherCell", forIndexPath: indexPath) as! DayWeatherCell
            if let trip = trip {
                let date = trip.dateRange![indexPath.row]
                cell.forecast = trip.forecast[date]
            }
            setCellBorderColor(cell)
            return cell
        }
    }
    
    func setCellBorderColor(cell: UITableViewCell) {
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trip = trip {
            if section == 0 {
                if let suggestions = trip.suggestions {
                    return suggestions.count
                }
                
                return 0
            } else {
                if let dates = trip.dateRange {
                    return dates.count
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let date = trip!.dateRange![indexPath.row]
            let dataPoints = trip?.forecast[date]?.daily?.data
//            if let point = dataPoints!.first {
//                let temperature = Double(point.temperatureMax!)
//                let fillColor = ColorPalette.getAverageColorForTemp(temperature)
//                CellHelpers.drawCellBackground(cell, fillColor: fillColor, backgroundImage: nil)
//            }
            cell.backgroundColor = UIColor.clearColor()
        } else {
            cell.backgroundColor = UIColor.clearColor()
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return (trip!.dateRange?.count)!
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        let date = trip!.dateRange![index]
        let dailyForecast = trip!.forecast[date]?.daily!.data![0]
        let maxTemp = dailyForecast?.temperatureMax
        let minTemp = dailyForecast?.temperatureMin
        let temp = (maxTemp! + minTemp!)/2
        return CGFloat(temp)
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        return printDate((trip?.dateRange![index])!)
    }
    
    func numberOfYAxisLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 2
    }
    
    func printDate(date:NSDate) -> (String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    
    
    func setupDetailView() {
        tripNameLabel.textColor = UIColor.whiteColor()
        datesLabel.textColor = UIColor.whiteColor()
        addressLabel.textColor = UIColor.whiteColor()
        packLabel.textColor = UIColor.whiteColor()
        if let trip = trip {
            tripNameLabel.text = trip.place?.name
            addressLabel.text = trip.place?.formattedAddress
            if let sDate = trip.startDateString {
                if let eDate = trip.endDateString {
                    datesLabel.text = "\(sDate) - \(eDate)"
                }
            }
        }
    }
    
    // MARK - Editing trip
    
    func editTrip(sender: AnyObject) {
        let vc = NewTripViewController.instantiateFromStoryboard() as! NewTripViewController
        if let trip = trip {
            vc.editTrip(trip)
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func newTripViewController(newTripViewController: NewTripViewController, addNewTrip trip: Trip) {
        trip.loadForecast() {
            self.trip = trip
        }
    }
}
