: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_modal_tran_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_modal_tran_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.init_loan_modal_cd,chr(13),''),chr(10),'') as init_loan_modal_cd
,replace(replace(t.loan_modal_cd,chr(13),''),chr(10),'') as loan_modal_cd
,replace(replace(t.init_acru_non_acru_flg_cd,chr(13),''),chr(10),'') as init_acru_non_acru_flg_cd
,replace(replace(t.acru_non_acru_flg_cd,chr(13),''),chr(10),'') as acru_non_acru_flg_cd
,t.nomal_pric_amt as nomal_pric_amt
,t.ovdue_pric_amt as ovdue_pric_amt
,t.idle_pric_amt as idle_pric_amt
,t.bad_debt_pric_amt as bad_debt_pric_amt
,t.recvbl_acru_int_amt as recvbl_acru_int_amt
,t.coll_acru_int_amt as coll_acru_int_amt
,t.recvbl_over_int_amt as recvbl_over_int_amt
,t.coll_over_int_amt as coll_over_int_amt
,t.recvbl_acru_pnlt_amt as recvbl_acru_pnlt_amt
,t.coll_acru_pnlt_amt as coll_acru_pnlt_amt
,t.recvbl_pnlt_amt as recvbl_pnlt_amt
,t.coll_pnlt_amt as coll_pnlt_amt
,t.acru_comp_int_amt as acru_comp_int_amt
,t.comp_int_amt as comp_int_amt
,t.tran_dt as tran_dt
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.tran_evt_cd,chr(13),''),chr(10),'') as tran_evt_cd
,replace(replace(t.tran_evt_descb,chr(13),''),chr(10),'') as tran_evt_descb
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_retl_loan_modal_tran_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_modal_tran_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes