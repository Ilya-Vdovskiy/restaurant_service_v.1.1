const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';

export class ApiError extends Error {
  constructor(message, status) {
    super(message);
    this.status = status;
  }
}

export const api = {
  token: localStorage.getItem('auth_token') || '',

  setToken(token) {
    this.token = token || '';
    if (this.token) localStorage.setItem('auth_token', this.token);
    else localStorage.removeItem('auth_token');
  },

  async request(path, options = {}) {
    const headers = {
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    };
    if (this.token) headers.Authorization = `Bearer ${this.token}`;

    const response = await fetch(`${API_BASE_URL}${path}`, {
      ...options,
      headers,
    });

    const data = await response.json().catch(() => null);
    if (!response.ok) {
      throw new ApiError(data?.error || 'Ошибка API', response.status);
    }
    return data;
  },

  login(login, password) {
    return this.request('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ login, password }),
    });
  },

  me() {
    return this.request('/me');
  },

  list(path) {
    return this.request(path);
  },

  save(path, payload, method = 'POST') {
    return this.request(path, {
      method,
      body: JSON.stringify(payload),
    });
  },
};

