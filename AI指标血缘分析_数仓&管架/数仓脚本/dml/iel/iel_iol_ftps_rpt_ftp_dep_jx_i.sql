: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ftps_rpt_ftp_dep_jx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ftps_rpt_ftp_dep_jx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.data_dt as data_dt
,replace(replace(t1.tp_code,chr(13),''),chr(10),'') as tp_code
,replace(replace(t1.tp_desc,chr(13),''),chr(10),'') as tp_desc
,replace(replace(t1.currency_cd,chr(13),''),chr(10),'') as currency_cd
,t1.term as term
,replace(replace(t1.term_cd,chr(13),''),chr(10),'') as term_cd
,t1.base_ftp_rate as base_ftp_rate
,t1.adj01 as adj01
,t1.adj02 as adj02
,t1.adj03 as adj03
,t1.adj04 as adj04
,t1.adj05 as adj05
,t1.adj06 as adj06
,t1.adj07 as adj07
,t1.adj08 as adj08
,t1.adj09 as adj09
,t1.adj10 as adj10
from ${iol_schema}.ftps_rpt_ftp_dep_jx t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ftps_rpt_ftp_dep_jx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes