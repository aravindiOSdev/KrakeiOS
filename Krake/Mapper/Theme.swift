//
//  CoreTheme.swift
//  OrchardCore
//
//  Created by Patrick on 04/02/16.
//  Copyright © 2016 Laser Group srl. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import WebKit.WKWebView
import SwiftMessages

//MARK: - KThemeProtocolObjc

@objc public enum ColorStyle: Int {
    
    case `default`
    case tint //Colore di tinta dell'App
    case textTint //Colore del testo sopra il tint dell'App
    case alternate //colore di contrasto rispetto al tint (Accent su android)
    case textAlternate //Colore del testo sopra l'alternate
    case title //colore dei titoli
    case subtitle
    case headline
    case subHeadline
    case normal //colore del testo normale
    case selected
    case popoverBorder
    case popoverBackground
    case popoverText
    case userSelectablePin
    case background
    
    public var rawValue: String {
        get{
            switch self {
                case .tint:
                    return "tint"
                case .textTint:
                    return "textTint"
                case .alternate:
                    return "alternate"
                case .textAlternate:
                    return "textAlternate"
                case .title:
                    return "title"
                case .subtitle:
                    return "subtitle"
                case .headline:
                    return "headline"
                case .subHeadline:
                    return "subHeadline"
                case .normal:
                    return "normal"
                case .selected:
                    return "selected"
                case .popoverBorder:
                    return "popoverBorder"
                case .popoverBackground:
                    return "popoverBackground"
                case .popoverText:
                    return "popoverText"
                case .userSelectablePin:
                    return "userSelectablePin"
                case .background:
                    return "background"
                case .default:
                    return "default"
            }
        }
    }
    
    public init?(rawValue: String) {
        return nil
    }
}

@objc public enum ViewStyle: Int{
    case `default`
    case policy
    case selected
    case social
    case detailHeaderView
    case detailBodyView
    case mediaCollectionView
    case userReactions
    case webView
}

@objc public enum TextFieldStyle: Int{
    case contentManager
}

@objc public enum ButtonStyle: Int{
    case `default`
    case policy
    case social
    case fabButton
    case calendar
    case map
}

@objc public enum LabelStyle: Int{
    case `default`
    case title
    case subtitle
    case cellTitle
    case cellSubtitle
    case annotationTitle
    case annotationSubtitle
    case custom1
    case custom2
    case custom3
}

@objc public enum SwitchStyle: Int{
    case `default`
    case policy
    case login
    case otp
    case contentMofication
}

@objc(KThemeProtocolObjc)
public protocol KThemeProtocolObjc
{
    @objc func color(_ style: ColorStyle) -> UIColor
    
    @objc func applyTheme(toView mainView: UIView, style: ViewStyle)
    @objc func applyTheme(toTextField textField: UITextField, style: TextFieldStyle)
    @objc func applyTheme(toButton button: UIButton, style: ButtonStyle)
    @objc func applyTheme(toLabel label: UILabel, style: LabelStyle)
    @objc func applyTheme(toSwitch switcher: UISwitch, style: SwitchStyle)
}

//MARK: - KThemeProtocol

public enum ReactionColorStyle{
    case enableNormal
    case enableSelected
    case disableNormal
    case disableSelected
}

public enum EffectStyle{
    case shadow
}

public enum ToolbarStyle{
    case `default`
}

public enum TableViewStyle{
    case `default`
    case social
}

public enum StackViewStyle{
    case `default`
    case social
}

public enum PlaceholderStyle{
    case `default`
    case photo
    case video
    case audio
    case category
    case people
}

public enum NavigationBarStyle {
    case `default`
    case gallery
}

public enum WebViewStyle {
    case `default`
    case detail
    case policy
}

public enum ImageViewStyle{
    case termPart
    case `default`
}

public enum PolylineStyle {
    case directions
}

public enum SearchBarStyle {
    case `default`
    case onNavigation
}

public enum StatuBarStyle {
    case `default`
}

@objc open class KTheme: NSObject{
    
    public static var current: KThemeProtocol = KMainTheme()
    
    @objc public static var currentObjc: KThemeProtocolObjc!{
        get
        {
            return current as KThemeProtocolObjc
        }
    }
}

public protocol KThemeProtocol: KThemeProtocolObjc
{
    func applyEffect(toView mainView: UIView, style: EffectStyle)
    
