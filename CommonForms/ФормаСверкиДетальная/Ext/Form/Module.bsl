﻿
&НаКлиенте
Процедура КоличествоФактПриИзменении(Элемент)
	
	ОбработатьВводКоличества(?(ЗначениеЗаполнено(Идентификатор), Новый Структура("ПолеПоиска, ЗначениеПоиска", "Идентификатор", Идентификатор), Новый Структура("ПолеПоиска, ЗначениеПоиска", "Штрихкод", Штрихкод)));
	ЗаполнитьДанныеПоТовару(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВводКоличества(СтруктураПараметров)
	
	ИсправленаИмеющаяся = Ложь;
	
	об = Сборка.ПолучитьОбъект();
	
	Нстроки = об.Товары.НайтиСтроки(Новый Структура(СтруктураПараметров.ПолеПоиска,СтруктураПараметров.ЗначениеПоиска));
	
	Попытка
		тСтрока = Нстроки[0];
		
		Если КоличествоФакт > тСтрока.КоличествоУчет И КонтрольПревышенияКоличества() Тогда
			Сообщить("Нельзя превышать учётное количество");
			Возврат;
		КонецЕсли;
		
		тСтрока.Количество = КоличествоФакт;
		//об.Товары.Сдвинуть(тСтрока, 0-об.Товары.Индекс(тСтрока));
		об.Записать();
		//ЗаполнитьДанныеПоСверке();
		Элементы.ИнформацияОТоваре.Заголовок = ПолучитьОписаниеТовара();
	Исключение
		Сообщить("Не найдена строка с таким товаром");
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция КонтрольПревышенияКоличества()
	
	Результат = Ложь;
	
	Если Сборка.ВидДокумента = "WebOrder" Или Сборка.ВидДокумента = "ProductAssembly" Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	_Маркировка	 = Параметры._Маркировка;
	Штрихкоды	 = Параметры.Штрихкоды;
	Сборка		 = Параметры.Сборка;
	Товар	     = Параметры.Товар;
	Штрихкод	 = Параметры.Штрихкод;
	СпецШтрихкод = Параметры.СпецШтрихкод;
	Идентификатор= Параметры.Идентификатор;
	Попытка
		Для Каждого ИД Из Параметры.МаркированныеТовары Цикл
			НС = МаркированныеТовары.Добавить();
			НС.Идентификатор = ИД;
		КонецЦикла;
	Исключение КонецПопытки;
КонецПроцедуры

&НаКлиенте
Функция ВсеПозицииОтработаны(ДопПараметры) Экспорт 
	ЭтаФорма.Закрыть();
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если _Маркировка Тогда
		ЗаполнитьДанныеПоМаркировке();
		ОтключитьДоступностьЭлементов();
	Иначе
		ЗаполнитьДанныеПоТовару();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере                 
Функция ЭтоМаркировка()
	
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(Идентификатор) И МаркированныеТовары.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор)).Количество() > 0 Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтключитьДоступностьЭлементов()
	Элементы.КоличествоФакт.ТолькоПросмотр = Истина;
	Элементы.предТовар.Доступность = Ложь;
	Элементы.следТовар.Доступность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеПоТовару(пОбновитьКартинку = Истина)
	
	ШК = ПолучитьШтрихкодТовара();             

	МаркированныйТовар = ЭтоМаркировка();
	Элементы.ИнформацияОТоваре.Заголовок = ?(МаркированныйТовар, "МАРКИРОВКА!" + Символы.ПС, "") + ПолучитьОписаниеТовара();
	
	Если ЗначениеЗаполнено(ШК) и пОбновитьКартинку Тогда
		ОбновитьКартинку(ШК)
	КонецЕсли;
	
	УстановитьКоличествоФакт();
	УстановитьДоступностьКнопок();
	
	Элементы.КоличествоФакт.ТолькоПросмотр = МаркированныйТовар;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеПоМаркировке()
	
	СтрокаШтрихкоды = "";
	ШК = "";
	МассивШК = ОбщегоНазначения_Сервер.ДеСериализовать(Штрихкоды);
	
	Для Каждого Эл Из МассивШК Цикл
		СтрокаШтрихкоды = СтрокаШтрихкоды + Эл + Символы.ПС;
		Шк = Эл;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ШК) Тогда
		ОбновитьКартинку(ШК)
	КонецЕсли;
	
	Элементы.ИнформацияОТоваре.Заголовок = "МАРКИРОВКА!" + Символы.ПС + Товар + Символы.ПС + СтрокаШтрихкоды;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопок()
	
	//Индексы						   = ПолучитьДанныеОИндексах();	
	//Элементы.следТовар.Доступность = НЕ(Индексы.тИндекс = Индексы.максИндекс);
	//Элементы.предТовар.Доступность = НЕ(Индексы.тИндекс = Индексы.минИндекс);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКартинку(ШК)
	ДвоичныеДанныеКартинка=API.ПолучитьКартинку(ШК);
	СсылкаВХ=ПоместитьВоВременноеХранилище(ДвоичныеДанныеКартинка,Новый УникальныйИдентификатор);
	СсылкаНаКартинку = СсылкаВХ;
	Элементы.СсылкаНаКартинку.РазмерКартинки = РазмерКартинки.Пропорционально;
