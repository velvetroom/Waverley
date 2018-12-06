import AppKit

extension NSFont {
    class func editorLight(_ size:CGFloat) -> NSFont { return NSFont(name:"SourceCodeRoman-Light", size:size)! }
    class func editorBold(_ size:CGFloat) -> NSFont { return NSFont(name:"SourceCodeRoman-Bold", size:size)! }
    class func printLight(_ size:CGFloat) -> NSFont { return .systemFont(ofSize:size, weight:.light) }
    class func printBold(_ size:CGFloat) -> NSFont { return .systemFont(ofSize:size, weight:.bold) }
    class func printLightItalic(_ size:CGFloat) -> NSFont {
        return NSFont(descriptor:NSFontDescriptor(name:NSFont.systemFont(ofSize:size, weight:.light).fontName,
                                                  size:size).withSymbolicTraits(.italic), size:size)!
    }
    class func printBoldItalic(_ size:CGFloat) -> NSFont {
        return NSFont(descriptor:NSFontDescriptor(name:NSFont.systemFont(ofSize:size, weight:.bold).fontName,
                                                  size:size).withSymbolicTraits(.italic), size:size)!
    }
}