    func applyTheme(toToolbar toolbar: UIToolbar, style: ToolbarStyle)
    func applyTheme(toStackView stackView: UIStackView, style: StackViewStyle)
    func applyTheme(toPolyline polyline : MKPolylineRenderer, style: PolylineStyle)
    func applyTheme(toImageView imageView : UIImageView, style: ImageViewStyle)
    func applyTheme(toUserDisplay view: KUserDisplayView)
    func applyTheme(toMessageView view: MessageView)
    func applyTheme(toSearchBar searchBar: UISearchBar, style: SearchBarStyle)
    func applyTheme(toTableView tableView: UITableView, style: TableViewStyle)
    func applyTheme(toNavigationBar navigationBar: UINavigationBar, style: NavigationBarStyle)
    func applyTheme(toWebView webView: WKWebView, style: WebViewStyle)
    
    func reactionColor(_ style: ReactionColorStyle) -> UIColor
    func statusBarStyle(_ style: StatuBarStyle) -> UIStatusBarStyle
    func placeholder(_ style: PlaceholderStyle) -> UIImage?

    func loadEmptyView(for viewController: KItemsCollectionViewController )
}

@objc(KMainTheme)
open class KMainTheme: NSObject, KThemeProtocol {
    
    public override init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: .textTint)!], for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: .disabled)
    }

    open func placeholder(_ style: PlaceholderStyle) -> UIImage? {
        switch style {
        case .photo, .category:
            return KAssets.OrchardMapper.photoPlaceholder.image
        case .video:
            return KAssets.OrchardMapper.videoPlaceholder.image
        case .audio:
            return KAssets.OrchardMapper.audioPlaceholder.image
        case .people:
            return KAssets.OrchardMapper.userPlaceholder.image
        default:
            return KAssets.OrchardMapper.defaultPlaceholder.image
        }
    }
    
    open func color(_ style: ColorStyle) -> UIColor{
        return UIColor(named: style) ?? .black
    }
    
    open func reactionColor(_ style: ReactionColorStyle) -> UIColor {
        switch style {
        case .enableNormal:
            return color(.tint)
        case .enableSelected:
            return color(.selected)
        case .disableNormal:
            return color(.normal)
        case .disableSelected:
            return color(.selected)
        }
    }

    open func loadEmptyView(for viewController: KItemsCollectionViewController) {
        let nib = UINib(nibName: "KEmptyCollectionView",
                        bundle:  Bundle(url: Bundle(for: KItemsCollectionViewController.self).url(forResource: "Content", withExtension: "bundle")!))
        nib.instantiate(withOwner: viewController, options: nil)

        if let emptyStateLabel = viewController.emptyStateLabel
        {
            KTheme.current.applyTheme(toLabel: emptyStateLabel, style: .default)
        }
    }
    
    open func applyEffect(toView mainView: UIView, style: EffectStyle) {
        switch style {
        case .shadow:
            mainView.clipsToBounds = false
            mainView.layer.shadowColor = UIColor.black.cgColor
            mainView.layer.shadowOffset = CGSize(width: 0.5,height: 0.5)
            mainView.layer.shadowOpacity = 0.6
            mainView.layer.shadowRadius = 1.5
        }
    }
    
    open func applyTheme(toView mainView: UIView, style: ViewStyle){
        switch style {
        case .selected:
            mainView.backgroundColor = color(.tint).withAlphaComponent(0.1)
        case .policy:
            mainView.backgroundColor = UIColor.white
        case .social:
            mainView.backgroundColor = color(.tint).withAlphaComponent(0.8)
        case .detailHeaderView, .detailBodyView, .mediaCollectionView, .userReactions, .webView:
            mainView.backgroundColor = .clear
        default:
            break
        }
    }
    
    open func applyTheme(toTextField textField: UITextField, style: TextFieldStyle) {
        textField.backgroundColor = UIColor.clear
    }
    
    open func applyTheme(toButton button: UIButton, style: ButtonStyle){
        switch style {
            case .policy:
                button.setTitleColor(UIColor.white, for: .normal)
                button.setTitleColor(UIColor.lightGray, for: .disabled)
                button.backgroundColor = color(.tint)
            case .fabButton:
                button.clipsToBounds = false
                button.backgroundColor = KTheme.current.color(.alternate)
                button.tintColor = KTheme.current.color(.textAlternate)
                button.layer.cornerRadius = button.frame.width/2
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                button.layer.shadowOpacity = 0.8
                button.layer.shadowRadius = 1.5
            case .calendar: //MARK: tint button with color tint of the navigationBar
                button.tintColor = color(.textTint)
                button.setTitleColor(color(.textTint), for: .normal)
            case .map:
                button.setTitleColor(color(.tint), for: .normal)
                button.tintColor = color(.tint)
                button.alignImageAndTitleVertically()
            case .social:
                break
            default:
                button.setTitleColor(color(.tint), for: .normal)
                button.tintColor = color(.tint)
                
        }
    }
    
    open func applyTheme(toToolbar toolbar: UIToolbar, style: ToolbarStyle){
        switch style {
        default:
            toolbar.barTintColor = color(.tint)
            toolbar.isTranslucent = false
            toolbar.tintColor = color(.textTint)
        }
    }
    
    open func applyTheme(toStackView stackView: UIStackView, style: StackViewStyle) {
        switch style {
        case .social:
            stackView.backgroundColor = color(.tint)
            stackView.tintColor = color(.textTint)
        default:
            break
        }
    }
    
    open func applyTheme(toLabel label: UILabel, style: LabelStyle){
        switch style {
        case .title:
            label.textColor = color(.normal)
            label.font = UIFont.preferredFont(forTextStyle: .title1)
        case .subtitle:
            label.textColor = color(.normal)
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        default:
            label.textColor = color(.normal)
        }
    }
    
    open func applyTheme(toTableView tableView: UITableView, style: TableViewStyle){
        
    }
    
    open func applyTheme(toNavigationBar navigationBar: UINavigationBar, style: NavigationBarStyle){
        switch style {
        default:
            navigationBar.tintColor = color(.textTint)
            navigationBar.barTintColor = color(.tint)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color(.textTint)]
            navigationBar.largeTitleTextAttributes = navigationBar.titleTextAttributes
            
            if #available(iOS 13.0, *){
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color(.textTint)]
                navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color(.textTint)]
                navBarAppearance.backgroundColor = color(.tint)
                navigationBar.standardAppearance = navBarAppearance
                navigationBar.scrollEdgeAppearance = navBarAppearance
                navigationBar.compactAppearance = navBarAppearance
            }
        }
    }
    
    
    open func applyTheme(toWebView webView: WKWebView, style: WebViewStyle) {
        switch style {
        default:
            webView.tintColor = color(.normal)
            webView.isOpaque = false
            webView.backgroundColor = UIColor.clear
        }
    }
    
    open func applyTheme(toPolyline polyline: MKPolylineRenderer, style: PolylineStyle) {
        polyline.strokeColor = UIColor.red
        polyline.lineWidth = 2.0
    }
    
    open func applyTheme(toImageView imageView: UIImageView, style: ImageViewStyle) {
        if style == .termPart {
            imageView.layer.cornerRadius = imageView.bounds.size.width/2
            imageView.clipsToBounds = true
            imageView.layer.borderColor = color(.tint).cgColor
            imageView.layer.borderWidth = 1.5
        }
    }
    
    open func applyTheme(toSwitch switchView: UISwitch, style: SwitchStyle){
        switch style{
        default:
            switchView.tintColor = color(.tint)
            switchView.onTintColor = color(.tint)
        }
    }
    
    open func applyTheme(toUserDisplay view: KUserDisplayView){
        
        view.backgroundColor = KTheme.current.color(.tint).lighter(0.20)
        
        view.userImageView.backgroundColor = KTheme.current.color(.tint)
        view.userImageView.tintColor = KTheme.current.color(.textTint)
        
        view.nameFirstLettersButton.titleLabel!.font = UIFont.preferredFont(forTextStyle: .title1)
        view.nameFirstLettersButton.tintColor = KTheme.current.color(.textTint)
        
        view.userNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.userNameLabel.textColor = KTheme.current.color(.textTint)
        
        view.logoutButton.setImage(KAssets.Images.logout.image, for: .normal)
        view.logoutButton.tintColor = KTheme.current.color(.textTint)
    }
    
    open func statusBarStyle(_ style: StatuBarStyle) -> UIStatusBarStyle {
        return .default
    }

    open func applyTheme(toMessageView view: MessageView) {

    }
    
    open func applyTheme(toSearchBar searchBar: UISearchBar, style: SearchBarStyle)
    {
        searchBar.barTintColor = color(.tint)
    }
}
