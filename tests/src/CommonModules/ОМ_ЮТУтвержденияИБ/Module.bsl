//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты.ВТранзакции().УдалениеТестовыхДанных()
		.ДобавитьТест("СодержитЗаписи")
		.ДобавитьТест("НеСодержитЗаписи")
		.ДобавитьТест("СообщенияОбОшибках")
		.ДобавитьТест("СодержитЗаписиСНаименованием")
		.ДобавитьТест("СодержитЗаписиСКодом")
		.ДобавитьТест("СодержитЗаписиСНомером")
		.ДобавитьТест("НеСодержитЗаписиСНаименованием")
		.ДобавитьТест("НеСодержитЗаписиСКодом")
		.ДобавитьТест("НеСодержитЗаписиСНомером")
	;
	
КонецПроцедуры

Процедура СодержитЗаписи() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Конструктор.Записать();
	ДанныеСправочника = Конструктор.ДанныеОбъекта();
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("РегистрыСведений.КурсыВалют")
		.Фикция("Валюта")
		.Фикция("Период")
		.Фикция("Курс");
	ДанныеРегистра = Конструктор.ДанныеОбъекта();
	Конструктор.Записать();
	
	Конструктор
		.Фикция("Период")
		.Фикция("Курс")
		.Записать();
	
	ЮТест.ОжидаетЧтоТаблицаБазы("Справочник.Товары")
		.СодержитЗаписи();
	
	ЮТест.ОжидаетЧтоТаблицаБазы("Справочник.Товары")
		.СодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Наименование").Равно(ДанныеСправочника.Наименование));
	
	ЮТест.ОжидаетЧтоТаблицаБазы("Справочник.Товары")
		.СодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Поставщик").Равно(ДанныеСправочника.Поставщик));
	
	ЮТест.ОжидаетЧтоТаблицаБазы("Справочник.Товары")
		.СодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Наименование").Равно(ДанныеСправочника.Наименование)
			.Реквизит("Поставщик").Равно(ДанныеСправочника.Поставщик));
	
	ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.КурсыВалют")
		.СодержитЗаписи();
	
	ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.КурсыВалют")
		.СодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Валюта").Равно(ДанныеРегистра.Валюта));
	
КонецПроцедуры

Процедура НеСодержитЗаписи() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	
	ИмяТаблицы = "Справочник.Товары";
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы)
		.НеСодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Наименование").Равно(Конструктор.ДанныеОбъекта().Наименование));
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы)
		.НеСодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Поставщик").Равно(Конструктор.ДанныеОбъекта().Поставщик));
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы)
		.НеСодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Наименование").Равно(Конструктор.ДанныеОбъекта().Наименование)
			.Реквизит("Поставщик").Равно(Конструктор.ДанныеОбъекта().Поставщик));
	Конструктор.Записать();
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы)
		.СодержитЗаписи(ЮТест.Предикат()
			.Реквизит("Поставщик").Равно(Конструктор.ДанныеОбъекта().Поставщик));
	
КонецПроцедуры

Процедура СообщенияОбОшибках() Экспорт
	
	МетодНеСодержитЗаписи = "НеСодержитЗаписи";
	МетодСодержитЗаписи = "СодержитЗаписи";
	ТаблицаСправочник = "Справочник.Товары";
	ТаблицаБезЗаписей = "Справочник.МобильныеУстройства";
	
	Наименование = ЮТест.Данные().СлучайнаяСтрока();
	ПредикатНаименование = ЮТест.Предикат()
		.Реквизит("Наименование").Равно(Наименование)
		.Получить();
		
	ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Установить("Наименование", Наименование)
		.Записать();
	Префикс = "Ожидали, что проверяемая таблица ";
	Варианты = ЮТест.Варианты("ИмяТаблицы, Метод, Предикат, ОжидаемоеСообщение, ОписаниеПроверки, ОписаниеУтверждения")
		
		.Добавить(ТаблицаСправочник, МетодНеСодержитЗаписи, Неопределено,
			Префикс + "`Справочник.Товары` не содержит записи, но это не так.")
		
		.Добавить(ТаблицаСправочник, МетодНеСодержитЗаписи, ПредикатНаименование,
			СтрШаблон("%1`Справочник.Товары` не содержит записи с `Наименование` равно `%2`, но это не так.", Префикс, Наименование))
		
		.Добавить(ТаблицаБезЗаписей, МетодСодержитЗаписи, Неопределено,
			Префикс + "`Справочник.МобильныеУстройства` содержит записи, но это не так.")
		
		.Добавить(ТаблицаБезЗаписей, МетодСодержитЗаписи, Неопределено,
			СтрШаблон("Описание проверки: %1`Справочник.МобильныеУстройства` содержит записи, но это не так.", СтрочнаяПерваяБуква(Префикс)), "Описание проверки")
		
		.Добавить(ТаблицаБезЗаписей, МетодСодержитЗаписи, Неопределено,
			СтрШаблон("Описание проверки: %1`Справочник.МобильныеУстройства` содержит записи, но это не так.", СтрочнаяПерваяБуква(Префикс)), , "Описание проверки")
		
		.Добавить(ТаблицаБезЗаписей, МетодСодержитЗаписи, Неопределено,
			СтрШаблон("Описание проверки: %1`Справочник.МобильныеУстройства` содержит записи, но это не так.", СтрочнаяПерваяБуква(Префикс)), "Описание", "проверки")
	;
	
	Индекс = 1;
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		ЮТест.ОжидаетЧтоТаблицаБазы(Вариант.ИмяТаблицы, Вариант.ОписаниеПроверки);
		
		Ошибка = Неопределено;
		Попытка
			Если Вариант.Метод = МетодНеСодержитЗаписи Тогда
				ЮТУтвержденияИБ.НеСодержитЗаписи(Вариант.Предикат, Вариант.ОписаниеУтверждения);
			ИначеЕсли Вариант.Метод = МетодСодержитЗаписи Тогда
				ЮТУтвержденияИБ.СодержитЗаписи(Вариант.Предикат, Вариант.ОписаниеУтверждения);
			КонецЕсли;
		Исключение
			Ошибка = ИнформацияОбОшибке();
		КонецПопытки;
		
		ПроверитьОшибкуУтверждения("Вариант " + Индекс, Ошибка, Вариант.ОжидаемоеСообщение);
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СодержитЗаписиСНаименованием() Экспорт
	
	ИмяТаблицы = "Справочник.Товары";
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование");
	Данные = Конструктор.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСНаименованием(Данные.Наименование);
	
	Объект = Конструктор.Записать();
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСНаименованием(Данные.Наименование);
	
	ПомощникТестированияВызовСервера.УстановитьРеквизит(Объект, "ПометкаУдаления", Истина);
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСНаименованием(Данные.Наименование, Ложь);
	
	Попытка
		ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСНаименованием(Данные.Наименование);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПроверитьОшибкуУтверждения(Неопределено, Ошибка, "Ожидали, что проверяемая таблица `Справочник.Товары` содержит записи с `Наименование` равно");
	
