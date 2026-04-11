local M = {}

function M:peek(job)
	local cache = ya.target_cache(job.file.url)
	if not cache then return end

	if not cache:exists() then
		local status = self:preload(job)
		if status ~= 1 then return end
	end

	return ya.image_show(cache, job.area)
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		ya.mgr_emit("peek", { math.max(0, cx.active.preview.skip + job.units), only_if = job.file.url })
	end
end

function M:preload(job)
	local cache = ya.target_cache(job.file.url)
	if not cache or cache:exists() then return 1 end

	-- Quick check if it's a zip file
	local f = io.open(tostring(job.file.url), "rb")
	if not f then return 0 end
	local header = f:read(4)
	f:close()
	if header ~= "PK\x03\x04" then return 0 end

	-- Try to extract mergedimage.png first, then preview.png
	local cmd = string.format(
		"unzip -p %s mergedimage.png > %s 2>/dev/null || unzip -p %s preview.png > %s 2>/dev/null",
		ya.quote(tostring(job.file.url)),
		ya.quote(tostring(cache)),
		ya.quote(tostring(job.file.url)),
		ya.quote(tostring(cache))
	)

	local status = Command("sh"):args({ "-c", cmd }):spawn():wait()
	
	if status and status.success and cache:exists() and cache:size() > 0 then
		return 1
	end

	if cache:exists() then os.remove(tostring(cache)) end
	return 2
end

return M
