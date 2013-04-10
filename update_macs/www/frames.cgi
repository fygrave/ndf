#!/usr/bin/perl

#use lib "/usr/local/apache/lib/perl";
use CGI;
use TNK::UserAccess;

my $u = new TNK::UserAccess;

#my $qq = "w=left_frame&si=ISS_REP";
#my $q = new CGI($qq);
#$user = 'svs';

my $q = new CGI;
my $user = $ENV{"REMOTE_USER"};

print $q->header(-charset=>'windows-1251'),
	$q->start_html('Frames'), "\n";

unless ($u->getUserName($user)){
	print "<H2>You're not allowed to access this site!</H2><small>References: Sergey Soldatov, svsoldatov\@yourdomaoin.com, 1613</small>\n";
	exit(11); # not allowed to access
}


my $w = $q->param('w'); #what
if ($w eq 'up_frame'){
	my $order = $u->getUserItemsOrder($user) || $u->getItems();
	
	for (@{$order}){
		if($u->getUserAccess($user, $_) =~ /R/){ #if item has 'R' right then it is showed in upper frame
			print "<A HREF=\"/cgi-bin/frames.cgi?w=left_frame&si=$_\" TARGET=\"left_frame\">".$u->getItemTitle($_).
				"</A>&nbsp;&nbsp;\n";
		}
	}
	# DIFF
	#print "<A HREF=\"/diff/index.html\" \" TARGET=\"left_frame\">CYBER configs DIFF</A>\n" 
	#	if ($u->getUserAccess($user, 'CYBER_DIFF') =~ /R/);
}
elsif ($w eq 'left_frame'){
	my $si = $q->param('si'); #selected item
	if ($si eq 'ISS_REP'){
		print "<P><A HREF=\"/ISSRep/index.htm\" TARGET=\"centre_frame\">Latest report</A>\n".
			"<P><A HREF=\"/ISSRep/arch/index.htm\" TARGET=\"centre_frame\">Archive</A>\n";
	}
	if ($si eq 'CHPW'){
		print "<P><A HREF=\"/cgi-bin/ch_pw.cgi\" TARGET=\"centre_frame\">Изменить пароль</A>\n";
	}
	if ($si eq 'INCIDENTS'){
		print "<P><A HREF=\"/cgi-bin/inc/ins_inc.cgi\" TARGET=\"centre_frame\">Зарегистрировать Инцидент</A>\n"
			if $u->getUserAccess($user, 'INCIDENTS') =~ /W/;
		print "<P><A HREF=\"/cgi-bin/inc/sh_inc.cgi\" TARGET=\"centre_frame\">Найти Инциденты</A>\n";
		print "<P><A HREF=\"/cgi-bin/inc/sh_inc.cgi?instrOpts1=1\" TARGET=\"centre_frame\">Работа с инструкциями</A>\n"
			if $u->getUserAccess($user, 'INCIDENTS') =~ /W/;
		print "<P><A HREF=\"/cgi-bin/inc/sh_inc.cgi?regOpts1=1\" TARGET=\"centre_frame\">Работа с регионами</A>\n"
			if $TNK::UserAccess::USERACCESS{$user}->{OPTIONS}->{INC}->{REGADMIN};
		print "<P><A HREF=\"/inc/inc_changelog.html\" TARGET=\"centre_frame\">История изменений</A>\n";
		print "<P><A HREF=\"/inc/2007-01-24-Inc_UserGuide.htm\" TARGET=\"centre_frame\">Руководство пользователя</A><BR>".
			"(<A HREF=\"/inc/2007-01-24-Inc_UserGuide.pdf\" TARGET=\"_blank\">PDF</A>)\n";
		print "<P><A HREF=\"https://.yourdomaoin.ru/phpbb/viewforum.php?f=4\" TARGET=\"_blank\">База инцидентов на Форуме Безопасности</A>\n";
	}
	if ($si eq 'TST'){
		print "<p><font size=\"+2\" color=\"red\">Тестовая зона!</font></p>\n";
		if ($u->getUserAccess($user, 'TST') =~ /RW/){
			# New SAP req
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=ins2\" TARGET=\"centre_frame\">Вставить НОВУЮ заявку</A>\n" 
				if $u->getUserAccess($user, 'SAP') =~ /W/;
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=find2\" TARGET=\"centre_frame\">Найти НОВУЮ заявку</A>\n";
			print $q->br, $q->hr, "\n";
		
			#Insert Approved Req
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=insert\" TARGET=\"centre_frame\">Вставить SAP заявку</A>\n" 
				if $u->getUserAccess($user, 'SAP') =~ /W/;
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=find\" TARGET=\"centre_frame\">Найти SAP заявку</A>\n";
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=count\" TARGET=\"centre_frame\">Подсчитать SAP заявки</A>\n";
			print $q->br, $q->hr, "\n";
		
			#Insert SAP Users
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=ins_sap_user\" TARGET=\"centre_frame\">Вставить пользователя SAP</A>\n" 
				if $u->getUserAccess($user, 'SAP') =~ /W/;
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=find_sap_user\" TARGET=\"centre_frame\">Найти пользователя SAP</A>\n"; 
			print "<P><A HREF=\"/cgi-bin/test/sap_req2.cgi?what=find_sap_users\" TARGET=\"centre_frame\">Найти множество пользователей SAP</A>\n"; 

			##Sluzhebki
			print "<HR>\n";
			print "<P><A HREF=\"/cgi-bin/test/find_sz.cgi?what=find\" TARGET=\"centre_frame\">Поиск служебок (тест)</A>\n";
			print "<P><A HREF=\"/cgi-bin/test/find_sz.cgi?what=insert\" TARGET=\"centre_frame\">Вставка служебных записок (тест)</A>\n";
			##

			#Inc
			print "<HR>\n";
			print "<P><A HREF=\"/cgi-bin/test/ins_inc.cgi\" TARGET=\"centre_frame\">Зарегистрировать Инцидент</A>\n";
			print "<P><A HREF=\"/cgi-bin/test/sh_inc.cgi\" TARGET=\"centre_frame\">Найти Инциденты</A>\n";
			print "<P><A HREF=\"/cgi-bin/test/sh_inc.cgi?instrOpts1=1\" TARGET=\"centre_frame\">Работа с инструкциями</A>\n";
			print "<P><A HREF=\"/cgi-bin/test/sh_inc.cgi?regOpts1=1\" TARGET=\"centre_frame\">Работа с регионами</A>\n";
			##
		}
		#Env var
		##print "<P><A HREF=\"/cgi-bin/sh_env.cgi\" TARGET=\"centre_frame\">Show script env var</A>\n";
	}
	if ($si eq 'UU4NAS'){
		print "<P><A HREF=\"/cgi-bin/find_sz.cgi?what=ins4nas\" TARGET=\"centre_frame\">Вставка служебок</A>\n";
		print "<P><A HREF=\"/cgi-bin/find_sz.cgi?what=find\" TARGET=\"centre_frame\">Поиск служебок</A>\n";
		print "<P><A HREF=\"/cgi-bin/find_sz.cgi?what=findCHOP\" TARGET=\"centre_frame\">Что искал ЧОП?</A>\n";
	}
	if ($si eq 'UU4CHOP'){
		print "<P><A HREF=\"/cgi-bin/findsz4helpdesk.cgi?what=f4chop\" TARGET=\"centre_frame\">Разрешения на внос/вынос ноутбуков</A>\n";
	}
	if ($si eq 'UU4HD'){
		if ($u->getUserAccess($user, 'INSWIFI') =~ /R/){
			print "<P><A HREF=\"/cgi-bin/findsz4helpdesk.cgi?what=insWIFI\" TARGET=\"centre_frame\">Вставка заявок на wi-fi</A>\n";
		}
		print "<P><A HREF=\"/cgi-bin/findsz4helpdesk.cgi?what=find\" TARGET=\"centre_frame\">Поиск служебок в базе ДЗИ для helpdesk</A>\n";
		print "<HR>\n";
		#print "<P><A HREF=\"/cgi-bin/nbtscan.cgi\" TARGET=\"centre_frame\">NBT scan</A>\n";
		print "<P><A HREF=\"/cgi-bin/nslookup.cgi\" TARGET=\"centre_frame\">NSLookup</A>\n";
		print "<P><A HREF=\"/cgi-bin/find_dmz_mac.cgi\" TARGET=\"centre_frame\">Спросить Маршритизатор</A>\n";
		if ($u->getUserAccess($user, 'MACs') =~ /R/){
			print "<P><A HREF=\"/cgi-bin/find_switch.cgi?what=find\" TARGET=\"centre_frame\">Найти MAC, коммутатор, порт, пр.</A>\n";
		}
		print "<P><A HREF=\"/cgi-bin/logons2.cgi\" TARGET=\"centre_frame\">Logon Activity</A>\n"
			if ($u->getUserAccess($user, 'LOGONS') =~ /R/);
		print "<P><A HREF=\"/cgi-bin/desc2login.cgi\" TARGET=\"centre_frame\">Description &lt;=&gt; Login</A>\n"
			if ($u->getUserAccess($user, 'DESC2LOGIN') =~ /R/);
		print "<HR>\n";
		print "<P><A HREF=\"/cgi-bin/translate.cgi\" TARGET=\"centre_frame\">Translate</A>\n";
		print "<P><A HREF=\"/cgi-bin/b64.cgi\" TARGET=\"centre_frame\">BASE64,QP enc/dec</A>\n";
		print "<P><A HREF=\"https://www.grc.com/pass\" TARGET=\"centre_frame\">Хороший генератор паролей</A>\n";
	}
	if ($si eq 'AC_UTILS'){
		print "<P><A HREF=\"/cgi-bin/desc2login.cgi\" TARGET=\"centre_frame\">Description &lt;=&gt; Login</A>\n"
			if ($u->getUserAccess($user, 'DESC2LOGIN') =~ /R/);
		print "<P><A HREF=\"/cgi-bin/translate.cgi\" TARGET=\"centre_frame\">Translate</A>\n";
		print "<P><A HREF=\"/cgi-bin/tr_ww_report.cgi\" TARGET=\"centre_frame\">Транслировать отчет WW</A>\n";
		print "<P><A HREF=\"/cgi-bin/b64.cgi\" TARGET=\"centre_frame\">BASE64,QP enc/dec</A>\n";
		print "<P><A HREF=\"https://www.grc.com/pass\" TARGET=\"centre_frame\">Хороший генератор паролей</A>\n";
		print "<P><A HREF=\"/cgi-bin/WebShell.cgi\" TARGET=\"centre_frame\">Web Shell</A>\n"
			if ($u->getUserAccess($user, 'WEBSHELL') =~ /R/);
	}
	if ($si eq 'USER_UTILS'){
		print "<P><A HREF=\"/cgi-bin/find_sz.cgi?what=find\" TARGET=\"centre_frame\">Поиск служебных записок</A>".
			"<br>(<small> <A HREF=\"/cgi-bin/find_sz.cgi?what=find\" TARGET=\"_blank\">Открыть в новом окне</A></small> )\n"; 
		print "<P><A HREF=\"/cgi-bin/find_sz.cgi?what=insert\" TARGET=\"centre_frame\">Вставка служебных записок</A>".
			"<br>(<small> <A HREF=\"/cgi-bin/find_sz.cgi?what=insert\" TARGET=\"_blank\">Открыть в новом окне</A></small> )\n"
			if ($u->getUserAccess($user, 'USER_UTILS') =~ /W/); 
		print "<HR>\n";
		print "<P><A HREF=\"/cgi-bin/projects.cgi?what=find\" TARGET=\"centre_frame\">Найти проекты</A>".
			"<br>(<small> <A HREF=\"/cgi-bin/projects.cgi?what=find\" TARGET=\"_blank\">Открыть в новом окне</A></small> )\n"; 
		print "<P><A HREF=\"/cgi-bin/projects.cgi?what=insert\" TARGET=\"centre_frame\">Зарегистрировать проект</A>".
			"<br>(<small> <A HREF=\"/cgi-bin/projects.cgi?what=insert\" TARGET=\"_blank\">Открыть в новом окне</A></small> )\n"
			if ($u->getUserAccess($user, 'USER_UTILS') =~ /W/); 
		print "<HR>\n";
		print "<P><A HREF=\"/cgi-bin/desc2login.cgi\" TARGET=\"centre_frame\">Description &lt;=&gt; Login</A>\n"
			if ($u->getUserAccess($user, 'DESC2LOGIN') =~ /R/);
		print "<P><A HREF=\"https://y..yourdomaoin.ru/nomenu/acsinfo.aspx\" TARGET=\"centre_frame\">Пользователи и номера их пропусков (СКД)</A>\n" ;
		print "<P><A HREF=\"/cgi-bin/fs.cgi\" TARGET=\"centre_frame\">Логи файловых серверов</A>\n"
			if ($u->getUserAccess($user, 'FS') =~ /R/);
		##print "<P><A HREF=\"/cgi-bin/logons.cgi\" TARGET=\"centre_frame\">Logon Activity</A>\n"
		##	if ($u->getUserAccess($user, 'LOGONS') =~ /R/);
		print "<P><A HREF=\"/cgi-bin/logons2.cgi\" TARGET=\"centre_frame\">Logon Activity</A>\n"
			if ($u->getUserAccess($user, 'LOGONS') =~ /R/);
		print "<P><A HREF=\"/cgi-bin/violations.cgi\" TARGET=\"centre_frame\">Поиск/Вставка нарушений</A>\n";
	}
	if ($si eq 'UTILS'){
		print "<P><A HREF=\"/cgi-bin/logons2.cgi\" TARGET=\"centre_frame\">Logon Activity</A>\n"
			if ($u->getUserAccess($user, 'LOGONS') =~ /R/);
		print "<P><A HREF=\"/cgi-bin/finduser.cgi\" TARGET=\"centre_frame\">Поиск пользователя (DATECOMP)</A>\n" ;
		print "<P><A HREF=\"/cgi-bin/nbtscan.cgi\" TARGET=\"centre_frame\">NBT scan</A>\n";
		print "<P><A HREF=\"/cgi-bin/nslookup.cgi\" TARGET=\"centre_frame\">NSLookup</A>\n";
		print "<P><A HREF=\"/cgi-bin/findserver.cgi\" TARGET=\"centre_frame\">Find Server</A>\n";
		print "<P><A HREF=\"/cgi-bin/find_dmz_mac.cgi\" TARGET=\"centre_frame\">Ask router</A>\n";
		print "<P><A HREF=\"/cgi-bin/check_vpn.cgi\" TARGET=\"centre_frame\">Check VPN conf</A>\n";
		print "<P><A HREF=\"/cgi-bin/sh_route.cgi\" TARGET=\"centre_frame\">Show routes</A>\n";
		print "<P><A HREF=\"/cgi-bin/sh_span.cgi\" TARGET=\"centre_frame\">Show SPAN/RSPAN</A>\n";
		print "<HR>\n";
		if ($u->getUserAccess($user, 'MACs') =~ /R/){
			print "<P><A HREF=\"/cgi-bin/find_switch.cgi?what=find\" TARGET=\"centre_frame\">Find switch, port, MAC</A>\n";
			print "<P><A HREF=\"/cgi-bin/find_switch.cgi?what=update\" TARGET=\"centre_frame\">Update MACs in DB</A>\n" 
				if $u->getUserAccess($user, 'MACs') =~ /W/;
		}
	}
	if ($si eq 'SAP'){
		# New SAP req
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=ins2\" TARGET=\"centre_frame\">Вставить НОВУЮ заявку</A>\n" 
			if $u->getUserAccess($user, 'SAP') =~ /W/;
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=find2\" TARGET=\"centre_frame\">Найти НОВУЮ заявку</A>\n";
		print $q->br, $q->hr, "\n";
		
		#Insert Approved Req
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=insert\" TARGET=\"centre_frame\">Вставить SAP заявку</A>\n" 
			if $u->getUserAccess($user, 'SAP') =~ /W/;
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=find\" TARGET=\"centre_frame\">Найти SAP заявку</A>\n";
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=count\" TARGET=\"centre_frame\">Подсчитать SAP заявки</A>\n";
		print $q->br, $q->hr, "\n";
		
		#Insert SAP Users
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=ins_sap_user\" TARGET=\"centre_frame\">Вставить пользователя SAP</A>\n" 
			if $u->getUserAccess($user, 'SAP') =~ /W/;
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=find_sap_user\" TARGET=\"centre_frame\">Найти пользователя SAP</A>\n"; 
		print "<P><A HREF=\"/cgi-bin/sap_req2.cgi?what=find_sap_users\" TARGET=\"centre_frame\">Найти множество пользователей SAP</A>\n"; 
	}
	if ($si eq 'SZ'){
		 print "<P><A HREF=\"/cgi-bin/sap/sap-user.cgi?what=insert\" TARGET=\"centre_frame\">Создание пользователя</A>\n"
			if $u->getUserAccess($user, 'SZ') =~ /W/;
	}
}
elsif($w eq 'centre_frame'){
	my $user_name = $u->getUserName($user);
	my $Hello = $u->getWelcome($user) || "Hello, USERNAME !";
	$Hello =~ s/USERNAME/$user_name/;
	print "<H1>$Hello</H1><br>\n";
	print "<P><MARQUEE><FONT COLOR= \"black\" size=\"4\" >Обо всех проблемах в работе интерфейса, пожалуйста, сообщайте по адресу <a href=\"mailto:svsoldatov\@yourdomaoin.ru\"><b>svsoldatov\@yourdomaoin.ru</b></a></FONT COLOR></MARQUEE></P>\n";
}



#print "<TABLE><TR><TH>VAR<TH>VAL</TR>\n";
#for (keys %ENV){
#	print "<TR><TD>$_<TD>".$ENV{$_}."</TR>\n";
#}
#print "</TABLE>\n";

print $q->end_html,"\n"; 


