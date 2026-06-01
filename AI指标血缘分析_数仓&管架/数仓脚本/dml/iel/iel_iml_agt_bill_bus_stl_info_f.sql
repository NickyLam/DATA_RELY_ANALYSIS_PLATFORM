: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_bus_stl_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_bill_bus_stl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
replace(replace(bus_stl_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(mem_org_cd,chr(13),''),chr(10),'')
,replace(replace(stl_req_id,chr(13),''),chr(10),'')
,stl_tm
,replace(replace(bus_type_cd,chr(13),''),chr(10),'')
,replace(replace(stl_way_cd,chr(13),''),chr(10),'')
,replace(replace(stl_bus_type_cd,chr(13),''),chr(10),'')
,replace(replace(clear_type_cd,chr(13),''),chr(10),'')
,replace(replace(bag_dir_cd,chr(13),''),chr(10),'')
,stl_amt
,int_paybl
,bill_cnt
,replace(replace(ctr_nt_id,chr(13),''),chr(10),'')
,replace(replace(lg_pay_sys_msg_ind_no,chr(13),''),chr(10),'')
,replace(replace(bill_num,chr(13),''),chr(10),'')
,replace(replace(recver_org_cd,chr(13),''),chr(10),'')
,replace(replace(recver_trust_acct_num,chr(13),''),chr(10),'')
,replace(replace(recver_trust_acct_name,chr(13),''),chr(10),'')
,replace(replace(recver_cap_acct_num,chr(13),''),chr(10),'')
,replace(replace(recver_cap_acct_name,chr(13),''),chr(10),'')
,replace(replace(payer_org_cd,chr(13),''),chr(10),'')
,replace(replace(payer_trust_acct_num,chr(13),''),chr(10),'')
,replace(replace(payer_trust_acct_name,chr(13),''),chr(10),'')
,replace(replace(payer_cap_acct_num,chr(13),''),chr(10),'')
,replace(replace(payer_cap_acct_name,chr(13),''),chr(10),'')
,replace(replace(stl_status_cd,chr(13),''),chr(10),'')
,replace(replace(stl_rest_code,chr(13),''),chr(10),'')
,replace(replace(stl_fail_rs,chr(13),''),chr(10),'')
,replace(replace(bill_sub_intrv_id,chr(13),''),chr(10),'')
,start_dt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_bill_bus_stl_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_bus_stl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
