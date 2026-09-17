// Maps Pandoc metadata to article() arguments. Brand values are resolved
// here, after Quarto's header-includes defined the brand dictionaries.
#show: doc => article(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$],
      affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
      email: [$it.email$] ),
$endif$
$endfor$
    ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
  abstract-title: "$labels.abstract$",
$endif$
$if(mainfont)$
  font: ("$mainfont$", "Libertinus Serif"),
$elseif(brand.typography.base.family)$
  font: $brand.typography.base.family$ + ("Libertinus Serif",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(brand.typography.headings.family)$
  heading-family: $brand.typography.headings.family$ + ("Libertinus Serif",),
$elseif(mainfont)$
  heading-family: ("$mainfont$", "Libertinus Serif"),
$endif$
$if(brand.typography.headings.weight)$
  heading-weight: $brand.typography.headings.weight$,
$endif$
$if(brand.typography.headings.style)$
  heading-style: "$brand.typography.headings.style$",
$endif$
$if(brand.typography.headings.line-height)$
  heading-line-height: $brand.typography.headings.line-height$,
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
$if(mathfont)$
  mathfont: ($for(mathfont)$"$mathfont$",$endfor$),
$endif$
$if(codefont)$
  codefont: ($for(codefont)$"$codefont$",$endfor$),
$elseif(brand.typography.monospace.family)$
  codefont: $brand.typography.monospace.family$ + ("DejaVu Sans Mono",),
$endif$
$if(linestretch)$
  linestretch: $linestretch$,
$endif$
$if(thanks)$
  thanks: [$thanks$],
$endif$
$if(linkcolor)$
  linkcolor: [$linkcolor$],
$endif$
$if(citecolor)$
  citecolor: [$citecolor$],
$endif$
$if(filecolor)$
  filecolor: [$filecolor$],
$endif$
$if(keywords)$
  keywords: ($for(keywords)$"$keywords$",$endfor$),
$endif$
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-title)$
  toc_title: [$toc-title$],
$endif$
$if(toc-indent)$
  toc_indent: $toc-indent$,
$endif$
  toc_depth: $toc-depth$,
  primary: brand-color.at("primary", default: black),
  logo: brand-logo.at("medium", default: (:)).at("path", default: none),
$if(logo-width)$
  logo-width: $logo-width$,
$endif$
$if(footer-text)$
  footer-text: "$footer-text$",
$endif$
$if(cover)$
  cover: true,
$else$
  cover: false,
$endif$
  doc,
)
