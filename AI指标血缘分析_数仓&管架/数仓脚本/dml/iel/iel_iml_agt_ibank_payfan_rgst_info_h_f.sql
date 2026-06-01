: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ibank_payfan_rgst_info_h_f
CreateDate: 20230927
FileName:   ${iel_data_path}/agt_ibank_payfan_rgst_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_inr,chr(13),''),chr(10),'') as tran_inr
,replace(replace(t1.rela_table_name,chr(13),''),chr(10),'') as rela_table_name
,replace(replace(t1.rela_tab_inr,chr(13),''),chr(10),'') as rela_tab_inr
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,ths_tm_payfan_pric
,ths_tm_payfan_int
,ths_tm_payfan_pnlt
,payfan_value_dt
,payfan_exp_dt
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,ovdue_int_rat
,payfan_pnlt_int_rat
,entry_amt
,int_adj_amt
,pnlt_adj_amt
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.pay_cont_id,chr(13),''),chr(10),'') as pay_cont_id
,replace(replace(t1.applit_cust_id,chr(13),''),chr(10),'') as applit_cust_id
,replace(replace(t1.final_coll_flg,chr(13),''),chr(10),'') as final_coll_flg
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id

from ${iml_schema}.agt_ibank_payfan_rgst_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ibank_payfan_rgst_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
