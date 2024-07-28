package user

import (
	userDomain "api/domain/user"
	"context"
)

type FindUserUseCase struct {
	ur userDomain.UserRepository
}

type FindUserUseCaseOutputDTO struct {
	UserName string
	Email    string
	Password string
}

func NewFindUserUseCase(ur userDomain.UserRepository) *FindUserUseCase {
	return &FindUserUseCase{ur}
}

func (uc *FindUserUseCase) Run(ctx context.Context, id string) (*FindUserUseCaseOutputDTO, error) {
	user, err := uc.ur.FindById(id)
	if err != nil {
		return nil, err
	}
	return &FindUserUseCaseOutputDTO{
		UserName: user.UserName,
		Email:    user.Email,
		Password: user.Password,
	}, nil
}
