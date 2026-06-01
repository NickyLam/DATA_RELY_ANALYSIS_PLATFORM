: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ftps_rpt_rst_ftp261_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ftps_rpt_rst_ftp261_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.data_date as data_date
    ,replace(replace(t.soc_cre_code,chr(13),''),chr(10),'') as soc_cre_code
    ,replace(replace(t.ftp_bus_type,chr(13),''),chr(10),'') as ftp_bus_type
    ,replace(replace(t.term_type_cd,chr(13),''),chr(10),'') as term_type_cd
    ,t.cha_date as cha_date
    ,t.ftp_rate as ftp_rate
from iol.ftps_rpt_rst_ftp261_info t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ftps_rpt_rst_ftp261_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes