: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_epc_pay_ext_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_epc_pay_ext_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.tran_id,chr(13),''),chr(10),'') as tran_id
    ,replace(replace(t.payer_epc_org_id,chr(13),''),chr(10),'') as payer_epc_org_id
    ,replace(replace(t.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
    ,replace(replace(t.payer_acct_type_cd,chr(13),''),chr(10),'') as payer_acct_type_cd
    ,replace(replace(t.recver_epc_org_id,chr(13),''),chr(10),'') as recver_epc_org_id
    ,replace(replace(t.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
    ,replace(replace(t.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name
    ,replace(replace(t.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd
    ,replace(replace(t.epc_org_exc_resv_acct_id,chr(13),''),chr(10),'') as epc_org_exc_resv_acct_id
    ,replace(replace(t.epc_org_exc_resv_acct_name,chr(13),''),chr(10),'') as epc_org_exc_resv_acct_name
    ,replace(replace(t.exc_resv_acct_epc_org_id,chr(13),''),chr(10),'') as exc_resv_acct_epc_org_id
    ,replace(replace(t.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
    ,replace(replace(t.bus_kind_id,chr(13),''),chr(10),'') as bus_kind_id
    ,replace(replace(t.indent_id,chr(13),''),chr(10),'') as indent_id
    ,replace(replace(t.indent_descb,chr(13),''),chr(10),'') as indent_descb
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,t.tran_cmplt_tm as tran_cmplt_tm
    ,replace(replace(t.pay_acct_epc_org_id,chr(13),''),chr(10),'') as pay_acct_epc_org_id
    ,t.create_tm as create_tm
from iml.evt_epc_pay_ext_info t
   where to_char(t.create_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_epc_pay_ext_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes