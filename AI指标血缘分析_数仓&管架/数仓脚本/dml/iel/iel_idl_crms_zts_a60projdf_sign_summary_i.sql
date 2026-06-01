: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a60projdf_sign_summary_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_zts_a60projdf_sign_summary_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
projno
,summsq
,bachdt
,bachsq
,datfna
,mmtext
,mmcont
,projtp
,payacc
,paynam
,tranno
,tranam
,succno
,succam
,failno
,failam
,branch
,tlrnbr
,opendcmt
,opendcno
,transt
,prtdt
,chktlr
,transq
,dcmtno
,payadr
,paytel
,enflag
,trflag
,errmsg
,agstyp
,iccdfg
,coopcd
from ${idl_schema}.crms_zts_a60projdf_sign_summary
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_zts_a60projdf_sign_summary_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes