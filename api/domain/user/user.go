package user

type User struct {
	UserName string
	Email    string
	Password string
}
type UserDomainService struct {
	ur UserRepository
}
