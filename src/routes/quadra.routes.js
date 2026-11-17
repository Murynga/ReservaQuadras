import { Router } from 'express';

import * as quadraController from '../controllers/quadra.controller.js';
import { authenticate, authorize } from '../middlewares/auth.middleware.js';
import { upload } from '../middlewares/upload.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';
import { createQuadraSchema, updateQuadraSchema } from '../validators/quadra.validator.js';

const router = Router();

// Consulta (qualquer usuário autenticado)
router.get('/', authenticate, quadraController.list);
router.get('/:id', authenticate, quadraController.getById);

// Horários livres/ocupados de uma quadra em um dia: GET /quadras/:id/horarios?data=2026-10-20
router.get('/:id/horarios', authenticate, quadraController.horarios);

// Gerenciamento (somente admin). "foto" é o campo do upload (multipart/form-data)
router.post(
  '/',
  authenticate,
  authorize('ADMIN'),
  upload.single('foto'),
  validate(createQuadraSchema),
  quadraController.create,
);

router.put(
  '/:id',
  authenticate,
  authorize('ADMIN'),
  upload.single('foto'),
  validate(updateQuadraSchema),
  quadraController.update,
);

router.delete('/:id', authenticate, authorize('ADMIN'), quadraController.remove);

export default router;
