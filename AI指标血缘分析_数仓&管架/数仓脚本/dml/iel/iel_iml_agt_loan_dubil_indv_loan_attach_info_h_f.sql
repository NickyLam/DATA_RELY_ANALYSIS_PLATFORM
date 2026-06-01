: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_dubil_indv_loan_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_dubil_indv_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.white_list_cust_flg,chr(13),''),chr(10),'') as white_list_cust_flg
,blon_loan_amort_exp_dt
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg
,replace(replace(t1.cust_char_cd,chr(13),''),chr(10),'') as cust_char_cd
,cust_crdt_tot_amt
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg

from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_dubil_indv_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
