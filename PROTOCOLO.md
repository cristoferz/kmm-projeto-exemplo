# Projeto de exemplo (Colmeia)

## Funções de Busca

### Busca de Municipios

Request: Todos os campos são opcionais e usados para filtro

    Operation: getMunicipio
    {
       "municipio_id": 1,
       "municipio": "",
       "uf": "uf",
       "cod_ibge": "cod_ibge"
    }

Response:

    {
      "municipios": [
         {
            "municipio_id": 93122,
            "municipio": "Pontal do Paraná",
            "uf": "PR",
            "cod_ibge": "4119954"
         }
      ]
    }   

## Cadastro da colmeia

### Lista de Colmeias

Request: Todos os campos são opcionais e usados para filtro

    Operation: getColmeia
    {
       "colmeia_id": 1,
       "num_colmeia": 1,
       "descricao": "",
       "tipo": "AFRICANA",
       "municipio": "",
       "municipio_id": 1,
       "retornar_abelhas": true
    }

Response:

    {
       "colmeias": [
          {
            "colmeia_id": 1,
            "num_colmeia": 1,
            "descricao": "Colmeia Alterada",
            "tipo": "Africana",
            "producao_minima": 1,
            "producao_atual": 10,
            "municipio_id": 1,
            "abelhas": [
               {
                  "abelha_id": 1,
                  "num_abelha": 1,
                  "nome": "Abelha 1",
                  "producao_individual": 10,
                  "modalidade": "FROTA"
               },
               {
                  "abelha_id": 2,
                  "num_abelha": 2,
                  "nome": "Abelha 2",
                  "producao_individual": 11,
                  "modalidade": "AGREGADO"
               }
            ]
          },
          {
            "colmeia_id": 1,
            "num_colmeia": 1,
            "descricao": "Colmeia Alterada",
            "tipo": "Africana",
            "producao_minima": 1,
            "producao_atual": 10,
            "municipio_id": 1,
            "abelhas": []
          },
       ]
    }    

### Lista de Abelhas

Request:

    Operation: getAbelha
    {
       "colmeia_id": 1
    }

Response:

    {
      "abelhas": [
         {
            "abelha_id": 1,
            "num_abelha": 1,
            "nome": "Abelha 1",
            "producao_individual": 10,
            "modalidade": "FROTA"
         },
         {
            "abelha_id": 2,
            "num_abelha": 2,
            "nome": "Abelha 2",
            "producao_individual": 11,
            "modalidade": "AGREGADO"
         }
      ]
    }    

### Inserção

Request:

    Operation: insColmeia
    {
       "num_colmeia": 1,
       "descricao": "Colmeia",
       "tipo": "Africana",
       "producao_minima": 1,
       "producao_atual": 10,
       "municipio_id": 1,
       "abelhas": [
         {
            "num_abelha": 1,
            "nome": "Abelha 1",
            "producao_individual": 10,
            "modalidade": "FROTA"
         },
         {
            "num_abelha": 2,
            "nome": "Abelha 2",
            "producao_individual": 11,
            "modalidade": "AGREGADO"
         }
      ]
    }

Response:

    {
       "mensagem": "Colméia inserida com sucesso.",
       "colmeia_id": 1,
       "abelhas": [
               {
                  "abelha_id": 1,
                  "num_abelha": 1,
                  "nome": "Abelha 1",
                  "producao_individual": 10,
                  "modalidade": "FROTA"
               },
               {
                  "abelha_id": 2,
                  "num_abelha": 2,
                  "nome": "Abelha 2",
                  "producao_individual": 11,
                  "modalidade": "AGREGADO"
               }
            ]
    }   

### Alteração

Request:

    Operation: updColmeia
    {
       "colmeia_id": 1,
       "num_colmeia": 1,
       "descricao": "Colmeia Alterada",
       "tipo": "Africana",
       "producao_minima": 1,
       "producao_atual": 10,
       "municipio_id": 1,
       "abelhas": [
         {
            "operation": "UPDATE",
            "abelha_id": 1
            "num_abelha": 1,
            "nome": "Abelha 1 - Alterada",
            "producao_individual": 10,
            "modalidade": "FROTA"
         },
         {
            "operation": "INSERT",
            "num_abelha": 3,
            "nome": "Abelha 3",
            "producao_individual": 11,
            "modalidade": "AGREGADO"
         },
         {
            "operation": "DELETE",
            "abelha_id": 2
         }
      ]
    }

Response:

    {
       "mensagem": "Colméia alterada com sucesso",
       "abelhas": [
               {
                  "abelha_id": 1,
                  "num_abelha": 1,
                  "nome": "Abelha 1",
                  "producao_individual": 10,
                  "modalidade": "FROTA"
               },
               {
                  "abelha_id": 2,
                  "num_abelha": 2,
                  "nome": "Abelha 2",
                  "producao_individual": 11,
                  "modalidade": "AGREGADO"
               }
            ]
    }

### Exclusão

Request:

    Operation: delColmeia
    {
       "colmeia_id": 1
    }    

Response:

    {
       "mensagem": "Colméia excluida com sucesso."
    }
  