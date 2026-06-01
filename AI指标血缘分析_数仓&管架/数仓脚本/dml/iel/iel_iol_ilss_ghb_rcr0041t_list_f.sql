: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_rcr0041t_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_rcr0041t_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.rela_id as rela_id
,replace(replace(t.busstype,chr(13),''),chr(10),'') as busstype
,replace(replace(t.loan_start_date,chr(13),''),chr(10),'') as loan_start_date
,replace(replace(t.loan_end_date,chr(13),''),chr(10),'') as loan_end_date
,t.loan_amt as loan_amt
from iol.ilss_ghb_rcr0041t_list t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_rcr0041t_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes