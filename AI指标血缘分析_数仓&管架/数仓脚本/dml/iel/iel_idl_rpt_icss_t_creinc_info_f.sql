: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_creinc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_creinc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.increaseway,chr(13),''),chr(10),'') as increaseway
,replace(replace(t1.ishxcustomer,chr(13),''),chr(10),'') as ishxcustomer
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
 from iol.icss_t_creinc_info T1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_creinc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes