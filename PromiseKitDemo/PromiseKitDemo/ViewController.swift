//
//  ViewController.swift
//  PromiseKitDemo
//
//  Created by Zsolt Bencze on 31/01/2017.
//  Copyright © 2017 iSylva. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

class ViewController: UIViewController {

    let lblLocation = UILabel()
    let locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNotifications()
        setupUI()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateWithCurrentLocation()
    }

    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.configureView),
                                               name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                               object: nil)
    }

    func setupUI() {
        self.view.translatesAutoresizingMaskIntoConstraints = false

        //Add a UILabel and setup constraints
        lblLocation.translatesAutoresizingMaskIntoConstraints = false
        lblLocation.text = NSLocalizedString("Searching for your location..", comment: "")
        lblLocation.textAlignment = .center
        lblLocation.numberOfLines = 2

        self.view.addSubview(lblLocation)

        let margins = self.view.layoutMarginsGuide
        lblLocation.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        lblLocation.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        lblLocation.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }

    func configureView() {
        // Label
        let scaleFactor: CGFloat = 1.2
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let pointSize = fontDescriptor.pointSize * scaleFactor
        lblLocation.font = UIFont.init(descriptor: fontDescriptor, size: pointSize)
    }

    //MARK: location

    private func updateWithCurrentLocation() {

        _ = locationManager.getLocation().then { placemark in
            self.handleLocation(placemark: placemark)
            }.catch { error in
                switch error {
                case is CLError where (error as! CLError).code == CLError.Code.denied:
                    self.lblLocation.text = NSLocalizedString("Enable Location Permissions in Settings", comment: "")
                default:
                    self.lblLocation.text = error.localizedDescription
                }
        }

        _ = after(interval: 20).then {
            self.updateWithCurrentLocation()
        }
    }

    func handleLocation(placemark: CLPlacemark) {
        handleLocation(city: placemark.locality,
                       state: placemark.administrativeArea,
                       latitude:  placemark.location!.coordinate.latitude,
                       longitude: placemark.location!.coordinate.longitude)
    }

    func handleLocation(city: String?, state: String?,
                        latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let city = city, let state = state {
            self.lblLocation.text = "\(city), \(state)"
        }
    }
}
