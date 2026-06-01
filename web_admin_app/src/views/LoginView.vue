<template>
  <main class="login-page">
    <form class="login-card" @submit.prevent="submit">
      <div class="brand-mark">RS</div>
      <div>
        <span>Restaurant Service</span>
        <h1>Вход руководителя</h1>
        <p>Используйте демо-доступ или учетную запись ресторана.</p>
      </div>
      <label class="field-label">
        <span>Email</span>
        <input v-model="login" type="email" autocomplete="username" />
      </label>
      <label class="field-label">
        <span>Пароль</span>
        <input v-model="password" type="password" autocomplete="current-password" />
      </label>
      <p v-if="auth.error" class="form-error">{{ auth.error }}</p>
      <button class="primary" :disabled="auth.loading">{{ auth.loading ? 'Входим...' : 'Войти' }}</button>
      <small>Демо: manager@restaurant.local / manager123</small>
    </form>
  </main>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';

const router = useRouter();
const auth = useAuthStore();
const login = ref('manager@restaurant.local');
const password = ref('manager123');

const submit = async () => {
  await auth.login(login.value, password.value);
  router.push('/');
};
</script>
