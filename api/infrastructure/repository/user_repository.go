package repository

import (
	userDomain "api/domain/user"
	query "api/infrastructure/sqlc"
	"context"
	"database/sql"
	"fmt"
)

type userRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) userDomain.UserRepository {
	return &userRepository{db}
}

func (ur *userRepository) FindById(id string) (*userDomain.User, error) {
	queries := query.New(ur.db)
	ctx := context.Background()

	user, err := queries.SelectUsers(ctx)
	if err != nil {
		return nil, err
	}
	fmt.Println(user)
	return &userDomain.User{
		UserName: user[0].Username,
		Email:    user[0].Email,
		Password: user[0].Password,
	}, nil
}

func (ur *userRepository) Register(user *userDomain.User) error {
	queries := query.New(ur.db)
	ctx := context.Background()
	param := query.RegisterUserParams{
		Username: user.UserName,
		Email:    user.Email,
		Password: user.Password,
	}

	err := queries.RegisterUser(ctx, param)
	if err != nil {
		return err
	}
	return nil
}
