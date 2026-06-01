: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_caps_dms_exch_loan_sign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_caps_dms_exch_loan_sign.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(rid,chr(10),''),chr(13),'') as rid
      ,replace(replace(oper_typ_cd,chr(10),''),chr(13),'') as oper_typ_cd
      ,replace(replace(del_rsns,chr(10),''),chr(13),'') as del_rsns
      ,replace(replace(dms_or_ovs_exch_loan_id,chr(10),''),chr(13),'') as dms_or_ovs_exch_loan_id
      ,replace(replace(creditorcode,chr(10),''),chr(13),'') as creditorcode
      ,replace(replace(debt_cd,chr(10),''),chr(13),'') as debt_cd
      ,replace(replace(debt_cn_name,chr(10),''),chr(13),'') as debt_cn_name
      ,replace(replace(dofoexlotype,chr(10),''),chr(13),'') as dofoexlotype
      ,replace(replace(lenproname,chr(10),''),chr(13),'') as lenproname
      ,replace(replace(lenagree,chr(10),''),chr(13),'') as lenagree
      ,replace(replace(int_start_day,chr(10),''),chr(13),'') as int_start_day
      ,replace(replace(due_day,chr(10),''),chr(13),'') as due_day
      ,replace(replace(loan_ccy_cd,chr(10),''),chr(13),'') as loan_ccy_cd
      ,sign_amt
      ,year_rate_val
      ,replace(replace(memo,chr(10),''),chr(13),'') as memo
      ,replace(replace(err_num,chr(10),''),chr(13),'') as err_num
      ,replace(replace(org_id,chr(10),''),chr(13),'') as org_id
      ,replace(replace(etl_dt,chr(10),''),chr(13),'') as etl_dt
      ,replace(replace(sbm_id,chr(10),''),chr(13),'') as sbm_id
      ,replace(replace(contr_num,chr(10),''),chr(13),'') as contr_num 
from idl.hdws_dul_d_caps_dms_exch_loan_sign 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_caps_dms_exch_loan_sign.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes