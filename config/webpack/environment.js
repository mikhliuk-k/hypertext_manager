const { environment } = require('@rails/webpacker')

environment.loaders.append("bootstrap.native", {
    test: /bootstrap\.native/,
    use: {
        loader: "bootstrap.native-loader",
        options: {
            only: ["alert", "button", "dropdown", "modal", "tooltip", "popover", "collapse", "tab"],
            bsVersion: 4
        }
    }
})

module.exports = environment
