import type { Register, ThemeSetArgs } from 'claude-code'

import { makeColors } from './make-colors.js'

// Pastel: the dark violet look from the iTerm "Pastel" profile and the Starship
// "little icons" prompt. Dark only, so the app stays dark while the mod is on.
const { theme, problems } = makeColors({
  label: 'Pastel',
  only: 'dark',
  // Pink accent like the prompt's flower and heart; lavender, green, amber and coral
  // from the prompt's directory, Node, git-status and error colors.
  roles: { accent: '#ED93B1', danger: '#F09595', success: '#97C459', warning: '#EF9F27', pro: '#AFA9EC' },
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
