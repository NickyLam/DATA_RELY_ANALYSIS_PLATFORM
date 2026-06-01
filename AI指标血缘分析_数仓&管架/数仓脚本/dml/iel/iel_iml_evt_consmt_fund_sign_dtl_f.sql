: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_consmt_fund_sign_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_consmt_fund_sign_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
    ,replace(replace(t.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num
    ,replace(replace(t.cfm_flow_num,chr(13),''),chr(10),'') as cfm_flow_num
    ,t.appl_dt as appl_dt
    ,t.appl_tm as appl_tm
    ,t.sys_dt as sys_dt
    ,t.cfm_dt as cfm_dt
    ,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id
    ,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
    ,replace(replace(t.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_abbr,chr(13),''),chr(10),'') as cust_abbr
    ,replace(replace(t.fund_acct_id,chr(13),''),chr(10),'') as fund_acct_id
    ,replace(replace(t.seller_id,chr(13),''),chr(10),'') as seller_id
    ,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
    ,replace(replace(t.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
    ,replace(replace(t.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
    ,replace(replace(t.gender_cd,chr(13),''),chr(10),'') as gender_cd
    ,t.birth_dt as birth_dt
    ,replace(replace(t.resdnt_addr,chr(13),''),chr(10),'') as resdnt_addr
    ,replace(replace(t.zip_cd,chr(13),''),chr(10),'') as zip_cd
    ,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
    ,replace(replace(t.mobile_no,chr(13),''),chr(10),'') as mobile_no
    ,replace(replace(t.e_mail,chr(13),''),chr(10),'') as e_mail
    ,replace(replace(t.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
    ,replace(replace(t.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
    ,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.err_cd,chr(13),''),chr(10),'') as err_cd
    ,replace(replace(t.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,replace(replace(t.accpt_way_cd,chr(13),''),chr(10),'') as accpt_way_cd
from iml.evt_consmt_fund_sign_dtl t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_consmt_fund_sign_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes