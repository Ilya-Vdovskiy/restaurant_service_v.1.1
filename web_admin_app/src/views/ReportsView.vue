<template>
  <section class="page">
    <div class="section-head">
      <div><h1>Отчёты</h1><p>Готовые шаблоны выгрузок по обучению и тестированию.</p></div>
      <button class="primary"><FileCog :size="19" />Сформировать отчёт</button>
    </div>
    <div class="report-grid">
      <article v-for="report in reports" :key="report.title" class="report-card">
        <component :is="report.icon" :size="28" />
        <h3>{{ report.title }}</h3>
        <p>{{ report.text }}</p>
        <div class="card-actions"><button class="primary small">Скачать PDF</button><button class="ghost small">Скачать Excel</button></div>
      </article>
    </div>
  </section>
</template>

<script setup>
import { Building2, ClipboardCheck, FileCog, GraduationCap, UserRound } from 'lucide-vue-next';
const reports = [
  { title: 'Отчёт по сотруднику', text: 'Прогресс, курсы, тесты и история активности.', icon: UserRound },
  { title: 'Отчёт по подразделению', text: 'Сводка по кухне, залу, бару или управлению.', icon: Building2 },
  { title: 'Отчёт по курсу', text: 'Проходимость модулей и средние результаты.', icon: GraduationCap },
  { title: 'Отчёт по тестам', text: 'Попытки, проходной балл и проблемные вопросы.', icon: ClipboardCheck },
];
</script>
