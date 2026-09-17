// Quarto 1.9's page.typ without the logo block: Quarto would otherwise paint
// the small brand logo as a page background on every page. The owd-typst
// format places the medium logo once, in the title block (typst-template.typ).
#set page(
  paper: $if(papersize)$"$papersize$"$else$"a4"$endif$,
$if(margin-geometry)$
  // Margins handled by marginalia.setup below
$elseif(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$else$
  margin: (x: 25mm, y: 25mm),
$endif$
  numbering: $if(page-numbering)$"$page-numbering$"$else$none$endif$,
  columns: $if(columns)$$columns$$else$1$endif$,
)
$if(margin-geometry)$
// Configure marginalia page geometry (functions defined in definitions.typ)
#show: marginalia.setup.with(
  inner: (
    far: $margin-geometry.inner.far$,
    width: $margin-geometry.inner.width$,
    sep: $margin-geometry.inner.separation$,
  ),
  outer: (
    far: $margin-geometry.outer.far$,
    width: $margin-geometry.outer.width$,
    sep: $margin-geometry.outer.separation$,
  ),
  top: $if(margin.top)$$margin.top$$else$25mm$endif$,
  bottom: $if(margin.bottom)$$margin.bottom$$else$25mm$endif$,
  book: false,
  clearance: $margin-geometry.clearance$,
)
$endif$
