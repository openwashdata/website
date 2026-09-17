-- Give data tables the bordered OwdTable style from reference.docx.
-- Quarto's own docx wrappers (caption and figure containers, callouts) are
-- raw OOXML on the plain Table style and are not touched, so only real
-- tables get borders. A table that already carries a custom-style keeps it.
function Table(tbl)
  if not tbl.attr.attributes["custom-style"] then
    tbl.attr.attributes["custom-style"] = "OwdTable"
  end
  return tbl
end