КонецФункции

&НаСервере
Функция УстановитьКоличествоФакт()
	КоличествоФакт = ПолучитьСтрокуТовара().Количество;
КонецФункции

&НаСервере
Функция ПолучитьСтрокуТовара()
	Возврат Сборка.Товары.НайтиСтроки(Новый Структура("Идентификатор, СпецШтрихкод", Идентификатор, СпецШтрихкод))[0];
	
	//Если ОбщегоНазначения_Сервер.ШтрихкодУценки(Штрихкод) Тогда
	//	Возврат ДанныеСверки.НайтиСтроки(Новый Структура("Название, Штрихкод", Товар, Штрихкод))[0];
	//Иначе
	//	нужныеСтроки = ДанныеСверки.НайтиСтроки(Новый Структура("Название, Штрихкод", Товар, Штрихкод));
	//	
	//	Для Каждого Строчка Из нужныеСтроки Цикл
	//		Если НЕ ОбщегоНазначения_Сервер.ШтрихкодУценки(Строчка.Штрихкод) Тогда
	//			Возврат Строчка;
	//		КонецЕсли;
	//	КонецЦикла;
	//	
	//КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьШтрихкодТовара()
	
	нСтрока = ПолучитьСтрокуТовара();
	
	Попытка
		Возврат ОбщегоНазначения_Сервер.ДеСериализовать(нСтрока.Штрихкоды)[0];
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция ПолучитьОписаниеТовара()
	
	нСтрока = ПолучитьСтрокуТовара();
	
	Результат = Товар + Символы.ПС + 
				ОбщегоНазначения_Сервер.ПолучитьСтроковоеПредставлениеМассива(ОбщегоНазначения_Сервер.ДеСериализовать(нСтрока.Штрихкоды)) + Символы.ПС + 
				//"Ошибка: " + УправлениеСборками_Сервер.НормироватьКомментарий(нСтрока.Комментарий) + Символы.ПС + 
				"Учет - " + нСтрока.КоличествоУчет + Символы.ПС + 
				"Факт - " + нСтрока.Количество + Символы.ПС +
				ОбщегоНазначения_Сервер.СформироватьТекстовыеДанныеОУценке(нСтрока.Штрихкод); 
				
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПолучитьТоварПоСписку(НаправлениеПоиска)
	
	нСтрока = ПолучитьСтрокуТовара();
	
	СледИндекс = Сборка.Товары.Индекс(нСтрока) + ?(НаправлениеПоиска = "След", 1, -1);
	
	Если СледИндекс<0 Или СледИндекс>=Сборка.Товары.Количество() Тогда
		Сообщить("Это последний элемент");
	Иначе
		тСтрока = Сборка.Товары[СледИндекс];
		товар = тСтрока.Название;
		Штрихкод = тСтрока.Штрихкод;
		Идентификатор = тСтрока.Идентификатор;
		СпецШтрихкод = ?(ОбщегоНазначения_Сервер.ЭтоСпецШтрихкод(Штрихкод), Штрихкод, "");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура предТовар(Команда)
	ПолучитьТоварПоСписку("Пред");
	ЗаполнитьДанныеПоТовару();
КонецПроцедуры

&НаКлиенте
Процедура следТовар(Команда)
	ПолучитьТоварПоСписку("След");
	ЗаполнитьДанныеПоТовару();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	УправлениеСборками_Сервер.ПроставитьКомментарииСогласноКоличеству(Сборка);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если _Маркировка Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	
КонецПроцедуры
