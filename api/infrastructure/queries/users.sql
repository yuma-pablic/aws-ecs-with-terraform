-- name: SelectUsers :many
select * from users;

-- name: RegisterUser :exec
insert into users (username,email,password) values ($1, $2, $3);