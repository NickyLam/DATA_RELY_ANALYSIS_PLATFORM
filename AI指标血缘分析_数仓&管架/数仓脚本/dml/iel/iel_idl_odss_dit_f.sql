: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_dit_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_dit_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select inr
,adlcnd
,defdet
,dftat
,feetxt
,insbnk
,lcrdoc
,lcrgod
,mixdet
,preper
,rmbcha
,shpper
,ver
,adlcndame
,lcrgodame
,lcrdocame
,narhis
,fldmodblk
,revnotes
,revcls
,avbwthtxt
,addamtcov
,insbnkame
,contag72
,contag79
,preperdef
,preperflg
,decamtstm
,forins
,insdat
,othtyp
,xddstm from ${idl_schema}.odss_dit where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_dit_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes