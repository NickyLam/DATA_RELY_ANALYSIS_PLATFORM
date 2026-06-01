: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1ntsignacctinfo_f
CreateDate: 20240220
FileName:   ${iel_data_path}/mpcs_a1ntsignacctinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.mainseq,chr(13),''),chr(10),'') as mainseq
,replace(replace(t1.projectcode,chr(13),''),chr(10),'') as projectcode
,replace(replace(t1.projectname,chr(13),''),chr(10),'') as projectname
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.qybh,chr(13),''),chr(10),'') as qybh
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.fbqycode,chr(13),''),chr(10),'') as fbqycode
,replace(replace(t1.fbqyname,chr(13),''),chr(10),'') as fbqyname
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.specialaccount,chr(13),''),chr(10),'') as specialaccount
,replace(replace(t1.accountname,chr(13),''),chr(10),'') as accountname
,replace(replace(t1.bankjointnumber,chr(13),''),chr(10),'') as bankjointnumber
,replace(replace(t1.optype,chr(13),''),chr(10),'') as optype
,replace(replace(t1.opbalance,chr(13),''),chr(10),'') as opbalance
,replace(replace(t1.ophandler,chr(13),''),chr(10),'') as ophandler
,replace(replace(t1.ophandleridcard,chr(13),''),chr(10),'') as ophandleridcard
,replace(replace(t1.opcreatime,chr(13),''),chr(10),'') as opcreatime
,replace(replace(t1.opremarks,chr(13),''),chr(10),'') as opremarks
,replace(replace(t1.destype,chr(13),''),chr(10),'') as destype
,replace(replace(t1.balance,chr(13),''),chr(10),'') as balance
,replace(replace(t1.deshandler,chr(13),''),chr(10),'') as deshandler
,replace(replace(t1.deshandleridcard,chr(13),''),chr(10),'') as deshandleridcard
,replace(replace(t1.transactionno,chr(13),''),chr(10),'') as transactionno
,replace(replace(t1.destaccount,chr(13),''),chr(10),'') as destaccount
,replace(replace(t1.destname,chr(13),''),chr(10),'') as destname
,replace(replace(t1.destorgancode,chr(13),''),chr(10),'') as destorgancode
,replace(replace(t1.destbusicode,chr(13),''),chr(10),'') as destbusicode
,replace(replace(t1.descreatime,chr(13),''),chr(10),'') as descreatime
,replace(replace(t1.desremarks,chr(13),''),chr(10),'') as desremarks
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.sndstatus,chr(13),''),chr(10),'') as sndstatus
,replace(replace(t1.updt,chr(13),''),chr(10),'') as updt
,replace(replace(t1.tlrno,chr(13),''),chr(10),'') as tlrno
,replace(replace(t1.brcno,chr(13),''),chr(10),'') as brcno
,replace(replace(t1.oldspecialaccount,chr(13),''),chr(10),'') as oldspecialaccount
,replace(replace(t1.projno,chr(13),''),chr(10),'') as projno
,replace(replace(t1.spectp,chr(13),''),chr(10),'') as spectp
,replace(replace(t1.glacno,chr(13),''),chr(10),'') as glacno
,replace(replace(t1.glacna,chr(13),''),chr(10),'') as glacna
,replace(replace(t1.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t1.payacctname,chr(13),''),chr(10),'') as payacctname
,replace(replace(t1.payacctbank,chr(13),''),chr(10),'') as payacctbank

from ${iol_schema}.mpcs_a1ntsignacctinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1ntsignacctinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
