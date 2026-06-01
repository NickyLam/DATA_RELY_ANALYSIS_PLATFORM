: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_cbss_pfb_dedt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_cbss_pfb_dedt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,t1.tranam as tranam
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.ckbkus,chr(13),''),chr(10),'') as ckbkus
,replace(replace(t1.extd01,chr(13),''),chr(10),'') as extd01
,replace(replace(t1.extd02,chr(13),''),chr(10),'') as extd02
,replace(replace(t1.extd03,chr(13),''),chr(10),'') as extd03
,replace(replace(t1.extd04,chr(13),''),chr(10),'') as extd04
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.extd05,chr(13),''),chr(10),'') as extd05
,replace(replace(t1.extd06,chr(13),''),chr(10),'') as extd06
,replace(replace(t1.extd07,chr(13),''),chr(10),'') as extd07
,replace(replace(t1.extd08,chr(13),''),chr(10),'') as extd08
,replace(replace(t1.extd09,chr(13),''),chr(10),'') as extd09
,replace(replace(t1.extd10,chr(13),''),chr(10),'') as extd10
,replace(replace(t1.extd11,chr(13),''),chr(10),'') as extd11
,replace(replace(t1.extd12,chr(13),''),chr(10),'') as extd12
,replace(replace(t1.datatp,chr(13),''),chr(10),'') as datatp
,replace(replace(t1.extd13,chr(13),''),chr(10),'') as extd13
,replace(replace(t1.extd14,chr(13),''),chr(10),'') as extd14
,replace(replace(t1.extd15,chr(13),''),chr(10),'') as extd15
,replace(replace(t1.extd17,chr(13),''),chr(10),'') as extd17
,replace(replace(t1.extd16,chr(13),''),chr(10),'') as extd16
,replace(replace(t1.extd18,chr(13),''),chr(10),'') as extd18
from ${iol_schema}.cbss_pfb_dedt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_cbss_pfb_dedt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes