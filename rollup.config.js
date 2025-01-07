import includePaths from 'rollup-plugin-includepaths';
import commonjs from '@rollup/plugin-commonjs';

const BUNDLE = process.env.BUNDLE === 'true'
const ESM = process.env.ESM === 'true'

const fileDest = `default${ESM ? '.esm' : ''}`
const external = [
  'leaflet',
]
const globals = {
  leaflet: 'L',
}
let includePathOptions = {
  include: {},
  paths: ['app/javascript', 'vendor/assets/javascripts'],
  external: [],
  extensions: ['.js', '.es6']
};

const rollupConfig = {
  input: 'app/javascript/blacklight_heatmaps.js',
  output: {
    file: `app/assets/javascripts/blacklight_heatmaps/${fileDest}.js`,
    format: ESM ? 'es' : 'umd',
    globals,
    generatedCode: { preset: 'es2015' },
    name: ESM ? undefined : 'BlacklightHeatmaps'
  },
  external,
  plugins: [includePaths(includePathOptions), commonjs()]
}

export default rollupConfig
