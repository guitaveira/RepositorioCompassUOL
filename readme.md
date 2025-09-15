[Estratégia de Mapeamento.txt](https://github.com/user-attachments/files/22350400/Estrategia.de.Mapeamento.txt)
# Estratégia de Mapeamento — Challenging DOM (Squad)

**Página:** [https://the-internet.herokuapp.com/challenging\_dom](https://the-internet.herokuapp.com/challenging_dom)

## Princípios

* Priorizar **CSS e seletores semânticos** antes de XPath longo.
* Evitar depender do **texto dos botões** (muda a cada reload).
* **Ancorar por contexto** (linha da tabela → ação nessa linha).
* Garantir **unicidade** de cada seletor (retornar 1 elemento).

## Inventário e seletores

### 1) Botões do topo (são `<a>` estilizados)

* Neutro: `a.button`
* Alerta: `a.button.alert`
* Sucesso: `a.button.success`

> Motivo: texto desses botões é dinâmico; classes são estáveis.

### 2) “Answer:” e Canvas

* Answer (estático): `xpath=//*[contains(normalize-space(.), 'Answer:')]`
* Canvas: `css=canvas`

### 3) Tabela (linha → ação)

* Todas as linhas: `css=table tbody tr`
* Célula \[linha N, col M]: `css=table tbody tr:nth-child(N) td:nth-child(M)`
* Linha pela 1ª coluna (ex.: "Iuvaret7"): `xpath=//table//tr[td[1][normalize-space()='Iuvaret7']]`
* Ação **edit** nessa linha: `xpath=//tr[td[1][normalize-space()='Iuvaret7']]//a[normalize-space()='edit']`
* Ação **delete** nessa linha: `xpath=//tr[td[1][normalize-space()='Iuvaret7']]//a[normalize-space()='delete']`

## Anti-padrões evitados

* XPaths **absolutos** e longos.
* `nth-child` sem âncora semântica.
* Seletores por texto nos botões dinâmicos.

## Checks rápidos (unicidade)

* `css:a.button`, `css:a.button.alert`, `css:a.button.success` devem existir.
* `css=table tbody tr` deve retornar **> 0**.
* `xpath=//*[contains(normalize-space(.),'Answer:')]` deve existir.

---

---

## Exemplos — Selenium (Python)

```py
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

URL = 'https://the-internet.herokuapp.com/challenging_dom'
ROW_KEY = 'Iuvaret7'

opts = Options()
# opts.add_argument('--headless=new')  # descomente se quiser headless

dr = webdriver.Chrome(options=opts)
try:
    dr.get(URL)

    # Botões por classe
    dr.find_element(By.CSS_SELECTOR, 'a.button').click()
    dr.find_element(By.CSS_SELECTOR, 'a.button.alert').click()
    dr.find_element(By.CSS_SELECTOR, 'a.button.success').click()

    # Answer
    dr.find_element(By.XPATH, "//*[contains(normalize-space(.), 'Answer:')]")

    # Linha por primeira coluna
    row_xpath = f"//table//tr[td[1][normalize-space()='{ROW_KEY}']]"
    row = dr.find_element(By.XPATH, row_xpath)

    # Ações da linha
    row.find_element(By.XPATH, ".//a[normalize-space()='edit']").click()
    dr.back()
    row = dr.find_element(By.XPATH, row_xpath)
    row.find_element(By.XPATH, ".//a[normalize-space()='delete']").click()
finally:
    dr.quit()
```

---

