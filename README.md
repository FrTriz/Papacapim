# 🐦 Papacapim - Estrutura e Explicação Completa do Código

Este documento foi criado para ajudar na apresentação e compreensão do código do projeto Papacapim. Ele explica a função de cada arquivo e como os blocos interagem entre si para formar a rede social.

## 🏛️ Visão Geral da Arquitetura
O aplicativo foi escrito em **Flutter/Dart** e utiliza o padrão de gerenciamento de estados chamado **Provider**. Esse padrão concentra todas as regras, dados e atualizações do aplicativo em uma espécie de "cérebro central" (a classe `AppState`). As telas apenas consultam esse cérebro para desenhar o visual e avisam o cérebro quando o usuário clica em algum botão. 

Quando o cérebro atualiza um dado (ex: ao curtir um post), ele avisa as telas envolvidas que o dado mudou (usando `notifyListeners()`), e as telas recarregam sozinhas. 

O aplicativo não usa um banco de dados real. Ele utiliza dados pré-criados em memória (*mock data*) para poder ser testado imediatamente.

---

## 📄 Detalhamento dos Blocos de Código (Arquivos e Pastas)

### 1. `main.dart` - A Porta de Entrada
Todo aplicativo Flutter obrigatoriamente inicia por aqui.
- **`void main()`**: Função inicial padrão do Dart. Inicia o ambiente visual com `runApp`. Aqui, todo o aplicativo (`PapacapimApp`) é envolvido por um widget invisível chamado `ChangeNotifierProvider`. O papel dele é injetar o `AppState` (o cérebro do app) em todas as telas subsequentes para que elas possam compartilhar informações.
- **`class PapacapimApp`**: Configurações essenciais. Define cores padrões do tema (semente de cor verde), usa os ícones do Material Design 3 e orienta que a primeira tela a carregar é o `LoginScreen`.

---

### 2. `models/` - Os "Moldes" (Fichas Cadastrais)
Essa pasta dita como as informações devem se parecer.
- **`user.dart` (Classe `User`)**: Define todos os atributos necessários para um usuário existir, contendo propriedades editáveis e imutáveis (`final`). São eles: ID (único), nome, username (@), senha, link para foto de perfil, número de seguidores e número de contas que segue.
- **`post.dart` (Classe `Post`)**: Define os dados essenciais de uma publicação: um ID (único), um ID do autor (`userId`, para vincular um post ao usuário que o escreveu), conteúdo, quantidade de curtidas, data de criação e um `parentPostId` (opcional). Se `parentPostId` for preenchido, o sistema entende que aquele post é um comentário (resposta) em outra publicação.

---

### 3. `mock_data/mocks.dart` - O "Banco de Dados" Fictício
- Fornece duas listas pré-fabricadas: `mockUsers` e `mockPosts`. Elas já chegam recheadas de conteúdo para o app não abrir em branco. 
- Uma curiosidade legal aqui é o uso do serviço gratuito `ui-avatars.com` — ele gera automaticamente um link de imagem com as iniciais do nome da pessoa criada caso ela não possua uma foto real.

---

### 4. `providers/app_state.dart` - O Cérebro e Lógica de Negócios
Este é o arquivo mais complexo do projeto. Ele herda a classe `ChangeNotifier`. Sempre que uma mudança ocorre nas variáveis aqui dentro, a função `notifyListeners()` avisa as interfaces gráficas para se atualizarem.

Aqui listaremos as responsabilidades de suas principais funções:

*   **Estado Global (Variáveis guardadas no cérebro):**
    *   `users` e `posts`: Cópias temporárias dos dados de `mocks.dart`.
    *   `currentUser`: Armazena os dados do usuário logado naquele instante.
    *   `likedPostIds` (Set): Guarda os IDs dos posts curtidos.
    *   `followingUserIds` (Set): Guarda os IDs das pessoas que seguimos.

*   **Autenticação (Login, Logout e Cadastro):**
    *   `login(username, password)`: Varre a lista de usuários comparando as credenciais. Se achar, cadastra o usuário no `currentUser`.
    *   `logout()`: Limpa o `currentUser`.
    *   `register(name, username, password)`: Checa se o usuário já existe. Se não existir, gera um ID único via data (usando milissegundos), salva a nova pessoa na lista, e faz login com ela.

*   **Publicações (Posts):**
    *   `createPost(...)`: Monta o post com um novo ID temporal e o insere no índice `0` da lista. Ficar no índice zero garante que o post novo sempre vai aparecer no topo da tela inicial.
    *   `deletePost(postId)`: Elimina o post da lista permanentemente.
    *   `toggleLike(postId)`: Alterna a curtida (botão inteligente). Ele checa a lista de posts que você já curtiu: se o post estiver lá, ele remove (você descurtiu); se não, ele anexa. Ao mesmo tempo ele ajusta os números exibidos embaixo da postagem.

