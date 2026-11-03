// 把 PDF 上的高亮、下划线、手绘标记和批注，写进各公司或专题文件夹 notes/ 里对应笔记的"原文摘录"部分（笔记的 pdf 属性指向哪个 PDF 就读哪个）。
//
// 用法（在 Mac 的终端里，先 cd 到笔记库文件夹）：
//   swift scripts/extract_highlights.swift            处理全部笔记
//   swift scripts/extract_highlights.swift 09_HOST    只处理文件名以 09_HOST 开头的笔记
//
// 笔记里 <!-- highlights:start --> 和 <!-- highlights:end --> 之间的内容每次都会重新生成，
// 自己的笔记请写在这两个标记之外。高亮在 iPad 的"文件"App 或 Mac 的"预览"里画即可。

import Foundation
import PDFKit

let vault = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let startMark = "<!-- highlights:start -->"
let endMark = "<!-- highlights:end -->"
let filter = CommandLine.arguments.dropFirst().first

struct Item {
    let page: Int
    let top: CGFloat
    let left: CGFloat
    let text: String
    let comment: String
    let approximate: Bool
}

func clean(_ s: String) -> String {
    s.replacingOccurrences(of: "-\n", with: "")
        .components(separatedBy: .whitespacesAndNewlines)
        .filter { !$0.isEmpty }
        .joined(separator: " ")
}

func text(on page: PDFPage, in rect: CGRect) -> String {
    clean(page.selection(for: rect)?.string ?? "")
}

// 每 4 个点是一行文字的四边形。PDFKit 一般给出相对于注释边框原点的坐标，个别 PDF 是页面绝对坐标，两种都试。
func lineRects(of a: PDFAnnotation) -> [CGRect] {
    guard let qp = a.quadrilateralPoints, qp.count >= 4 else { return [] }
    let area = a.bounds.insetBy(dx: -2, dy: -2)
    var rects: [CGRect] = []
    for k in stride(from: 0, through: qp.count - 4, by: 4) {
        let pts = (k..<k + 4).map { qp[$0].pointValue }
        let xs = pts.map(\.x), ys = pts.map(\.y)
        let raw = CGRect(x: xs.min()!, y: ys.min()!, width: xs.max()! - xs.min()!, height: ys.max()! - ys.min()!)
        let rel = raw.offsetBy(dx: a.bounds.minX, dy: a.bounds.minY)
        rects.append(area.contains(CGPoint(x: rel.midX, y: rel.midY)) ? rel : raw)
    }
    return rects
}

// 先把每行的框上下各收窄一点，避免带上相邻行的字。行框很矮、或页面里叠着零散文字时，
// 收窄后可能只选到几个字，这时逐步放宽，直到选到的字数接近整个框的六成以上。
func lineText(on page: PDFPage, in r: CGRect) -> String {
    let full = text(on: page, in: r)
    for inset in [0.25, 0.1] {
        let t = text(on: page, in: r.insetBy(dx: 0, dy: r.height * inset))
        if !t.isEmpty && t.count * 10 >= full.count * 6 { return t }
    }
    return full
}

func items(in doc: PDFDocument) -> [Item] {
    var out: [Item] = []
    for i in 0..<doc.pageCount {
        guard let page = doc.page(at: i) else { continue }
        for a in page.annotations {
            let comment = clean(a.contents ?? "")
            var t = ""
            var approximate = false
            switch a.type ?? "" {
            case "Highlight", "Underline", "StrikeOut", "Squiggly":
                let rects = lineRects(of: a)
                t = rects.isEmpty ? text(on: page, in: a.bounds) : rects.map { lineText(on: page, in: $0) }.filter { !$0.isEmpty }.joined(separator: " ")
            case "Ink":
                t = text(on: page, in: a.bounds)
                approximate = true
            case "Text", "FreeText":
                break
            default:
                continue
            }
            if t.isEmpty && comment.isEmpty { continue }
            out.append(Item(page: i + 1, top: a.bounds.maxY, left: a.bounds.minX, text: t, comment: comment, approximate: approximate))
        }
    }
    return out.sorted { ($0.page, -$0.top, $0.left) < ($1.page, -$1.top, $1.left) }
}

func pdfPath(in note: String) -> String? {
    for line in note.split(separator: "\n") where line.hasPrefix("pdf:") {
        guard let s = line.range(of: "[["), let e = line.range(of: "]]") else { return nil }
        return String(line[s.upperBound..<e.lowerBound]).components(separatedBy: "|")[0]
    }
    return nil
}

func render(_ items: [Item], pdf: String) -> String {
    var blocks: [String] = []
    var seen = Set<String>()
    for it in items {
        let key = "\(it.page)|\(it.text)|\(it.comment)"
        if !seen.insert(key).inserted { continue }
        var lines: [String] = []
        if !it.text.isEmpty { lines.append("> \(it.text)") }
        if it.approximate { lines.append("> （手绘标记，文字按标记范围截取，可能不准）") }
        if !it.comment.isEmpty { lines.append("> 批注：\(it.comment)") }
        lines.append("> — [[\(pdf)#page=\(it.page)|p.\(it.page)]]")
        blocks.append(lines.joined(separator: "\n"))
    }
    return blocks.isEmpty ? "" : "共 \(blocks.count) 条\n\n" + blocks.joined(separator: "\n\n")
}

// 笔记库下每个公司或专题文件夹里的 notes/，包括其中的子文件夹（如 topics/notes/语义3DGS与具身导航/）
let fm = FileManager.default
let orgs = (try? fm.contentsOfDirectory(at: vault, includingPropertiesForKeys: nil)) ?? []
let files = orgs.flatMap { org in
    (fm.enumerator(at: org.appendingPathComponent("notes"), includingPropertiesForKeys: nil)?.allObjects as? [URL]) ?? []
}
var updated = 0, unchanged = 0
for url in files.sorted(by: { $0.path < $1.path }) where url.pathExtension == "md" {
    // 显示名去掉 notes 这一层：xsquare/09_HOST、topics/语义3DGS与具身导航/1-01_GaussNav
    var parts = Array(url.deletingPathExtension().pathComponents.dropFirst(vault.pathComponents.count))
    if let i = parts.firstIndex(of: "notes") { parts.remove(at: i) }
    let name = parts.joined(separator: "/")
    if let f = filter, !name.hasPrefix(f), !url.lastPathComponent.hasPrefix(f) { continue }
    guard let note = try? String(contentsOf: url, encoding: .utf8),
          let pdf = pdfPath(in: note),
          let s = note.range(of: startMark), let e = note.range(of: endMark), s.upperBound <= e.lowerBound else {
        print("跳过 \(name)：没有 pdf 属性或缺少摘录标记")
        continue
    }
    guard let doc = PDFDocument(url: vault.appendingPathComponent(pdf)) else {
        print("跳过 \(name)：打不开 \(pdf)（文件不存在，或还没从 iCloud 下载到这台 Mac）")
        continue
    }
    let found = items(in: doc)
    let body = render(found, pdf: pdf)
    let newNote = note.replacingCharacters(in: s.upperBound..<e.lowerBound, with: body.isEmpty ? "\n" : "\n" + body + "\n")
    if newNote == note {
        unchanged += 1
        continue
    }
    try newNote.write(to: url, atomically: true, encoding: .utf8)
    updated += 1
    print("\(name)：\(found.count) 条")
}
print("完成：更新 \(updated) 篇，无变化 \(unchanged) 篇")
