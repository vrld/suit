package = "suit"
version = "0.1-1"
source = {
  url = "git://github.com/vrld/suit.git"
}
description = {
  summary="Immediate mode GUI library in pure Lua.",
  homepage = "https://suit.readthedocs.io",
  license = "MIT",
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["suit"] = "init.lua",
    ["suit.button"] = "button.lua",
    ["suit.checkbox"] = "checkbox.lua",
    ["suit.core"] = "core.lua",
    ["suit.imagebutton"] = "imagebutton.lua",
    ["suit.input"] = "input.lua",
    ["suit.label"] = "label.lua",
    ["suit.layout"] = "layout.lua",
    ["suit.slider"] = "slider.lua",
    ["suit.theme"] = "theme.lua",
  }
}
