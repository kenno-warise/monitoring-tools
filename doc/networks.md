# コンテナのネットワーク設計

ネットワークドライバーはmacvlanに設定。デフォルトのbridgeは本番環境では非推奨という事で。

- docker-compose.ymlのネットワーク構成

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
