﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	МенеджерОборудования_Клиент.УстановитьКомпонентуСканераШК(ПараметрыСканера);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	МенеджерОборудования_Клиент.ОтключитьКомпоненту();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПараметрыСканера = ОбщегоНазначения_Сервер.ДеСериализовать(Константы.ПараметрыСканераШтрихкодовAndroid.Получить());
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ШК = ОбщегоНазначения_Сервер.НормироватьШтрихкод(Данные);
	
	ПолучитьДанныеПоШК(ШК);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПоШК(пШК)
	
	ОбновитьКартинку(пШК);
	ОбновитьИнформациюПоШК(пШК);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКартинку(пШК)
	ДвоичныеДанныеКартинка=API.ПолучитьКартинку(пШК);
	СсылкаВХ=ПоместитьВоВременноеХранилище(ДвоичныеДанныеКартинка,Новый УникальныйИдентификатор);
	СсылкаНаКартинку = СсылкаВХ;
	Элементы.СсылкаНаКартинку.РазмерКартинки = РазмерКартинки.Пропорционально;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюПоШК(пШК)
	
	Результат = api.ПолучитьИнформациюОТовареПодробную(ОбщегоНазначения_Сервер.Сериализовать(Новый Структура("barcode", пШК)));
	
	Если ТипЗнч(Результат) = Тип("Структура") и Результат.Свойство("Ошибка") Тогда
		Сообщить(Результат.Ошибка);
	Иначе
		Информация = "" + ?(Результат.mark, "Маркировка!", "") + Символы.ПС + Результат.name + Символы.ПС;
		Для Каждого тШК Из Результат.barcodes Цикл
			Информация = Информация + тШК + Символы.ПС;
		КонецЦикла;
		Информация = Информация + "Цена - " + Результат.price + Символы.ПС 
				   + ?(Результат.promoPrice = 0, "", "По акции - " + Результат.promoPrice + Символы.ПС)
				   + "Остаток - " + Результат.stockShop + Символы.ПС
				   + "На транзите - " + Результат.stockTransit;
				   
		Элементы.ИнформацияОТоваре.Заголовок = Информация;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВвестиШК(Команда)
	тСтрока = "";
	ПоказатьВводСтроки(Новый ОписаниеОповещения("ПослеВводаШКВручную", ЭтаФорма), тСтрока, "Введите штрихкод");
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаШКВручную(Результат, ДопПараметры) Экспорт
	
	ПолучитьДанныеПоШК(Результат);
	
КонецПроцедуры