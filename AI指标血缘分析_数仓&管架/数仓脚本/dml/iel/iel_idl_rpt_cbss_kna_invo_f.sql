: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kna_invo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kna_invo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.invosi,chr(13),''),chr(10),'') as invosi
,replace(replace(t1.invosi1,chr(13),''),chr(10),'') as invosi1
,replace(replace(t1.invorm,chr(13),''),chr(10),'') as invorm
,replace(replace(t1.invodl,chr(13),''),chr(10),'') as invodl
,replace(replace(t1.invobr,chr(13),''),chr(10),'') as invobr
,replace(replace(t1.invost,chr(13),''),chr(10),'') as invost
,replace(replace(t1.invobr2,chr(13),''),chr(10),'') as invobr2
,replace(replace(t1.sendsi,chr(13),''),chr(10),'') as sendsi
,t1.sendti as sendti
,replace(replace(t1.invodt,chr(13),''),chr(10),'') as invodt
,replace(replace(t1.invodt1,chr(13),''),chr(10),'') as invodt1
,replace(replace(t1.invodt2,chr(13),''),chr(10),'') as invodt2
,replace(replace(t1.frozdt,chr(13),''),chr(10),'') as frozdt
,replace(replace(t1.frozsq,chr(13),''),chr(10),'') as frozsq
,t1.invoti as invoti
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.reason,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.intext,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5
,replace(replace(t1.remark6,chr(13),''),chr(10),'') as remark6
,replace(replace(t1.remark7,chr(13),''),chr(10),'') as remark7
,replace(replace(t1.remark8,chr(13),''),chr(10),'') as remark8
from ${iol_schema}.cbss_kna_invo t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kna_invo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes