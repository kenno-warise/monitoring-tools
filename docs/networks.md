# コンテナのネットワーク設計

~~ネットワークドライバーはmacvlanに設定。デフォルトのbridgeは本番環境では非推奨という事で。~~

本番環境でコンテナオーケストレーションを使わない場合、**ユーザー定義の bridge ネットワーク**の利用が推奨されています。ユーザー定義の bridge ネットワークは、デフォルトの bridge ネットワークよりも分離性や柔軟性、DNS解決機能が優れており、複数のコンテナを安全かつ効率的に管理できます。  
デフォルトの bridge ネットワークは技術的な制約が多く、本番環境には推奨されていません。ユーザー定義ネットワークを使うことで、コンテナ間通信の制御やネットワーク設定のカスタマイズが容易になります  
[Differences between user-defined bridges and the default bridge](https://docs.docker.com/engine/network/drivers/bridge/#differences-between-user-defined-bridges-and-the-default-bridge)  
[Bridge network driver](https://docs.docker.com/engine/network/drivers/bridge/)

特殊な要件（物理ネットワークへの直接接続や、ネットワーク分離の強化など）がある場合は、macvlan や none ドライバーも検討できますが、一般的にはユーザー定義の bridge ネットワークが最適です。

- docker-compose.ymlのネットワーク構成（仮）

```yml
version: '3.8'
services:
  nginx:
    image: nginx:latest
    container_name: nginx_proxy
    ports:
      - "80:80"
    networks:
      my-macvlan-net:
        ipv4_address: 192.168.1.10
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    networks:
      my-macvlan-net:
        iiipv4_address: 192.168.1.11
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter
    network_mode: "host"  # ← ホストのネットワークを直接利用（macvlan不要）
    restart: always

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    nejtworks:
      my-macvlan-net:
        ipv4_address: 192.168.1.12
    voljumes:
      - grafana-data:/var/lib/grafana

networks:
  my-macvlan-net:
    driver: macvlan
    driver_opts:
      parent: eth0
    ipam:
      config:
        j- subnet: 192.168.1.0/24
          gateway: 192.168.1.1
j
volumes:
 j grafana-data:
```

上記のIPアドレスはip aコマンドで確認できるとの事だが今一まだ設定のやり方が分かってない。
