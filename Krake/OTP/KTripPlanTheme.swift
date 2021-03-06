//
//  KTripPlanTheme.swift
//  Krake
//
//  Created by joel on 05/05/17.
//  Copyright © 2017 Laser Group srl. All rights reserved.
//

import Foundation
import DateTimePicker
import Segmentio

extension KTheme {
    public static var travelModeSegmentOptions: SegmentioOptions = {

        SegmentioOptions(backgroundColor: .clear,
                         segmentPosition: .dynamic,
                         scrollEnabled: false,
                         indicatorOptions: SegmentioIndicatorOptions(color: KTheme.current.color(.tint)),
                         horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(type: .none),
                         verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(ratio: 1, color: KTheme.current.color(.tint).withAlphaComponent(0.3)),
                         segmentStates: SegmentioStates(defaultState: SegmentioState(titleTextColor: KTheme.current.color(.tint)),
                                                       selectedState: SegmentioState(titleTextColor: KTheme.current.color(.alternate)),
                                                       highlightedState: SegmentioState(titleTextColor: KTheme.current.color(.tint)))
                         )
    }()
}

public class KTripTheme {
    static public var shared: KTripPlanTheme = KTripDefaultTheme()
}

public enum KTripText {
    case distance
    case mainInfo
    case instruction
    case instructionImportant
    case date
    case timeScheduled
    case timeReal
}

public enum KTripPinName {
    case from
    case to
}

public protocol KTripPlanTheme {

    func colorFor(travelMode mode: KTravelMode) -> UIColor
    func colorFor(vehicle: KVehicleType) ->  UIColor

    func applyTheme(toLabel label: UILabel, type: KTripText)
    func colorFor(text: KTripText) ->  UIColor
    func fontFor(text: KTripText) ->  UIFont

    func imageFor(travelMode mode: KTravelMode) -> UIImage
    func imageFor(vehicleType vehicle: KVehicleType) -> UIImage

    func annotationName(for otpItem: KOTPStopItem)  -> String
    func color(for otpItem: KOTPStopItem) -> UIColor

    func imageFor(maneuver: KManeuver) -> UIImage

    func pinName(_ pin: KTripPinName) -> String

    func applyTheme(toDateTimePicker dateTimePicker: DateTimePicker)
}

open class KTripDefaultTheme: NSObject,  KTripPlanTheme {

    open func annotationName(for otpItem: KOTPStopItem)  -> String {
        return "ic_directions_transit"
    }

    open func applyTheme(toLabel label: UILabel, type: KTripText)
    {
        label.font = KTripTheme.shared.fontFor(text: type)
        label.textColor = KTripTheme.shared.colorFor(text: type)
    }

    open func colorFor(travelMode mode: KTravelMode) -> UIColor
    {
        switch mode {
        case .bicycle:
            return UIColor(red: 0.417, green: 0.709, blue: 0.147, alpha: 1.0)

        case .car:
            return UIColor(red: 0.352, green: 0.678, blue: 0.865, alpha: 1.0)

        case .walk:
            return UIColor(red: 0.472, green: 0.311, blue: 0.171, alpha: 1.0)

        default:
            return KTheme.current.color(.tint)
        }
    }

    open func colorFor(vehicle: KVehicleType) -> UIColor
    {
        switch vehicle {
        case .bus:
            return UIColor(red: 0.043, green: 0.357, blue: 0.682, alpha: 1.0)

        case .tram:
            return UIColor(hexString:"#f7931e")
        case .subway:
            return UIColor.black
        default:
            return KTheme.current.color(.tint)
        }
    }

    open func color(for otpItem: KOTPStopItem) -> UIColor {
        return KTheme.current.color(.tint)
    }

    open func imageFor(travelMode mode: KTravelMode) -> UIImage {

        let image: UIImage
        
        switch mode {
        case .bicycle:
            image = KOTPAssets.icDirectionsBike.image

        case .car:
            image = KOTPAssets.icDirectionsCar.image

        case .walk:
            image = KOTPAssets.icDirectionsWalk.image

        case .transit:
            image = KOTPAssets.icDirectionsTransit.image
        }

        let size = image.size

        return image.resizableImage(withCapInsets: UIEdgeInsets(top: size.height - 1, left: 0, bottom: 0, right:0), resizingMode: .tile)
    }

    open func imageFor(maneuver: KManeuver) -> UIImage {

        let image: UIImage
        switch maneuver {
        case .depart, .keepGoing:
            image = KOTPAssets.continuaDritto.image

        case .right, .hardRight:
            image = KOTPAssets.destra90.image

        case .slightlyRight:
            image = KOTPAssets.destra45.image

        case .circleClockwise, .circleCounterClockwise:
            image = KOTPAssets.rotonda.image

        case .left, .hardLeft:
            image = KOTPAssets.sinistra90.image

        case .slightlyLeft:
            image = KOTPAssets.sinistra45.image

        case .uturnRight:
            image = KOTPAssets.inversioneUDx.image

        case .uturnLeft:
            image = KOTPAssets.inversioneUSx.image
        }

        return image.withRenderingMode(.alwaysTemplate)
    }

    open func colorFor(text: KTripText) ->  UIColor
    {
        switch text {
        case .timeReal:
            return KTheme.current.color(.tint)

        case .distance:
            return UIColor.darkGray

        default:
            return UIColor.black
        }
    }

    open func fontFor(text: KTripText) ->  UIFont
    {
        switch text {

        case .instruction:
            return UIFont.systemFont(ofSize: 15)

        case .instructionImportant, .timeReal, .timeScheduled:
            return UIFont.boldSystemFont(ofSize: 15)

        case .mainInfo:
            return UIFont.preferredFont(forTextStyle: .headline)

        case .distance, .date:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        }
    }

    open func imageFor(vehicleType vehicle: KVehicleType) -> UIImage
    {
        let image: UIImage
        switch vehicle {
        case .subway:
            image = KOTPAssets.pinMetro.image
        case .tram:
            image = KOTPAssets.pinTram.image
        case .bus:
            image = KOTPAssets.pinBus.image
        default:
            image = KOTPAssets.icDirectionsTransit.image
        }

        return image.withRenderingMode(.alwaysTemplate)
    }

    open func pinName(_ pin: KTripPinName) -> String {
        switch pin {
        case .from:
            return "pin_partenza"
        default:
            return "pin_traguardo"
        }
    }

    open func applyTheme(toDateTimePicker dateTimePicker: DateTimePicker) {
        dateTimePicker.highlightColor = KTheme.current.color(.tint)
    }
}
