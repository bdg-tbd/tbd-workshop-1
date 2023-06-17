## Local Development Evniroment

### Inspirations
- [Code-server](https://hub.docker.com/r/linuxserver/code-server)
- [OpenVSCodeServer](https://github.com/gitpod-io/openvscode-server)
### Start development environment
```bash
docker-compose up
```
and navigate to local instance of [OpenVSCodeServer](http:/localhost:3000)

### Terminal inside of OpenVSCode
```bash
sudo chmod 777 /var/run/docker.sock 
```

### Stop
```bash
docker-compose down
```