<template>
  <section class="page">
    <div class="section-head">
      <div>
        <h1>Отчёты</h1>
        <p>Генерация, экспорт и история отчётов руководителя.</p>
      </div>
    </div>

    <div class="report-builder-grid">
      <article v-for="template in reportTemplates" :key="template.title" class="report-builder-card">
        <div class="report-icon"><component :is="template.icon" :size="24" /></div>
        <h3>{{ template.title }}</h3>
        <p>{{ template.text }}</p>
        <div class="form-grid">
          <select v-if="template.kind !== 'period'">
            <option>{{ template.placeholder }}</option>
            <option v-for="option in template.options" :key="option">{{ option }}</option>
          </select>
          <div v-else class="split">
            <input type="date" value="2026-04-01" />
            <input type="date" value="2026-04-28" />
          </div>
          <div class="card-actions">
            <button class="primary small"><FileText :size="16" />PDF</button>
            <button class="ghost small"><FileSpreadsheet :size="16" />Excel</button>
          </div>
        </div>
      </article>
    </div>

    <section class="panel-list">
      <div class="panel-list-head">
        <h2>Последние отчёты</h2>
      </div>
      <article v-for="report in recentReports" :key="report.id" class="report-row">
        <div class="report-file-icon">
          <component :is="report.format === 'PDF' ? FileText : FileSpreadsheet" :size="22" />
        </div>
        <div>
          <h3>{{ report.title }}</h3>
          <p>{{ report.date }} · {{ report.format }} · {{ report.type }}</p>
        </div>
        <button class="ghost small"><Download :size="16" />Скачать</button>
      </article>
    </section>

    <section class="chart-card">
      <div class="section-head compact">
        <div>
          <h2>Автоматические отчёты</h2>
          <p>Настройка регулярной отправки сводок на email руководителя.</p>
        </div>
      </div>
      <div class="report-settings-grid">
        <label>
          <span>Периодичность</span>
          <select>
            <option>Еженедельно</option>
            <option>Ежедневно</option>
            <option>Ежемесячно</option>
          </select>
        </label>
        <label>
          <span>Тип отчёта</span>
          <select>
            <option>Общая статистика</option>
            <option>По подразделениям</option>
            <option>По курсам</option>
          </select>
        </label>
        <label>
          <span>Email для отправки</span>
          <input type="email" value="manager@restaurant.local" />
        </label>
        <label>
          <span>Формат</span>
          <div class="radio-row">
            <label><input type="radio" name="format" checked />PDF</label>
            <label><input type="radio" name="format" />Excel</label>
          </div>
        </label>
      </div>
      <button class="primary">Сохранить настройки</button>
    </section>
  </section>
</template>

<script setup>
import { Calendar, Download, FileSpreadsheet, FileText, UserRound, UsersRound } from 'lucide-vue-next';

const reportTemplates = [
  {
    title: 'Отчёт по сотруднику',
    text: 'Детальная информация о прогрессе, курсах и результатах сотрудника.',
    icon: UserRound,
    placeholder: 'Выберите сотрудника...',
    options: ['Анна Соколова', 'Михаил Орлов', 'Екатерина Белова', 'Даниил Морозов'],
  },
  {
    title: 'Отчёт по подразделению',
    text: 'Сводная статистика по отделу, смене или группе сотрудников.',
    icon: UsersRound,
    placeholder: 'Выберите подразделение...',
    options: ['Зал', 'Кухня', 'Бар', 'Управление'],
  },
  {
    title: 'Периодический отчёт',
    text: 'Отчёт за выбранный период времени с ключевыми показателями.',
    icon: Calendar,
    kind: 'period',
  },
];

const recentReports = [
  { id: 1, title: 'Отчёт по обучению за апрель 2026', date: '28.04.2026', format: 'PDF', type: 'Ежемесячный' },
  { id: 2, title: 'Результаты тестирования Анны Соколовой', date: '25.04.2026', format: 'Excel', type: 'По сотруднику' },
  { id: 3, title: 'Отчёт по подразделению «Зал»', date: '22.04.2026', format: 'PDF', type: 'По подразделению' },
  { id: 4, title: 'Статистика по курсу «Барная карта»', date: '20.04.2026', format: 'Excel', type: 'По курсу' },
];
</script>
