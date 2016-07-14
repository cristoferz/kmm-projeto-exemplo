# Tutorial de uso da metodologia Backend/Frontend nos padrões KMM

Esse tutorial tem por objetivo detalhar os padrões e praticas recomendadas para o 
desenvolvimento de aplicações KMM utilizando-se da metodologia Backend/Frontend. 

Está subdividido nos seguintes grupos, cada um em seu arquivo independente:

* [Definição do protocolo](TUTORIAL_PROTOCOLO.md)
* [Construção do backend](TUTORIAL_BACKEND.md)
* [Frontend Java](TUTORIAL_JAVA.md)
* [Frontend Ionic (Mobile)](TUTORIAL_IONIC.md)
* [Frontend Angular 2 (Web)](TUTORIAL_NG2.md)

A metodologia de desenvolvimento baseada na topologia backend/frontend visa maior
flexibilidade de tecnologias, maior isolamento entre interface e regra de negócio e melhor
estruturação lógica do sistema, dando ganhos em manutenibilidade, testabilidade e desempenho 
global do sistema.

Para a utilização dessa metodologia, faz-se necessária a subdivisão do processo de construção em 
3 etapas, sendo a primeira delas pré-requisito para o início das 2 próximas, que podem ser
executadas de forma paralela.

1. Definição do Protoloco: É a base para a metodologia e **DEVE** definir **TODAS** as mensagens trocadas entre
backend e frontend. A definição **DEVE** ser feita sempre antes de quaisquer desenvolvimentos das outras
partes, pois o conhecimento de todas as funções permite uma otimização de quantidade de requisições
e volume de dados, base dessa etapa, trazendo ganhos funcionais e de desempenho. Ajustes durante as demais 
etapas até podem ocorrer, mas lembrem-se "todo puxadinho costuma dar goteira", portanto, acertar nessa etapa 
é essencial para um bom resultado no projeto.

2. Desenvolvimento do backend: Com o conhecimento de todas as mensagens trocadas entre as partes (backend e frontend), 
é possível o desenvolvimento completo do backend de forma direta. Ele inclui a construção das estruturas de 
banco de dados e programação das regras de negócio, assim como a construção das mensagens de resposta para o 
frontend, seja ele qual for.

3. Desenvolvimento do frontend: Essa etapa é a construção das interfaces com o mundo exterior. Em geral, se 
trata de interfaces com o usuário, porém pode se tratar também de integrações de sistemas externos. Deve-se 
partir da ideia que o frontend sempre é um território inseguro e, portanto, o backend tem que ser o responsável 
pela segurança do sistema. Essa etapa pode ser executada diversas vezes, visto que uma mesma funcionalidade
pode ser implementada em diversas tecnologias e formatos diferentes. 

## Flexibilização de tecnologia

Visto que um dos objetivos dessa metodologia é trazer flexibilidade de tecnologia aos sistemas KMM, fez-se 
necessária a adoção de algumas tecnologias de transporte diferentes das atuais. O modelo Cliente/Servidor,
utilizado até então, se mostrou ineficaz quando se trata de tecnologias móveis e de web. 

### Protocolo de transportes
Como um dos principais pontos nessa flexibidade é a definição de uma camada de transporte que pudesse ser
utilizada nas mais diversas tecnologias e sabendo-se que a tecnologia mais acessível, tratando de passagem
por firewalls e proxys é o protocolo HTTP, adotou-se essa tecnologia como camada de transporte dos dados
entre as partes. Dessa forma, tornou-se possível o uso de Proxys, HTTP e HTTPS e aumentou-se a facilidade de
controlar os acessos dos usuários.

### Formato dos dados
Pensando-se em um formato de dados atualizado e que pudesse ser utilizado nas mais diversas tecnologias, a
melhor opção foi o JSON. JSON é amplamente suportado pelas tecnologias WEB (afinal, ele nasceu lá...) e também
facilmente adaptado ao Java. 

Uma única questão comprometia o uso de JSON, é a versão atualmente homologada do Oracle para os clientes KMM,
a 11.2.0.4. JSON está disponível no Oracle a partir das versões 12c, e nossos clientes não possuirão a licença para que 
possamos migrar. 

Em contrapartida, o Oracle é robusto no uso de XML. O problema é que XML e JSON não são tecnologias compatíveis. 
Para resolver esse problema, foi criado um formato XML compatível com JSON, trazendo a robustez do XML e a
flexibilidade do JSON.   