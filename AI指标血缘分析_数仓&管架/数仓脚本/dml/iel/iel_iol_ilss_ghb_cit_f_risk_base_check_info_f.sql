: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_cit_f_risk_base_check_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_cit_f_risk_base_check_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.qry_seq_num,chr(13),''),chr(10),'') as qry_seq_num
,replace(replace(t.etl_dt_ora,chr(13),''),chr(10),'') as etl_dt_ora
,replace(replace(t.quer_iden_num,chr(13),''),chr(10),'') as quer_iden_num
,replace(replace(t.quer_name,chr(13),''),chr(10),'') as quer_name
,replace(replace(t.final_risk_est_resu_cd,chr(13),''),chr(10),'') as final_risk_est_resu_cd
,replace(replace(t.final_risk_coef,chr(13),''),chr(10),'') as final_risk_coef
,replace(replace(t.medium_rule_to_uniq_encd,chr(13),''),chr(10),'') as medium_rule_to_uniq_encd
,replace(replace(t.medium_rule_id,chr(13),''),chr(10),'') as medium_rule_id
,replace(replace(t.medium_rule_name,chr(13),''),chr(10),'') as medium_rule_name
,replace(replace(t.medium_rule_decis_resu,chr(13),''),chr(10),'') as medium_rule_decis_resu
from iol.ilss_ghb_cit_f_risk_base_check_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_cit_f_risk_base_check_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes