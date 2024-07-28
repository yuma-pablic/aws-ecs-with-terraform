//go:build wireinject
// +build wireinject

// wire.go
package di

import (
	userPresenter "api/presentation/user"
	userUseCase "api/usecase/user"
	"dd/infra/rdb"
	"ddd/infra/repository"

	"github.com/google/wire"
)

func InitUser() userPresenter.Handler {
	wire.Build(repository.NewUserRepository, userUseCase.NewFindUserUseCase, userPresenter.NewHandler, rdb.NewDB)
	return userPresenter.Handler{}
}
