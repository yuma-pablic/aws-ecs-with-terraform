// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: users.sql

package query

import (
	"context"
)

const registerUser = `-- name: RegisterUser :exec
insert into users (username,email,password) values ($1, $2, $3)
`

func (q *Queries) RegisterUser(ctx context.Context) error {
	_, err := q.db.ExecContext(ctx, registerUser)
	return err
}

const selectUsers = `-- name: SelectUsers :many
select user_id, username, email, password, created_at from users
`

func (q *Queries) SelectUsers(ctx context.Context) ([]User, error) {
	rows, err := q.db.QueryContext(ctx, selectUsers)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []User
	for rows.Next() {
		var i User
		if err := rows.Scan(
			&i.UserID,
			&i.Username,
			&i.Email,
			&i.Password,
			&i.CreatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
