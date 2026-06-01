: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_bid_margin_acct_cfg_info_h_f
CreateDate: 20230927
FileName:   ${iel_data_path}/agt_bid_margin_acct_cfg_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.sub_acct_num_prefix,chr(13),''),chr(10),'') as sub_acct_num_prefix
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,sub_acct_num_qtty
,replace(replace(t1.allow_setup_sub_acct_num_flg,chr(13),''),chr(10),'') as allow_setup_sub_acct_num_flg
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,rgst_tm
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.proj_name,chr(13),''),chr(10),'') as proj_name

from ${iml_schema}.agt_bid_margin_acct_cfg_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bid_margin_acct_cfg_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
