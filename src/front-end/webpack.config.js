//
const { VueLoaderPlugin } = require('vue-loader');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');
//const { web } = require('webpack');
//const env = process.env.NODE_ENV;

module.exports = {
    //mode: env == 'production' || env == 'none' ? env : 'development',
    entry: ['./src/app.js'],
    module: {
        rules: [
        {
            test: /\.vue$/,
            use: 'vue-loader'
        },
        {
            test: /\.js$/,
            loader: 'babel-loader'
        },
        {
            test: /\.css$/,
            use: ['vue-style-loader', 'css-loader']
        }
        ]
    },
    plugins: [
        new VueLoaderPlugin(),
        new HtmlWebpackPlugin({
            filename: 'index.html',
            template: 'index.html',
            favicon: 'favicon.ico',
            inject: true
        }),
        new webpack.HotModuleReplacementPlugin()
    ],
    devServer: {
        hot: true,
    }
};