*   **Ações de Usuário (Perfil):**
    *   `toggleFollow(targetUserId)`: Alterna entre seguir/deixar de seguir alguém, calculando instantaneamente e somando/diminuindo na ficha tanto de quem aperta o botão como de quem recebe o clique.
    *   `updateProfile()` e `deleteProfile()`: Autoexplicativos — atualizam dados cadastrais em tempo real ou removem tudo relacionado àquela pessoa e devolvem o app para a tela de login.

    *   `generalFeedPosts`: Devolve para a tela do feed geral todos os posts (agora incluindo as respostas) para que elas apareçam normalmente na linha do tempo.
    *   `followingFeedPosts`: Devolve para a tela Seguindo os posts **apenas** das pessoas dentro do conjunto de `followingUserIds`.
    *   `getPostsByUser(userId)`: Muito usado na tela de Perfil — filtra e varre os posts garantindo que devolve apenas os feitos pela mesma pessoa.
    *   `getPostById(postId)`: Busca e devolve um post específico pelo seu ID único. Fundamental para carregar detalhes de uma thread ou descobrir a quem uma resposta se refere.

---

### 5. `screens/` - O Setor de Visualização (Telas)
As telas em si apenas montam quebra-cabeças visuais. 

*   **`login_screen.dart`**: Tela de entrada simples utilizando um `StatefulWidget` (pois exige edição de texto). Ela aciona os métodos `login()` do AppState e verifica a resposta (verdadeiro ou falso). Se errar a senha exibirá uma falha (`SnackBar`), se não, usará navegação para ir para o FeedScreen.
*   **`feed_screen.dart`**: Tela principal, que foi organizada num layout de sistema de abas utilizando o `TabController`. O conteúdo que alimenta a tela vem diretamente do `AppState.followingFeedPosts` ou `generalFeedPosts` e preenche listas do Flutter (`ListView.builder`). No rodapé carrega um botão `+` (Floating Action Button) para abrir as opções de criar conteúdo.
*   **`profile_screen.dart`**: Recebe um atributo chamado `userId` durante a navegação. Pela inteligência da tela, ao carregar ela verifica `isMe` (Sou eu?). Se for verdadeiro renderiza de imediato o botão "**Editar Perfil**". Se for de outra pessoa ele verifica se já a seguimos, renderizando "**Seguir**" ou "**Deixar de seguir**". Ele utiliza a foto circular (`CircleAvatar`) para exibir as fotos lidas tanto da nuvem (URL) quanto do disco físico local.
*   **`post_detail_screen.dart`**: Uma tela focada em exibir os detalhes de uma publicação específica. Ela recebe o ID do post, exibe o post principal no topo e, logo abaixo, lista todas as respostas diretas àquele post, permitindo a visualização de "threads" de conversas.
*   **Outras Telas**: `register_screen.dart`, `search_screen.dart`, `edit_profile_screen.dart`, e `create_post_screen.dart` operam seguindo a mesma estrutura arquitetural — recolhendo dados inseridos pelo usuário em controladores e acionando o AppState.

---

### 6. `widgets/post_card.dart` - Componentes Visuais Reutilizáveis
Esse widget (PostCard) é o grande facilitador do App. Ao invés de redesenharmos o "quadradinho de postagem" várias vezes para cada post diferente que existe, isolamos isso em um bloco e mandamos o Flutter carregar esse componente dentro de um laço de repetição. 
*   **Funcionalidades internas**: O cartão não exibe apenas texto, ele possui interações vinculadas a si mesmo.
    *   **Respostas e Threads**: Se o post for uma resposta a alguém, ele exibe um texto clicável "Em resposta a @usuario". Tocar nesse texto abre a tela de detalhes (`PostDetailScreen`) daquela conversa.
    *   Clicar na foto dispara a navegação visual para ver o perfil completo do dono do post.
    *   O botão de curtir aciona a checagem no `AppState` para modificar sua cor (se curtiu fica vermelho, do contrário fica cinza).
    *   O ícone de lixeira faz uma pergunta direta ao AppState: *"O ID do dono deste post bate com o ID do seu login?"*. Se não bater, o botão de excluir nem é impresso na tela. Se bater, o botão estará livre para uso.
    *   O botão de Comentar é responsável por redirecionar para a página de Criar Post passando o ID atual dele junto — esse ID passado entra no modelo como `parentPostId`, sendo finalmente marcado no sistema como "Este post é um comentário!".

## 📌 Conclusão para a Apresentação
Ao explicar este projeto, foque nos três pilares principais que geram valor para seu sistema em Flutter:
1.  **Separação e Modularização:** Modelos para definir como a informação é registrada, Telas puramente para visões gráficas e Providers (o cérebro) assumindo tudo sobre a inteligência, memória e cálculo, não poluindo as visualizações.
2.  **Widgets Reutilizáveis:** O `PostCard` é o exemplo perfeito de economia de código.
3.  **Gerenciamento de Estado Reativo:** Usar o `ChangeNotifierProvider` (o cérebro/AppState) onde uma variável atualizada muda automaticamente o botão de vermelho e soma os números nas interfaces das telas de dezenas de usuários, provando que o projeto não necessita de recarregar páginas por completo (refresh) para ver pequenas interações acontecendo.
