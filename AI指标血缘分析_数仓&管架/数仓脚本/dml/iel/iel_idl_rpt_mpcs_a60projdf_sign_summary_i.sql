: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a60projdf_sign_summary_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a60projdf_sign_summary.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.projno,chr(13),''),chr(10),'') as projno
,replace(replace(t1.summsq,chr(13),''),chr(10),'') as summsq
,replace(replace(t1.bachdt,chr(13),''),chr(10),'') as bachdt
,replace(replace(t1.bachsq,chr(13),''),chr(10),'') as bachsq
,replace(replace(t1.datfna,chr(13),''),chr(10),'') as datfna
,replace(replace(t1.mmtext,chr(13),''),chr(10),'') as mmtext
,replace(replace(t1.mmcont,chr(13),''),chr(10),'') as mmcont
,replace(replace(t1.projtp,chr(13),''),chr(10),'') as projtp
,replace(replace(t1.payacc,chr(13),''),chr(10),'') as payacc
,replace(replace(t1.paynam,chr(13),''),chr(10),'') as paynam
,t1.tranno as tranno
,t1.tranam as tranam
,t1.succno as succno
,t1.succam as succam
,t1.failno as failno
,t1.failam as failam
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.tlrnbr,chr(13),''),chr(10),'') as tlrnbr
,replace(replace(t1.opendcmt,chr(13),''),chr(10),'') as opendcmt
,replace(replace(t1.opendcno,chr(13),''),chr(10),'') as opendcno
,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t1.prtdt,chr(13),''),chr(10),'') as prtdt
,replace(replace(t1.chktlr,chr(13),''),chr(10),'') as chktlr
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t1.payadr,chr(13),''),chr(10),'') as payadr
,replace(replace(t1.paytel,chr(13),''),chr(10),'') as paytel
,replace(replace(t1.enflag,chr(13),''),chr(10),'') as enflag
,replace(replace(t1.trflag,chr(13),''),chr(10),'') as trflag
,replace(replace(t1.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t1.iccdfg,chr(13),''),chr(10),'') as iccdfg
,replace(replace(t1.coopcd,chr(13),''),chr(10),'') as coopcd
,replace(replace(t1.agstyp,chr(13),''),chr(10),'') as agstyp
,replace(replace(t1.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t1.signst,chr(13),''),chr(10),'') as signst
,replace(replace(t1.realacctno,chr(13),''),chr(10),'') as realacctno
,replace(replace(t1.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t1.hostdt,chr(13),''),chr(10),'') as hostdt
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.cardkind,chr(13),''),chr(10),'') as cardkind
 from iol.mpcs_a60projdf_sign_summary T1
where bachdt='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a60projdf_sign_summary.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes