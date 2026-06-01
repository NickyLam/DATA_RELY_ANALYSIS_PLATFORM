: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_card_ubhandchrg_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_card_ubhandchrg_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select trandate
,trantype
,tranflag
,brnnbr
,tranamt
,recvamt
,uniodate
,unionbr
,hostnbr
,hostdate
,status
,errcode
,errmsg from idl.pirs_f_evt_card_ubhandchrg where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_card_ubhandchrg_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes