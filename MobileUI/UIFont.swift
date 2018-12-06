import UIKit

extension UIFont {
    class func editorLight(_ size:CGFloat) -> UIFont { return UIFont(name:"SourceCodeRoman-Light", size:size)! }
    class func editorBold(_ size:CGFloat) -> UIFont { return UIFont(name:"SourceCodeRoman-Bold", size:size)! }
    class func printLight(_ size:CGFloat) -> UIFont { return .systemFont(ofSize:size, weight:.light) }
    class func printBold(_ size:CGFloat) -> UIFont { return .systemFont(ofSize:size, weight:.bold) }
    class func printLightItalic(_ size:CGFloat) -> UIFont {
        return UIFont(descriptor:UIFontDescriptor(name:UIFont.systemFont(ofSize:size, weight:.light).fontName,
                                                  size:size).withSymbolicTraits(.traitItalic)!, size:size)
    }
    class func printBoldItalic(_ size:CGFloat) -> UIFont {
        return UIFont(descriptor:UIFontDescriptor(name:UIFont.systemFont(ofSize:size, weight:.bold).fontName,
                                                  size:size).withSymbolicTraits(.traitItalic)!, size:size)
    }
}
