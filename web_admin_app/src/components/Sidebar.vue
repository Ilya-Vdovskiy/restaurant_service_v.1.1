<template>
  <aside class="sidebar">
    <RouterLink to="/" class="brand">
      <span class="brand-mark">RS</span>
      <span>
        <strong>Restaurant Service</strong>
        <small>Обучение и аттестация</small>
      </span>
    </RouterLink>

    <nav class="nav-list">
      <RouterLink v-for="item in items" :key="item.to" :to="item.to" class="nav-link">
        <component :is="item.icon" :size="19" />
        <span>{{ item.label }}</span>
      </RouterLink>
    </nav>

    <div class="sidebar-profile">
      <div class="avatar">АК</div>
      <div>
        <strong>Администратор</strong>
        <small>admin@restaurant.local</small>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { RouterLink } from 'vue-router';
import { BarChart3, BookOpen, ClipboardList, FileBarChart, FileText, LayoutDashboard, Settings, Users } from 'lucide-vue-next';

const items = [
  { to: '/', label: 'Панель управления', icon: LayoutDashboard },
  { to: '/employees', label: 'Сотрудники', icon: Users },
  { to: '/training', label: 'Обучение', icon: BookOpen },
  { to: '/tests', label: 'Тесты', icon: FileText },
  { to: '/assignments', label: 'Назначения', icon: ClipboardList },
  { to: '/analytics', label: 'Аналитика', icon: BarChart3 },
  { to: '/reports', label: 'Отчёты', icon: FileBarChart },
  { to: '/settings', label: 'Настройки', icon: Settings },
];
</script>
