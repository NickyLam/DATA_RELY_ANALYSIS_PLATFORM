: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_plms_addaccountbilllistinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/plms_addaccountbilllistinfo_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select transq
,acctno
,subsac
,tranbr
,brchna
,trandt
,billsq
,cheqtp
,cheqno
,toacct
,tobkna
,toacna
,trantp
,valuna
,amntcd
,tranam
,tranbl from idl.plms_addaccountbilllistinfo where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/plms_addaccountbilllistinfo_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes