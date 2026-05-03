import { createRouter, createWebHistory } from 'vue-router';
import DashboardView from '../views/DashboardView.vue';
import EmployeesView from '../views/EmployeesView.vue';
import TrainingView from '../views/TrainingView.vue';
import TestsView from '../views/TestsView.vue';
import AssignmentsView from '../views/AssignmentsView.vue';
import AnalyticsView from '../views/AnalyticsView.vue';
import ReportsView from '../views/ReportsView.vue';
import SettingsView from '../views/SettingsView.vue';

const routes = [
  { path: '/', name: 'dashboard', component: DashboardView, meta: { title: 'Панель управления' } },
  { path: '/employees', name: 'employees', component: EmployeesView, meta: { title: 'Сотрудники' } },
  { path: '/training', name: 'training', component: TrainingView, meta: { title: 'Обучение' } },
  { path: '/tests', name: 'tests', component: TestsView, meta: { title: 'Тесты' } },
  { path: '/assignments', name: 'assignments', component: AssignmentsView, meta: { title: 'Назначения' } },
  { path: '/analytics', name: 'analytics', component: AnalyticsView, meta: { title: 'Аналитика' } },
  { path: '/reports', name: 'reports', component: ReportsView, meta: { title: 'Отчёты' } },
  { path: '/settings', name: 'settings', component: SettingsView, meta: { title: 'Настройки' } },
];

export default createRouter({
  history: createWebHistory(),
  routes,
});
