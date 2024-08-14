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
    case kakao

    var color: UIColor {
        switch self {
        case .black: return UIColor(hex: "000000")
        case .white: return UIColor(hex: "FFFFFF")
        case .primary: return UIColor(hex: "12D6E3")
        case .secondary: return UIColor(hex: "FFF493")
        case .neutral900: return UIColor(hex: "131417")
        case .neutral800: return UIColor(hex: "2A2C34")
        case .neutral700: return UIColor(hex: "3F4350")
        case .neutral600: return UIColor(hex: "575C6B")
        case .neutral500: return UIColor(hex: "7C8394")
        case .neutral400: return UIColor(hex: "A2A8B7")
        case .neutral300: return UIColor(hex: "C3C8D4")
        case .neutral200: return UIColor(hex: "DCDFE7")
        case .neutral100: return UIColor(hex: "ECEEF4")
        case .neutral50: return UIColor(hex: "F8F9FB")
        case .positive: return UIColor(hex: "00E275")
        case .caution: return UIColor(hex: "FF961A")
        case .negative: return UIColor(hex: "FF2517")
        case .information: return UIColor(hex: "1355FF")
        case .kakao : return UIColor(hex : "FEE500")
        }
    }
}
