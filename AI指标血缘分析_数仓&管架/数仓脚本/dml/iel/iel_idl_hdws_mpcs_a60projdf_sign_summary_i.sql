: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a60projdf_sign_summary_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a60projdf_sign_summary.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.projno
,t1.summsq
,t1.bachdt
,t1.bachsq
,t1.datfna
,t1.mmtext
,t1.mmcont
,t1.projtp
,t1.payacc
,t1.paynam
,t1.tranno
,t1.tranam
,t1.succno
,t1.succam
,t1.failno
,t1.failam
,t1.branch
,t1.tlrnbr
,t1.opendcmt
,t1.opendcno
,t1.transt
,t1.prtdt
,t1.chktlr
,t1.transq
,t1.dcmtno
,t1.payadr
,t1.paytel
,t1.enflag
,t1.trflag
,t1.errmsg
,t1.iccdfg
,t1.coopcd
,t1.agstyp
,t1.trantp
,t1.signst
,t1.realacctno
,t1.hostseqno
,t1.hostdt
,t1.transeqno
,t1.cardkind
from ${idl_schema}.hdws_mpcs_a60projdf_sign_summary t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a60projdf_sign_summary.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes