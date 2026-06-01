: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_ghb_finc_prod_inpwn_info_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_ghb_finc_prod_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t1.finc_prod_name,chr(13),''),chr(10),'') as finc_prod_name
,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,cap_avl_days
,value_dt
,exp_dt
,inpwn_lot
,expe_yld_rat
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tot_lot
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_dt
,update_dt

from ${iml_schema}.ast_ghb_finc_prod_inpwn_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_ghb_finc_prod_inpwn_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
