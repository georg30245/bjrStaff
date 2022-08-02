﻿
Функция ПолучитьРезультатЗапросаГет(Запрос)
	
	НастройкиАПИ = ПолучитьНастройкиAPI();
	
	Попытка
		HTTP = Новый HTTPСоединение(НастройкиАПИ.Сервер,НастройкиАПИ.Порт,,,,150,);
		
		Запрос = Новый HTTPЗапрос(НастройкиАПИ.Ресурс + Запрос);
		Запрос.Заголовки.Вставить("1c_usr_token", НастройкиАПИ.Токен);
		
		Возврат HTTP.Получить(запрос).ПолучитьТелоКакСтроку();
	Исключение
		Попытка
			HTTP = Новый HTTPСоединение(НастройкиАПИ.ДополнительныйСервер,НастройкиАПИ.Порт,,,,150,);
			
			Запрос = Новый HTTPЗапрос(НастройкиАПИ.Ресурс + Запрос);
			Запрос.Заголовки.Вставить("1c_usr_token", НастройкиАПИ.Токен);
			
			Возврат HTTP.Получить(запрос).ПолучитьТелоКакСтроку();
		Исключение
		КонецПопытки;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьРезультатЗапросаПост(Запрос, ТелоЗапроса)
	
	НастройкиАПИ = ПолучитьНастройкиAPI();
	
	Попытка
		HTTP = Новый HTTPСоединение(НастройкиАПИ.Сервер,НастройкиАПИ.Порт,,,,150,);
		
		Запрос = Новый HTTPЗапрос(НастройкиАПИ.Ресурс + Запрос);
		Запрос.Заголовки.Вставить("1c_usr_token", НастройкиАПИ.Токен);
		
		Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);
		
		Возврат HTTP.ВызватьHTTPМетод("POST", Запрос).ПолучитьТелоКакСтроку();
	Исключение
		Попытка
			HTTP = Новый HTTPСоединение(НастройкиАПИ.ДополнительныйСервер,НастройкиАПИ.Порт,,,,150,);
			
			Запрос = Новый HTTPЗапрос(НастройкиАПИ.Ресурс + Запрос);
			Запрос.Заголовки.Вставить("1c_usr_token", НастройкиАПИ.Токен);
			
			Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);
			
			Возврат HTTP.ВызватьHTTPМетод("POST", Запрос).ПолучитьТелоКакСтроку();
		Исключение
		КонецПопытки;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьНастройкиAPI()
	Возврат ОбщегоНазначения_Сервер.ДеСериализовать(Константы.ГлобальныеНастройки.Получить());
КонецФункции

Функция ВыполнитьМетодGET(Метод)
	Попытка
		Ответ = ПолучитьРезультатЗапросаГет(Метод);
		Ответ = ОбщегоНазначения_Сервер.ДеСериализовать(Ответ);
		Возврат Ответ;
	Исключение
		Возврат Новый Структура("Ошибка", Ответ);
	КонецПопытки;
КонецФункции

Функция ВыполнитьМетодPOST(Метод, Тело)
	Попытка
		Ответ = ПолучитьРезультатЗапросаПост(Метод, Тело);
		Ответ = ОбщегоНазначения_Сервер.ДеСериализовать(Ответ);
		Возврат Ответ;
	Исключение
		Возврат Новый Структура("Ошибка", Ответ);
	КонецПопытки;
КонецФункции

#Область МетодыАпиГет

Функция ПолучитьМагазинПоТокену() Экспорт

	Возврат ВыполнитьМетодGET("?querry=mobile_getShop");
	
КонецФункции

Функция ПолучитьМагазины() Экспорт

	Возврат ВыполнитьМетодGET("?querry=mobile_getShops");
	
КонецФункции

Функция ПолучитьТоварныеГруппы() Экспорт

	Возврат ВыполнитьМетодGET("?querry=mobile_getFoldersGoods");
	
КонецФункции

Функция ПолучитьПоступленияНаТранзитах() Экспорт

	Возврат ВыполнитьМетодGET("?querry=mobile_getTransitInvoices");
	
КонецФункции

Функция ПолучитьИнтернетЗаказыПокупателей() Экспорт

	Возврат ВыполнитьМетодGET("?querry=mobile_getWebOrders");

КонецФункции

Функция ПолучитьСборкиТовара() Экспорт
	
	Возврат ВыполнитьМетодGET("?querry=mobile_getProductsAssembly");
	
КонецФункции

Функция ПолучитьАктуальныеИнвентаризации() Экспорт
	
	Возврат ВыполнитьМетодGET("?querry=mobile_getInventories");
	
КонецФункции

Функция ПолучитьМаркировкуНаМагазине() Экспорт
	
	Возврат ВыполнитьМетодGET("?querry=mobile_getStockMark");
	
КонецФункции

#КонецОбласти

#Область МетодыАпиПост

Функция СверитьДанныеПоСборке(ТелоЗапроса) Экспорт

	Возврат ВыполнитьМетодPOST("?querry=mobile_checkingDocuments", ТелоЗапроса);
	
КонецФункции

Функция ОтработатьДанныеПоСборке(ТелоЗапроса) Экспорт 
	
	Возврат ВыполнитьМетодPOST("?querry=mobile_confirmReadiness", ТелоЗапроса);
	
КонецФункции

Функция ПолучитьТоварыДляСборки(ТелоЗапроса) Экспорт 
	
	Возврат ВыполнитьМетодPOST("?querry=mobile_getDataForAssembly", ТелоЗапроса);
	
КонецФункции

Функция ПолучитьИнформациюОТоваре(ТелоЗапроса) Экспорт
	
	Возврат ВыполнитьМетодPOST("?querry=mobile_getGoodByBarcode", ТелоЗапроса);
	
КонецФункции

Функция ПолучитьИнформациюОТовареПодробную(ТелоЗапроса) Экспорт
	Возврат ВыполнитьМетодPOST("?querry=mobile_getInfoGoodByBarcode", ТелоЗапроса);
КонецФункции

#КонецОбласти

#Область Картинки

Функция ПолучитьКартинку(Штрихкод, ШиринаК = Неопределено, ВысотаК = Неопределено) Экспорт 
	
	НастройкиАПИ = ПолучитьНастройкиAPI();
	
	HTTP = Новый HTTPСоединение(НастройкиАПИ.СерверКартинок,,,,,,Новый ЗащищенноеСоединениеOpenSSL);
	
	Параметры = ?(ЗначениеЗаполнено(ШиринаК) И ЗначениеЗаполнено(ВысотаК), "?w=" + ШиринаК + "&h=" + ВысотаК, "");
	Запрос = Новый HTTPЗапрос(СтрЗаменить(НастройкиАПИ.РесурсКартинок, "ШК", Штрихкод) + Параметры);
	Результат = HTTP.Получить(Запрос);
	
	Возврат Результат.ПолучитьТелоКакДвоичныеДанные();

КонецФункции

#КонецОбласти