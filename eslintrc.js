module.exports = {
  parser: "babel-eslint",
  env: {
    es6: true,
    node: true,
    browser: true,
    jest: true,
  },
  parserOptions: {
    ecmaVersion: 6,
    sourceType: "module",
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: ["react", "eslint-plugin-no-inline-styles"],
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:prettier/recommended",
  ],
  rules: {
    "arrow-body-style": ["error", "as-needed"],
    "no-inline-styles/no-inline-styles": 1,
    "react/jsx-key": "error",
    "react/jsx-no-target-blank": "error",
    "react/default-props-match-prop-types": "error",
    "react/forbid-prop-types": "error",
    "react/no-array-index-key": "error",
    "react/no-typos": "error",
    "react/no-unescaped-entities": "error",
    "react/prefer-stateless-function": "error",
    "react/prop-types": "error",
    "react/require-default-props": "error",
    "react/jsx-no-duplicate-props": "error",
  },
  settings: {
    react: {
      pragma: "React",
      version: "detect",
    },
  },
};
