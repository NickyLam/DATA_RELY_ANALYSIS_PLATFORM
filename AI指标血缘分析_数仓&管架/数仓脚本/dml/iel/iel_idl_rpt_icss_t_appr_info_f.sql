: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_appr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_appr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.creditarea,chr(13),''),chr(10),'') as creditarea
,t1.businesssum as businesssum
,t1.totalsum as totalsum
,t1.businessavlsum as businessavlsum
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.approveopinion,chr(13),''),chr(10),'') as approveopinion
,replace(replace(t1.approvedate,chr(13),''),chr(10),'') as approvedate
,replace(replace(t1.isestatefinance,chr(13),''),chr(10),'') as isestatefinance
,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'') as isgovernfinance
,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'') as isconsumerfinance
,replace(replace(t1.isbeltroadfinance,chr(13),''),chr(10),'') as isbeltroadfinance
,replace(replace(t1.isgreenfinance,chr(13),''),chr(10),'') as isgreenfinance
,replace(replace(t1.amtduelevel,chr(13),''),chr(10),'') as amtduelevel
,replace(replace(t1.pricerisktype,chr(13),''),chr(10),'') as pricerisktype
,replace(replace(t1.pbusinesstype,chr(13),''),chr(10),'') as pbusinesstype
,replace(replace(t1.pbusinesscurrency,chr(13),''),chr(10),'') as pbusinesscurrency
,t1.pbusinesssum as pbusinesssum
,t1.ptotalsum as ptotalsum
,t1.pbusinessbal as pbusinessbal
,t1.pbusinessavlbal as pbusinessavlbal
,replace(replace(t1.pbegindate,chr(13),''),chr(10),'') as pbegindate
,replace(replace(t1.penddate,chr(13),''),chr(10),'') as penddate
,replace(replace(t1.operateuser,chr(13),''),chr(10),'') as operateuser
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
 from iol.icss_t_appr_info T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_appr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes