local M = {}

function M.tbl_merge(parent, child)
  for k, v in pairs(child) do
    parent[k] = v
  end
  return parent
end

function M.hex_to_rgba(opacity, color)
  if opacity == nil then
    opacity = 1
  end
  local hex = color:gsub("#", "")
  local r = tostring(tonumber("0x" .. hex:sub(1, 2)))
  local g = tostring(tonumber("0x" .. hex:sub(3, 4)))
  local b = tostring(tonumber("0x" .. hex:sub(5, 6)))
  local rgba = "rgba(" .. r .. "," .. g .. "," .. b .. "," .. tostring(opacity) .. ")"
  return rgba
end

function M.base16(color)
  local base16 = {
    base00 = color.background,
    base01 = color.indexed[18],
    base02 = color.indexed[19],
    base03 = color.brights[1],
    base04 = color.indexed[20],
    base05 = color.foreground,
    base06 = color.indexed[21],
    base07 = color.brights[8],
    base08 = color.ansi[2],
    base09 = color.indexed[16],
    base0A = color.ansi[4],
    base0B = color.ansi[3],
    base0C = color.ansi[7],
    base0D = color.ansi[5],
    base0E = color.ansi[6],
    base0F = color.indexed[17],
  }
  return base16
end

return M
