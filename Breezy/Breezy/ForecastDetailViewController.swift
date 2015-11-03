//
//  ForecastDetailViewController.swift
//  Breezy
//
//  Created by Matthew Goo on 10/31/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController, UIScrollViewDelegate, NewTripViewControllerDelegate {
    static let storyboardID = "ForecastDetailViewController"
    static func instantiateFromStoryboard() -> UIViewController {
        return UIStoryboard(name: storyboardID, bundle: nil).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    var graphView: UIView?
    var detailsView: UIView?
    var trip: Trip?
    var detailsVc: MultiDayViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        addSettings()
        
        addScrollView()
        addGraphView()
        addDetailsView()
        createContraints()
    }
    
    private func addSettings() {
        let gear = UIImage(named: "gear")
        let rightBarButton = UIBarButtonItem(image: gear, style: .Plain, target: self, action: "editTrip:")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func addScrollView() {
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = UIColor.redColor()
    }
    
    private func addGraphView() {
//        graphView = UIView()
//        graphView!.backgroundColor = ColorPalette.blue
//        graphView!.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(graphView!)
//        
        let graphVC = GraphViewController.instantiateFromStoryboard() as! GraphViewController
        graphVC.trip = trip
        self.addChildViewController(graphVC)
        graphView = graphVC.view
        graphView!.translatesAutoresizingMaskIntoConstraints = false
        graphVC.didMoveToParentViewController(self)
        scrollView.addSubview(graphView!)
        
    }
    
    private func addDetailsView() {
        detailsVc = MultiDayViewController.instantiateFromStoryboard() as? MultiDayViewController
        if let detailsVc = detailsVc {
            detailsVc.trip = trip
            self.addChildViewController(detailsVc)
            detailsView = detailsVc.view
            detailsView!.translatesAutoresizingMaskIntoConstraints = false
            detailsVc.didMoveToParentViewController(self)
            scrollView.addSubview(detailsView!)
        }
    }
    
    private func createContraints() {
        let graphViewHeight = self.view.frame.height/3
        
        let views = [
            "detailsView": detailsView!,
            "graphView": graphView!,
            "scrollView": scrollView!,
            "view": view!
        ]
        
        let metrics = [
            "graphViewHeight": graphViewHeight
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailsView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[graphView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[graphView(graphViewHeight)][detailsView(==view)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
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
            self.detailsVc!.trip = trip
        }
    }
}
