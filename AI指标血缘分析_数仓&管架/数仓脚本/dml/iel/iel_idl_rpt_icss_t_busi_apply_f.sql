: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_busi_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_busi_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.operateorg,chr(13),''),chr(10),'') as operateorg
,replace(replace(t1.leader,chr(13),''),chr(10),'') as leader
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,t1.businesssum as businesssum
,t1.totalsum as totalsum
,t1.termmonth as termmonth
,replace(replace(t1.pbusinesstype,chr(13),''),chr(10),'') as pbusinesstype
,replace(replace(t1.pbusinesscurrency,chr(13),''),chr(10),'') as pbusinesscurrency
,t1.pbusinesssum as pbusinesssum
,t1.ptotalsum as ptotalsum
,replace(replace(t1.pbegindate,chr(13),''),chr(10),'') as pbegindate
,replace(replace(t1.penddate,chr(13),''),chr(10),'') as penddate
 from iol.icss_t_busi_apply T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_busi_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes