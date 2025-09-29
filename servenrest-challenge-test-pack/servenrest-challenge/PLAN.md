# Plano de Testes — ServeRest (Challenge)

## Escopo
- **API**: /login, /usuarios, /produtos, /carrinhos
- **Tipos de teste**: contrato, funcional (happy path + erros comuns), permissões, dados inválidos, smoke.

## Riscos & Mitigações
- Dados “sujos” entre execuções → reset de massa (teardowns)
- Alterações na API → testes de **contrato** como proteção inicial
- Ambiente instável → rodadas smoke curtas e frequentes

## Ambientes
- Dev local (http://localhost:3000)
- (Opcional) EC2 app (:3000) + EC2 runner (Robot)

## Critérios
- **Entrada**: rotas estáveis, massa mínima definida
- **Saída**: 100% smoke + 90% alta prioridade verdes; sem blockers

## Estratégia
1. Smoke (login, CRUD básico)
2. Contrato (schemas mínimos)
3. Funcionais (happy path)
4. Negativos (403/400/409)
5. Regressão (automatizados + exploratórios)

## Candidatos à Automação (amostra)
- A1: POST /login → 200 + Bearer
- U1: POST /usuarios → 201
- U2: GET /usuarios/{id} → 200
- U3: DELETE /usuarios/{id} → 200 e depois GET → 400/404
- P1: POST /produtos (admin) → 201
- P2: POST /produtos (sem admin) → 403
- P3: GET /produtos → 200; lista > 0
