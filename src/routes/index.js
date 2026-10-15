import { Router } from 'express';

import authRoutes from './auth.routes.js';
import usuarioRoutes from './usuario.routes.js';
import quadraRoutes from './quadra.routes.js';
import reservaRoutes from './reserva.routes.js';

const router = Router();

router.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

router.use('/auth', authRoutes);
router.use('/usuarios', usuarioRoutes);
router.use('/quadras', quadraRoutes);
router.use('/reservas', reservaRoutes);

export default router;
