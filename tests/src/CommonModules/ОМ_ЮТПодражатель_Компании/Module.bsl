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

Процедура ИсполняемыеСценарии() Экспорт

	ЮТТесты
		.ДобавитьТестовыйНабор("Компании")
			.ДобавитьТест("Наименование")
			.ДобавитьТест("ИНН")
			.ДобавитьТест("КПП")
	;
	
КонецПроцедуры

Процедура Наименование() Экспорт
	
	Имя = ЮТест.Данные().Подражатель().Компании().Наименование();
	ЮТест.ОжидаетЧто(Имя)
		.ИмеетТип("Строка")
		.Заполнено()
	;
	
	ЮТест.ОжидаетЧто(СтрДлина(Имя))
		.Больше(1)
	;
КонецПроцедуры

Процедура ИНН() Экспорт
	
	ИНН = ЮТест.Данные().Подражатель().Компании().ИНН("77");
	ЮТест.ОжидаетЧто(ИНН)
		.ИмеетТип("Строка")
		.Заполнено()
		.ИмеетДлину(10)
		.НачинаетсяС("77")
	;
	ЮТЛогирование.Отладка("ИНН: " + ИНН);
	
КонецПроцедуры

Процедура КПП() Экспорт
	
	ИНН = ЮТест.Данные().Подражатель().Компании().КПП("7701");
	ЮТест.ОжидаетЧто(ИНН)
		.ИмеетТип("Строка")
		.Заполнено()
		.ИмеетДлину(9)
		.НачинаетсяС("7701")
	;
	
КонецПроцедуры

#КонецОбласти
