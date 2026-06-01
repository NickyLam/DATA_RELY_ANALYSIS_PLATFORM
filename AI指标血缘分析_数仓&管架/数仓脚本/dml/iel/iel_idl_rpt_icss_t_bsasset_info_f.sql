: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_bsasset_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_bsasset_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.businesssum as businesssum
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
 from iol.icss_t_bsasset_info T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_bsasset_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes