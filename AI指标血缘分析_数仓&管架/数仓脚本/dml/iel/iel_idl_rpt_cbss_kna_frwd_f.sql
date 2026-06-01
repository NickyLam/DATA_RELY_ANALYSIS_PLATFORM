: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kna_frwd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kna_frwd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.cyovdt,chr(13),''),chr(10),'') as cyovdt
,replace(replace(t1.cyovsq,chr(13),''),chr(10),'') as cyovsq
,t1.cytlam as cytlam
,t1.cyprin as cyprin
,t1.cyinst as cyinst
,replace(replace(t1.rttrdt,chr(13),''),chr(10),'') as rttrdt
,replace(replace(t1.rttrsq,chr(13),''),chr(10),'') as rttrsq
,replace(replace(t1.dtitcd,chr(13),''),chr(10),'') as dtitcd
,replace(replace(t1.toacct,chr(13),''),chr(10),'') as toacct
,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t1.erortx,chr(13),''),chr(10),'') as erortx
,replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid
 from iol.cbss_kna_frwd T1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kna_frwd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
