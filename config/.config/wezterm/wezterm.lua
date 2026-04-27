-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- Force the cursor to use reverse video colors based on the `foreground` and
-- `background` colors.
config.force_reverse_video_cursor = true

-- If set to true, when there is only a single tab, the tab bar is hidden from
-- the display.
config.hide_tab_bar_if_only_one_tab = true

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 11
config.color_scheme = 'AdventureTime'

-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold font variant.
config.font =
  wezterm.font('JetBrains Mono', { weight = 'Bold' })

-- Finally, return the configuration to wezterm:
return config
