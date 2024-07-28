//go:build wireinject
// +build wireinject

// wire.go
package di

import (
	"ddd/infra/rdb"
	"ddd/infra/repository"
	userPresenter "ddd/presentation/user"
	userUseCase "ddd/usecase/user"

	"github.com/google/wire"
)

func InitUser() userPresenter.Handler {
	wire.Build(repository.NewUserRepository, userUseCase.NewFindUserUseCase, userPresenter.NewHandler, rdb.NewDB)
	return userPresenter.Handler{}
}
