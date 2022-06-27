import resolve from "@rollup/plugin-node-resolve"
import typescript from "@rollup/plugin-typescript"
import excludeDependencies from "rollup-plugin-exclude-dependencies-from-bundle"

export default [
  {
    input: "packages/turbo_stream_button/index.ts",
    output: [
      {
        file: "app/assets/javascripts/turbo_stream_button.js",
        format: "es",
      },
    ],
    plugins: [
      resolve(),
      typescript(),
      excludeDependencies(),
    ],
  },
]
