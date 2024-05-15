//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
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

Функция ЭтоПодходящееРасширение(ИмяРасширения) Экспорт
	
	Контекст = ЮТКонтекстСлужебный.КонтекстЧитателя();
	
	НормализованноеИмяРасширения = НРег(ИмяРасширения);
	
	Возврат НЕ Контекст.Фильтр.ЕстьФильтрРасширений ИЛИ Контекст.Фильтр.Расширения[НормализованноеИмяРасширения] <> Неопределено;
	
КонецФункции

Функция ЭтоПодходящийМодуль(ОписаниеМодуля) Экспорт
	
	Контекст = ЮТКонтекстСлужебный.КонтекстЧитателя();
	
	Возврат ЗначениеЗаполнено(ОписаниеМодуля.Расширение)
		И (НЕ Контекст.Фильтр.ЕстьФильтрМодулей ИЛИ Контекст.Фильтр.Модули.Свойство(ОписаниеМодуля.Имя))
		И ЭтоПодходящееРасширение(ОписаниеМодуля.Расширение);
	
КонецФункции

// Отфильтровать тестовые наборы.
//
// Параметры:
//  ОписаниеТестовогоМодуля - см. ЮТФабрикаСлужебный.ОписаниеТестовогоМодуля
Процедура ОтфильтроватьТестовыеНаборы(ОписаниеТестовогоМодуля) Экспорт
	
	Фильтр = ЮТКонтекстСлужебный.КонтекстЧитателя().Фильтр;
	
	Если НЕ Фильтр.ЕстьФильтрТестов И НЕ Фильтр.ЕстьФильтрКонтекстов И НЕ Фильтр.ЕстьФильтрТегов Тогда
		Возврат;
	КонецЕсли;
	
	НаборыТестов = ОписаниеТестовогоМодуля.НаборыТестов;
	МетаданныеМодуля = ОписаниеТестовогоМодуля.МетаданныеМодуля;
	
	Результат = Новый Массив();
	
	СостояниеФильтрации = Новый Структура;
	ДоступныеТестовыеМетоды(Фильтр, МетаданныеМодуля, СостояниеФильтрации);
	
	Для Каждого Набор Из НаборыТестов Цикл
		
		Если НЕ ЭтоПодходящийНабор(Набор, Фильтр) Тогда
			Продолжить;
		КонецЕсли;
		
		ОтфильтрованныйНабор = ЮТФабрикаСлужебный.ОписаниеТестовогоНабора(Набор.Имя);
		ЗаполнитьЗначенияСвойств(ОтфильтрованныйНабор, Набор, , "Тесты");
		
		ОбработатьТегиНабора(ОписаниеТестовогоМодуля, Набор, Фильтр, СостояниеФильтрации);
		
		Для Каждого Тест Из Набор.Тесты Цикл
			
			ТестПодходитПодФильтр = ФильтрТестов(Тест, Фильтр, СостояниеФильтрации)
				И ФильтрКонтекста(Тест, Фильтр)
				И ФильтрТегов(Тест, Фильтр, СостояниеФильтрации);
			
			Если ТестПодходитПодФильтр Тогда
				
				ОтфильтрованныйТест = ЮТФабрикаСлужебный.ОписаниеТеста(Тест.Имя, "", "");
				ЗаполнитьЗначенияСвойств(ОтфильтрованныйТест, Тест);
				ОтфильтрованныйНабор.Тесты.Добавить(ОтфильтрованныйТест);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОтфильтрованныйНабор.Тесты.Количество() Тогда
			Результат.Добавить(ОтфильтрованныйНабор);
		КонецЕсли;
		
	КонецЦикла;
	
	ОписаниеТестовогоМодуля.НаборыТестов = Результат;
	
КонецПроцедуры

// Конструктор фильтра поиска тестовых методов
//
// Возвращаемое значение:
//  Структура - Фильтр:
// * Расширения - Структура - Имена расширений
// * Модули - Структура - Имена модулей
// * Наборы - Соответствие из Строка - Имена тестовых наборов
// * Теги - Соответствие из Строка
// * Контексты - Массив из Строка - Контексты вызова тестовых методов
// * Тесты - Массив из см. ОписаниеИмениТеста - Список путей к тестовым методам
Функция Фильтр() Экспорт
	
	//@skip-check structure-consructor-too-many-keys
	Фильтр = Новый Структура("Расширения, Модули, Наборы, Теги, Контексты, Тесты");
	
	Фильтр.Расширения = Новый Соответствие();
	Фильтр.Модули = Новый Структура();
	Фильтр.Теги = Новый Соответствие();
	Фильтр.Контексты = Новый Массив();
	Фильтр.Наборы = Новый Соответствие();
	Фильтр.Тесты = Новый Массив();
	
	//@skip-check constructor-function-return-section
	Возврат Фильтр;
	
