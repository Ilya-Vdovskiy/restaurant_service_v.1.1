<template>
  <section class="page">
    <div class="page-title"><span>Настройки</span><h1>Параметры системы</h1><p>Роли, доступы, безопасность и профиль администратора.</p></div>
    <div class="settings-grid">
      <ChartCard title="Управление ролями">
        <label v-for="role in roles" :key="role" class="setting-line"><span>{{ role }}</span><input type="checkbox" checked /></label>
      </ChartCard>
      <ChartCard title="Права доступа">
        <label class="setting-line"><span>Создание курсов</span><input type="checkbox" checked /></label>
        <label class="setting-line"><span>Просмотр аналитики</span><input type="checkbox" checked /></label>
        <label class="setting-line"><span>Экспорт отчётов</span><input type="checkbox" /></label>
      </ChartCard>
      <ChartCard title="Настройки безопасности">
        <label class="setting-line"><span>Двухфакторная авторизация</span><input type="checkbox" /></label>
        <label class="setting-line"><span>Сессия 30 минут</span><input type="checkbox" checked /></label>
      </ChartCard>
      <ChartCard title="Профиль администратора">
        <div class="profile-hero compact"><div class="avatar xl">АК</div><h3>Администратор курсов</h3><p>admin@restaurant.local</p></div>
      </ChartCard>
    </div>
  </section>
</template>

<script setup>
import ChartCard from '../components/ChartCard.vue';
const roles = ['Администратор', 'Руководитель', 'Менеджер', 'Сотрудник'];
</script>
