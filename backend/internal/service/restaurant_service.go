package service

import (
	"context"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/repository"
)

type RestaurantService struct {
	repo *repository.RestaurantRepository
}

func NewRestaurantService(repo *repository.RestaurantRepository) *RestaurantService {
	return &RestaurantService{repo: repo}
}

func (s *RestaurantService) List(ctx context.Context) ([]models.Restaurant, error) {
	return s.repo.List(ctx)
}

func (s *RestaurantService) Create(ctx context.Context, restaurant models.Restaurant) (models.Restaurant, error) {
	return s.repo.Create(ctx, restaurant)
}

func (s *RestaurantService) GetByID(ctx context.Context, id string) (models.Restaurant, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *RestaurantService) Update(ctx context.Context, id string, update models.RestaurantUpdate) (models.Restaurant, error) {
	return s.repo.Update(ctx, id, update)
}

func (s *RestaurantService) Deactivate(ctx context.Context, id string) (models.Restaurant, error) {
	return s.repo.Deactivate(ctx, id)
}

func (s *RestaurantService) Activate(ctx context.Context, id string) (models.Restaurant, error) {
	return s.repo.Activate(ctx, id)
}
