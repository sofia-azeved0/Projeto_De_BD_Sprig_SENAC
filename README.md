# 🌾 Projeto de Banco de Dados – Sprig  

## 📖 Descrição Geral  
Este projeto foi desenvolvido como parte do **Projeto Integrador (PI)** da disciplina de **Banco de Dados – DQL e DTL**.  
O objetivo foi criar a **modelagem e implementação do banco de dados** do sistema **Sprig**, uma plataforma web que integra **controle de estoque, logística, rastreamento e transparência pública** do **Programa de Aquisição e Distribuição de Sementes**.  

O Sprig busca **digitalizar e automatizar o ciclo logístico das sementes**, oferecendo **eficiência, sustentabilidade e acesso transparente às informações** para gestores, técnicos e agricultores.  

---

## 🎯 O que foi pedido  
De acordo com as orientações do professor, o projeto de banco de dados deveria conter:  

- **Minimundo** detalhado do domínio de negócio.  
- **Modelagem Entidade-Relacionamento (MER)**.  
- **Modelagem Relacional (MR)**.  
- Documento explicativo com as imagens dos diagramas.  
- **Scripts SQL organizados e documentados**, incluindo:  
  - Criação das tabelas e views (**DDL**).  
  - Inserção de dados (**mínimo 20 registros por tabela**).  
  - Relatórios e consultas (**mínimo 20 SELECTs com JOINs e subselects**).  
  - Criação de views (**mínimo 10**).  
  - Criação e execução de **procedures e funções** (**mínimo 14**).  
  - Criação e execução de **triggers** (**mínimo 12**).  

---

## 🌱 Minimundo – Sprig  
O sistema **Sprig** foi projetado para gerenciar todo o processo de **aquisição, armazenamento, distribuição e rastreabilidade de sementes** no âmbito de programas públicos de agricultura.  

O sistema contempla:  
- **Usuários** (gestores, técnicos e agricultores) com diferentes níveis de acesso.  
- **Controle de Estoque**, com entradas e saídas de lotes de sementes.  
- **Logística e Entregas**, acompanhando o transporte até o destino final.  
- **Rastreabilidade**, permitindo identificar a origem e o percurso de cada lote.  
- **Transparência Pública**, disponibilizando relatórios abertos sobre as distribuições realizadas.  
- **Relatórios Gerenciais**, que apoiam auditorias e decisões estratégicas.  

---

## ⚙️ O que foi adicionado além do pedido  
Para enriquecer a modelagem e aproximar o projeto da realidade, foram feitos aprimoramentos:  

1. **Relacionamento entre Usuário e Entrega**  
   - Criada uma entidade associativa para mapear a responsabilidade de cada técnico ou gestor sobre as entregas.  

2. **Tabela de Logística Detalhada**  
   - Adicionada para registrar dados como rota, veículo e motorista responsáveis pelo transporte.  

3. **Controle de Qualidade das Sementes**  
   - Implementada entidade específica para registrar testes, datas e resultados de amostras.  

4. **Histórico de Movimentação**  
   - Entidade que armazena todas as movimentações do estoque, garantindo rastreabilidade completa.  

5. **Cardinalidades Otimizadas**  
   - Ajustadas para refletir com precisão os relacionamentos reais, como:  
     - Usuário – Entrega → 1:N  
     - Estoque – Movimentação → 1:N  
     - Entrega – Logística → 1:1  
     - Sementes – Qualidade → 1:N  

---

## 🧩 Modelo Entidade-Relacionamento (MER)  
> Inserir imagem do MER aqui (exemplo):  
> `![MER](./diagramas/mer-sprig.png)`

---

## 🧠 Modelo Relacional (MR)  
> Inserir imagem do MR aqui (exemplo):  
> `![MR](./diagramas/mr-sprig.png)`

---

## 📂 Estrutura dos Scripts  
O repositório contém os seguintes arquivos:  

- `01_SPRIG_DDL_Create.sql` → Criação das tabelas e dependências (DDL).  
- `02_SPRIG_DML_Insert.sql` → Inserção de dados nas tabelas (DML).  
- `03_SPRIG_DQL_Select.sql` → Consultas e relatórios (mínimo 20 SELECTs com JOINs/Subselects).  
- `04_SPRIG_DDL_Views.sql` → Criação de views (mínimo 10).  
- `05_SPRIG_SP_Functions.sql` → Criação e execução de procedures e funções (mínimo 14).  
- `06_SPRIG_Triggers.sql` → Criação e execução de triggers (mínimo 12).  

---

## 📊 Conclusão  
O projeto Sprig consolidou uma **modelagem de banco de dados completa e escalável**, atendendo aos requisitos acadêmicos e também às demandas reais de um sistema de rastreabilidade e logística.  

A estrutura criada permite:  
- **Consultas rápidas e seguras**.  
- **Controle detalhado de estoque e transporte**.  
- **Transparência no uso e distribuição das sementes**.  
- **Integração futura com aplicações web** para gestão e acompanhamento em tempo real.  

---

## 👩‍💻 Autoras  
- [Nome da Autora 1]  
- [Nome da Autora 2]  
- [Nome da Autora 3]  
- [Nome da Autora 4]  

## 🌐 LinkedIn  
- [Nome da Autora 1] → [linkedin.com/in/nome1](#)  
- [Nome da Autora 2] → [linkedin.com/in/nome2](#)  
- [Nome da Autora 3] → [linkedin.com/in/nome3](#)  
- [Nome da Autora 4] → [linkedin.com/in/nome4](#)  

---

## 📚 Professor Orientador  
**Danilo Farias Soares da Silva**  
Disciplina: Banco de Dados – DQL e DTL  
Curso: Tecnologia em Análise e Desenvolvimento de Sistemas  

---

## 🗓️ Ano  
**2025**
