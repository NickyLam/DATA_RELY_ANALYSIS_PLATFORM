: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_loan_lmt_seg_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_loan_lmt_seg_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.seg_lmt_id,chr(13),''),chr(10),'') as seg_lmt_id
,replace(replace(t.spcl_seg_lmt_flg,chr(13),''),chr(10),'') as spcl_seg_lmt_flg
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,t.seg_lmt_amt as seg_lmt_amt
,replace(replace(t.seg_lmt_amt_type_cd,chr(13),''),chr(10),'') as seg_lmt_amt_type_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg
,t.seg_lmt_effect_dt as seg_lmt_effect_dt
,t.seg_lmt_invalid_dt as seg_lmt_invalid_dt
,t.seg_lmt_surp_cont_amt as seg_lmt_surp_cont_amt
,replace(replace(t.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,t.estim_freq as estim_freq
,replace(replace(t.freq_corp_cd,chr(13),''),chr(10),'') as freq_corp_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_corp_loan_lmt_seg_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_loan_lmt_seg_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes