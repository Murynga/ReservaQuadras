import { Router } from 'express';

import * as usuarioController from '../controllers/usuario.controller.js';
import { authenticate, authorize } from '../middlewares/auth.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';
import { createAdminSchema } from '../validators/usuario.validator.js';

const router = Router();

// Todas as rotas de usuários são restritas a administradores
router.use(authenticate, authorize('ADMIN'));

router.get('/', usuarioController.list);
router.get('/:id', usuarioController.getById);

// Admin cadastra outro admin
router.post('/admins', validate(createAdminSchema), usuarioController.createAdmin);

export default router;
