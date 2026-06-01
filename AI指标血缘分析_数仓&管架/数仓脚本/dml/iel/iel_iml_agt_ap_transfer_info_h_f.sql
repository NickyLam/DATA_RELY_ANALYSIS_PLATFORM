: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ap_transfer_info_h_f
CreateDate: 20230915
FileName:   ${iel_data_path}/agt_ap_transfer_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.disp_prop_id,chr(13),''),chr(10),'') as disp_prop_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_type_cd,chr(13),''),chr(10),'') as obj_type_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,distr_amt
,loan_bal
,recvbl_over_int
,acru_comp_int
,recvbl_pnlt
,tran_amt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,up_date

from ${iml_schema}.agt_ap_transfer_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ap_transfer_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
