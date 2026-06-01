: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_lmt_seg_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_lmt_seg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.obj_type_name as obj_type_name
,t1.obj_id as obj_id
,t1.up_level_seg_lmt_id as up_level_seg_lmt_id
,t1.seg_obj_type_cd as seg_obj_type_cd
,t1.seg_obj_id as seg_obj_id
,t1.circl_flg as circl_flg
,t1.curr_cd as curr_cd
,t1.nmal_amt as nmal_amt
,t1.open_amt as open_amt
,t1.used_nmal_amt as used_nmal_amt
,t1.used_open_amt as used_open_amt
,t1.aval_nmal_amt as aval_nmal_amt
,t1.aval_open_amt as aval_open_amt
,t1.higt_sig_amt as higt_sig_amt
,t1.lowt_margin_ratio as lowt_margin_ratio
,t1.lowt_int_rat as lowt_int_rat
,t1.other_request_descb as other_request_descb
,t1.status_cd as status_cd
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.guar_type_cd as guar_type_cd
,t1.exlus_lmt_flg as exlus_lmt_flg
,t1.chn_id as chn_id
,t1.init_obj_type_name as init_obj_type_name
,t1.init_obj_id as init_obj_id
,t1.lmt_belong_cust_id as lmt_belong_cust_id
,t1.comn_risk_open_lmt as comn_risk_open_lmt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.seg_lmt_id as seg_lmt_id

from ${idl_schema}.oass_agt_loan_lmt_seg_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_lmt_seg_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
