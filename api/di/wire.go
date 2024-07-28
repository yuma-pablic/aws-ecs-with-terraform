//go:build wireinject
// +build wireinject

// wire.go
package di

import (
	"api/infrastructure/rdb"
	"api/infrastructure/repository"
	userPresenter "api/presentation/user"
	userUseCase "api/usecase/user"

	"github.com/google/wire"
)

func InitUser() userPresenter.Handler {
	wire.Build(repository.NewUserRepository, userUseCase.NewFindUserUseCase, userPresenter.NewHandler, rdb.NewDB)
	return userPresenter.Handler{}
}
