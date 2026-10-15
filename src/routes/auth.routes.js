import { Router } from 'express';

import * as authController from '../controllers/auth.controller.js';
import { authenticate } from '../middlewares/auth.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';
import { registerSchema, loginSchema } from '../validators/auth.validator.js';

const router = Router();

// Cadastro de aluno (público)
router.post('/register', validate(registerSchema), authController.register);

// Login (público) -> retorna JWT
router.post('/login', validate(loginSchema), authController.login);

// Dados do usuário logado
router.get('/me', authenticate, authController.me);

export default router;
