$env.config.keybindings = ($env.config.keybindings | append {
    name: open_editor
    modifier: control
    keycode: char_g
    mode: [emacs, vi_normal, vi_insert]
    event: { send: OpenEditor }
})
