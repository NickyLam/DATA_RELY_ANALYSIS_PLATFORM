: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_syn_cnter_sign_prod_para_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_syn_cnter_sign_prod_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sign_agt_cd,chr(13),''),chr(10),'') as sign_agt_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_name,chr(13),''),chr(10),'') as agt_name
,replace(replace(t1.sign_way_cd,chr(13),''),chr(10),'') as sign_way_cd
,replace(replace(t1.realtm_sync_flg,chr(13),''),chr(10),'') as realtm_sync_flg
,replace(replace(t1.sell_obj_cd,chr(13),''),chr(10),'') as sell_obj_cd
,replace(replace(t1.sign_obj_permit_cd,chr(13),''),chr(10),'') as sign_obj_permit_cd
,replace(replace(t1.auto_change_card_cd,chr(13),''),chr(10),'') as auto_change_card_cd
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_syn_cnter_sign_prod_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_syn_cnter_sign_prod_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
