-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'ALUNO');

-- CreateEnum
CREATE TYPE "StatusQuadra" AS ENUM ('DISPONIVEL', 'INDISPONIVEL', 'MANUTENCAO');

-- CreateEnum
CREATE TYPE "StatusReserva" AS ENUM ('ATIVA', 'CANCELADA');

-- CreateTable
CREATE TABLE "usuarios" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "email_institucional" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'ALUNO',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alunos" (
    "usuario_id" INTEGER NOT NULL,
    "curso" TEXT NOT NULL,
    "num_matricula" TEXT NOT NULL,

    CONSTRAINT "alunos_pkey" PRIMARY KEY ("usuario_id")
);

-- CreateTable
CREATE TABLE "admins" (
    "usuario_id" INTEGER NOT NULL,

    CONSTRAINT "admins_pkey" PRIMARY KEY ("usuario_id")
);

-- CreateTable
CREATE TABLE "quadras" (
    "id_quadra" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "local" TEXT NOT NULL,
    "descricao" TEXT,
    "foto" TEXT,
    "status" "StatusQuadra" NOT NULL DEFAULT 'DISPONIVEL',

    CONSTRAINT "quadras_pkey" PRIMARY KEY ("id_quadra")
);

-- CreateTable
CREATE TABLE "reservas" (
    "id" SERIAL NOT NULL,
    "id_aluno" INTEGER NOT NULL,
    "id_quadra" INTEGER NOT NULL,
    "data" DATE NOT NULL,
    "hora" VARCHAR(5) NOT NULL,
    "duracao" INTEGER NOT NULL,
    "descricao" TEXT,
    "qtd_participantes" INTEGER NOT NULL,
    "status" "StatusReserva" NOT NULL DEFAULT 'ATIVA',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reservas_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_institucional_key" ON "usuarios"("email_institucional");

-- CreateIndex
CREATE UNIQUE INDEX "alunos_num_matricula_key" ON "alunos"("num_matricula");

-- CreateIndex
CREATE INDEX "reservas_id_quadra_data_idx" ON "reservas"("id_quadra", "data");

-- CreateIndex
CREATE INDEX "reservas_id_aluno_idx" ON "reservas"("id_aluno");

-- AddForeignKey
ALTER TABLE "alunos" ADD CONSTRAINT "alunos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admins" ADD CONSTRAINT "admins_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas" ADD CONSTRAINT "reservas_id_aluno_fkey" FOREIGN KEY ("id_aluno") REFERENCES "alunos"("usuario_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas" ADD CONSTRAINT "reservas_id_quadra_fkey" FOREIGN KEY ("id_quadra") REFERENCES "quadras"("id_quadra") ON DELETE RESTRICT ON UPDATE CASCADE;
