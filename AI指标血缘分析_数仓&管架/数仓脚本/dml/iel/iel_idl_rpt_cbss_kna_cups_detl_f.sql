: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kna_cups_detl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kna_cups_detl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.btchno,chr(13),''),chr(10),'') as btchno
,replace(replace(t1.blbrch,chr(13),''),chr(10),'') as blbrch
,replace(replace(t1.blusid,chr(13),''),chr(10),'') as blusid
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.cpstyp,chr(13),''),chr(10),'') as cpstyp
,replace(replace(t1.csbxno,chr(13),''),chr(10),'') as csbxno
,t1.fulcps as fulcps
,t1.icpcps as icpcps
,t1.sipcps as sipcps
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
 from iol.cbss_kna_cups_detl T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kna_cups_detl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes