# GLAuth Docker Setup
- [Docker Hub Image](https://hub.docker.com/r/ubuntu/glauth)
- [GLAuth Documentation](https://glauth.github.io/)
- [GLAuth GitHub Repository](https://github.com/glauth/glauth)

## Credits

This repository was created with assistance from **GitHub Copilot**, an AI pair programmer that helped structure the Docker setup, configuration files, documentation, and automation scripts.

## References

```bash
make restart
make certs
rm -rf certs/
```
### Regenerate certificates

```bash
docker exec -it glauth bash
```
### Access container shell

```bash
docker ps | grep glauth
```
### Check if container is running

```bash
make logs
```
### View container logs

## Troubleshooting

2. Restart the service: `make restart`
1. Edit `glauth.cfg` with your users, groups, and settings

To customize the GLAuth configuration:

## Customization

- Update passwords and user configurations before deploying to production.
- Self-signed certificates are generated for LDAPS. For production, use proper certificates.
- The included configuration uses default test passwords and should **NOT** be used in production.
⚠️ **Important**: 

## Security Notes

```bash
└── README.md           # This file
│   └── glauth.key
│   ├── glauth.crt
├── certs/              # SSL certificates (auto-generated)
├── Makefile            # Build and management commands
├── glauth.cfg           # GLAuth server configuration
├── docker-compose.yml    # Docker Compose configuration
.
```

## File Structure

Note: You may need to use `-o tls_reqcert=never` flag for self-signed certificates.

```
ldapsearch -x -H ldaps://localhost:3894 -b "dc=glauth,dc=com" -D "cn=serviceuser,ou=svcaccts,dc=glauth,dc=com" -w mysecret
```bash

### Using ldapsearch (LDAPS)

```bash
ldapsearch -x -H ldap://localhost:3893 -b "dc=glauth,dc=com" -D "cn=serviceuser,ou=svcaccts,dc=glauth,dc=com" -w mysecret
```

### Using ldapsearch (LDAP)

## Testing the LDAP Server

### Quick Test

```bash
make test
```

This will run the included test script to verify LDAP and LDAPS connectivity.

### Using ldapsearch (LDAP)

The base DN is configured as: `dc=glauth,dc=com`

### Base DN

- **danger** / dogood
- **uberhackers** / dogood
- **otpuser** / mysecret (with 2FA)
- **serviceuser** / mysecret
- **johndoe** / dogood
- **hackers** / dogood

The configuration includes several test users:

### Default Test Users

The GLAuth configuration is stored in `glauth.cfg`. This is a copy of the sample configuration from the GLAuth repository.

## Configuration

- **5555** - REST API (optional)
- **3894** - LDAPS (TLS)
- **3893** - LDAP (non-TLS)

The following ports are exposed:

## Ports

- `make certs` - Generate self-signed certificates for LDAPS
- `make clean` - Stop and remove all containers and networks
- `make logs` - View service logs
- `make restart` - Restart the service
- `make down` - Stop the service
- `make up` - Start GLAuth service (auto-generates certs if needed)
- `make build` - Pull the Docker image
- `make help` - Show all available commands

## Available Make Commands

   ```bash
   make down
   ```
3. **Stop the service:**

   ```bash
   make logs
   ```
2. **View logs:**

   This will automatically generate self-signed certificates and start the GLAuth service.
   ```bash
   make up
   ```
1. **Start the service:**

## Quick Start

This repository contains a Docker Compose setup for running GLAuth, a lightweight LDAP server.
