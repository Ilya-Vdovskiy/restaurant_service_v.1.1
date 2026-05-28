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

func (s *SubdivisionService) List(ctx context.Context) ([]models.Subdivision, error) {
	return s.repo.List(ctx)
}

func (s *SubdivisionService) Create(ctx context.Context, subdivision models.Subdivision) (models.Subdivision, error) {
	return s.repo.Create(ctx, subdivision)
}
