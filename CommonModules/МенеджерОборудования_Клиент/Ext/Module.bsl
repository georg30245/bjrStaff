﻿
Процедура УстановитьКомпонентуСканераШК(ПараметрыСканера) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеУстановкиВнешнейКомпоненты", ЭтотОбъект, ПараметрыСканера);

	НачатьУстановкуВнешнейКомпоненты(Оповещение, "ОбщийМакет.ДрайверСканераШтрихкодовAndroid");

КонецПроцедуры

Процедура ПослеУстановкиВнешнейКомпоненты(ДопПараметры) Экспорт 
	
	НачатьПодключениеВнешнейКомпоненты(Новый ОписаниеОповещения("ПослеПодключенияВнешнейКомпоненты", ЭтотОбъект, ДопПараметры), "ОбщийМакет.ДрайверСканераШтрихкодовAndroid", "com_ptolkachev_AndroidScannerExtension", ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

Процедура ПослеПодключенияВнешнейКомпоненты(Результат, ДопПараметры) Экспорт 
	
	ProgID = "AddIn.com_ptolkachev_AndroidScannerExtension.com_ptolkachev_AndroidScannerExtension";
	глОбъектДрайвера = Новый(ProgID);
	
	глОбъектДрайвера.УстановитьПараметр("ActionName", ДопПараметры.ActionName);
	глОбъектДрайвера.УстановитьПараметр("ExtraData", ДопПараметры.ExtraData);

	ПодключитьКомпоненту();
	
КонецПроцедуры

Процедура ПодключитьКомпоненту() Экспорт
	глОбъектДрайвера.Подключить("");
КонецПроцедуры

Процедура ОтключитьКомпоненту()  Экспорт
	глОбъектДрайвера.Отключить("");
КонецПроцедуры

Функция ПолучитьВидКода(пШК) Экспорт 
	
	Если СтрДлина(пШК) >= 31 Тогда
		Результат = "DataMatrix";
	Иначе
		Результат = "Barcode";
	КонецЕсли;
	
КонецФункции

Функция НормироватьКодDataMatrix(КодDataMatrix) Экспорт
	
	//КМ = 01 + gtin(14) + 21 + sn(13)	
	Результат = Строка(КодDataMatrix);
	
	Результат = СтрЗаменить(Результат, Символы.ПС, "");
	Результат = СтрЗаменить(Результат, Символы.ВК, "");
	
	Пока Лев(Результат, 1) <> "(" и Лев(Результат, 1) <> "0"  Цикл
		Результат = Прав(Результат, СтрДлина(Результат)-1);
		Если Не ЗначениеЗаполнено(Результат) Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Лев(Результат, 1) = Символ(29) ТОгда
		Результат = Прав(Результат, СтрДлина(Результат)-1);
	КонецЕсли;
	
	Если Прав(Результат, 1) = Символ(29) ТОгда
		Результат = Лев(Результат, СтрДлина(Результат)-1);
	КонецЕсли;
	
	//иногда 01 и 21 помещают в скобки - проверим и избавимся
	Если Сред(Результат, 1, 1) = "(" Тогда
		Результат = Прав(Результат, СтрДлина(Результат) - 1);
		
		Если Сред(Результат, 3, 1) = ")" Тогда
			Результат = Лев(Результат, 2) + Прав(Результат, СтрДлина(Результат) - 3);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Сред(Результат, 17, 1) = "(" Тогда
		Результат = Лев(Результат, 16) + Прав(Результат, СтрДлина(Результат) - 17);
		
		Если Сред(Результат, 19, 1) = ")" Тогда
			Результат = Лев(Результат, 18) + Прав(Результат, СтрДлина(Результат) - 19);
		КонецЕсли;
	КонецЕсли;
	
	//Выведем ошибку пользователю - Может кто внимательный увидит и скажет, отловим ошибку
	Если Лев(Результат, 2) <> "01" Тогда ПоказатьПредупреждение(,"В начале кода не указан разделитель 01"); КонецЕсли;
	Если Сред(Результат, 17, 2) <> "21" Тогда ПоказатьПредупреждение(,"Не указан разделитель 21"); КонецЕсли;
	
	Результат = Лев(Результат, 31);
	
	Возврат Результат;
	
КонецФункции
