function health(req, res) {
  res.json({
    success: true,
    data: {
      status: 'ok',
      service: 'smartflow-api',
      timestamp: new Date().toISOString(),
    },
  });
}

module.exports = { health };