const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

module.exports = {
  content: ['./{components,contexts,hooks,pages,utils}/**/*.{js,cjs,mjs,ts,tsx}'],

  daisyui: {
    themes: ['dracula'],
  },

  theme: {
    extend: {
      colors: {
        miniutopia: { DEFAULT: '#2563EB', 80: '#1D4ED8' },
        dark: { DEFAULT: '#06090B' },
        gray: { DEFAULT: '#A9A9A9' },
        'dark-gray': { DEFAULT: '#191D20' },
        purple: { DEFAULT: '#7E5DFF' },

        neutral: colors.neutral,
        plumbus: {
          DEFAULT: '#2563EB',
          light: '#3B82F6',
          matte: '#60A5FA',
          dark: '#1E40AF',
          10: '#EFF6FF',
          20: '#DBEAFE',
          30: '#BFDBFE',
          40: '#93C5FD',
          50: '#60A5FA',
          60: '#3B82F6',
          70: '#2563EB',
          80: '#1D4ED8',
          90: '#1E40AF',
          100: '#1E3A8A',
          110: '#172554',
          120: '#0F172A',
        },
        twitter: { DEFAULT: '#1DA1F2' },
      },
      fontFamily: {
        heading: ["'Basement Grotesque'", ...defaultTheme.fontFamily.sans],
        sans: ['Roboto', ...defaultTheme.fontFamily.sans],
        mono: ['"JetBrains Mono"', ...defaultTheme.fontFamily.mono],
      },
      animation: {
        'spin-slow': 'spin 3s linear infinite',
      },
    },
  },

  plugins: [
    // tailwindcss official plugins
    require('@tailwindcss/forms')({
      strategy: 'class',
    }),
    require('@tailwindcss/line-clamp'),
    require('tailwindcss-opentype'),

    // custom gradient background
    plugin(({ addUtilities }) => {
      addUtilities({
        '.miniutopia-gradient-bg': {
          background: `linear-gradient(64.38deg, #1E3A8A 15.06%, #60A5FA 100.6%), #0F172A`,
        },
        '.miniutopia-gradient-brand': {
          background: `linear-gradient(102.33deg, #3B82F6 10.96%, #60A5FA 93.51%)`,
        },
      })
    }),
    require('daisyui'),
  ],
}
