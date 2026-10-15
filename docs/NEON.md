# Issue 04 — Banco Neon com branch de testes

## 1. Criar o projeto

1. Entre em https://console.neon.tech e crie a conta (pode ser com o GitHub).
2. **New project** → nome `reserva-quadras`, Postgres na versão padrão e, se aparecer, a região mais próxima do Brasil (São Paulo, `sa-east-1`).
3. O projeto já nasce com a branch raiz, chamada **production** no console (e `main` na API/CLI). Ela não pode ser apagada. Use-a como banco principal.

## 2. Criar a branch de testes

No console: **Branches → Create branch**.

- Nome: `teste`
- Parent: `production`

Ou pela CLI (`npm i -g neonctl`):

```bash
neon auth
neon branches create --name teste --project-id <ID_DO_PROJETO>
```

Cada colega também pode criar a própria branch de desenvolvimento (`dev/nome`) para não mexer nos dados dos outros:

```bash
neon branches create --name dev/nome --parent production --project-id <ID_DO_PROJETO>
```

## 3. Pegar as strings de conexão

Clique em **Connect**, escolha a branch, o database e o role:

| Variável | Qual string | Para quê |
|---|---|---|
| `DATABASE_URL` | **Pooled** (host com `-pooler`) | A aplicação em execução |
| `DIRECT_URL` | **Direct** (sem `-pooler`) | `prisma migrate` |

Repita para a branch `teste` e guarde em variáveis separadas (serão usadas na issue 08 e nos testes):

```env
DATABASE_URL="postgresql://...-pooler.../neondb?sslmode=require"
DIRECT_URL="postgresql://.../neondb?sslmode=require"

DATABASE_URL_TEST="postgresql://...-pooler.../neondb?sslmode=require"   # branch teste
DIRECT_URL_TEST="postgresql://.../neondb?sslmode=require"               # branch teste
```

Nunca coloque essas strings no Git. O `.env` já está no `.gitignore`; só o `.env.example` (sem valores reais) vai para o repositório.

## 4. Aplicar o schema em cada branch

Depois de `npm install`:

```bash
# branch production
npx prisma migrate dev --name init

# branch teste (aponta as variáveis para a branch de testes só neste comando)
DATABASE_URL="$DATABASE_URL_TEST" DIRECT_URL="$DIRECT_URL_TEST" npx prisma migrate deploy
```

Nos testes (issue 14), o setup do Vitest deve trocar `process.env.DATABASE_URL` por `DATABASE_URL_TEST` antes de criar o `PrismaClient`, para nunca rodar teste na branch principal.

## 5. Adicionar os colegas

Existem dois caminhos:

**A) Colaboradores do projeto (mais simples para a disciplina)**

1. Console → selecione o projeto → **Settings → Collaborators**.
2. **Invite**, digite o e-mail de cada colega e confirme.
3. O colega precisa ter (ou criar) uma conta Neon com esse e-mail. Ele acessa o projeto pelo console, API e CLI, usando a própria API key.
4. Quem é convidado usa os limites do plano do dono do projeto, e o custo de uso é cobrado do dono.

**B) Organização do Neon**

Se preferirem uma conta de equipe, crie uma **Organization** e convide os membros em **Invite members**. Os projetos ficam sob a organização, com papéis e cobrança centralizados.

Para o trabalho, o caminho A resolve. Confira no console os limites do plano gratuito (número de branches e colaboradores), porque eles mudam com o tempo.

## Fontes

- https://neon.com/docs/guides/project-collaboration-guide
- https://neon.com/docs/get-started/workflow-primer
- https://neon.com/docs/concepts/the-object-model
- https://neon.tech/docs/guides/branching-neon-cli
