# Godwoken Explorer

> This project is still under development

Godwoken Explorer is designed for [godwoken](https://github.com/nervosnetwork/godwoken)(A CKB layer2 roll up solution).Current only support [polyjuice](https://github.com/nervosnetwork/godwoken-polyjuice).

Our dev chatroom [discord](https://discord.com/channels/956765352514183188/958261584004804650).

For technology infrastructure, this project is inspired by [blockscout](https://github.com/blockscout/blockscout).An open-source EVM blockchain explorer.
## Get Started
### Requirements

- Erlang/OTP 24
- Elixir 1.13.x
- Postgresql 10.3+,11,12
- Rust

### Run local development
1. export your enviroment: [reference](./docker_compose/envs/.env)
2. `$ mix ecto.setup`
3. `$ mix phx.server`
4. Visit `http://localhost:4001`

### Deploy
[Local Deploy to Ubuntu](./docs/deploy_to_ubuntu.md)

### Docker Compose
1. [Install Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. [Docker README](docs/docker-compose.md)

### Branch for godwoken version
main: godwoken v0

compatibility-breaking-changes: godwoken v1
### Contribute
Fork it and submit your PR!
