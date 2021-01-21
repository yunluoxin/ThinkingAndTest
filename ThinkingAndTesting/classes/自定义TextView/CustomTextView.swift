//
//  CustomTextView.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2021/1/15.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    /// 最小字号
    var minTextSize: CGFloat = 5
    /// 最大字号
    var maxTextSize: CGFloat = 20
    
    var lineSpacing: CGFloat = 0 {
        didSet {
            updateAttributes()
            makeVerticalAlign()
        }
    }
    
    var lineHeightMultiple: CGFloat = 1 {
        didSet {
            updateAttributes()
            makeVerticalAlign()
        }
    }
    
    override var font: UIFont? {
        didSet {
            updateAttributes()
            makeVerticalAlign()
        }
    }
    
    override var text: String! {
        didSet {
            makeVerticalAlign()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            makeVerticalAlign()
        }
    }
    
    override var delegate: UITextViewDelegate? {
        didSet {
            assert(delegate == nil || delegate === self, "请使用bridgeDelegate接收回调！")
        }
    }
    
    var bridgeDelegate: UITextViewDelegate?

    private var attributes: [NSAttributedString.Key:Any] = [:]
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        delegate = self
    }
    
    /// 更新属性
    private func updateAttributes() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.lineHeightMultiple = lineHeightMultiple
        
        attributes[.font] = font
        attributes[.paragraphStyle] = style
        attributes[.foregroundColor] = textColor ?? .black
        attributes[.backgroundColor] = backgroundColor ?? .white
        self.typingAttributes = attributes
    }
    
    /// 垂直居中
    private func makeVerticalAlign() {
        let height = calculateHeight(self.text, with: nil)
        let top = (self.bounds.height - height) / 2
        if top <= 0 {
            contentInset = .zero
            panGestureRecognizer.isEnabled = true
            isScrollEnabled = true
        } else {
            // 不加这个，会出现出现contentOffset变成0，字体直接顶到顶部
            contentInset = UIEdgeInsets(top: top, left: 0, bottom: top, right: 0)
            panGestureRecognizer.isEnabled = false
            isScrollEnabled = false
            // 不加这个不能上下居中
            contentOffset = .init(x: 0, y: -top)
//            contentSize = .init(width: self.contentSize.width, height: height)
        }
        
//        print("top: \(top)")
//        print("contentSize:\(contentSize)")
    }
    
    /// 根据UITextView中的text和内容大小，调整合适的fontSize让文字可以按照文本原来的行数显示。
    /// 显示行数过多时缩小字号；显示行数与文本行数一致时缩小放大字号已沾满整行。
    func calculateTextFontSize() {
        // 获取文本中的换行符数量。
        let lineBreakCount = text.lineBreakCount()
        // 调整的文本大小。
        var adjustFontSize: CGFloat = self.font?.pointSize ?? 12
        // 预估出来的当前文字行数
        let targetLineCount = calculateLineCount(text, with: nil)
        // 记录目前是在缩小字体还是扩大字体
        let isShrinking = targetLineCount > lineBreakCount + 1
        // 调整步伐
        let step: CGFloat = 0.2
        while true {
            if isShrinking {
                if adjustFontSize <= minTextSize {
                    // 到达最小文本限制，不在缩小。
                    break
                }
                adjustFontSize = adjustFontSize - step
                if calculateLineCount(text, with: adjustFontSize) <= lineBreakCount + 1 {
                    // 缩小fontSize直到和文本行数一致。
                    break
                }
            } else {
                if adjustFontSize >= maxTextSize {
                    // 到底最大文本限制，不再扩大。
                    break
                }
                adjustFontSize = adjustFontSize + step
                if calculateLineCount(text, with: adjustFontSize) > lineBreakCount + 1 {
                    // 放大的逻辑比较特殊，如果本次扩大使行数扩大了，那么上一个调整尺寸就是最合适的尺寸。
                    adjustFontSize = adjustFontSize - step
                    break
                }
            }
        }
        
        self.font = self.font?.withSize(adjustFontSize)
    }
    
    private var maxWidth: CGFloat = UIScreen.main.bounds.width - 6
    
    /// 计算文字的高度
    /// - Returns: 高度
    private func calculateHeight(_ text: String?, with fontSize: CGFloat?) -> CGFloat {
        let text = text ?? " "
        let size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        var attrs = attributes
        if let font = self.font, let size = fontSize {
            attrs[.font] = font.withSize(size)
        }
        let rect = (text as NSString).boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attrs, context: nil)
        return rect.height
    }
    
    /// 计算文字的行数
    func calculateLineCount(_ text: String?, with fontSize: CGFloat?) -> Int {
        guard let font = self.font, bounds.width > 0 else { return 1 }
        
        let text = text ?? " "
        let height = calculateHeight(text, with: fontSize)
        let f: UIFont
        if let size = fontSize {
            f = font.withSize(size)
        } else {
            f = font
        }
        let lineHeight = lineHeightMultiple * f.lineHeight
//        print("文本高度：\(height),字体大小：\(fontSize ?? 0), 行高：\(f.lineHeight)")
        let result = Int(ceil(height / lineHeight))
//        print("计算出来的文本行数：\(result)")
        return result
    }
    
    /// 重写返回光标frame的方法避免光标扩大问题
//    override func caretRect(for position: UITextPosition) -> CGRect {
//        let rect = super.caretRect(for: position)
//        return rect
//    }
}


// MARK: - <UITextViewDelegate>

extension CustomTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        bridgeDelegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        bridgeDelegate?.textViewDidEndEditing?(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        calculateTextFontSize()
        makeVerticalAlign()
        bridgeDelegate?.textViewDidChange?(self)
        
        print("\(textView.textContainerInset)")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        bridgeDelegate?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        bridgeDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) == true
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("\(scrollView.contentOffset)")
//    }
}


extension String {
    
    /// 获取一段文本中的换行符个数。
    func lineBreakCount() -> Int {
        var count = 0
        self.forEach { (ch) in
            if ch == "\n" {
                count = count + 1
            }
        }
        return count
    }
}
