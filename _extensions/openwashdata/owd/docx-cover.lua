-- Start the body on a new page after the front matter (title, authors,
-- date, abstract), which pandoc writes before the first body block.
-- The break sits in a paragraph of its own with a 1 pt paragraph mark,
-- so the new page starts with the first heading and not with a blank line.
-- Set cover: false in the document header to keep everything on one page.
function Pandoc(doc)
  local cover = doc.meta.cover
  if cover == false then
    return doc
  end
  local brk = pandoc.RawBlock("openxml",
    '<w:p><w:pPr><w:spacing w:before="0" w:after="0" w:line="240" w:lineRule="auto"/>'
    .. '<w:rPr><w:sz w:val="2"/><w:szCs w:val="2"/></w:rPr></w:pPr>'
    .. '<w:r><w:br w:type="page"/></w:r></w:p>')
  table.insert(doc.blocks, 1, brk)
  return doc
end
