import type { Register, ThemeSetArgs } from 'claude-code'

import { makeColors } from './make-colors.js'

// Pastel: the look from the iTerm "Pastel" profile and the Starship "little icons"
// prompt. Follows macOS light/dark mode, like the iTerm profile: dark violet at night,
// pale lavender by day.
const { theme, problems } = makeColors({
  label: 'Pastel',
  // Pink accent like the prompt's flower and heart; lavender, green, amber and coral
  // from the prompt's directory, Node, git-status and error colors.
  roles: { accent: '#ED93B1', danger: '#F09595', success: '#97C459', warning: '#EF9F27', pro: '#AFA9EC' },
  // Light mode: a pale lavender page, with deeper versions of the same accents so they
  // stay readable on it (the iTerm profile's light colors).
  light: {
    roles: { accent: '#993556', danger: '#A32D2D', success: '#3B6D11', warning: '#854F0B', pro: '#534AB7' },
    gray: {
      anchors: {
        'surface-0': '#E4E0F0',
        'surface-1': '#EAE7F4',
        'surface-2': '#F0EEF8',
        'surface-3': '#F0EEF8',
        'text-primary': '#2A2838', // the iTerm light-mode text color
        'text-secondary': '#4A475C',
        'text-muted': '#5E5B70',
      },
    },
  },
  dark: {
    gray: {
      anchors: {
        'surface-0': '#1E1E2A', // the iTerm background
        'surface-1': '#232331',
        'surface-2': '#262635',
        'surface-3': '#29293A',
        'text-primary': '#E8E6DF', // the iTerm text color
        'text-secondary': '#CFCBDA',
        'text-muted': '#A6A2B8',
      },
    },
  },
})

const LOOK: ThemeSetArgs = { colors: theme }

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    // Shows the line that would stop Desktop painting the look, if a color change causes one.
    const unpainted = problems.find(line => line.startsWith("Desktop won't paint"))

    if (unpainted !== undefined) {
      $.ui.toast(unpainted)
    }
    const set = await $.theme.set(LOOK)

    if (!set.isDrawn) {
      $.ui.status(set.reason)
    }

    return next(e)
  })
}
