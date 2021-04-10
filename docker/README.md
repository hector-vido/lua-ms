# Docker

Aqui estão os arquivos relacionados a imagem do Docker e ao `compose file`.

Preste atenção pois o arquivo `nginx.conf` está configurado para resolver nomes no DNS interno do Docker em `127.0.0.11` e no DNS interno do Kubernetes em `10.96.0.10`, sem a configuração de `resolver` o Openresty não encontrará o banco pelo nome do serviço.
