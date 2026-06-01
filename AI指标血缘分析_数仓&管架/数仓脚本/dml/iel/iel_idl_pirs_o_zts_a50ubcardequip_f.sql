: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_zts_a50ubcardequip_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_zts_a50ubcardequip_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select termid
,unit
,tell
,addr
,ipaddr
,type
,lastdate
,equipstat
,module1
,module2
,module3
,module4
,othmod
,sflag
,trskey
,filldate
,currvalue1
,currvalue2
,currvalue3
,currvalue4
,lastfill1
,lastfill2
,lastfill3
,lastfill4
,periprst1
,periprst2
,periprst3
,periprst4
,cutdate
,cutprst1
,cutprst2
,cutprst3
,cutprst4
,cwdnum
,cwdsum
,depnum
,depsum
,tfrnum
,tfrsum
,cardret
,zmkey
,zakey
,machinekey
,begindatetime
,enddatetime
,remainno
,lastopttime
 from idl.pirs_o_zts_a50ubcardequip where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_zts_a50ubcardequip_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes