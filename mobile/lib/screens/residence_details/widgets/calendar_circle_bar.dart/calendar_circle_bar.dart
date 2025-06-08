import "dart:math" as math;

import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

/// Виджет круговой диаграммы с месяцами года, который отображает период пребывания.
class CalendarCircleBar extends StatefulWidget {
  const CalendarCircleBar({
    required this.stayPeriods,
    required this.progress,
    required this.statusUpdateDate,
    super.key,
    this.size = 300,
    this.backgroundColor = Colors.blue,
    this.activeColor = Colors.greenAccent,
    this.todayIndicatorColor = Colors.blue,
    this.updateIndicatorColor = Colors.amber,
    this.dividerColor = Colors.black,
    this.centerTextStyle,
    this.monthTextStyle,
    this.centerSubtitleStyle,
    this.onMonthTap,
  });

  /// Список периодов пребывания, которые будут отображаться
  final List<StayPeriodValueObject> stayPeriods;

  /// Прогресс (текущее значение / максимальное), отображается в центре
  final String progress;

  /// Дата обновления статуса (для оранжевого индикатора)
  final DateTime statusUpdateDate;

  /// Размер виджета (ширина и высота)
  final double size;

  /// Цвет фона для неактивных сегментов
  final Color backgroundColor;

  /// Цвет активных сегментов (где пользователь присутствует)
  final Color activeColor;

  /// Цвет делений между месяцами
  final Color dividerColor;

  /// Цвет индикатора сегодняшнего дня (синяя стрелка)
  final Color todayIndicatorColor;

  /// Цвет индикатора даты обновления (оранжевая стрелка)
  final Color updateIndicatorColor;

  /// Стиль для основного текста в центре
  final TextStyle? centerTextStyle;

  /// Стиль для названий месяцев на круге
  final TextStyle? monthTextStyle;

  /// Стиль для подписи progress под основным текстом в центре
  final TextStyle? centerSubtitleStyle;

  /// Коллбэк при клике на месяц
  final void Function(int monthIndex)? onMonthTap;

  @override
  State<CalendarCircleBar> createState() => _CalendarCircleBarState();
}

