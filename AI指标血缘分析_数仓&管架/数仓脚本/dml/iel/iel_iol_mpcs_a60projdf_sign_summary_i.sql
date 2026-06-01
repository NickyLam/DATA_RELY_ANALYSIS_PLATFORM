: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a60projdf_sign_summary_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a60projdf_sign_summary.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.projno,chr(13),''),chr(10),'') as projno
,replace(replace(t.summsq,chr(13),''),chr(10),'') as summsq
,replace(replace(t.bachdt,chr(13),''),chr(10),'') as bachdt
,replace(replace(t.bachsq,chr(13),''),chr(10),'') as bachsq
,replace(replace(t.datfna,chr(13),''),chr(10),'') as datfna
,replace(replace(t.mmtext,chr(13),''),chr(10),'') as mmtext
,replace(replace(t.mmcont,chr(13),''),chr(10),'') as mmcont
,replace(replace(t.projtp,chr(13),''),chr(10),'') as projtp
,replace(replace(t.payacc,chr(13),''),chr(10),'') as payacc
,replace(replace(t.paynam,chr(13),''),chr(10),'') as paynam
,t.tranno as tranno
,t.tranam as tranam
,t.succno as succno
,t.succam as succam
,t.failno as failno
,t.failam as failam
,replace(replace(t.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t.tlrnbr,chr(13),''),chr(10),'') as tlrnbr
,replace(replace(t.opendcmt,chr(13),''),chr(10),'') as opendcmt
,replace(replace(t.opendcno,chr(13),''),chr(10),'') as opendcno
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.prtdt,chr(13),''),chr(10),'') as prtdt
,replace(replace(t.chktlr,chr(13),''),chr(10),'') as chktlr
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t.payadr,chr(13),''),chr(10),'') as payadr
,replace(replace(t.paytel,chr(13),''),chr(10),'') as paytel
,replace(replace(t.enflag,chr(13),''),chr(10),'') as enflag
,replace(replace(t.trflag,chr(13),''),chr(10),'') as trflag
,replace(replace(t.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t.iccdfg,chr(13),''),chr(10),'') as iccdfg
,replace(replace(t.coopcd,chr(13),''),chr(10),'') as coopcd
,replace(replace(t.agstyp,chr(13),''),chr(10),'') as agstyp
,replace(replace(t.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t.signst,chr(13),''),chr(10),'') as signst
,replace(replace(t.realacctno,chr(13),''),chr(10),'') as realacctno
,replace(replace(t.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t.hostdt,chr(13),''),chr(10),'') as hostdt
,replace(replace(t.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t.cardkind,chr(13),''),chr(10),'') as cardkind
from ${iol_schema}.MPCS_A60PROJDF_SIGN_SUMMARY t 
where BACHDT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a60projdf_sign_summary.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes