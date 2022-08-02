﻿
&НаСервере
Процедура ЗаписатьНастройкиСборки(пАвтовводЕдиницы)
	Константы.НастройкиСборки.Установить(ОбщегоНазначения_Сервер.Сериализовать(Новый Структура("АвтовводЕдиницы", пАвтовводЕдиницы)));
КонецПроцедуры

&НаКлиенте
Процедура АвтовводЕдиницыПриИзменении(Элемент)
	ЗаписатьНастройкиСборки(АвтовводЕдиницы);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекПараметры	 = ОбщегоНазначения_Сервер.ДеСериализовать(Константы.НастройкиСборки.Получить());
	АвтовводЕдиницы	 = ТекПараметры.АвтовводЕдиницы;
	
КонецПроцедуры
