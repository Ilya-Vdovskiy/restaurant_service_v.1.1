<template>
  <section class="page">
    <div class="page-title">
      <span>Настройки</span>
      <h1>Параметры системы</h1>
      <p>Управление ролями, пользователями и сервисными параметрами руководителя.</p>
    </div>

    <div class="settings-action-grid">
      <button v-for="item in settingsTiles" :key="item.title" class="settings-action-card" :class="{ active: item.active }">
        <component :is="item.icon" :size="30" />
        <h3>{{ item.title }}</h3>
        <p>{{ item.text }}</p>
      </button>
    </div>

    <section class="panel-list">
      <div class="panel-list-head">
        <div>
          <h2>Управление ролями</h2>
          <p>Роли определяют уровень доступа пользователей к системе.</p>
        </div>
        <button class="primary small">Создать роль</button>
      </div>

      <article v-for="role in roles" :key="role.name" class="role-row">
        <div>
          <div class="role-title-row">
            <h3>{{ role.name }}</h3>
            <span>{{ role.users }} пользователей</span>
          </div>
          <div class="permission-tags">
            <span v-for="permission in role.permissions" :key="permission">{{ permission }}</span>
          </div>
        </div>
        <button class="ghost small">Редактировать</button>
      </article>
    </section>
  </section>
</template>

<script setup>
import { Bell, Database, Globe, Shield, Users } from 'lucide-vue-next';

const settingsTiles = [
  { title: 'Роли и права', text: 'Управление ролями пользователей', icon: Shield, active: true },
  { title: 'Пользователи', text: 'Управление учётными записями', icon: Users },
  { title: 'Уведомления', text: 'Настройка уведомлений', icon: Bell },
  { title: 'Локализация', text: 'Язык и региональные настройки', icon: Globe },
  { title: 'Резервное копирование', text: 'Управление резервными копиями', icon: Database },
];

const roles = [
  { name: 'Руководитель', users: 2, permissions: ['Отчёты', 'Аналитика', 'Управление обучением'] },
  { name: 'Менеджер', users: 8, permissions: ['Курсы', 'Назначения', 'Просмотр отчётов'] },
  { name: 'Инструктор', users: 5, permissions: ['Создание курсов', 'Создание тестов'] },
  { name: 'Сотрудник', users: 232, permissions: ['Просмотр курсов', 'Прохождение тестов'] },
];
</script>
