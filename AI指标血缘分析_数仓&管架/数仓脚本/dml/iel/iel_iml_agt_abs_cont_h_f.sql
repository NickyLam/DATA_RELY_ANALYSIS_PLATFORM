: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_abs_cont_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_abs_cont_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_bag_cont_id,chr(13),''),chr(10),'') as asset_bag_cont_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,bus_tran_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,replace(replace(t1.asset_bag_id,chr(13),''),chr(10),'') as asset_bag_id
,replace(replace(t1.asset_bag_name,chr(13),''),chr(10),'') as asset_bag_name
,asset_bag_amt
,replace(replace(t1.asset_bag_cont_seq_num,chr(13),''),chr(10),'') as asset_bag_cont_seq_num
,replace(replace(t1.asset_bag_cont_type_cd,chr(13),''),chr(10),'') as asset_bag_cont_type_cd
,replace(replace(t1.asset_bag_cont_status_cd,chr(13),''),chr(10),'') as asset_bag_cont_status_cd
,replace(replace(t1.asset_bag_tran_type_cd,chr(13),''),chr(10),'') as asset_bag_tran_type_cd
,issue_tran_tm
,issue_revo_dt
,pkg_dt
,pkg_tran_tm
,issue_convt_prem
,replace(replace(t1.comp_int_tran_out_idf_cd,chr(13),''),chr(10),'') as comp_int_tran_out_idf_cd
,replace(replace(t1.pnlt_tran_out_idf_cd,chr(13),''),chr(10),'') as pnlt_tran_out_idf_cd
,replace(replace(t1.int_tran_out_idf_cd,chr(13),''),chr(10),'') as int_tran_out_idf_cd
,replace(replace(t1.pl_calc_way_cd,chr(13),''),chr(10),'') as pl_calc_way_cd
,imp_blank_draw_dt
,redem_convt_prem
,redem_value_dt
,asset_redem_dt
,revo_pkg_dt
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,tran_tm
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.apv_teller_id,chr(13),''),chr(10),'') as apv_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,final_modif_dt

from ${iml_schema}.agt_abs_cont_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_abs_cont_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