class _CalendarCircleBarState extends State<CalendarCircleBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int? _selectedMonthIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    final box = context.findRenderObject()! as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final centerX = box.size.width / 2;
    final centerY = box.size.height / 2;

    // Расчет расстояния от центра до точки касания
    final dx = localPosition.dx - centerX;
    final dy = localPosition.dy - centerY;
    final distance = math.sqrt(dx * dx + dy * dy);

    // Размеры круговой диаграммы
    final radius = widget.size / 2 - 10;
    final innerRadius = radius * 0.65;

    // Проверяем, находится ли точка касания в области круговой диаграммы
    if (distance >= innerRadius && distance <= radius) {
      // Вычисляем угол
      var angle = math.atan2(dy, dx);
      if (angle < 0) angle += 2 * math.pi;

      // Преобразуем угол в индекс месяца (0-11)
      final monthIndex = (((angle + math.pi / 2) % (2 * math.pi)) / (2 * math.pi) * 12).floor();

      // Вызываем коллбэк
      widget.onMonthTap?.call(monthIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return GestureDetector(
      onTapDown: _handleTapDown,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: _CalendarCirclePainter(
                stayPeriods: widget.stayPeriods,
                progress: widget.progress,
                statusUpdateDate: widget.statusUpdateDate,
                backgroundColor: widget.backgroundColor,
                activeColor: widget.activeColor,
                todayIndicatorColor: widget.todayIndicatorColor,
                updateIndicatorColor: widget.updateIndicatorColor,
                dividerColor: widget.dividerColor,
                centerTextStyle: widget.centerTextStyle ?? theme.body18,
                monthTextStyle: widget.monthTextStyle ?? theme.body14,
                centerSubtitleStyle: widget.centerSubtitleStyle ?? theme.body14,
                months: getMonths(context),
                animationValue: _animationController.value,
                selectedMonthIndex: _selectedMonthIndex,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CalendarCirclePainter extends CustomPainter {
  _CalendarCirclePainter({
    required this.stayPeriods,
    required this.progress,
    required this.statusUpdateDate,
    required this.backgroundColor,
    required this.activeColor,
    required this.todayIndicatorColor,
    required this.updateIndicatorColor,
    required this.dividerColor,
    required this.centerTextStyle,
    required this.monthTextStyle,
    required this.centerSubtitleStyle,
    required this.months,
    required this.animationValue,
    this.selectedMonthIndex,
  });

  final List<StayPeriodValueObject> stayPeriods;
  final String progress;
  final DateTime statusUpdateDate;
  final Color backgroundColor;
  final Color activeColor;
  final Color todayIndicatorColor;
  final Color updateIndicatorColor;
  final Color dividerColor;
  final TextStyle centerTextStyle;
  final TextStyle monthTextStyle;
  final TextStyle centerSubtitleStyle;
  final List<String> months;
  final double animationValue;
  final int? selectedMonthIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final innerRadius = radius * 0.7;

    // Определяем активные месяцы для последующего использования
    final activeMonths = _getActiveMonths();

    // Рисуем круговую основу
    _drawCircleBase(canvas, center, radius, innerRadius);

    // Рисуем активные сегменты периода пребывания с выделением и анимацией
    _drawStayPeriodSegments(canvas, center, radius, innerRadius, activeMonths);

    // Рисуем деления между месяцами
    _drawMonthDividers(canvas, dividerColor, center, radius, innerRadius, activeMonths);

    // Рисуем названия месяцев
    _drawMonthLabels(canvas, center, radius, innerRadius, activeMonths);

    // Рисуем индикаторы: сегодняшний день и дата обновления статуса
    _drawTodayIndicator(canvas, center, radius, innerRadius);
    _drawUpdateIndicator(canvas, center, radius, innerRadius);

    // Рисуем центральный текст
    _drawCenterText(canvas, center, innerRadius);
  }

  // Получить список активных месяцев
  List<bool> _getActiveMonths() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month; // Текущий месяц (1-12)
    final activeMonths = List<bool>.filled(12, false);

    // Создаем список месяцев с их началом и окончанием
    final monthStarts = <DateTime>[];
    for (var i = 0; i < 12; i++) {
      final year = i > currentMonth ? currentYear - 1 : currentYear;
      monthStarts.add(DateTime(year, i + 1, 1));
    }

    // Сначала отметим, какие месяцы уже прошли или текущий
    for (var monthIndex = 0; monthIndex < 12; monthIndex++) {
      // Теперь проверяем, есть ли в этом месяце период пребывания
      final monthStart = monthStarts[monthIndex];
      final monthEnd = monthIndex > currentMonth
          ? DateTime(currentYear - 1, monthIndex + 1, 1)
          : DateTime(currentYear, monthIndex + 1, 1);

      for (final period in stayPeriods) {
        // Проверяем, пересекается ли месяц с периодом пребывания
        if (period.startDate.isBefore(monthEnd) && period.endDate.isAfter(monthStart)) {
          activeMonths[monthIndex] = true;
          break;
        }
      }
    }

    return activeMonths;
  }

  // Нарисовать базовую круговую диаграмму
  void _drawCircleBase(Canvas canvas, Offset center, double radius, double innerRadius) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius;

    canvas.drawCircle(center, (radius + innerRadius) / 2, paint);
  }

  // Нарисовать деления между месяцами
  void _drawMonthDividers(
    Canvas canvas,
    Color dividerColor,
    Offset center,
    double radius,
    double innerRadius,
    List<bool> activeMonths,
  ) {
    final paint = Paint()
      ..color = dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (var i = 0; i < 12; i++) {
      // Вычисляем прогресс анимации для этого месяца
      final monthAnimProgress = _calculateMonthAnimationProgress(i);

      // Угол для границы между месяцами
      final angle = 2 * math.pi * (i + 0.5) / 12 - math.pi / 2 - math.pi / 6;

      // Вычисляем, должен ли этот разделитель быть анимирован
      final isActive = activeMonths[i] || activeMonths[(i - 1) % 12];

      // Интерполируем расширение только на основе прогресса анимации месяца
      final expansionFactor = isActive ? 1.0 + (0.10 * monthAnimProgress) : 1.0;

      final expandedRadius = radius * expansionFactor;

      // Применяем opacity анимацию
      final opacity = 0.5 + (0.5 * monthAnimProgress);
      paint.color = dividerColor.withValues(alpha: opacity);

      // Рисуем линию от внутреннего радиуса к внешнему
      final startX = center.dx + math.cos(angle) * innerRadius;
      final startY = center.dy + math.sin(angle) * innerRadius;
      final endX = center.dx + math.cos(angle) * expandedRadius;
      final endY = center.dy + math.sin(angle) * expandedRadius;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  // Метод для вычисления прогресса анимации для конкретного месяца
  double _calculateMonthAnimationProgress(int monthIndex) {
    final now = DateTime.now();
    final currentMonth = now.month; // Текущий месяц (1-12)

    // Определяем количество месяцев в нашем периоде (12 месяцев)
    const totalMonths = 12;

    // Вычисляем начальный месяц (следующий после текущего месяца в прошлом году)
    // Если сейчас месяц 5, то начнем с месяца 6 прошлого года (индекс 5)
    final startMonthIndex = currentMonth % totalMonths;

    // Количество месяцев от начального до текущего
    // Если сейчас месяц 5, то всего 12 месяцев (от 6 прошлого года до 5 текущего)

    // Вычисляем позицию monthIndex в нашем 12-месячном цикле
    // Нормализуем индекс так, чтобы 0 соответствовал начальному месяцу
    final normalizedIndex = (monthIndex - startMonthIndex + totalMonths) % totalMonths;

    // Общий прогресс анимации (0.0 - 1.0)
    final totalProgress = animationValue;

    // Вычисляем, в какой момент должен анимироваться каждый месяц
    final monthStartAnimationPoint = normalizedIndex / totalMonths;

    // Длительность анимации для каждого месяца
    const monthAnimationDuration = 1.0 / totalMonths;

    // Если анимация еще не дошла до этого месяца, возвращаем 0
    if (totalProgress < monthStartAnimationPoint) {
      return 0.0;
    }

    // Если анимация уже прошла этот месяц полностью, возвращаем 1
    if (totalProgress >= monthStartAnimationPoint + monthAnimationDuration) {
      return 1.0;
    }

    // Иначе рассчитываем прогресс анимации для этого месяца
    return (totalProgress - monthStartAnimationPoint) / monthAnimationDuration;
  }

  // Нарисовать активные сегменты для периодов пребывания с выделением и анимацией
  void _drawStayPeriodSegments(
    Canvas canvas,
    Offset center,
    double radius,
    double innerRadius,
    List<bool> activeMonths,
  ) {
    final currentMonth = DateTime.now().month;
    // Проходим по каждому месяцу
    for (var i = 0; i < 12; i++) {
      final monthIndex = (i + currentMonth - 1) % 12;

      // Рассчитываем начальный и конечный углы для месяца
      final startAngle = 2 * math.pi * (monthIndex + 0.5) / 12 - math.pi / 2 - math.pi / 6;
      const sweepAngle = 2 * math.pi / 12;

      // Вычисляем прогресс анимации для этого месяца
      final monthAnimProgress = _calculateMonthAnimationProgress(monthIndex);

      if (activeMonths[monthIndex]) {
        // Для активных месяцев - интерполируем цвет от фонового к активному
        final animatedColor = Color.lerp(
          backgroundColor.withValues(alpha: 0.5),
          activeColor,
          monthAnimProgress,
        )!;

        // Интерполируем расширение
        final expansionFactor = 1.0 + (0.10 * monthAnimProgress);

        // Создаем краску с анимированным цветом
        final animatedPaint = Paint()
          ..color = animatedColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = (radius * expansionFactor - innerRadius);

        // Рисуем дугу с анимированными параметрами
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: (radius * expansionFactor + innerRadius) / 2),
          startAngle,
          sweepAngle,
          false,
          animatedPaint,
        );
      } else {
        // Для неактивных месяцев применяем анимацию прозрачности
        // Начинаем с прозрачности 0.5 и анимируем до полной непрозрачности
        final opacity = 0.5 + (0.5 * monthAnimProgress);

        // Используем тот же базовый цвет, но с анимированной прозрачностью
        final animatedColor = backgroundColor.withValues(alpha: opacity);

        final nonActivePaint = Paint()
          ..color = animatedColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = (radius - innerRadius);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: (radius + innerRadius) / 2),
          startAngle,
          sweepAngle,
          false,
          nonActivePaint,
        );
      }
    }
  }

  // Нарисовать названия месяцев по окружности
  void _drawMonthLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double innerRadius,
    List<bool> activeMonths,
  ) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 0; i < 12; i++) {
      final angle = 2 * math.pi * i / 12 - math.pi / 2;

      // Вычисляем прогресс анимации для этого месяца
      final monthAnimProgress = _calculateMonthAnimationProgress(i);

      // Рассчитываем радиус для расположения текста - анимируем для всех месяцев
      // Базовый радиус для всех месяцев
      final baseRadius = (radius + innerRadius) / 2;

      // Анимируем радиус для всех месяцев, но для активных сильнее
      final expansionFactor = activeMonths[i]
          ? 1.0 +
                (0.04 * monthAnimProgress) // Больше расширение для активных
          : 1.0; // Меньше расширение для неактивных

      final labelRadius = baseRadius * expansionFactor;

      final x = center.dx + math.cos(angle) * labelRadius;
      final y = center.dy + math.sin(angle) * labelRadius;

      // Подготавливаем текст для отрисовки
      final monthName = months[i].length > 3 ? months[i].substring(0, 3) : months[i];

      // Интерполируем вес шрифта от normal до bold на основе прогресса анимации
      // Для активных месяцев достигаем FontWeight.bold (w700), для неактивных - более легкого (w500)
      final targetWeight = activeMonths[i] ? FontWeight.w700 : FontWeight.w500;

      // Начальный вес для всех - normal (w400)
      const initialWeight = FontWeight.w400;

      // Вычисляем промежуточный вес в зависимости от прогресса анимации
      final weightValue =
          initialWeight.index +
          ((targetWeight.index - initialWeight.index) * monthAnimProgress).round();

      // Получаем соответствующий FontWeight
      final interpolatedWeight =
          FontWeight.values[weightValue.clamp(0, FontWeight.values.length - 1)];

      // Увеличиваем размер шрифта для всех месяцев, но больше для активных
      final fontSizeIncrease = activeMonths[i] ? 2.0 * monthAnimProgress : 1.0 * monthAnimProgress;
      final fontSize = monthTextStyle.fontSize! + fontSizeIncrease;

      // Если месяц выбран, делаем его текст другого цвета
      var textColor = Colors.white;
      if (selectedMonthIndex == i) {
        textColor = Colors.yellow;
      }

      textPainter.text = TextSpan(
        text: monthName,
        style: monthTextStyle.copyWith(
          color: textColor,
          fontWeight: interpolatedWeight,
          fontSize: fontSize,
        ),
      );

      textPainter.layout();

      // Рисуем текст с учетом смещения для центрирования
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  // Нарисовать индикатор сегодняшнего дня (синяя стрелка)
  void _drawTodayIndicator(Canvas canvas, Offset center, double radius, double innerRadius) {
    final now = DateTime.now();

    // Рассчитываем положение индикатора (угол) на основе текущей даты
    // Используем текущий день месяца и общее количество дней в текущем месяце
    final dayOfMonth = now.day;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // Вычисляем угол для индикатора в пределах текущего месяца
    final monthProgress = dayOfMonth / daysInMonth;

    // Находим угол начала текущего месяца
    final currentMonthIndex = now.month - 1; // 0-11
    final startAngle = 2 * math.pi * currentMonthIndex / 12 - math.pi / 2;

    // Вычисляем угол индикатора в этом месяце
    final angle = startAngle + monthProgress * (2 * math.pi / 12) - math.pi / 12;

    // Создаем треугольник для индикатора с правильным размером
    final arrowSize = (radius - innerRadius) * 0.2; // Уменьшаем размер стрелки
    const distanceFromCircle = 20.0; // Расстояние от круга

    // Позиционируем стрелку снаружи круга
    final arrowCenterX = center.dx + math.cos(angle) * (radius + distanceFromCircle);
    final arrowCenterY = center.dy + math.sin(angle) * (radius + distanceFromCircle);

    // Создаем треугольную стрелку
    final path = Path();
    // Вершина треугольника (направлена к кругу)
    final tipX = center.dx + math.cos(angle) * (radius + distanceFromCircle);
    final tipY = center.dy + math.sin(angle) * (radius + distanceFromCircle);
    path.moveTo(tipX, tipY);

    // Задняя часть треугольника
    final backX = arrowCenterX + arrowSize * math.cos(angle);
    final backY = arrowCenterY + arrowSize * math.sin(angle);

    // Правый угол
    path.lineTo(
      backX + arrowSize / 1.5 * math.sin(angle),
      backY - arrowSize / 1.5 * math.cos(angle),
    );

    // Левый угол
    path.lineTo(
      backX - arrowSize / 1.5 * math.sin(angle),
      backY + arrowSize / 1.5 * math.cos(angle),
    );

    path.close();

    final paint = Paint()
      ..color = todayIndicatorColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  // Нарисовать индикатор даты обновления статуса (оранжевая стрелка)
  void _drawUpdateIndicator(Canvas canvas, Offset center, double radius, double innerRadius) {
    // Рассчитываем положение индикатора (угол) на основе текущей даты
    // Используем текущий день месяца и общее количество дней в текущем месяце
    final dayOfMonth = statusUpdateDate.day;
    final daysInMonth = DateTime(statusUpdateDate.year, statusUpdateDate.month + 1, 0).day;

    // Вычисляем угол для индикатора в пределах текущего месяца
    final monthProgress = dayOfMonth / daysInMonth;

    // Находим угол начала текущего месяца
    final currentMonthIndex = statusUpdateDate.month - 1; // 0-11
    final startAngle = 2 * math.pi * currentMonthIndex / 12 - math.pi / 2;

    // Вычисляем угол индикатора в этом месяце
    final angle = startAngle + monthProgress * (2 * math.pi / 12) - math.pi / 12;

    // Создаем треугольник для индикатора с правильным размером
    final arrowSize = (radius - innerRadius) * 0.2; // Уменьшаем размер стрелки
    const distanceFromCircle = 20.0; // Расстояние от круга

    // Позиционируем стрелку снаружи круга
    final arrowCenterX = center.dx + math.cos(angle) * (radius + distanceFromCircle);
    final arrowCenterY = center.dy + math.sin(angle) * (radius + distanceFromCircle);

    // Создаем треугольную стрелку
    final path = Path();
    // Вершина треугольника (направлена к кругу)
    final tipX = center.dx + math.cos(angle) * (radius + distanceFromCircle);
    final tipY = center.dy + math.sin(angle) * (radius + distanceFromCircle);
    path.moveTo(tipX, tipY);

    // Задняя часть треугольника
    final backX = arrowCenterX + arrowSize * math.cos(angle);
    final backY = arrowCenterY + arrowSize * math.sin(angle);

    // Правый угол
    path.lineTo(
      backX + arrowSize / 1.5 * math.sin(angle),
      backY - arrowSize / 1.5 * math.cos(angle),
    );

    // Левый угол
    path.lineTo(
      backX - arrowSize / 1.5 * math.sin(angle),
      backY + arrowSize / 1.5 * math.cos(angle),
    );

    path.close();

    final paint = Paint()
      ..color = updateIndicatorColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  // Нарисовать центральный текст
  void _drawCenterText(Canvas canvas, Offset center, double innerRadius) {
    // Отрисовываем основной текст (прогресс)
    final textPainter = TextPainter(
      text: TextSpan(text: progress, style: centerTextStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2 - 10),
    );

    // Отрисовываем подпись (progress)
    final subtitlePainter = TextPainter(
      text: TextSpan(text: "progress", style: centerSubtitleStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    subtitlePainter.layout();
    subtitlePainter.paint(
      canvas,
      Offset(center.dx - subtitlePainter.width / 2, center.dy + textPainter.height / 2 - 10),
    );
  }

  @override
  bool shouldRepaint(covariant _CalendarCirclePainter oldDelegate) {
    return oldDelegate.stayPeriods != stayPeriods ||
        oldDelegate.progress != progress ||
        oldDelegate.statusUpdateDate != statusUpdateDate ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedMonthIndex != selectedMonthIndex;
  }
}
