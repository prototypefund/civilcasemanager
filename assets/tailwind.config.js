// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  darkMode: 'media',
  content: [
    "./js/**/*.js",
    "../lib/case_manager_web.ex",
    "../lib/case_manager_web/**/*.*ex",
    "../lib/datasources/*.ex",
  ],
  theme: {
    extend: {
      colors: {

        gray: {
          '50':  '#FAFCFC',
          '100': '#E4E8EE',
          '200': '#C1C9D0',
          '300': '#A2ABB7',
          '400': '#8892A2',
          '500': '#6B7385',
          '600': '#505669',
          '700': '#3C4055',
          '800': '#2B2E44',
          '900': '#2B2E44',
        },
        blue: {
          '50':  '#F5FCFF',
          '100': '#D9EDFF',
          '200': '#ACCFFC',
          '300': '#85ACF4',
          '400': '#758CEC',
          '500': '#5C66D2',
          '600': '#414AA6',
          '700': '#313B84',
          '800': '#262C62',
          '900': '#152041',
        },
        teal: {
          '50':  '#EEFDFE',
          '100': '#CFF3FB',
          '200': '#8ED8E9',
          '300': '#62BDE4',
          '400': '#4D9DCE',
          '500': '#277FB5',
          '600': '#1C5B92',
          '700': '#154876',
          '800': '#0F3451',
          '900': '#082530',
        },
        emerald: {
          '50':  '#F2FEEE',
          '100': '#CFF7C9',
          '200': '#91E396',
          '300': '#52D080',
          '400': '#3EB574',
          '500': '#288D60',
          '600': '#216B44',
          '700': '#18533A',
          '800': '#113B34',
          '900': '#0A2627',
        },
        orange: {
          '50':  '#FBF9EA',
          '100': '#F6E4BA',
          '200': '#E7C07B',
          '300': '#DC9742',
          '400': '#CB7519',
          '500': '#AD5102',
          '600': '#893301',
          '700': '#6C2706',
          '800': '#501A0F',
          '900': '#361206',
        },
        chestnut: {
          '50':  '#FEFAEE',
          '100': '#FCE2C0',
          '200': '#EFB586',
          '300': '#E78B5F',
          '400': '#D7664B',
          '500': '#B34434',
          '600': '#912728',
          '700': '#731620',
          '800': '#550F1C',
          '900': '#3B0B14',
        },
        cerise: {
          '50':  '#FEF7F4',
          '100': '#FBE0DD',
          '200': '#F2AFB3',
          '300': '#EC798B',
          '400': '#DC5472',
          '500': '#BC3263',
          '600': '#98184D',
          '700': '#73123F',
          '800': '#560E39',
          '900': '#3B0427',
        },
        purple: {
          '50':  '#FEF7FF',
          '100': '#F8DDF4',
          '200': '#E8ADE1',
          '300': '#D882D9',
          '400': '#BF62CF',
          '500': '#9B47B2',
          '600': '#743095',
          '700': '#57237E',
          '800': '#3D1867',
          '900': '#2A0D53',
        },
        indigo: {
          '50':  '#F8F9FE',
          '100': '#E7E5FC',
          '200': '#C6C0E9',
          '300': '#AE9DDE',
          '400': '#9B7AD8',
          '500': '#7F58BE',
          '600': '#5F4199',
          '700': '#4A2D7F',
          '800': '#362164',
          '900': '#20144C',
        },


        // brand: "#FD4F00",
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
