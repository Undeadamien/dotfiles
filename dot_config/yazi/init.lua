function Status:position()
	local cursor = self._current.cursor
	local length = #self._current.files
	if length == 0 then
		return ""
	end

	local style = self:style()
	local width = #tostring(length)
	local pad = math.max(2, width)

	return ui.Line({
		ui.Span(th.status.sep_right.open):fg(style.main:bg()):bg(style.alt:bg()),
		ui.Span(string.format(" %0" .. pad .. "d/%0" .. pad .. "d ", math.min(cursor + 1, length), length))
			:style(style.main),
		ui.Span(th.status.sep_right.close):fg(style.main:bg()):bg("reset"),
	})
end
