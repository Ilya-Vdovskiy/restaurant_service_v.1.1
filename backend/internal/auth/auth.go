package auth

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
)

type contextKey string

const userContextKey contextKey = "auth_user"

type Claims struct {
	Sub          string `json:"sub"`
	RestaurantID string `json:"restaurant_id"`
	Role         string `json:"role"`
	Exp          int64  `json:"exp"`
}

func WithUser(ctx context.Context, user models.User) context.Context {
	return context.WithValue(ctx, userContextKey, user)
}

func UserFromContext(ctx context.Context) (models.User, bool) {
	user, ok := ctx.Value(userContextKey).(models.User)
	return user, ok
}

func CreateToken(user models.User, secret string, ttl time.Duration) (string, error) {
	header := map[string]string{"alg": "HS256", "typ": "JWT"}
	claims := Claims{
		Sub:          user.ID,
		RestaurantID: user.RestaurantID,
		Role:         user.Role,
		Exp:          time.Now().Add(ttl).Unix(),
	}

	headerJSON, err := json.Marshal(header)
	if err != nil {
		return "", err
	}
	claimsJSON, err := json.Marshal(claims)
	if err != nil {
		return "", err
	}

	encodedHeader := base64.RawURLEncoding.EncodeToString(headerJSON)
	encodedClaims := base64.RawURLEncoding.EncodeToString(claimsJSON)
	signingInput := encodedHeader + "." + encodedClaims
	signature := sign(signingInput, secret)

	return signingInput + "." + signature, nil
}

func ParseToken(token, secret string) (Claims, error) {
	parts := strings.Split(token, ".")
	if len(parts) != 3 {
		return Claims{}, errors.New("invalid token format")
	}

	signingInput := parts[0] + "." + parts[1]
	expectedSignature := sign(signingInput, secret)
	if !hmac.Equal([]byte(expectedSignature), []byte(parts[2])) {
		return Claims{}, errors.New("invalid token signature")
	}

	payload, err := base64.RawURLEncoding.DecodeString(parts[1])
	if err != nil {
		return Claims{}, fmt.Errorf("decode token payload: %w", err)
	}

	var claims Claims
	if err := json.Unmarshal(payload, &claims); err != nil {
		return Claims{}, fmt.Errorf("parse token payload: %w", err)
	}
	if claims.Exp <= time.Now().Unix() {
		return Claims{}, errors.New("token expired at " + strconv.FormatInt(claims.Exp, 10))
	}

	return claims, nil
}

func BearerToken(r *http.Request) string {
	header := r.Header.Get("Authorization")
	if !strings.HasPrefix(header, "Bearer ") {
		return ""
	}
	return strings.TrimSpace(strings.TrimPrefix(header, "Bearer "))
}

func sign(input, secret string) string {
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(input))
	return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}
