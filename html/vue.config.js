module.exports = {
  devServer: {
    open: process.platform === 'darwin',
    host: '0.0.0.0',
    port: 3344,
    https: false,
    hotOnly: false,
    proxy: 'http://localhost:3000',
    before: app => {
      // app is an express instance
    }
  }
}