КонецФункции

Процедура УстановитьКонтекст(ПараметрыЗапускаТестов) Экспорт
	
	Расширения = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "extensions", Новый Массив);
	Модули = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "modules", Новый Массив);
	Контексты = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "contexts");
	Тесты = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "tests", Новый Массив);
	
	Теги = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "tags", Новый Массив);
	Наборы = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "suites", Новый Массив);
	
	Фильтр = Фильтр();
	
	Фильтр.Расширения = МассивВСоответствие(Расширения);
	Фильтр.Модули = ЮТКоллекции.МассивВСтруктуру(Модули);
	
	Если Контексты = Неопределено Тогда
		Фильтр.Контексты = ЮТФабрикаСлужебный.КонтекстыПриложения();
	Иначе
		Фильтр.Контексты = Контексты;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Теги) Тогда
		Фильтр.Теги = МассивВСоответствие(Теги);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наборы) Тогда
		Фильтр.Наборы = МассивВСоответствие(Наборы);
	КонецЕсли;
	
	МодулиТестов = Новый Структура();
	
	Если ЗначениеЗаполнено(Тесты) Тогда
		Для Каждого ПолноеИмяТеста Из Тесты Цикл
			Описание = ОписаниеИмениТеста(ПолноеИмяТеста);
			Фильтр.Тесты.Добавить(Описание);
			МодулиТестов.Вставить(Описание.ИмяМодуля, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Если МодулиТестов.Количество() И Фильтр.Модули.Количество() = 0 Тогда
		
		Фильтр.Модули = МодулиТестов;
		
	ИначеЕсли МодулиТестов.Количество() Тогда
		
		Модули = Новый Структура();
		
		Для Каждого Элемент Из Фильтр.Модули Цикл
			Если МодулиТестов.Свойство(Элемент.Ключ) Тогда
				Модули.Вставить(Элемент.Ключ, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Фильтр.Модули = Модули;
		
	КонецЕсли;
	
	Фильтр.Вставить("ЕстьФильтрРасширений", Фильтр.Расширения.Количество() > 0);
	Фильтр.Вставить("ЕстьФильтрМодулей", МодулиТестов.Количество() ИЛИ Фильтр.Модули.Количество());
	Фильтр.Вставить("ЕстьФильтрНаборов", ЗначениеЗаполнено(Фильтр.Наборы));
	Фильтр.Вставить("ЕстьФильтрТестов", Фильтр.Тесты.Количество() > 0 );
	Фильтр.Вставить("ЕстьФильтрКонтекстов", ЗначениеЗаполнено(Фильтр.Контексты));
	Фильтр.Вставить("ЕстьФильтрТегов", ЗначениеЗаполнено(Фильтр.Теги));
	
	ЮТКонтекстСлужебный.УстановитьКонтекстЧитателя(Новый Структура("Фильтр", Фильтр));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеИмениТеста(Путь)
	
	Части = СтрРазделить(Путь, ".");
	
	Если Части.Количество() <= 1 ИЛИ Части.Количество() > 3 Тогда
		ВызватьИсключение СтрШаблон("Не корректный формат пути к тесту `%1`, должен быть в формате `ИмяМодуля.ИмяМетода{.Контекст}`", Путь);
	КонецЕсли;
	
	Описание = Новый Структура("ИмяМодуля, ИмяМетода, Контекст");
	
	Для Инд = 0 По Части.ВГраница() Цикл
		Части[Инд] = СокрЛП(Части[Инд]);
	КонецЦикла;
	
	Описание.ИмяМодуля = Части[0];
	Описание.ИмяМетода = Части[1];
	Если Части.Количество() > 2 Тогда
		Описание.Контекст = Части[2];
	КонецЕсли;
	
	Возврат Описание;
	
КонецФункции

Процедура ДоступныеТестовыеМетоды(Фильтр, ОписаниеМодуля, СостояниеФильтрации)
	
	Если НЕ Фильтр.ЕстьФильтрТестов Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеТестовыеМетоды = Новый Соответствие();
	
	Для Каждого ОписаниеИмениТеста Из Фильтр.Тесты Цикл
		
		Если СтрСравнить(ОписаниеИмениТеста.ИмяМодуля, ОписаниеМодуля.Имя) = 0 Тогда
			ОписаниеИмениТеста.ИмяМетода = ВРег(ОписаниеИмениТеста.ИмяМетода);
			
			СохраненноеОписаниеИмени = ДоступныеТестовыеМетоды[ОписаниеИмениТеста.ИмяМетода];
			
			Если СохраненноеОписаниеИмени = Неопределено И ОписаниеИмениТеста.Контекст = Неопределено Тогда
				ДоступныеТестовыеМетоды.Вставить(ВРег(ОписаниеИмениТеста.ИмяМетода), ОписаниеИмениТеста);
			ИначеЕсли СохраненноеОписаниеИмени = Неопределено Тогда
				ОписаниеИмениТеста.Контекст = ЮТКоллекции.ЗначениеВМассиве(ОписаниеИмениТеста.Контекст);
				ДоступныеТестовыеМетоды.Вставить(ВРег(ОписаниеИмениТеста.ИмяМетода), ОписаниеИмениТеста);
			ИначеЕсли ОписаниеИмениТеста.Контекст = Неопределено Тогда
				СохраненноеОписаниеИмени.Контекст = Неопределено; // Без фильтрации контекста теста, возьмем из самого теста контексты
			ИначеЕсли СохраненноеОписаниеИмени.Контекст <> Неопределено Тогда
				СохраненноеОписаниеИмени.Контекст.Добавить(ОписаниеИмениТеста.Контекст);
			Иначе
				// Если было имя теста без контекста, то будет вызов во всех контекстах
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	СостояниеФильтрации.Вставить("ДоступныеТестовыеМетоды", ДоступныеТестовыеМетоды);
	
КонецПроцедуры

Процедура ОбработатьТегиНабора(ОписаниеМодуля, Набор, Фильтр, СостояниеФильтрации)
	
	Если НЕ Фильтр.ЕстьФильтрТегов Тогда
		Возврат;
	КонецЕсли;
	
	ПодходитПодФильтрТегов = ПодходитПодФильтрТегов(Фильтр, ОписаниеМодуля.Теги) Или ПодходитПодФильтрТегов(Фильтр, Набор.Теги);
	СостояниеФильтрации.Вставить("ПодходитПодФильтрТегов", ПодходитПодФильтрТегов);
	
КонецПроцедуры

Функция ПодходитПодФильтрТегов(Фильтр, Теги)
	
	Для Каждого Тег Из Теги Цикл
		
		Если Фильтр.Теги[НРег(Тег)] <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоПодходящийНабор(Набор, Фильтр)
	
	Возврат НЕ Фильтр.ЕстьФильтрНаборов Или Фильтр.Наборы[НРег(Набор.Имя)] <> Неопределено;
	
КонецФункции

Функция ФильтрТестов(Тест, Фильтр, СостояниеФильтрации)
	
	Если НЕ Фильтр.ЕстьФильтрТестов Тогда
		Возврат Истина;
	КонецЕсли;
	
	ФильтрТеста = СостояниеФильтрации.ДоступныеТестовыеМетоды[ВРег(Тест.Имя)];
	
	Если ФильтрТеста = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФильтрТеста.Контекст) Тогда
		Тест.КонтекстВызова = ЮТКоллекции.ПересечениеМассивов(Тест.КонтекстВызова, ФильтрТеста.Контекст);
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(Тест.КонтекстВызова);
	
КонецФункции

Функция ФильтрКонтекста(Тест, Фильтр)
	
	Если НЕ Фильтр.ЕстьФильтрКонтекстов Тогда
		Возврат Истина;
	КонецЕсли;
	
	Тест.КонтекстВызова = ЮТКоллекции.ПересечениеМассивов(Тест.КонтекстВызова, Фильтр.Контексты);
	
	Возврат ЗначениеЗаполнено(Тест.КонтекстВызова);
	
КонецФункции

Функция ФильтрТегов(Тест, Фильтр, СостояниеФильтрации)
	
	Если НЕ Фильтр.ЕстьФильтрТегов Или СостояниеФильтрации.ПодходитПодФильтрТегов Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для Каждого Тег Из Тест.Теги Цикл
		
		Если Фильтр.Теги[НРег(Тег)] <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция МассивВСоответствие(Значения)
	
	Результат = Новый Соответствие();
	
	Если НЕ ЗначениеЗаполнено(Значения) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Значение Из Значения Цикл
		Результат.Вставить(НРег(Значение), Истина);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
