: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_indv_ext_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_indv_ext_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.risk_estim_level_cd,chr(13),''),chr(10),'') as risk_estim_level_cd
    ,t.risk_estim_valid_tm as risk_estim_valid_tm
    ,replace(replace(t.cmplt_cnter_risk_estim_flg,chr(13),''),chr(10),'') as cmplt_cnter_risk_estim_flg
    ,replace(replace(t.risk_estim_quesn_edit_id,chr(13),''),chr(10),'') as risk_estim_quesn_edit_id
    ,t.risk_estim_quesn_scor as risk_estim_quesn_scor
    ,t.risk_estim_update_tm as risk_estim_update_tm
    ,replace(replace(t.risk_estim_chn_cd,chr(13),''),chr(10),'') as risk_estim_chn_cd
    ,replace(replace(t.use_camp_wish_flg,chr(13),''),chr(10),'') as use_camp_wish_flg
    ,replace(replace(t.qual_invtor_cert_flg,chr(13),''),chr(10),'') as qual_invtor_cert_flg
    ,replace(replace(t.qual_invtor_vlid_tenor,chr(13),''),chr(10),'') as qual_invtor_vlid_tenor
    ,replace(replace(t.qual_invtor_src_chn_cd,chr(13),''),chr(10),'') as qual_invtor_src_chn_cd
    ,replace(replace(t.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
    ,replace(replace(t.create_org_id,chr(13),''),chr(10),'') as create_org_id
    ,replace(replace(t.create_chn_cd,chr(13),''),chr(10),'') as create_chn_cd
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark    
from iml.pty_indv_ext_info t
where start_dt <= to_date('${batch_date}','yyyymmdd')
and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv_ext_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes