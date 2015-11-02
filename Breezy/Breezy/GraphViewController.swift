//
//  GraphViewController.swift
//  Breezy
//
//  Created by Anvisha Pai on 10/31/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph
import ForecastIOClient

class GraphViewController: UIViewController, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate {
    
    static let storyboardID = "GraphViewController"
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    var trip: Trip!
    @IBOutlet weak var graphView: BEMSimpleLineGraphView!
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.dataSource = self
        graphView.delegate = self
        graphView.enableXAxisLabel = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return (trip.dateRange?.count)!
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        let date = trip.dateRange![index]
        let dailyForecast = trip.forecast[date]?.daily!.data![0]
        let temp = dailyForecast?.temperatureMax
        return CGFloat(temp!)
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        return "1"
    }
    
    func printDate(date:NSDate) -> (String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