КонецПроцедуры

Процедура СодержитЗаписиСКодом() Экспорт
	
	ИмяТаблицы = "Справочник.Товары";
	Код = "t00000001";
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Установить("Код", Код);
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСКодом(Код);
	
	Объект = Конструктор.Записать();
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСКодом(Код);
	
	ПомощникТестированияВызовСервера.УстановитьРеквизит(Объект, "ПометкаУдаления", Истина);
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСКодом(Код, Ложь);
	
	Попытка
		ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСКодом(Код);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПроверитьОшибкуУтверждения(Неопределено, Ошибка, "`Справочник.Товары` содержит записи с `Код` равно");
	
КонецПроцедуры

Процедура СодержитЗаписиСНомером() Экспорт
	
	ИмяТаблицы = "Документ.Оплата";
	Номер = "t00000001";
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Документы.Оплата")
		.Установить("Номер", Номер);
	
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСНомером(Номер);
	
	Объект = Конструктор.Записать();
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСНомером(Номер);
	
	ПомощникТестированияВызовСервера.УстановитьРеквизит(Объект, "ПометкаУдаления", Истина);
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСНомером(Номер, Ложь);
	
	Попытка
		ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).СодержитЗаписиСНомером(Номер);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПроверитьОшибкуУтверждения(Неопределено, Ошибка, "`Документ.Оплата` содержит записи с `Номер` равно");
	
КонецПроцедуры

Процедура НеСодержитЗаписиСНаименованием() Экспорт
	
	ИмяТаблицы = "Справочник.Товары";
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Установить("ПометкаУдаления", Истина);
	Данные = Конструктор.ДанныеОбъекта();
	
	Конструктор.Записать();
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСНаименованием(Данные.Наименование);
	Попытка
		ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСНаименованием(Данные.Наименование, Ложь);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПроверитьОшибкуУтверждения(Неопределено, Ошибка, "`Справочник.Товары` не содержит записи с `Наименование` равно");
	
КонецПроцедуры

Процедура НеСодержитЗаписиСКодом() Экспорт
	
	ИмяТаблицы = "Справочник.Товары";
	Код = "t00000001";
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Установить("Код", Код)
		.Установить("ПометкаУдаления", Истина);
	
	Конструктор.Записать();
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСКодом(Код);
	Попытка
		ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСКодом(Код, Ложь);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПроверитьОшибкуУтверждения(Неопределено, Ошибка, "`Справочник.Товары` не содержит записи с `Код` равно");
	
КонецПроцедуры

Процедура НеСодержитЗаписиСНомером() Экспорт
	
	ИмяТаблицы = "Документ.Оплата";
	Номер = "t00000001";
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Документы.Оплата")
		.Установить("Номер", Номер)
		.Установить("ПометкаУдаления", Истина);
	
	Конструктор.Записать();
	ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСНомером(Номер);
	Попытка
		ЮТест.ОжидаетЧтоТаблицаБазы(ИмяТаблицы).НеСодержитЗаписиСНомером(Номер, Ложь);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПроверитьОшибкуУтверждения(Неопределено, Ошибка, "`Документ.Оплата` не содержит записи с `Номер` равно");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОшибкуУтверждения(Префикс, ИнформацияОбОшибке, ОжидаемоеОписание) Экспорт
	
	ЮТест.ОжидаетЧто(ИнформацияОбОшибке, Префикс)
		.ЭтоНеНеопределено()
		.Свойство("Описание")
			.НачинаетсяС("[Failed]")
			.Содержит(ОжидаемоеОписание);
	
КонецПроцедуры

Функция СтрочнаяПерваяБуква(Строка)
	Возврат НРег(Лев(Строка, 1)) + Сред(Строка, 2);
КонецФункции

#КонецОбласти
