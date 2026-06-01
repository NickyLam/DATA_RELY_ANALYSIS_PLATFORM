: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_batch_open_card_actv_chn_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_batch_open_card_actv_chn.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.card_no,chr(13),''),chr(10),'') as card_no
    ,t.batch_dt as batch_dt
    ,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
    ,replace(replace(t.payoff_flg_cd,chr(13),''),chr(10),'') as payoff_flg_cd
    ,replace(replace(t.init_actv_chn_cd,chr(13),''),chr(10),'') as init_actv_chn_cd
    ,t.actv_dt as actv_dt
    ,replace(replace(t.actv_flow_id,chr(13),''),chr(10),'') as actv_flow_id
    ,t.cnter_cfm_dt as cnter_cfm_dt
    ,replace(replace(t.cnter_cfm_flow_id,chr(13),''),chr(10),'') as cnter_cfm_flow_id
    ,replace(replace(t.cnter_cfm_flg_cd,chr(13),''),chr(10),'') as cnter_cfm_flg_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_batch_open_card_actv_chn t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_batch_open_card_actv_chn.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes