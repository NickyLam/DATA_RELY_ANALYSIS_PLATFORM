: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ta_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ta_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_src_abbr,chr(13),''),chr(10),'') as sys_src_abbr
,replace(replace(t1.ta_abbr,chr(13),''),chr(10),'') as ta_abbr
,replace(replace(t1.ta_name,chr(13),''),chr(10),'') as ta_name
,replace(replace(t1.check_entry_mode_cd,chr(13),''),chr(10),'') as check_entry_mode_cd
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
,replace(replace(t1.close_tm,chr(13),''),chr(10),'') as close_tm
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t1.tot_flg,chr(13),''),chr(10),'') as tot_flg
,replace(replace(t1.multi_acct_num_mode_flg,chr(13),''),chr(10),'') as multi_acct_num_mode_flg
,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_ta_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ta_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
