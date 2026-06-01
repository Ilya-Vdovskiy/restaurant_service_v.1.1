import { defineStore } from 'pinia';
import { api } from '../api/client';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('auth_token') || '',
    user: JSON.parse(localStorage.getItem('auth_user') || 'null'),
    loading: false,
    error: '',
  }),
  getters: {
    isAuthenticated: (state) => Boolean(state.token),
  },
  actions: {
    async login(login, password) {
      this.loading = true;
      this.error = '';
      try {
        const data = await api.login(login, password);
        this.token = data.token;
        this.user = data.user;
        api.setToken(data.token);
        localStorage.setItem('auth_user', JSON.stringify(data.user));
      } catch (error) {
        this.error = error.message || 'Не удалось войти';
        throw error;
      } finally {
        this.loading = false;
      }
    },
    logout() {
      this.token = '';
      this.user = null;
      api.setToken('');
      localStorage.removeItem('auth_user');
    },
  },
});

