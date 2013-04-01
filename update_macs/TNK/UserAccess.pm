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
		WELCOME => '������, USERNAME!', #Welcome string
		NAME => 'Sergey V. Soldatov', #Username
		FIO_RUS => '�������� ������ ������������',
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
		WELCOME => '������, USERNAME!', #Welcome string
		NAME => 'Alexander P. Bodrik', #Username
		FIO_RUS => '������ ��������� ��������',
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
	#	NAME => '�����',
	#	FIO_RUS => '�������� ����� ����������',
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
		NAME => '�����',
		FIO_RUS => '�������� �������� ������������',
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
		NAME => '�������',
		FIO_RUS => '������ ������� ����������',
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
		NAME => '������',
		FIO_RUS => '����� ������ ����������',
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
		NAME => '�����',
		FIO_RUS => '����������� ����� ������������',
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
		FIO_RUS => '������� ������� ����������',
		NAME => '�������',
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
	#	FIO_RUS => '�������� ������ ����������',
	#	NAME => '������',
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
		NAME => '�������',
		FIO_RUS => '������ ������� ����������',
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
		NAME => '�����',
		FIO_RUS => '���������� ����� ����������',
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
		NAME => '����������',
		FIO_RUS => '������� ���������� ��������',
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
		NAME => '�����',
		FIO_RUS => '�������� ���������� �������',
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
	#	NAME => '�������',
	#	FIO_RUS => '������� ������� ����������',
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
		NAME => '�������',
		FIO_RUS => '������� ������� ����������',
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
		NAME => '��������',
		FIO_RUS => '������� �������� �������������',
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
	#	NAME => '������',
	#	FIO_RUS => '������� ������ �������������',
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
		NAME => '���������',
		FIO_RUS => '������� ��������� ���������',
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
		NAME => '������',
		FIO_RUS => '��������� ������ ������������',
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
		NAME => '�����',
		FIO_RUS => '���������� ����� �������������',
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
		NAME => '��������',
		FIO_RUS => '�������� ��������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ ����������',
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
	#	NAME => '������',
	#	FIO_RUS => '�������� ������ �������������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ �����������',
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
		NAME => '�����',
		FIO_RUS => '������ ����� �������',
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
		NAME => '�������',
		FIO_RUS => '���������� ������� �������������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� ����������',
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
		NAME => '����',
		FIO_RUS => '������ ���� �����������',
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
		NAME => '������� ',
		FIO_RUS => '������ ������� �����������',
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
	#	NAME => '�������',
	#	FIO_RUS => '������ ������� ����������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� ����������',
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
		NAME => '���������',
		FIO_RUS => '�������� ��������� ���������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ ������������',
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
		NAME => '�������',
		FIO_RUS => '����� ������� ����������',
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
		NAME => '������',
		FIO_RUS => '��������� ������ ����������',
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
		NAME => '����',
		FIO_RUS => '�������� ���� �������',
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
		  NAME => '������',
		  FIO_RUS => '�������� ������ ����������',
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
		NAME => '���������',
		FIO_RUS => '������ ��������� �������������',
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
		NAME => '���������',
		FIO_RUS => '������� ��������� �������������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� �������������',
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
		NAME => '�������',
		FIO_RUS => '������ ������� ���������',
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
		NAME => '����',
		FIO_RUS => '�������� ���� �����������',
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
		NAME => '�������',
		FIO_RUS => '������� ������� ������������',
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
		NAME => '����',
		FIO_RUS => '������ ���� ����������',
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
		NAME => '���������',
		FIO_RUS => '������� ��������� �������������',
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
		NAME => '������',
		FIO_RUS => '������� ������ ��������',
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
		NAME => '�����',
		FIO_RUS => '������ ����� �����������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� �����������',
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
		NAME => '������',
		FIO_RUS => '������� ������ ����������',
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
		NAME => '�������',
		FIO_RUS => '������ ������� ���������',
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
		NAME => '������',
		FIO_RUS => '��������� ������ ����������',
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
		NAME => '�����',
		FIO_RUS => '������������ ����� ����������',
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
		NAME => '���������',
		FIO_RUS => '����� ��������� ���������',
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
		NAME => '�����',
		FIO_RUS => '������ ����� ����������',
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
		NAME => '������',
		FIO_RUS => '������� ������ ����������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ �����������',
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
	#	NAME => '������',
	#	FIO_RUS => '������� ������ ����������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ ���������',
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
		NAME => '���������',
		FIO_RUS => '�������� ��������� ����������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� ����������',
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
		NAME => '������',
		FIO_RUS => '������� ������ ����������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� �������������',
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
		NAME => '������',
		FIO_RUS => '������� ������ ���������',
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
		NAME => '�������',
		FIO_RUS => '������������ ������� ����������',
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
		NAME => '���������',
		FIO_RUS => '����� ��������� ����������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ �������',
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
	#	NAME => '�����',
	#	FIO_RUS => '������� ����� ����������',
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
		NAME => '����',
		FIO_RUS => '������ ���� ����������',
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
		NAME => '�������',
		FIO_RUS => '����������� ������� ����������',
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
		NAME => '��������',
		FIO_RUS => '������� �������� ������������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ ����������',
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
		NAME => '������',
		FIO_RUS => '�������� ������ ������������',
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
		NAME => '����',
		FIO_RUS => '����� ���� ����������',
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
		NAME => '���������',
		FIO_RUS => '��������� ��������� ���������',
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
		NAME => '����',
		FIO_RUS => '������� ���� �������',
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
		NAME => '������',
		FIO_RUS => 'Ѹ���� ������ ��������',
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
		NAME => '�������',
		FIO_RUS => '�������� ������� ����������',
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
		NAME => '��������� ������� ��������������',
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
	#	NAME => '�������',
	#	FIO_RUS => '������ ������� ����������',
	#	WELCOME => '������, USERNAME!', #Welcome string
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
		FIO_RUS => '�������� ������� ������������',
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
		FIO_RUS => '��������� ����� �������',
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
		FIO_RUS => '������� �������� ����������',
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
	#	NAME => '����',
	#	WELCOME => '����������, USERNAME!',
	#	FIO_RUS => '����� ������ �������������',
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
		NAME => '�����',
		WELCOME => '����������, USERNAME!',
		FIO_RUS => '�������� ����� ���������',
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
		FIO_RUS => '����� ��������� ���������',
		WELCOME => '������, USERNAME!',
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
		FIO_RUS => '������ ����� ���������',
		WELCOME => '������, USERNAME!',
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
		FIO_RUS => '�������� ��������� ���������',
		WELCOME => '������, USERNAME!',
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
		FIO_RUS => '����� ������� ����������',
		WELCOME => '������, USERNAME!',
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
		FIO_RUS => '�������� ������ ���������',
		WELCOME => '������, ������!',
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
		WELCOME => '������, USERNAME!',
		FIO_RUS => '��������� ����� �����������',
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
		WELCOME => '������, USERNAME!',
		FIO_RUS => '����������� ��������� ��������',
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
		WELCOME => '������, USERNAME!',
		FIO_RUS => '��������� ������� �����������',
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
		 WELCOME => '������, USERNAME!',
		 FIO_RUS => '�������� ���� �����������',
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
		NAME => '������',
		WELCOME => '������ ����, USERNAME!',
		ADLOGIN => 'CORP\test-security',
	},
	askulagin => { #UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			##CHPW => "RW", #Change Password
		},
		NAME => '������� ������� �������������',
		WELCOME => '������ ����!',
		ADLOGIN => 'CORP\ASKulagin',
	},
	security => { #UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			##CHPW => "RW", #Change Password
		},
		NAME => '������',
		WELCOME => '������ ����!',
		ADLOGIN => 'CORP\security',
	},
	securityDC => { #UU4CHOP
		ACCESS => {
			UU4CHOP => "RW", #Menu for chop
			##CHPW => "RW", #Change Password
		},
		NAME => '������',
		WELCOME => '������ ����!',
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
	#	FIO_RUS => '������� ������� �����������',
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
		FIO_RUS => '�������� ������ ��������',
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
		NAME => '�������� ���������',
		FIO_RUS => '��������� �������� ���������',
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
		FIO_RUS => '���������� ����� ���������',
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
		NAME => '������ ����� �������������',
		ADLOGIN => 'CORP\vashelkov',
	},
	iazudin => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => '����� ���� �����������',
		ADLOGIN => 'CORP\iazudin',
	},
	dvivanov3 => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => '������ ����� ������������',
		ADLOGIN => 'CORP\dvivanov3',
	},
	aapavlyuchenko => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => '���������� �.�.',
		ADLOGIN => 'CORP\aapavlyuchenko',
	},
	iamiroshnikov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => '���������� �.�.',
		ADLOGIN => 'CORP\iamiroshnikov',
	},
	vschaschikhin => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => '������� �������� ���������',
		ADLOGIN => 'CORP\vschaschikhin',
	},
	eskovalev => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
			},
		NAME => '������� ������� ���������',
		ADLOGIN => 'CORP\eskovalev',
	},
	#svzhuchkov => {
	#	ACCESS => {
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => '������ ������ ����������',
	#	ADLOGIN => 'CORP\svzhuchkov',
	#	 },
	#
	snzhiganov => {
               ACCESS => {
                      UU4HD => "R", #User utils for helpdesk
                       CHPW => "RW", #Change Password
                },
                NAME => '������� ������ ����������',
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
		FIO_RUS => '������� ����� ���������',
		ADLOGIN => 'CORP\DSBorobin',
	},
	dskorolkov => {
		ACCESS => {
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Dmitriy S. Korolkov',
		FIO_RUS => '��������� ������� ���������',
		ADLOGIN => 'CORP\DSKorolkov',
	},
	#agcherkavskiy => {
	#	ACCESS => {
	#		INSWIFI => "RW", #Insertion of wi-fi requests
	#		UU4HD => "R", #User utils for helpdesk
	#		CHPW => "RW", #Change Password
	#	},
	#	NAME => 'Alexandr G. Cherkavskiy',
	#	FIO_RUS => '���������� ��������� �����������',
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
		FIO_RUS => '������������ ������ ����������',
	},
	vobakhtiyarov => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi request
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'vobakhtiyarov',
		ADLOGIN => 'CORP\vobakhtiyarov',
		FIO_RUS => '��������� �������� ��������',
	},
	avsukhovey => {
		ACCESS => {
			#INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Alexey V. Sukhovey',
		ADLOGIN => 'CORP\AVSukhovey',
		FIO_RUS => '������� ������� ������������',
	},
	piburykin => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Pavel I. Burykin',
		ADLOGIN => 'CORP\PIBurykin',
		FIO_RUS => '������� ����� ��������',
	},
	aavanyunin => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Alexander A. Vanyunin',
		ADLOGIN => 'CORP\aavanyunin',
		FIO_RUS => '������� ��������� �������������',
	},
	yvsnegov => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Yury V. Snegov',
		ADLOGIN => 'CORP\yvsnegov',
		FIO_RUS => '������ ���� ����������',
	},
	ovtolmachev => { ## 10 rown
		ACCESS => {
			INSWIFI => "RW", #Insertion of wi-fi requests
			UU4HD => "R", #User utils for helpdesk
			CHPW => "RW", #Change Password
		},
		NAME => 'Oleg V. Tolmachev',
		ADLOGIN => 'CORP\ovtolmachev',
		FIO_RUS => '�������� ���� ������������',
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
		FIO_RUS => '������� ��������� ����������',
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
		FIO_RUS => '������ �������� �����������',
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
		FIO_RUS => '����� ������ �������',
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
		FIO_RUS => '������� ����� ���������',
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
		NAME => '�������',
		FIO_RUS => '������ ������� ����������',
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
		FIO_RUS => '������ �� �������������',
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
		FIO_RUS => '������ ������',
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
		FIO_RUS => '����� ������ ������������',
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
		NAME => '������',
		FIO_RUS => '������� ������ ���������',
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
		NAME => '����',
		FIO_RUS => '�������� ���� ������������',
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
		NAME => '����� ���������',
		FIO_RUS => '������� ����� ���������',
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
		NAME => '������ ������������',
		FIO_RUS => '������ ������ ������������',
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
		NAME => '������� ����������',
		FIO_RUS => '�������� ������� ����������',
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
		NAME => '������ ���������',
		FIO_RUS => '�������� ������ ���������',
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
		NAME => '��������� ����������',
		FIO_RUS => '�������� ��������� ����������',
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
		NAME => '�������� ������������',
		FIO_RUS => '������� �������� ������������',
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
		NAME => '�������� ����������',
		FIO_RUS => '������ �������� ����������',
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
		TITLE => "����",
	},
	USER_UTILS => {
		TITLE => "������������",
	},
	AC_UTILS => {
		TITLE => "�������",
	},
	SZ => {
		TITLE => "Resource Requests",
	},
	UU4HD => {
		TITLE => "������� ��� Helpdesk",
	},
	CHPW => {
		TITLE => "����� ������",
	},
	TST => {
		TITLE => "�������� ����",
	},
	UU4NAS => {
		TITLE => "��������� �������",
	},
	UU4CHOP => {
		TITLE => "����/����� ���������",
	},
	INCIDENTS => {
		TITLE => "���������",
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

