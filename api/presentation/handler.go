package user

import (
	"context"
	"ddd/usecase/user"
	"net/http"
)

type Handler struct {
	FindUserUseCase *user.FindUserUseCase
}

func NewHandler(fu *user.FindUserUseCase) Handler {
	return Handler{
		FindUserUseCase: fu,
	}
}

func (h Handler) GetByUserID(ctx context.Context, r *http.Request) (*userResponseModel, error) {
	id := r.URL.Query().Get("id")
	dtos, err := h.FindUserUseCase.Run(ctx, id)
	if err != nil {
		return nil, err
	}
	return &userResponseModel{
		UserName: dtos.UserName,
		Email:    dtos.Email,
		Password: dtos.Password,
	}, nil

}
