import { Router } from 'express';

import * as reservaController from '../controllers/reserva.controller.js';
import { authenticate, authorize } from '../middlewares/auth.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';
import { createReservaSchema, updateReservaSchema } from '../validators/reserva.validator.js';

const router = Router();

router.use(authenticate);

// Aluno: criar reserva e ver as próprias reservas
router.post('/', authorize('ALUNO'), validate(createReservaSchema), reservaController.create);
router.get('/minhas', authorize('ALUNO'), reservaController.listMinhas);

// Admin: ver/gerenciar todas as reservas
router.get('/', authorize('ADMIN'), reservaController.listAll);
router.put('/:id', authorize('ADMIN'), validate(updateReservaSchema), reservaController.update);

// Aluno (dono da reserva) ou admin: detalhe e cancelamento.
// A checagem de "dono da reserva" fica na service.
router.get('/:id', reservaController.getById);
router.patch('/:id/cancelar', reservaController.cancel);

export default router;
