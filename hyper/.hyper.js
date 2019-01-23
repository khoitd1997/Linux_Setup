// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
    config: {
        // choose either `'stable'` for receiving highly polished,
        // or `'canary'` for less polished but more frequent updates
        updateChannel: 'stable',

        // default font size in pixels for all tabs
        fontSize: 18,

        // font family with optional fallbacks
        fontFamily: 'Source Code Pro',

        // default font weight: 'normal' or 'bold'
        fontWeight: 'normal',

        // font weight for bold characters: 'normal' or 'bold'
        fontWeightBold: 'bold',

        // line height as a relative unit
        lineHeight: 1,

        // letter spacing as a relative unit
        letterSpacing: 0,

        // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
        cursorColor: 'rgba(248,28,229,0.8)',

        // terminal text color under BLOCK cursor
        cursorAccentColor: '#000',

        // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
        cursorShape: 'BLOCK',

        // set to `true` (without backticks and without quotes) for blinking cursor
        cursorBlink: false,

        // color of the text
        foregroundColor: '#f7f1ff',

        // terminal background color
        // opacity is only supported on macOS
        backgroundColor: '#363537',

        // terminal selection color
        selectionColor: '#525154',

        // border color (window, tabs)
        borderColor: '#333',

        // custom CSS to embed in the main window
        css: '',

        // custom CSS to embed in the terminal window
        termCSS: '',

        // if you're using a Linux setup which show native menus, set to false
        // default: `true` on Linux, `true` on Windows, ignored on macOS
        showHamburgerMenu: true,

        // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
        // additionally, set to `'left'` if you want them on the left, like in Ubuntu
        // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
        showWindowControls: true,

        // custom padding (CSS format, i.e.: `top right bottom left`)
        padding: '12px 14px',

        // the full list. if you're going to provide the full color palette,
        // including the 6 x 6 color cubes and the grayscale map, just provide
        // an array here instead of a color map object
        colors: {
            black: "#363537",
            blue: "#fd9353",
            brightBlack: "#69676c",
            brightBlue: "#fd9353",
            brightCyan: "#5ad4e6",
            brightGreen: "#7bd88f",
            brightMagenta: "#948ae3",
            brightRed: "#fc618d",
            brightWhite: "#f7f1ff",
            brightYellow: "#fce566",
            cyan: "#5ad4e6",
            green: "#7bd88f",
            magenta: "#948ae3",
            red: "#fc618d",
            white: "#f7f1ff",
            yellow: "#fce566",
        },

        shellArgs: ['--command=usr/bin/bash.exe', '-l', '-i'],
        shell: 'C:\\Program Files\\Git\\git-cmd.exe',

        shell: '',
        shellArgs: ['--login'],

        // for environment variables
        env: { TERM: 'cygwin' },

        // set to `false` for no bell
        bell: 'SOUND',

        // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
        copyOnSelect: false,

        // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
        defaultSSHApp: true,

        // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
        // selection is present (`true` by default on Windows and disables the context menu feature)
        // quickEdit: true,

        // URL to custom bell
        // bellSoundURL: 'http://example.com/bell.mp3',

        // for advanced config flags please refer to https://hyper.is/#cfg
    },

    // a list of plugins to fetch and install from npm
    // format: [@org/]project[#version]
    // examples:
    //   `hyperpower`
    //   `@company/project`
    //   `project#1.0.1`
    plugins: [],

    // in development, you can create a directory under
    // `~/.hyper_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    localPlugins: [],

    keymaps: {
        // Example
        // 'window:devtools': 'cmd+alt+o',
    },
};
