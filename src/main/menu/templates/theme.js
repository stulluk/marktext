import * as actions from '../actions/theme'

export default function (userPreference) {
  const { theme } = userPreference.getAll()
  return {
    label: '&Theme',
    id: 'themeMenu',
    submenu: [{
      label: 'Cadmium Light',
      type: 'radio',
      id: 'light',
      checked: theme === 'light',
      click (menuItem, browserWindow) {
        actions.selectTheme('light')
      }
    }, {
      label: 'Dark',
      type: 'radio',
      id: 'dark',
      checked: theme === 'dark',
      click (menuItem, browserWindow) {
        actions.selectTheme('dark')
      }
    }, {
      label: 'Graphite Light',
      type: 'radio',
      id: 'graphite',
      checked: theme === 'graphite',
      click (menuItem, browserWindow) {
        actions.selectTheme('graphite')
      }
    }, {
      label: 'GitHub',
      type: 'radio',
      id: 'github',
      checked: theme === 'github',
      click (menuItem, browserWindow) {
        actions.selectTheme('github')
      }
    }, {
      label: 'GitHub Dark',
      type: 'radio',
      id: 'github-dark',
      checked: theme === 'github-dark',
      click (menuItem, browserWindow) {
        actions.selectTheme('github-dark')
      }
    }, {
      label: 'GitHub Even Darker',
      type: 'radio',
      id: 'github-even-darker',
      checked: theme === 'github-even-darker',
      click (menuItem, browserWindow) {
        actions.selectTheme('github-even-darker')
      }
    }, {
      label: 'Material Dark',
      type: 'radio',
      id: 'material-dark',
      checked: theme === 'material-dark',
      click (menuItem, browserWindow) {
        actions.selectTheme('material-dark')
      }
    }, {
      label: 'One Dark',
      type: 'radio',
      id: 'one-dark',
      checked: theme === 'one-dark',
      click (menuItem, browserWindow) {
        actions.selectTheme('one-dark')
      }
    }, {
      label: 'Ulysses Light',
      type: 'radio',
      id: 'ulysses',
      checked: theme === 'ulysses',
      click (menuItem, browserWindow) {
        actions.selectTheme('ulysses')
      }
    }]
  }
}
