hl.config({
  input = {
    kb_layout = "us,ir",
    kb_options = "caps:escape",
    repeat_rate = 25,
    repeat_delay = 600,
    sensitivity = 0.15,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.1,
      drag_lock = 1,
      drag_3fg = 1,
    },
  },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
