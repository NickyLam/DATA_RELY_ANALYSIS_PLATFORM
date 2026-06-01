: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.appl_id
,t1.lp_id
,t1.appl_flow_num
,t1.rela_flow_num
,t1.happ_dt
,t1.party_id
,t1.bus_breed_id
,t1.happ_type_cd
,t1.cap_src_cd
,t1.lmt_circl_flg
,t1.use_crdt_agt_id
,t1.bank_fin_tot
,t1.curr_cd
,t1.appl_amt
,t1.tenor_mon
,t1.major_guartor_id
,t1.low_risk_bus_flg
,t1.remote_loan_flg
,t1.appl_way_cd
,t1.oper_org_id
,t1.oper_teller_id
,t1.oper_dt
,t1.rgst_org_id
,t1.rgst_teller_id
,t1.rgst_dt
,t1.modif_dt
,t1.lmt_circl_flg1
,t1.camp_chn_id
,t1.loan_tenor
,t1.camp_corp_id
,t1.effect_flg
,t1.turn_crdt_flg
,t1.sm_retl_flg
,t1.matn_flg
,t1.ky_l_flg
,t1.risk_type_cd
,t1.o_use_lmt_id
,t1.o_use_lmt_type_cd
,t1.o_use_lmt_all_id
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_appl t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes