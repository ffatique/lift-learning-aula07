# Atividades Aula 07 Curso LIFT Learning

Resolução das atividades da Aula 07 para quem quiser acompanhar no Discord

Requisitos:

- Remix - https://remix.ethereum.org/

Nesta aula optei por utilizar o Remix ao invés do HardHat para poder ajudar e ensinar um pouco nessa outra ferramenta também. Mas quem queira pode estar pegando os Contratos e prosseguindo com o HardHat também.


## SmartContracts

Contrato Correto para a resolulçao do Exercício:

- Aula07AMMv2.sol

Vocês verão na pasta mais 3 contratos, o TokenA.sol e TokenB.sol que criei apenas para interação com o Aula07AMMv2.sol e o LiftAMM.sol que é o original e que serviu de base para as alterações que fiz o qual o professor disponibilizou em seu git - https://github.com/joaoavf/amm


## Remix

No Remix siga o procedimento

- Crie um arquivo novo chamado Aula07AMMv2.sol

- Copie o contrato Aula07AMMv2.sol desta pasta do Git e cole dentro deste arquivo que você criou em seu Remix

- Compile seu contrato utilizando a mesma versão do compilador 0.8.9

- Vá para DEPLOY & RUN TRANSACTIONS

- Selecione o Environment Injected Provider - Metamask **// Lembre-se de alterar a rede para qual você deseja fazer o Deploy do seu contrato em sua MetaMask**

- Depois em CONTRACT, selecione LIFTAMM - Aula07AMMv2.sol

- Após isso em DEPLOY será solicitado 2 argumentos, _TOKENA: e _TOKENB: **// Nestes 2 campos é onde passamos o endereço dos 2 Tokens que solicitamos em nosso Constructor do Aula07AMMv2.sol que é onde definimos quais serão os 2 Tokens utilizados para criar uma Pool de Liquidez e futuramente o Swap. Em meu exemplo aqui passei os endereços do TokenA e TokenB que criei anteriormente à este contrato para fazer essa intereção**

- Após isso clique em Transact, pague a transação e está feito o contrato do exercício da Aula 07

Espero mais uma vez que este tutorial ajude quem está com mais dificuldade em acompanhar esta parte de códigos no curso. Obs: ** Pretendo fazer algumas calls no Discord para mostrar mais alguns detalhes e como adicionei cada parte do contrato e sempre lembrando também que existem inúmeras maneiras de se criar as funções que foram exigidas, então nada garante que essas que passei são as melhores, são as corretas ou não estão sujeitas à algum ataque.

*** A verificação do contrato aqui direto na Scan escolhida é um pouco diferente, mas deixo essa parte com vocês <h1> &#128526;</h1>


