module Color
  ESC_CLR = "\e[0m"
  COLORS = {
    fg: {
      # foreground colors
      black: "30",
      red: "31",
      green: "32",
      blue: "34",
      white: "37",
    },
    bg: {
      # background colors
      black: "40",
      red: "41",
      green: "42",
      blue: "44",
      white: "47",
    },
    no_color: -> (str) { "\e[#{str}#{ESC_CLR}"},
  }
  def colorize(str, fg, bg)
    str = "" if str.nil?
    "\e[#{COLORS[:fg][fg]};#{COLORS[:bg][bg]}m#{str}#{ESC_CLR}"
  end

  def set_color_bg(str, bg)
    "\e[#{COLORS[:bg][bg]}m#{str}#{ESC_CLR}"
  end

end
