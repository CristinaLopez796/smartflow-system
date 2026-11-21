const { Router } = require('express');
const autenticar = require('../middlewares/autenticar');
const { me } = require('../controllers/me.controller');

const router = Router();
router.get('/me', autenticar, me);

module.exports = router;