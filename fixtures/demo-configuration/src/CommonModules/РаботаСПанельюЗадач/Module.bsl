// Поцедура - обработчик нажатия кнопки "Проверить письма" в панели задач
// Параметры:
//	 Параметры - дополнительные параметры описания оповещения 
Процедура ПроверитьПочту(Параметры) Экспорт
	
	#Если Не ВебКлиент И Не МобильныйКлиент Тогда
		Количество = РаботаСПочтойВызовСервера.ПроверитьПочту();
		
		Если Количество <> 0 Тогда
			ПанельЗадачОС.УстановитьНаклейку(Количество, Истина);
			ПанельЗадачОС.Сигнализировать(3);
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(СтрШаблон(НСтр("ru = 'Новых писем: %1'"), Количество));
	#КонецЕсли
	
КонецПроцедуры

// Поцедура - обработчик нажатия кнопки "Открыть заказы" в панели задач
// Параметры:
//	 Параметры - дополнительные параметры описания оповещения 
Процедура ОткрытьСписокЗаказов(Параметры) Экспорт
	
	ОткрытьФорму("Документ.Заказ.ФормаСписка");
	
КонецПроцедуры

// Процедура добавляющая кнопки в меню предпросмотра окна приложения
Процедура ДобавитьКнопки(Параметры) Экспорт
	
	#Если Не ВебКлиент И Не МобильныйКлиент Тогда
		КнопкиПанелиЗадач = Новый Массив();
		
		ПроверитьПисьмаКнопка = Новый Структура;
		ПроверитьПисьмаКнопка.Вставить("Картинка", Параметры.КартинкаПроверитьПочту);
		ПроверитьПисьмаКнопка.Вставить("Заголовок", НСтр("ru = 'Проверить письма'"));
		ДействиеПроверитьПисьма = Новый ОписаниеОповещения("ПроверитьПочту", ЭтотОбъект);
		ПроверитьПисьмаКнопка.Вставить("Действие", ДействиеПроверитьПисьма);
		КнопкиПанелиЗадач.Добавить(ПроверитьПисьмаКнопка);
		
		ОткрытьФормуКнопка = Новый Структура;
		ОткрытьФормуКнопка.Вставить("Картинка", Параметры.КартинкаСписокЗаказов);
		ОткрытьФормуКнопка.Вставить("Заголовок", НСтр("ru = 'Открыть заказы'"));
		ДействиеОткрытьФорму = Новый ОписаниеОповещения("ОткрытьСписокЗаказов", ЭтотОбъект);
		ОткрытьФормуКнопка.Вставить("Действие", ДействиеОткрытьФорму);
		КнопкиПанелиЗадач.Добавить(ОткрытьФормуКнопка);
		
		ПанельЗадачОС.УстановитьКнопки(КнопкиПанелиЗадач);
	#КонецЕсли
	
КонецПроцедуры