import UIKit

enum AppColor {
    case black
    case white
    case primary
    case secondary
    case neutral900
    case neutral800
    case neutral700
    case neutral600
    case neutral500
    case neutral400
    case neutral300
    case neutral200
    case neutral100
    case neutral50
    case positive
    case caution
    case negative
    case information

    var color: UIColor {
        switch self {
        case .black: return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .white: return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .primary: return UIColor(red: 0.071, green: 0.839, blue: 0.890, alpha: 1)
        case .secondary: return UIColor(red: 1.000, green: 0.953, blue: 0.576, alpha: 1)
        case .neutral900: return UIColor(red: 0.071, green: 0.078, blue: 0.090, alpha: 1)
        case .neutral800: return UIColor(red: 0.165, green: 0.173, blue: 0.204, alpha: 1)
        case .neutral700: return UIColor(red: 0.247, green: 0.259, blue: 0.314, alpha: 1)
        case .neutral600: return UIColor(red: 0.341, green: 0.361, blue: 0.420, alpha: 1)
        case .neutral500: return UIColor(red: 0.486, green: 0.514, blue: 0.580, alpha: 1)
        case .neutral400: return UIColor(red: 0.635, green: 0.659, blue: 0.718, alpha: 1)
        case .neutral300: return UIColor(red: 0.765, green: 0.784, blue: 0.831, alpha: 1)
        case .neutral200: return UIColor(red: 0.863, green: 0.875, blue: 0.906, alpha: 1)
        case .neutral100: return UIColor(red: 0.925, green: 0.933, blue: 0.953, alpha: 1)
        case .neutral50: return UIColor(red: 0.973, green: 0.976, blue: 0.984, alpha: 1)
        case .positive: return UIColor(red: 0, green: 0.886, blue: 0.459, alpha: 1)
        case .caution: return UIColor(red: 1.000, green: 0.588, blue: 0.102, alpha: 1)
        case .negative: return UIColor(red: 1.000, green: 0.145, blue: 0.090, alpha: 1)
        case .information: return UIColor(red: 0.075, green: 0.333, blue: 1.000, alpha: 1)
        }
    }
}
