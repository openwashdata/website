// owd-typst: the openwashdata article layout.
//
// This partial is concatenated before Quarto's header-includes, where the
// brand dictionaries (brand-color, brand-color-background, brand-logo) are
// defined. Typst closures capture their scope at definition time, so
// article() never reads those dictionaries itself: typst-show.typ resolves
// every brand value and passes it in as an argument.
//
// The empty dictionaries below make the template compile when Quarto emits
// no brand at all (Quarto 1.8 without a brand key). With a brand present,
// Quarto's header-includes redefine them.
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

// Own helpers, so the template does not depend on what a given Quarto
// version defines in definitions.typ (Quarto 1.8 lacks a string helper).
#let owd-to-string(content) = {
  if type(content) == str {
    content
  } else if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(owd-to-string).join("")
  } else if content.has("body") {
    owd-to-string(content.body)
  } else if content == [ ] {
    " "
  } else {
    ""
  }
}

#let owd-empty(v) = {
  if v == none { return true }
  let s = owd-to-string(v)
  s == none or s.trim() == ""
}

#let article(
  title: none,
  subtitle: none,
  authors: none,
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  title-size: 2em,
  subtitle-size: 1.25em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-line-height: 0.65em,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  // openwashdata additions, resolved from the brand in typst-show.typ
  primary: black,
  logo: none,
  logo-width: 40mm,
  footer-text: none,
  page-fill: white,
  cover: true,
  doc,
) = {
  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(author => owd-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()

  // The brand background (paper) is a screen token; printed pages stay white.
  // The footer replaces Typst's default page number line.
  set page(
    fill: page-fill,
    footer: context {
      set text(size: 9pt, fill: luma(110))
      grid(
        columns: (1fr, auto),
        align: (left, right),
        if footer-text != none { footer-text } else { [] },
        counter(page).display("1 / 1", both: true),
      )
    },
  )

  set par(
    justify: true,
    leading: linestretch * 0.65em
  )
  set text(lang: lang,
           region: region,
           size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none
  // Code block fill comes from the brand (typography.monospace-block) through
  // Quarto's own show rule; without a brand Quarto's default grey applies.

  set heading(numbering: sectionnumbering)
  show heading: set text(fill: primary)
  show heading.where(level: 1): set block(above: 1.6em, below: 0.8em)

  show link: set text(fill: rgb(owd-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(owd-to-string(citecolor))) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: rgb(owd-to-string(filecolor)))
    } else {
      text(this)
    }
  }

  // Tables: bold header cells; a soft grey line under every body row. The
  // rule under the header row comes from Quarto and keeps the text colour.
  show table.cell.where(y: 0): set text(weight: "bold")
  set table(stroke: (x, y) => if y == 0 { none } else { (bottom: 0.4pt + luma(200)) })

  let has-title-block = title != none or (authors != none and authors != ()) or date != none or abstract != none
  let front-matter = if has-title-block {
    let logo-path = if logo == none {
      none
    } else if logo.starts-with("/") or logo.starts-with("http") {
      logo
    } else {
      "/" + logo
    }
    let title-column = [
      #set par(justify: false)
      #if title != none {
        set par(leading: heading-line-height) if heading-line-height != none
        set text(font: heading-family) if heading-family != none
        set text(weight: heading-weight)
        set text(style: heading-style) if heading-style != "normal"
        text(size: title-size, fill: primary)[#title #if thanks != none {
          footnote(thanks, numbering: "*")
          counter(footnote).update(n => n - 1)
        }]
        if subtitle != none {
          v(0.5em)
          text(size: subtitle-size, weight: "regular", fill: luma(70))[#subtitle]
        }
      }
      #if authors != none and authors != () {
        v(1.2em)
        for author in authors {
          block(below: 0.6em)[
            #text(weight: "semibold")[#author.name]
            #if not owd-empty(author.affiliation) [\ #author.affiliation]
            #if not owd-empty(author.email) [\ #link("mailto:" + owd-to-string(author.email))[#author.email]]
          ]
        }
      }
      #if date != none {
        v(0.4em)
        text(fill: luma(70))[#date]
      }
    ]
    [
      #block(width: 100%, below: 2em)[
        #if logo-path != none {
          grid(
            columns: (1fr, logo-width),
            column-gutter: 1.5em,
            align: (left + top, right + top),
            title-column,
            image(logo-path, width: logo-width),
          )
        } else {
          title-column
        }
        #v(0.8em)
        #line(length: 100%, stroke: 0.75pt + primary)
      ]
      #if abstract != none {
        block(inset: (x: 0em, y: 0.5em), below: 1.5em)[
          #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
        ]
      }
    ]
  } else {
    none
  }

  let toc-block = if toc {
    block(above: 0em, below: 2em)[
      #outline(
        title: toc_title,
        depth: toc_depth,
        indent: toc_indent
      )
    ]
  } else {
    none
  }

  if cover and front-matter != none {
    // Cover page without footer: front matter and, when asked for, the
    // table of contents. The body starts on the next page as page 1.
    page(footer: none)[#front-matter #toc-block]
    counter(page).update(1)
  } else {
    front-matter
    toc-block
  }

  doc
}

#set table(
  inset: 6pt,
  stroke: none
)
