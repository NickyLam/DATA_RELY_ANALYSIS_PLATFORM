: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_comb_post_h_f
CreateDate: 20240229
FileName:   ${iel_data_path}/prd_am_comb_post_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inv_port_id,chr(13),''),chr(10),'') as inv_port_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id
,brch_seq_num
,replace(replace(t1.invest_aim_cd,chr(13),''),chr(10),'') as invest_aim_cd
,replace(replace(t1.post_type_cd,chr(13),''),chr(10),'') as post_type_cd
,post_lot
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.super_prod_id,chr(13),''),chr(10),'') as super_prod_id
,bond_fac_val

from ${iml_schema}.prd_am_comb_post_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_comb_post_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
