package TNK::UserAccess;
#
# User Access, svsoldatov, 2003
#
# Access to Incidents DB should be matched with Inc_DBUserRegionAccess

%USERACCESS = (
	svs => {
		ACCESS => {
			WEBSHELL => "RW", #WebShell.cgi
			INSWIFI => "RW", #Insertion of wi-fi requests
			MACs => "RW", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			ISS_REP => "RW", #Access to ISS Site Protector Reports
			SAP => "RW", #Access SAP requests
			LOGONS => "RW", #Search LogonActivity
			UTILS => "RW", #Utils
			USER_UTILS => "RW", #DKB only
			CYBER_DIFF => "RW", #CYBERGUARD configs DIFF
			#SZ => "RW", #Sluzhebki
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			TST => "RW", #For tests and debugging
			FS => "RW", #File servers logs
			UU4CHOP => "RW", #Interface for CHOP (in/out laptops)
			UU4NAS => "R", #Menu for Nadezhda
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		ORDER => ['SAP','UTILS','USER_UTILS','AC_UTILS','UU4HD','UU4CHOP','CHPW','TST', 'UU4NAS', 'INCIDENTS'], #Order for links in UPPER menu
		WELCOME => 'Привет, USERNAME!', #Welcome string
		NAME => 'Sergey V. Soldatov', #Username
		FIO_RUS => 'Солдатов Сергей Владимирович',
		ADLOGIN => 'CORP\SVSoldatov', #Login in AD
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
				GLOBALINSTREDITOR => 1, #Can edit global instructions
				REGADMIN => 1, #Can edit regions
			},
			CANEDIT => ['.+'], # Perl regex for username whose SZ user can edit
			SZ_DATE => 'blank', # find sz with blank current date by default 
			PROJ => {
				ALLOW_DELETE => 1,#Allow delete projects
			},
		},
	},
	apbodrik => {
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			MACs => "RW", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			SAP => "RW", #Access SAP requests
			LOGONS => "RW", #Search LogonActivity
			UTILS => "RW", #Utils
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UU4CHOP => "RW", #Interface for CHOP (in/out laptops)
			UU4NAS => "R", #Menu for Nadezhda
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		ORDER => ['SAP','UTILS','USER_UTILS','AC_UTILS','UU4HD','UU4CHOP','CHPW','TST', 'UU4NAS', 'INCIDENTS'], #Order for links in UPPER menu
		WELCOME => 'Привет, USERNAME!', #Welcome string
		NAME => 'Alexander P. Bodrik', #Username
		FIO_RUS => 'Бодрик Александр Петрович',
		ADLOGIN => 'CORP\apbodrik', #Login in AD
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
				#GLOBALINSTREDITOR => 1, #Can edit global instructions
				#REGADMIN => 1, #Can edit regions
			},
		},
	},
	#dvtoloshniy => {
	#	ACCESS => {
	#		MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		AC_UTILS => "RW", #Other utils (Academic)
	#		UTILS => "RW", #Utils
	#		LOGONS => "R", #Search LogonActivity
	#		USER_UTILS => "RW", #DKB only
	#		CHPW => "RW", #Change Password
	#		INCIDENTS => "RW", #Incidents
	#		DESC2LOGIN => "RW", #Translate Description to Login and vise versa
	#	},
	#	ORDER => ['INCIDENTS','UTILS','USER_UTILS','AC_UTILS','CHPW'], #Order for links in UPPER menu
	#	NAME => 'Денис',
	#	FIO_RUS => 'Толошный Денис Васильевич',
	#	ADLOGIN => 'CORP\DVToloshniy',
	#	OPTIONS => { #Optional scripts parameters (if needed)
	#		INC => {
	#			REG => 1, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	vaburdasov => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			UTILS => "RW", #Utils
			LOGONS => "R", #Search LogonActivity
			CYBER_DIFF => "RW", #CYBERGUARD configs DIFF
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		ORDER => ['INCIDENTS','UTILS','USER_UTILS','AC_UTILS','CHPW'], #Order for links in UPPER menu
		NAME => 'Слава',
		FIO_RUS => 'Бурдасов Вячеслав Алесандрович',
		ADLOGIN => 'CORP\VABurdasov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	avkoval => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			SAP => "RW", #Access SAP requests
			UTILS => "RW", #Utils
			LOGONS => "R", #Search LogonActivity
			CYBER_DIFF => "RW", #CYBERGUARD configs DIFF
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			##FS => "RW", #File servers logs
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		ORDER => ['SAP','UTILS','USER_UTILS','AC_UTILS','UU4HD','CHPW','INCIDENTS'], #Order for links in UPPER menu
		NAME => 'Алексей',
		FIO_RUS => 'Коваль Алексей Валерьевич',
		ADLOGIN => 'CORP\avkoval',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	ssv => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			SAP => "RW", #Access SAP requests
			UTILS => "RW", #Utils
			LOGONS => "R", #Search LogonActivity
			CYBER_DIFF => "RW", #CYBERGUARD configs DIFF
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			##FS => "RW", #File servers logs
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		ORDER => ['SAP','UTILS','USER_UTILS','AC_UTILS','UU4HD','CHPW','INCIDENTS'], #Order for links in UPPER menu
		NAME => 'Сергей',
		FIO_RUS => 'Шумов Сергей Викторович',
		ADLOGIN => 'CORP\SVShumov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
				GLOBALINSTREDITOR => 1, #Can edit global instructions
				REGADMIN => 1, #Can edit regions
			},
		},
	},
	ivkorenevskiy => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			UTILS => "RW", #Utils
			LOGONS => "R", #Search LogonActivity
			USER_UTILS => "RW", #DKB only
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			##DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Игорь',
		FIO_RUS => 'Кореневский Игорь Владимирович',
		ADLOGIN => 'CORP\IVKorenevskiy',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	## Mobile communication section
	empleshkov => {
		ACCESS => {
			USER_UTILS => "R", #DKB only
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		FIO_RUS => 'Плешков Евгений Михайлович',
		NAME => 'Евгений',
		ADLOGIN => 'CORP\empleshkov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
			SZ_DATE => 'blank', # find sz with blank current date by default
		},
	},
	#vmgolubkov => {
	#	ACCESS => {
	#		USER_UTILS => "R", #DKB only
	#		CHPW => "RW", #Change Password
	#		DESC2LOGIN => "RW", #Translate Description to Login and vise versa
	#	},
	#	FIO_RUS => 'Голубков Виктор Михайлович',
	#	NAME => 'Виктор',
	#	ADLOGIN => 'CORP\vmgolubkov',
	#	OPTIONS => { #Optional scripts parameters (if needed)
	#		INC => {
	#			REG => 1, # Must be syncronized with Inc_DBUserRegions
	#		},
	#		SZ_DATE => 'blank', # find sz with blank current date by default
	#	},
	#},
	## Regionals
	# Irkutsk
	avmisnik => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Алексей',
		FIO_RUS => 'Мисник Алексей Викторович',
		ADLOGIN => 'CORP\avmisnik',
		OPTIONS => {
			INC => {
				REG => 18, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Ryazan
	rrgatiatulin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Радик',
		FIO_RUS => 'Гатиатулин Радик Рифкатович',
		ADLOGIN => 'CORP\rrgatiatulin',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	kpkorneev => { # 20 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Константин',
		FIO_RUS => 'Корнеев Константин Павлович',
		ADLOGIN => 'CORP\KPKorneev',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	kykadushkin => { # 20 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Костя',
		FIO_RUS => 'Кадушкин Константин Юрьевич',
		ADLOGIN => 'CORP\KYKadushkin',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
				REGADMIN => 1, #Can edit regions
			},
		},
	},
	#dvkraynov => { # 14 rows
	#	ACCESS => {
	#		INCIDENTS => "RW", #Incidents
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Дмитрий',
	#	FIO_RUS => 'Крайнов Дмитрий Валерьевич',
	#	ADLOGIN => 'CORP\DVKraynov',
	#	OPTIONS => {
	#		INC => {
	#			REG => 15, # (here Saratov) Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	dnlysenko => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Дмитрий',
		FIO_RUS => 'Лысенко Дмитрий Николаевич',
		ADLOGIN => 'CORP\dnlysenko',
		OPTIONS => {
			INC => {
				REG => 15, # (here Saratov) Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	ganovikov => { # 18 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Геннадий',
		FIO_RUS => 'Новиков Геннадий Александрович',
		ADLOGIN => 'CORP\GANovikov',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#aazemskov => { # 18 rows
	#	ACCESS => {
	#		INCIDENTS => "RW", #Incidents
	#		AC_UTILS => "RW", #Other utils (Academic)
	#		CHPW => "RW", #Change Password
	#		DESC2LOGIN => "RW", #Translate Description to Login and vise versa
	#	},
	#	NAME => 'Андрей',
	#	FIO_RUS => 'Земсков Андрей Александрович',
	#	ADLOGIN => 'CORP\AAZemskov',
	#	OPTIONS => {
	#		INC => {
	#			REG => 7, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	askiryakin => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Александр',
		FIO_RUS => 'Кирякин Александр Сергеевич',
		ADLOGIN => 'CORP\ASKiryakin',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	avponomarev3 => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Андрей',
		FIO_RUS => 'Пономарев Андрей Владимирович',
		ADLOGIN => 'CORP\avponomarev3',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dmtazetdinov => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Денис',
		FIO_RUS => 'Тазетдинов Денис Миннисламович',
		ADLOGIN => 'CORP\dmtazetdinov',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	vbkropotov => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Владимир',
		FIO_RUS => 'Кропотов Владимир',
		ADLOGIN => 'CORP\vbkropotov',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	snmolchanov => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Сергей',
		FIO_RUS => 'Молчанов Сергей Николаевич',
		ADLOGIN => 'CORP\SNMolchanov',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#mavartanyan => { # 18 rows
	#	ACCESS => {
	#		UTILS => "R", #Utils
	#		LOGONS => "RW", #Search LogonActivity
	#		INCIDENTS => "RW", #Incidents
	#		AC_UTILS => "RW", #Other utils (Academic)
	#		CHPW => "RW", #Change Password
	#		DESC2LOGIN => "RW", #Translate Description to Login and vise versa
	#	},
	#	NAME => 'Михаил',
	#	FIO_RUS => 'Вартанян Михаил Александрович',
	#	ADLOGIN => 'CORP\MAVartanyan',
	#	OPTIONS => {
	#		INC => {
	#			REG => 7, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	mapavlunin => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Максим',
		FIO_RUS => 'Павлунин Максим Анатольевич',
		ADLOGIN => 'CORP\MAPavlunin',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	aysavchuk => { # 18 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Артем',
		FIO_RUS => 'Савчук Артем Юрьевич',
		ADLOGIN => 'CORP\AYSavchuk',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	amtazetdinov => { # 19 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			AC_UTILS => "RW", #Other utils (Academic)
			CHPW => "RW", #Change Password
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Альберт',
		FIO_RUS => 'Тазетдинов Альберт Миннисламович',
		ADLOGIN => 'CORP\amtazetdinov',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dekatyshkin => { 
		ACCESS => {
			UTILS => "RW", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
			AC_UTILS => "RW", #Other utils (Academic)
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Дмитрий',
		FIO_RUS => 'Катышкин Дмитрий Евгеньевич',
		ADLOGIN => 'CORP\DEKatyshkin',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
				REGADMIN => 1, #Can edit regions
			},
		},
	},
	oabobrov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
			AC_UTILS => "RW", #Other utils (Academic)
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Олег',
		FIO_RUS => 'Бобров Олег Анатольевич',
		ADLOGIN => 'CORP\OABobrov',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dvkartsev => { # 14 rows
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "RW", #Search LogonActivity
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
			AC_UTILS => "RW", #Other utils (Academic)
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			DESC2LOGIN => "RW", #Translate Description to Login and vise versa
		},
		NAME => 'Дмитрий ',
		FIO_RUS => 'Карцев Дмитрий Владимирови',
		ADLOGIN => 'CORP\DVKartsev',
		OPTIONS => {
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Ekaterinburg
	#eeshadrin => { # 14 rows
	#	ACCESS => {
	#		INCIDENTS => "RW", #Incidents
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Евгений',
	#	FIO_RUS => 'Шадрин Евгений Евгеньевич',
	#	ADLOGIN => 'CORP\eeshadrin',
	#	OPTIONS => {
	#		INC => {
	#			REG => 20, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	# Saratov
	avkaryabkin=> { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Алексей',
		FIO_RUS => 'Карябкин Алексей Валерьевич',
		ADLOGIN => 'CORP\avkaryabkin',
		OPTIONS => {
			INC => {
				REG => 15, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	asmartakov => { # 14 rows
	ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Александр',
		FIO_RUS => 'Мартаков Александр Сергеевич',
		ADLOGIN => 'CORP\asmartakov',
		OPTIONS => {
			INC => {
				REG => 15, # Must be syncronized with Inc_DBUserRegions
			 },
		 },
	 },
	avkochetkov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Андрей',
		FIO_RUS => 'Кочетков Андрей Вячеславович',
		ADLOGIN => 'CORP\avkochetkov',
		OPTIONS => {
			INC => {
				REG => 15, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	avbutko => { # 14 rows
		ACCESS => {
			SAP => "RW", #Access SAP requests
			INSWIFI => "RW", #Insertion of wi-fi requests
			##UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Алексей',
		FIO_RUS => 'Бутко Алексей Валерьевич',
		ADLOGIN => 'CORP\avbutko',
		OPTIONS => {
			INC => {
				REG => 15, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	kastrelyuhin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Кирилл',
		FIO_RUS => 'Стрелюхин Кирилл Аркадьевич',
		ADLOGIN => 'CORP\kastrelyuhin',
		OPTIONS => {
			INC => {
				REG => 15, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Orenburg
	outamodlin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Олег',
		FIO_RUS => 'Тамодлин Олег Юрьевич',
		ADLOGIN => 'CORP\outamodlin',
		OPTIONS => {
			INC => {
				REG => 3, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},

	gvfilatova => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		 },
		  NAME => 'Галина',
		  FIO_RUS => 'Филатова Галина Викторовна',
		  ADLOGIN => 'CORP\gvfilatova',
		  OPTIONS => {
		  	INC => {
				REG => 3, # Must be syncronized with Inc_DBUserRegions
			},
		},
	 },

	aapopova => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Анастасия',
		FIO_RUS => 'Попова Анастасия Александровна',
		ADLOGIN => 'CORP\AAPopova',
		OPTIONS => {
			 INC => {
		 		REG => 3, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	aayurtaeva => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Анастасия',
		FIO_RUS => 'Юртаева Анастасия Александровна',
		ADLOGIN => 'CORP\aayurtaeva',
		OPTIONS => {
			 INC => {
		 		REG => 3, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	damartyinov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Дмитрий',
		FIO_RUS => 'Мартынов Дмитрий Александрович',
		ADLOGIN => 'CORP\damartyinov',
		OPTIONS => {
			INC => {
				REG => 3, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dsyurtaev => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Дмитрий',
		FIO_RUS => 'Юртаев Дмитрий Сергеевич',
		ADLOGIN => 'CORP\dsyurtaev',
		OPTIONS => {
			INC => {
				REG => 3, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Novosibirsk
	iachechulina => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Инна',
		FIO_RUS => 'Чечулина Инна Анатольевна',
		ADLOGIN => 'CORP\iachechulina',
		OPTIONS => {
			INC => {
				REG => 9, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dvtsybizov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Дмитрий',
		FIO_RUS => 'Цыбизов Дмитрий Валентинович',
		ADLOGIN => 'CORP\dvtsybizov',
		OPTIONS => {
			INC => {
				REG => 9, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	yfsnitko => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Юрий',
		FIO_RUS => 'Снытко Юрий Феликсович',
		ADLOGIN => 'CORP\yfsnitko',
		OPTIONS => {
			INC => {
				REG => 9, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	aabaranov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Александр',
		FIO_RUS => 'Баранов Александр Александрович',
		ADLOGIN => 'CORP\aabaranov',
		OPTIONS => {
			INC => {
				REG => 9, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Kiev
	spzabelin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Сергей',
		FIO_RUS => 'Забелин Сергей Павлович',
		ADLOGIN => 'CORP\spzabelin',
		OPTIONS => {
			INC => {
				REG => 22, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	iaafonin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Игорь',
		FIO_RUS => 'Афонин Игорь Анатольевич',
		ADLOGIN => 'CORP\iaafonin',
		OPTIONS => {
			INC => {
				REG => 22, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Lisichansk
	vatkachenko => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Валерий',
		FIO_RUS => 'Ткаченко Валерий Анатольевич',
		ADLOGIN => 'CORP\vatkachenko',
		OPTIONS => {
			INC => {
				REG => 23, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# TNNC
	mvhoroshih => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Михаил',
		FIO_RUS => 'Хороших Михаил Валерьевич',
		ADLOGIN => 'CORP\MVHoroshih',
		OPTIONS => {
			INC => {
				REG => 8, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	nstorkhov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Николай',
		FIO_RUS => 'Торхов Николай Сергеевич',
		ADLOGIN => 'CORP\nstorkhov',
		OPTIONS => {
			INC => {
				REG => 4, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	onvershinina => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Оксана',
		FIO_RUS => 'Вершинина Оксана Николаевна',
		ADLOGIN => 'CORP\onvershinina',
		OPTIONS => {
			INC => {
				REG => 4, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dnkorobeynikov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Денис',
		FIO_RUS => 'Коробейников Денис Николаевич',
		ADLOGIN => 'CORP\dnkorobeynikov',
		OPTIONS => {
			INC => {
				REG => 4, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Tyumen
	aslysov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Александр',
		FIO_RUS => 'Лысов Александр Сергеевич',
		ADLOGIN => 'CORP\aslysov',
		OPTIONS => {
			INC => {
				REG => 8, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	tnsusoev => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Тарас',
		FIO_RUS => 'Сусоев Тарас Николаевич',
		ADLOGIN => 'CORP\tnsusoev',
		OPTIONS => {
			INC => {
				REG => 8, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	adkhramtsov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Андрей',
		FIO_RUS => 'Храмцов Андрей Дмитриевич',
		ADLOGIN => 'CORP\adkhramtsov',
		OPTIONS => {
			INC => {
				REG => 8, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	uagrotskova => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Ульяна',
		FIO_RUS => 'Гроцкова Ульяна Анатольевна',
		ADLOGIN => 'CORP\uagrotskova',
		OPTIONS => {
			INC => {
				REG => 8, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#anvelichko => { # 14 rows
	#	ACCESS => {
	#		INCIDENTS => "RW", #Incidents
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Андрей',
	#	FIO_RUS => 'Величко Андрей Николаевич',
	#	ADLOGIN => 'CORP\anvelichko',
	#	OPTIONS => {
	#		INC => {
	#			REG => 8, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	rfbekshenev => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Руслан',
		FIO_RUS => 'Бекшенев Руслан Фаритович',
		ADLOGIN => 'CORP\rfbekshenev',
		OPTIONS => {
			INC => {
				REG => 8, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Nizhnevartovsk
	svvarzakov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Станислав',
		FIO_RUS => 'Варзаков Станислав Викторович',
		ADLOGIN => 'CORP\svvarzakov',
		OPTIONS => {
		 	INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			 },
		},
	},
	vvgroshevoy => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Василий',
		FIO_RUS => 'Грошевой Василий Васильевич',
		ADLOGIN => 'CORP\vvgroshevoy',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	mvvoronin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Михаил',
		FIO_RUS => 'Воронин Михаил Валерьевич',
		ADLOGIN => 'CORP\mvvoronin',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	tadomasheva => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Татьяна',
		FIO_RUS => 'Домашева Татьяна Александровна',
		ADLOGIN => 'CORP\tadomasheva',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	oslyashenko => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Оксана',
		FIO_RUS => 'Ляшенко Оксана Сергеевна',
		ADLOGIN => 'CORP\oslyashenko',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	emkrasilnikov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Евгений',
		FIO_RUS => 'Красильников Евгений Михайлович',
		ADLOGIN => 'CORP\EMKrasilnikov',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	avvaver => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Александр',
		FIO_RUS => 'Вавер Александр Викторович',
		ADLOGIN => 'CORP\avvaver',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	ausamoilov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Андрей',
		FIO_RUS => 'Самойлов Андрей Юрьевич',
		ADLOGIN => 'CORP\ausamoilov',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#dnnitsenko => { # 14 rows
	#	ACCESS => {
	#		INCIDENTS => "RW", #Incidents
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Денис',
	#	FIO_RUS => 'Ниценко Денис Николаевич',
	#	ADLOGIN => 'CORP\dnnitsenko',
	#	OPTIONS => {
	#		INC => {
	#			REG => 2, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	ynsilyaev => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Юрий',
		FIO_RUS => 'Силяев Юрий Николаевич',
		ADLOGIN => 'CORP\ynsilyaev',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	nnvaskovskaya => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Надежда',
		FIO_RUS => 'Васьковская Надежда Николаевна',
		ADLOGIN => 'CORP\NNVaskovskaya',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	vvsemenov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Владимир',
		FIO_RUS => 'Семенов Владимир Вениаминович',
		ADLOGIN => 'CORP\VVSemenov',
		OPTIONS => {
			INC => {
				REG => 2, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Kursk
	lnsamsonov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Леонид',
		FIO_RUS => 'Самсонов Леонид Николаевич',
		ADLOGIN => 'CORP\lnsamsonov',
		OPTIONS => {
			INC => {
				REG => 13, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Krasnoyarsk
	avgolovan => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Андрей',
		FIO_RUS => 'Головань Андрей Владимирович',
		ADLOGIN => 'CORP\avgolovan',
		OPTIONS => {
			INC => {
				REG => 17, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# Petrozavodsk
	imrybin => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Илья',
		FIO_RUS => 'Рыбин Илья Михайлович',
		ADLOGIN => 'CORP\imrybin',
		OPTIONS => {
			INC => {
				REG => 14, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	# NovyUrengoy
	antimoshenko => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Александр',
		FIO_RUS => 'Тимошенко Александр Николаеви',
		ADLOGIN => 'CORP\ANTimoshenko',
		OPTIONS => {
			INC => {
				REG => 10, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	oysavinov => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Олег',
		FIO_RUS => 'Савинов Олег Юрьевич',
		ADLOGIN => 'CORP\oysavinov',
		OPTIONS => {
			INC => {
				REG => 10, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	rpsoymkin2 => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Руслан',
		FIO_RUS => 'Сёмкин Руслан Петрович',
		ADLOGIN => 'CORP\rpsoymkin2',
		OPTIONS => {
			INC => {
				REG => 10, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	avschenyatskiy => { # 14 rows
		ACCESS => {
			INCIDENTS => "RW", #Incidents
			CHPW => "RW", #Change Password
		},
		NAME => 'Алексей',
		FIO_RUS => 'Щеняцкий Алексей Викторович',
		ADLOGIN => 'CORP\avschenyatskiy',
		OPTIONS => {
			INC => {
				REG => 10, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	## Regionals
	ruslan => { #Ruslan Matvienko
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			UTILS => "R", #Utils
			LOGONS => "R", #Search LogonActivity
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Ruslan',
		ADLOGIN => 'CORP\RVMatvienko',
	},
	noc => { #NOC
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			UTILS => "R", #Utils
			LOGONS => "R", #Search LogonActivity
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Уважаемые сетевые администраторы',
		ADLOGIN => 'CORP\NOC',
	},
	aalileev => { #Andrey Lileev
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			UTILS => "R", #Utils
			LOGONS => "R", #Search LogonActivity
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Andrey',
		ADLOGIN => 'CORP\AALileev',
	},
	#avbokhan => { #Andrey Bokhan
	#	ACCESS => {
	#		MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		#UTILS => "R", #Utils
	#		LOGONS => "R", #Search LogonActivity
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#		DESC2LOGIN => "R", #Translate Description to Login and vise versa
	#	},
	#	NAME => 'Andrey',
	#	ADLOGIN => 'CORP\AVBokhan',
	#},
	#vnshkapin => {
	#	ACCESS => {
	#		UTILS => "R", #Utils
	#		USER_UTILS => "R", #DKB only
	#		CHPW => "RW", #Change Password
	#		DESC2LOGIN => "R", #Translate Description to Login and vise versa
	#	},
	#	NAME => 'Валерий',
	#	FIO_RUS => 'Шкапин Валерий Николаевич',
	#	WELCOME => 'Привет, USERNAME!', #Welcome string
	#	ADLOGIN => 'CORP\VNShkapin',
	#},
	avs => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			UTILS => "RW", #Utils
			LOGONS => "R", #Search LogonActivity
			CYBER_DIFF => "RW", #CYBERGUARD configs DIFF
			USER_UTILS => "RW", #DKB only
			UU4HD => "R", #User utils for helpdesk
			FS => "R", #File servers logs
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		ORDER => ['SAP','UTILS','USER_UTILS','AC_UTILS','UU4HD','CHPW','INCIDENTS'], #Order for links in UPPER menu
		NAME => 'Alexey V. Soloviev',
		FIO_RUS => 'Соловьев Алексей Владимирович',
		ADLOGIN => 'CORP\AVSoloviev',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	iykukhtenkov => {
		ACCESS => {
			UTILS => "R", #Utils
			LOGONS => "R", #Search LogonActivity
			USER_UTILS => "RW", #DKB only
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		ORDER => ['UTILS','USER_UTILS','CHPW','INCIDENTS'], #Order for links in UPPER menu
		NAME => 'Igor Y Kukhtenkov',
		FIO_RUS => 'Кухтенков Игорь Юрьевич',
		ADLOGIN => 'CORP\IYKukhtenkov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	vgpertsel => {
		ACCESS => {
			LOGONS => "R", #Search LogonActivity
			USER_UTILS => "RW", #DKB only
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		ORDER => ['INCIDENTS','CHPW','USER_UTILS'], #Order for links in UPPER menu
		NAME => 'Vyacheslav G Pertsel',
		FIO_RUS => 'Перцель Вячеслав Георгиевич',
		ADLOGIN => 'CORP\VGPertsel',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#matarko => {
	#	ACCESS => {
	#		SAP => "RW", #Access SAP requests
	#		CHPW => "RW", #Change Password
	#		UTILS => "R", #Utils
	#		USER_UTILS => "RW", #DKB only
	#		INCIDENTS => "RW", #Incidents
	#		LOGONS => "RW", #Search LogonActivity
	#		DESC2LOGIN => "R", #Translate Description to Login and vise versa
	#		TST => "RW", #For tests and debugging
	#	},
	#	NAME => 'Миша',
	#	WELCOME => 'Здравствуй, USERNAME!',
	#	FIO_RUS => 'Тарко Михаил Александрович',
	#	ADLOGIN => 'CORP\MATarko',
	#	OPTIONS => { #Optional scripts parameters (if needed)
	#		INC => {
	#			REG => 1, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	oskaraseva => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			CHPW => "RW", #Change Password
			UTILS => "RW", #Utils
			USER_UTILS => "RW", #DKB only
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Ольга',
		WELCOME => 'Здравствуй, USERNAME!',
		FIO_RUS => 'Карасева Ольга Сергеевна',
		ADLOGIN => 'CORP\OSKaraseva',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	wing => {
		ACCESS => {
			UTILS => "R",
			AC_UTILS => "RW", #Other utils (Academic)
			USER_UTILS => "RW",
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			LOGONS => "R", #Search LogonActivity
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Alexandr F. Kurov',
		FIO_RUS => 'Куров Александр Федорович',
		WELCOME => 'Привет, USERNAME!',
		ADLOGIN => 'CORP\AFKurov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	pbgrachev => {
		ACCESS => {
			UTILS => "R",
			AC_UTILS => "RW", #Other utils (Academic)
			USER_UTILS => "RW",
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			LOGONS => "R", #Search LogonActivity
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Pavel B. Grachev',
		FIO_RUS => 'Грачев Павел Борисович',
		WELCOME => 'Привет, USERNAME!',
		ADLOGIN => 'CORP\pbgrachev',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	askonoplev => {
		ACCESS => {
			UTILS => "R",
			AC_UTILS => "RW", #Other utils (Academic)
			USER_UTILS => "RW",
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			LOGONS => "R", #Search LogonActivity
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Alexander S. Konoplev',
		FIO_RUS => 'Коноплев Александр Сергеевич',
		WELCOME => 'Привет, USERNAME!',
		ADLOGIN => 'CORP\askonoplev',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 7, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	nnmukhin => {
		ACCESS => {
			UTILS => "R",
			USER_UTILS => "RW",
			UU4NAS => "R", #Menu for Nadezhda
			UU4CHOP => "R", #Menu for chop
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			LOGONS => "R", #Search LogonActivity
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Nikolay N. Mukhin',
		FIO_RUS => 'Мухин Николай Николаевич',
		WELCOME => 'Привет, USERNAME!',
		ADLOGIN => 'CORP\NNMukhin',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	rrvikhastyi => {
		ACCESS => {
			UTILS => "R",
			USER_UTILS => "RW",
			UU4NAS => "R", #Menu for Nadezhda
			UU4CHOP => "R", #Menu for chop
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			LOGONS => "R", #Search LogonActivity
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'RRVikhastyi',
		FIO_RUS => 'Вихастый Руслан Романович',
		WELCOME => 'Привет, Руслан!',
		ADLOGIN => 'CORP\RRVikhastyi',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			 },
		 },
	 },
	 ogdergunova => {
		ACCESS => {
			DESC2LOGIN => "R",
			AC_UTILS => "R",
			SAP => "RW", #Access SAP requests
			UU4NAS => "R", #Menu for Nadezhda
			UU4CHOP => "R", #Menu for chop
			USER_UTILS => "RW",
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'ogdergunova',
		WELCOME => 'Привет, USERNAME!',
		FIO_RUS => 'Дергунова Олеся Геннадьевна',
		ADLOGIN => 'CORP\ogdergunova',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	epkolesnikova => {
		ACCESS => {
			USER_UTILS => "RW",
			UU4NAS => "RW", #Menu for Nadezhda
			UU4CHOP => "RW", #Menu for chop
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
		},
		NAME => 'Ekaterina P. Kolesnikova',
		WELCOME => 'Привет, USERNAME!',
		FIO_RUS => 'Колесникова Екатерина Петровна',
		ADLOGIN => 'CORP\epkolesnikova',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
			PROJ => {
				ALLOW_DELETE => 1,#Allow delete projects
			},
		},
	},
	nasinichkina => {
		ACCESS => {
			DESC2LOGIN => "R",
			AC_UTILS => "R",
			SAP => "RW", #Access SAP requests
			UU4NAS => "R", #Menu for Nadezhda
			UU4CHOP => "R", #Menu for chop
			USER_UTILS => "RW",
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Nadezhda A. Sinichkina',
		WELCOME => 'Привет, USERNAME!',
		FIO_RUS => 'Сеничкина Надежда Анатольевна',
		ADLOGIN => 'CORP\NASinichkina',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
			PROJ => {
				ALLOW_DELETE => 1,#Allow delete projects
			},
		},
	},
	yademidova => {
		ACCESS => {
			DESC2LOGIN => "R",
			AC_UTILS => "R",
			UU4NAS => "R", #Menu for Nadezhda
			UU4CHOP => "R", #Menu for chop
			USER_UTILS => "RW",
			CHPW => "RW", #Change Password
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Yulia A. Demidova',
		 WELCOME => 'Привет, USERNAME!',
		 FIO_RUS => 'Демидова Юлия Анатольевна',
		 ADLOGIN => 'CORP\yademidova',
		 OPTIONS => { #Optional scripts parameters (if needed)
		 	INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	"test-security" => { #test user for testing UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			CHPW => "RW", #Change Password
		},
		NAME => 'Охрана',
		WELCOME => 'Добрый день, USERNAME!',
		ADLOGIN => 'CORP\test-security',
	},
	askulagin => { #UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			##CHPW => "RW", #Change Password
		},
		NAME => 'Кулагин Алексей Станиславович',
		WELCOME => 'Добрый день!',
		ADLOGIN => 'CORP\ASKulagin',
	},
	security => { #UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			##CHPW => "RW", #Change Password
		},
		NAME => 'Охрана',
		WELCOME => 'Добрый день!',
		ADLOGIN => 'CORP\security',
	},
	securityDC => { #UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			##CHPW => "RW", #Change Password
		},
		NAME => 'Охрана',
		WELCOME => 'Добрый день!',
		ADLOGIN => 'CORP\securityDC',
	},
	#aaa => {
	#	ACCESS => {
	#		LOGONS => "R", #Search LogonActivity
	#		AC_UTILS => "RW", #Other utils (Academic)
	#		MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		UTILS => "R",
	#		USER_UTILS => "RW",
	#		UU4HD => "R", #User utils for helpdesk
	#		FS => "R", #File servers logs
	#		CHPW => "RW", #Change Password
	#		INCIDENTS => "RW", #Incidents
	#		DESC2LOGIN => "R", #Translate Description to Login and vise versa
	#	},
	#	NAME => 'Alexey A. Andriets',
	#	FIO_RUS => 'Андриец Алексей Анатольевич',
	#	ADLOGIN => 'CORP\AAAndriets',
	#	OPTIONS => { #Optional scripts parameters (if needed)
	#		INC => {
	#			REG => 1, # Must be syncronized with Inc_DBUserRegions
	#		},
	#	},
	#},
	pit => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			UTILS => "R",
			CHPW => "RW", #Change Password
			LOGONS => "R", #Search LogonActivity
		},
		NAME => 'Alexandr P. Semenyuk',
		ADLOGIN => 'CORP\APSemenyuk',
	},
	morumyantsev => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			LOGONS => "R", #Search LogonActivity
			UTILS => "R",
			USER_UTILS => "RW",
			UU4HD => "R", #User utils for helpdesk
			FS => "R", #File servers logs
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Maxim O. Rumyantsev',
		FIO_RUS => 'Румянцев Максим Олегович',
		ADLOGIN => 'CORP\morumyantsev',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	vfgerasimov => {
		ACCESS => {
			CHPW => "RW", #Change Password
			INCIDENTS => "R", #Incidents
		},
		NAME => 'Владимир Федорович',
		FIO_RUS => 'Герасимов Владимир Федорович',
		ADLOGIN => 'CORP\VFGerasimov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	bbp => {
		ACCESS => {
			MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			AC_UTILS => "RW", #Other utils (Academic)
			LOGONS => "R", #Search LogonActivity
			UTILS => "R",
			USER_UTILS => "RW",
			UU4HD => "R", #User utils for helpdesk
			FS => "R", #File servers logs
			CHPW => "RW", #Change Password
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
		},
		NAME => 'Boris B. Polikarpov',
		FIO_RUS => 'Поликарпов Борис Борисович',
		ADLOGIN => 'CORP\BBPolikarpov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#sony => {
	#	ACCESS => {
	#		INSWIFI => "RW", #Insertion of wi-fi requests
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Dmitry E. Rannev',
	#	ADLOGIN => 'CORP\DERannev',
	#},
	novak => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			#MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
			CHPW => "RW", #Change Password
		},
		NAME => 'Radu Guzun',
		ADLOGIN => 'CORP\RGuzun',
	},
	#nnkazyulin => {
	#	ACCESS => {
	#		INSWIFI => "RW", #Insertion of wi-fi requests
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Nikolay N. Kazyulin',
	#	ADLOGIN => 'CORP\NNKazyulin',
	#},
	evpanin => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Evgeniy V. Panin',
		ADLOGIN => 'CORP\EVPanin',
	},
	aasolomatin => {
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Alexey A. Solomatin',
		ADLOGIN => 'CORP\AASolomatin',
	},
	dvkachyanov => { 
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Kachyanov, Dmitriy V.',
		ADLOGIN => 'CORP\dvkachyanov',
	},
	seboychenko => { 
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Boychenko, Sergey E.',
		ADLOGIN => 'CORP\seboychenko',
	},
	aazabiyako => { 
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Zabiyako, Aleksey A.',
		ADLOGIN => 'CORP\aazabiyako',
	},
	verozenberger => { 
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Rozenberger, Valentin E.',
		ADLOGIN => 'CORP\verozenberger',
	},
	vakhokhlov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		 NAME => 'Khokhlov, Vadim A.',
		 ADLOGIN => 'CORP\vakhokhlov',
		},
	gvpopkov  => { 
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Popkov, Gennady V',
		ADLOGIN => 'CORP\gvpopkov',
	},
	"help-test" => { #test user for testing UU4HD
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'help-test',
		ADLOGIN => 'CORP\help-test',
	},
	#asseryakov => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		#MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Alexandr S Seryakov',
	#	ADLOGIN => 'CORP\ASSeryakov',
	#},
	#svevdokimov => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		#MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Sergey V Evdokimov',
	#	ADLOGIN => 'CORP\SVEvdokimov',
	#},
	#aakharkov => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		#MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Alexey A Kharkov',
	#	ADLOGIN => 'CORP\AAKharkov',
	#},
	#dsr => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		MACs => "R", #Access find_switch.cgi (Find/Update switch, port, MAC)
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Dmitry S Reshetnikov',
	#	ADLOGIN => 'CORP\DSReshetnikov',
	#},
	yssapovatova => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Yuliya S. Sapovatova',
		ADLOGIN => 'CORP\yssapovatova',
	},
	# Ryazan
	lnmedvedeva => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Ludmila N. Medvedeva',
		ADLOGIN => 'CORP\LNMedvedeva',
	},
	# Ryasan
	ibpligunova => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Irina B. Pligunova',
		ADLOGIN => 'CORP\IBPligunova',
	},
	gnbystrov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Georgy N. Bystrov',
		ADLOGIN => 'CORP\GNBystrov',
	},
	evantonova => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Ekaterina V. Antonova',
		ADLOGIN => 'CORP\evantonova',
	},
	avkomarov3 => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		 },
		 NAME => 'Ekaterina V. Antonova',
		 ADLOGIN => 'CORP\evantonova',
		  },
	vashelkov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Шелков Вадим Александрович',
		ADLOGIN => 'CORP\vashelkov',
	},
	iazudin => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Зудин Илья Анатольевич',
		ADLOGIN => 'CORP\iazudin',
	},
	dvivanov3 => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Иванов Денис Владимирович',
		ADLOGIN => 'CORP\dvivanov3',
	},
	aapavlyuchenko => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Павлюченко А.А.',
		ADLOGIN => 'CORP\aapavlyuchenko',
	},
	iamiroshnikov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Мирошников И.А.',
		ADLOGIN => 'CORP\iamiroshnikov',
	},
	vschaschikhin => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Чащихин Валентин Сергеевич',
		ADLOGIN => 'CORP\vschaschikhin',
	},
	eskovalev => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			},
		NAME => 'Ковалев Евгений Сергеевич',
		ADLOGIN => 'CORP\eskovalev',
	},
	#svzhuchkov => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Жучков Сергей Валерьевич',
	#	ADLOGIN => 'CORP\svzhuchkov',
	#	 },
	#
	snzhiganov => {
               ACCESS => {
                      UU4HD => "R", #User utils for helpdesk
                       CHPW => "RW", #Change Password
                },
                NAME => 'Жиганов Сергей Николаевич',
                ADLOGIN => 'CORP\snzhiganov',
										        },
	sivoloshinova => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Svetlana I. Voloshinova',
		ADLOGIN => 'CORP\sivoloshinova',
	},
	dsborodin => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Denis S. Borodin',
		FIO_RUS => 'Бородин Денис Сергеевич',
		ADLOGIN => 'CORP\DSBorobin',
	},
	dskorolkov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Dmitriy S. Korolkov',
		FIO_RUS => 'Корольков Дмитрий Сергеевич',
		ADLOGIN => 'CORP\DSKorolkov',
	},
	#agcherkavskiy => {
	#	ACCESS => {
	#		INSWIFI => "RW", #Insertion of wi-fi requests
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Alexandr G. Cherkavskiy',
	#	FIO_RUS => 'Черкавский Александр Григорьевич',
	#	ADLOGIN => 'CORP\AGCherkavskiy',
	#},
	drfizikov  => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'drfizikov',
		ADLOGIN => 'CORP\drfizikov',
		FIO_RUS => 'drfizikov',
	},
	rzkashafutdinov => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'rzkashafutdinov',
		ADLOGIN => 'CORP\rzkashafutdinov',
		FIO_RUS => 'Кашафутдинов Рустем Зявдатович',
	},
	vobakhtiyarov => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi request
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'vobakhtiyarov',
		ADLOGIN => 'CORP\vobakhtiyarov',
		FIO_RUS => 'Бахтияров Владимир Олегович',
	},
	avsukhovey => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Alexey V. Sukhovey',
		ADLOGIN => 'CORP\AVSukhovey',
		FIO_RUS => 'Суховей Алексей Владимирович',
	},
	piburykin => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Pavel I. Burykin',
		ADLOGIN => 'CORP\PIBurykin',
		FIO_RUS => 'Бурыкин Павел Игоревич',
	},
	aavanyunin => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Alexander A. Vanyunin',
		ADLOGIN => 'CORP\aavanyunin',
		FIO_RUS => 'Ванюнин Александр Александрович',
	},
	yvsnegov => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Yury V. Snegov',
		ADLOGIN => 'CORP\yvsnegov',
		FIO_RUS => 'Снегов Юрий Викторович',
	},
	ovtolmachev => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Oleg V. Tolmachev',
		ADLOGIN => 'CORP\ovtolmachev',
		FIO_RUS => 'Толмачев Олег Вячеславович',
	},
	#salebedeva => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Svetlana Lebedeva',
	#	ADLOGIN => 'CORP\salebedeva',
	#},
	#dokaretnikova => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Darya O Karetnikova',
	#	ADLOGIN => 'CORP\dokaretnikova',
	#},
	#oyguseva => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Olga',
	#	ADLOGIN => 'CORP\oyguseva',
	#},
	#abmaznaya => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Anastasiya',
	#	ADLOGIN => 'CORP\abmaznaya',
	#},
	#ovkleshin => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Oleg V. Kleshin',
	#	ADLOGIN => 'CORP\ovkleshin',
	#},
	avsemenov4 => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			##TST => "RW", #For tests and debugging
		},
		NAME => 'Alexander V. Semenov',
		FIO_RUS => 'Семенов Александр Викторович',
		ADLOGIN => 'CORP\avsemenov4',
		ORDER => ['SAP','USER_UTILS','INCIDENTS','UTILS','CHPW'],
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	gggrishin => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			##INSWIFI => "RW", #Insertion of wi-fi requests
			##UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Grishin, Grigory G.',
		FIO_RUS => 'Гришин Григорий Григорьевич',
		ADLOGIN => 'CORP\gggrishin',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	myryzhov => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Ryzhov, Mikhail Y.',
		FIO_RUS => 'Рыжов Михаил Юрьевич',
		ADLOGIN => 'CORP\myryzhov',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dakuzmin => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			##INSWIFI => "RW", #Insertion of wi-fi requests
			##UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Denis A. Kuzmin',
		FIO_RUS => 'Кузьмин Денис Андреевич',
		ADLOGIN => 'CORP\dakuzmin',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	dmkataev => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Дмитрий',
		FIO_RUS => 'Катаев Дмитрий Михайлович',
		ADLOGIN => 'CORP\dmkataev',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	yagordon  => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			##INSWIFI => "RW", #Insertion of wi-fi requests
			##UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			LOGONS => "RW", #Search LogonActivity
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Yan A. Gordon',
		FIO_RUS => 'Гордон Ян Александрович',
		ADLOGIN => 'CORP\yagordon',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
	 	},
	},
	avvolkov4 => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Volkov, Andrey V.',
		FIO_RUS => 'Волков Андрей',
		ADLOGIN => 'CORP\avvolkov4',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	avpopov4 => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Andrey V. Popov',
		FIO_RUS => 'Попов Андрей Владимирович',
		ADLOGIN => 'CORP\avpopov4',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			 },
		},
	},
	aspavlova => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			##INSWIFI => "RW", #Insertion of wi-fi requests
			##UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Анжела',
		FIO_RUS => 'Павлова Анжела Семеновна',
		ADLOGIN => 'CORP\aspavlova',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	ivgavrilin => {
		ACCESS => {
			SAP => "RW", #Access SAP requests
			##INSWIFI => "RW", #Insertion of wi-fi requests
			##UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			UTILS => "R", #Utils
			LOGONS => "R", #Search LogonActivity
			USER_UTILS => "R", #DKB only
			INCIDENTS => "RW", #Incidents
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			TST => "RW", #For tests and debugging
		},
		NAME => 'Илья',
		FIO_RUS => 'Гаврилин Илья Вячеславович',
		ADLOGIN => 'CORP\ivgavrilin',
		OPTIONS => { #Optional scripts parameters (if needed)
			INC => {
				REG => 1, # USER region. Must be syncronized with Inc_DBUserRegions
			},
		},
	},
	#vaigushkin => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Vladimir A. Igushkin',
	#	ADLOGIN => 'CORP\vaigushkin',
	#},
	#avionkin => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Alexandr V. Ionkin',
	#	ADLOGIN => 'CORP\avionkin',
	#},
	#aaefimov => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Artem A. Efimov',
	#	ADLOGIN => 'CORP\aaefimov',
	#},
	#vasvetlichniy => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Vadim A. Svetlichniy',
	#	ADLOGIN => 'CORP\vasvetlichniy',
	#},
	#mmshulgin => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Maxim M. Shulgin',
	#	ADLOGIN => 'CORP\mmshulgin',
	#},
	aakorolev => {
		ACCESS => {
			MACs => "R", #MACs
			INSWIFI => "RW", #Insertion of wi-fi requests
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Антон Андреевич',
		FIO_RUS => 'Королев Антон Андреевич',
		ADLOGIN => 'CORP\aakorolev',
	},
	svgershun => {
		ACCESS => {
			MACs => "R", #MACs
			INSWIFI => "RW", #Insertion of wi-fi requests
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Сергей Владимирович',
		FIO_RUS => 'Гершун Сергей Владимирович',
		ADLOGIN => 'CORP\svgershun',
	},
	emseleznev => {
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			MACs => "R", #MACs
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Евгений Михайлович',
		FIO_RUS => 'Селезнев Евгений Михайлович',
		ADLOGIN => 'CORP\emseleznev',
	},
	asmikhailov => {
		ACCESS => {
			MACs => "R", #MACs
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Андрей Сергеевич',
		FIO_RUS => 'Михайлов Андрей Сергеевич',
		ADLOGIN => 'CORP\asmikhailov',
	},
	amtsyplakov => {
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			MACs => "R", #MACs
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Александр Михайлович',
		FIO_RUS => 'Цыплаков Александр Михайлович',
		ADLOGIN => 'CORP\amtsyplakov',
	},
	vvsosedov => {
		ACCESS => {
			MACs => "R", #MACs
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Владимир Владимирович',
		FIO_RUS => 'Соседов Владимир Владимирович',
		ADLOGIN => 'CORP\vvsosedov',
	},
	vvtyurmin => {
		ACCESS => {
			MACs => "R", #MACs
			LOGONS => "R", #Logon Activity Search
			DESC2LOGIN => "R", #Translate Description to Login and vise versa
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Владимир Викторович',
		FIO_RUS => 'Тюрмин Владимир Викторович',
		ADLOGIN => 'CORP\vvtyurmin',
	},
	#mvkontsevoi => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Mikhail V. Kontsevoi',
	#	ADLOGIN => 'CORP\mvkontsevoi',
	#},
	ailunevsky => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Andrey I. Lunevsky',
		ADLOGIN => 'CORP\ailunevsky',
	},
);

%ITEMS = (
	ISS_REP => {
		TITLE => "SP Reports",
	},
	SAP => {
		TITLE => "SAP",
	},
	UTILS => {
		TITLE => "Сеть",
	},
	USER_UTILS => {
		TITLE => "Пользователи",
	},
	AC_UTILS => {
		TITLE => "Утилиты",
	},
	SZ => {
		TITLE => "Resource Requests",
	},
	UU4HD => {
		TITLE => "Утилиты для Helpdesk",
	},
	CHPW => {
		TITLE => "Смена пароля",
	},
	TST => {
		TITLE => "Тестовая Зона",
	},
	UU4NAS => {
		TITLE => "Служебные записки",
	},
	UU4CHOP => {
		TITLE => "Внос/Вынос ноутбуков",
	},
	INCIDENTS => {
		TITLE => "Инциденты",
	},
);

sub new {
	my $self = {};
	bless $self;
	
	return $self;
}

## id_sz !!!
sub getIdSz {
	my $self = shift;
	my $date = shift;

	my $START_TIME = 1113163180;
	my $START_ID_SZ = 352;
	my $SECS_IN_WEEK = 7*24*3600;
	my $id_sz = $START_ID_SZ + int(($date - $START_TIME)/$SECS_IN_WEEK);

	return $id_sz;
}

sub getUserName {
	my $self = shift;
	my $u = shift;

	return $USERACCESS{$u}->{NAME};
}
sub getWelcome {
	my $self = shift;
	my $u = shift;

	return $USERACCESS{$u}->{WELCOME};
}
sub getUserOptions {
	my $self = shift;
	my $u = shift;

	return $USERACCESS{$u}->{OPTIONS};
}
sub getUserItemsOrder {
	my $self = shift;
	my $u = shift;

	return $USERACCESS{$u}->{ORDER};
}

sub getUserADLogin {
	my $self = shift;
	my $u = shift;

	return $USERACCESS{$u}->{ADLOGIN};
}

sub getFioRusByADLogin {
	my $self = shift;
	my $ADLogin = shift;

	foreach my $u (keys %USERACCESS){
		if ($ADLogin eq $USERACCESS{$u}->{ADLOGIN}){
			return $USERACCESS{$u}->{FIO_RUS};
		}
	}
	return undef;
}

sub getFioRus {
	my $self = shift;
	my $u = shift;

	return $USERACCESS{$u}->{FIO_RUS};
}

sub getUserAccess {
	my $self = shift;
	my $u = shift;
	my $i = shift;

	return $USERACCESS{$u}->{ACCESS}->{$i};
}

sub getItemTitle {
	my $self = shift;
	my $i = shift;
	
	return $ITEMS{$i}->{TITLE};
}

sub getItems {
	my $self = shift;
	my $i = shift;
	my @ret = keys %ITEMS;
	
	return \@ret;
}


1;

