
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыСканера = ОбщегоНазначения_Сервер.ДеСериализовать(Константы.ПараметрыСканераШтрихкодовAndroid.Получить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудования_Клиент.УстановитьКомпонентуСканераШК(ПараметрыСканера);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	МенеджерОборудования_Клиент.ОтключитьКомпоненту();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВводМаркировки(КодМаркировки)
	
	//КодДМ = МенеджерОборудования_Клиент.НормироватьКодDataMatrix(КодМаркировки);
	//
	//Если СтрДлина(КодДМ) <> 31 Тогда
	//	ЭтаФорма.Закрыть(Новый Структура("Код, Ошибка", КодДМ, "Некорректная длина кода маркировки"));
	//	Возврат;
	//КонецЕсли;
	//
	//Для Каждого ЭлементСписка Из ДоступнаяМаркировка Цикл
	//	Если Лев(ЭлементСписка.Значение, 31) = КодДМ Тогда
	//		ЭтаФорма.Закрыть(Новый Структура("Код, Ошибка", КодДМ, ""));
	//		Возврат;
	//	КонецЕсли;
	//КонецЦикла;
	
	Попытка МенеджерОборудования_Клиент.ОтключитьКомпоненту(); Исключение КонецПопытки;
	ЭтаФорма.Закрыть(Новый Структура("Код", КодМаркировки));
	//Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если не ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	Если Строка(Событие) = "Штрихкод" Тогда
		
		ОбработатьВводМаркировки(Данные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура тест_ВводМаркировки(Команда)
	ОбработатьВводМаркировки(ТестМаркировка);
КонецПроцедуры
