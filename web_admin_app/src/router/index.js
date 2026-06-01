import { createRouter, createWebHistory } from 'vue-router';
import DashboardView from '../views/DashboardView.vue';
import EmployeesView from '../views/EmployeesView.vue';
import TrainingView from '../views/TrainingView.vue';
import TestsView from '../views/TestsView.vue';
import AssignmentsView from '../views/AssignmentsView.vue';
import AnalyticsView from '../views/AnalyticsView.vue';
import ReportsView from '../views/ReportsView.vue';
import SettingsView from '../views/SettingsView.vue';
import LoginView from '../views/LoginView.vue';

const routes = [
  { path: '/login', name: 'login', component: LoginView, meta: { public: true, title: 'Вход' } },
  { path: '/', name: 'dashboard', component: DashboardView, meta: { title: 'Панель управления' } },
  { path: '/employees', name: 'employees', component: EmployeesView, meta: { title: 'Сотрудники' } },
  { path: '/training', name: 'training', component: TrainingView, meta: { title: 'Обучение' } },
  { path: '/tests', name: 'tests', component: TestsView, meta: { title: 'Тесты' } },
  { path: '/assignments', name: 'assignments', component: AssignmentsView, meta: { title: 'Назначения' } },
  { path: '/analytics', name: 'analytics', component: AnalyticsView, meta: { title: 'Аналитика' } },
  { path: '/reports', name: 'reports', component: ReportsView, meta: { title: 'Отчёты' } },
  { path: '/settings', name: 'settings', component: SettingsView, meta: { title: 'Настройки' } },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to) => {
  const token = localStorage.getItem('auth_token');
  if (!to.meta.public && !token) return '/login';
  if (to.name === 'login' && token) return '/';
  return true;
});

export default router;
