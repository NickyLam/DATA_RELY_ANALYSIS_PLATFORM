: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_curr_fin_instm_int_rat_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_curr_fin_instm_int_rat.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.int_rat_id,chr(13),''),chr(10),'') as int_rat_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.int_rat_def_id,chr(13),''),chr(10),'') as int_rat_def_id
,int_rat
,vp_start_dt
,vp_end_dt
,replace(replace(t1.cfm_id,chr(13),''),chr(10),'') as cfm_id
,replace(replace(t1.txy_matn_flg,chr(13),''),chr(10),'') as txy_matn_flg
,sign_lmt
,create_dt
,update_dt

from ${iml_schema}.ref_curr_fin_instm_int_rat t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_curr_fin_instm_int_rat.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
