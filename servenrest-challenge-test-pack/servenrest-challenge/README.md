# ServeRest — Challenge (Plano + Testes Robot)

Pacote pronto para postagem. Contém:
- **Plano de Testes** (`PLAN.md`)
- **Suites Robot** (`tests/`) usando `RequestsLibrary`
- **Recursos/Keywords** (`resources/api.resource`)
- **Variáveis de ambiente** (`variables/env.py`)
- **Requisitos** (`requirements.txt`)
- (Opcional) CI (`.github/workflows/robot.yml`)
- **Modelo de import CSV** para QAlity/Jira (`jira_import.csv`)

## Rodando local
```bash
pip install -r requirements.txt
robot -d reports tests
```

> Ajuste `variables/env.py` se necessário (BASE_URL, credenciais admin).
