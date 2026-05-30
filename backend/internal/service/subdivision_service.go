package service

import (
	"context"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/repository"
)

type SubdivisionService struct {
	repo *repository.SubdivisionRepository
}

func NewSubdivisionService(repo *repository.SubdivisionRepository) *SubdivisionService {
	return &SubdivisionService{repo: repo}
}

func (s *SubdivisionService) ListByRestaurantID(ctx context.Context, restaurantID string) ([]models.Subdivision, error) {
	return s.repo.ListByRestaurantID(ctx, restaurantID)
}

func (s *SubdivisionService) Create(ctx context.Context, subdivision models.Subdivision) (models.Subdivision, error) {
	return s.repo.Create(ctx, subdivision)
}
