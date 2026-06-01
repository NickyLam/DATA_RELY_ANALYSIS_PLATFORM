: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_crdt_lmt_seg_h_f
CreateDate: 20241230
FileName:   ${iel_data_path}/agt_crdt_lmt_seg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seg_lmt_id,chr(13),''),chr(10),'') as seg_lmt_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.up_level_seg_lmt_id,chr(13),''),chr(10),'') as up_level_seg_lmt_id
,replace(replace(t1.seg_type_cd,chr(13),''),chr(10),'') as seg_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.spcl_seg_lmt_flg,chr(13),''),chr(10),'') as spcl_seg_lmt_flg
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.seg_obj_id,chr(13),''),chr(10),'') as seg_obj_id
,replace(replace(t1.seg_obj_type_name,chr(13),''),chr(10),'') as seg_obj_type_name
,seg_open_amt
,seg_nmal_amt
,ocup_nmal_amt
,ocup_open_amt
,aval_nmal_amt
,aval_open_amt
,comn_open_amt
,comn_risk_aval_open_amt
,class_low_risk_open_amt
,class_low_risk_aval_open_amt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_crdt_lmt_seg_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_crdt_lmt_seg_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
