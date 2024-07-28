//go:generate mockgen -source=user_repository.go -destination=mocks/mock_user_repository.go -package=mocks
package user

type UserRepository interface {
	FindById(id string) (*User, error)
	Register(user *User) error
}
