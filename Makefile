init_postgres:
	docker run --name postgres12 -p 5454:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

start_postgres:
	docker start postgres12

stop_postgres:
	docker stop postgres12

create_db:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

drop_db:
	docker exec -it postgres12 dropdb simple_bank

add_migration:
	migrate create -ext sql -dir db/migration -seq $(migration_name)

migrate_up:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5454/simple_bank?sslmode=disable" -verbose up

migrate_down:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5454/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mockdb:
	sudo mockgen --package mockdb -destination db/mock/store.go github.com/enginbulut/golang-example-1/db/sqlc Store

print_go_path:
	/bin/bash -c "echo \$GOPATH"

.PHONY: init_postgres start_postgres stop_postgres create_db drop_db migrate_up migrate_down sqlc test server mockdb print_go_path