// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/events_web.ex",
    "../lib/events_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
        // 'blue': {
        //   '50': '#f0f8fb',
        //   '100': '#d9edf4',
        //   '200': '#b8dce9',
        //   '300': '#87c2d9',
        //   '400': '#4ea0c1',
        //   '500': '#3384a7',
        //   '600': '#2d6b8d',
        //   '700': '#2b5973',
        //   '800': '#2a4b60',
        //   '900': '#273f52',
        //   '950': '#152837',
        // },
        // 'red': {
        //   '50': '#fdf4f3',
        //   '100': '#fbe8e5',
        //   '200': '#f8d5d0',
        //   '300': '#f2b8af',
        //   '400': '#e98e80',
        //   '500': '#dc6957',
        //   '600': '#ca5644',
        //   '700': '#a73e2e',
        //   '800': '#8b3629',
        //   '900': '#743228',
        //   '950': '#3e1711',
        //  },
        'calypso': {
          '50': '#f1f8fa',
          '100': '#dcedf1',
          '200': '#bddde4',
          '300': '#8fc3d1',
          '400': '#5aa2b6',
          '500': '#3e869c',
          '600': '#3a758c',
          '700': '#325b6c',
          '800': '#2f4c5b',
          '900': '#2b414e',
          '950': '#182a34',
      },
      'web-orange': {
        '50': '#fffbeb',
        '100': '#fff5c6',
        '200': '#ffea88',
        '300': '#ffd949',
        '400': '#ffc620',
        '500': '#f29f05',
        '600': '#dd7c02',
        '700': '#b85705',
        '800': '#95420b',
        '900': '#7a360d',
        '950': '#461b02',
    },
    'flamingo': {
      '50': '#fef5ee',
      '100': '#fee7d6',
      '200': '#fbccad',
      '300': '#f8a879',
      '400': '#f57942',
      '500': '#f25d27',
      '600': '#e33c13',
      '700': '#bc2c12',
      '800': '#952417',
      '900': '#782116',
      '950': '#410d09',
  },
  
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}
