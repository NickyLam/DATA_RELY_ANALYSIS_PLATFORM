: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_cit_l_indv_base_check_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_cit_l_indv_base_check_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.quer_iden_num,chr(13),''),chr(10),'') as quer_iden_num
,replace(replace(t.etl_dt_ora,chr(13),''),chr(10),'') as etl_dt_ora
,replace(replace(t.quer_name,chr(13),''),chr(10),'') as quer_name
,t.qry_total_resu_qty as qry_total_resu_qty
,replace(replace(t.qry_end_tm,chr(13),''),chr(10),'') as qry_end_tm
,replace(replace(t.resu_sum,chr(13),''),chr(10),'') as resu_sum
from iol.ilss_ghb_cit_l_indv_base_check_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_cit_l_indv_base_check_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes