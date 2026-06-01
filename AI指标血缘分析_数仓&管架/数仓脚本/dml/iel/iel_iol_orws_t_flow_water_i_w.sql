: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_flow_water_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_t_flow_water_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select                                                                                                   
replace(replace(id,chr(10),''),chr(13),'') as id
,replace(replace(clt_seqno,chr(10),''),chr(13),'') as clt_seqno
,replace(replace(check_no,chr(10),''),chr(13),'') as check_no
,replace(replace(auth_opt_no,chr(10),''),chr(13),'') as auth_opt_no
,replace(replace(auth_opt_name,chr(10),''),chr(13),'') as auth_opt_name
,replace(replace(tran_opt_name,chr(10),''),chr(13),'') as tran_opt_name
,replace(replace(tran_opt_no,chr(10),''),chr(13),'') as tran_opt_no
,replace(replace(tran_inst,chr(10),''),chr(13),'') as tran_inst
,replace(replace(tran_date,chr(10),''),chr(13),'') as tran_date
,replace(replace(tran_time,chr(10),''),chr(13),'') as tran_time
,replace(replace(acc_no1,chr(10),''),chr(13),'') as acc_no1
,replace(replace(acc_name1,chr(10),''),chr(13),'') as acc_name1
,replace(replace(card_no1,chr(10),''),chr(13),'') as card_no1
,replace(replace(acc_no2,chr(10),''),chr(13),'') as acc_no2
,replace(replace(acc_name2,chr(10),''),chr(13),'') as acc_name2
,replace(replace(card_no2,chr(10),''),chr(13),'') as card_no2
,replace(replace(ccy,chr(10),''),chr(13),'') as ccy
,replace(replace(amt,chr(10),''),chr(13),'') as amt
,replace(replace(dr_cr_flag,chr(10),''),chr(13),'') as dr_cr_flag
,replace(replace(csh_tsf_flag,chr(10),''),chr(13),'') as csh_tsf_flag
,replace(replace(tran_stat,chr(10),''),chr(13),'') as tran_stat
,replace(replace(tran_type,chr(10),''),chr(13),'') as tran_type
,replace(replace(remarks,chr(10),''),chr(13),'') as remarks
,replace(replace(core_seq,chr(10),''),chr(13),'') as core_seq
,replace(replace(remarks1,chr(10),''),chr(13),'') as remarks1
,replace(replace(img_id,chr(10),''),chr(13),'') as img_id
,replace(replace(supervise_status,chr(10),''),chr(13),'') as supervise_status
,replace(replace(supervisor_code,chr(10),''),chr(13),'') as supervisor_code
,replace(replace(supervisor_name,chr(10),''),chr(13),'') as supervisor_name
,replace(replace(supervise_date,chr(10),''),chr(13),'') as supervise_date
,replace(replace(first_orgid,chr(10),''),chr(13),'') as first_orgid
,replace(replace(first_orgnum,chr(10),''),chr(13),'') as first_orgnum
,replace(replace(curr_month,chr(10),''),chr(13),'') as curr_month
,replace(replace(first_orgname,chr(10),''),chr(13),'') as first_orgname
,replace(replace(first_orgtype,chr(10),''),chr(13),'') as first_orgtype
,replace(replace(first_orgtypename,chr(10),''),chr(13),'') as first_orgtypename
,replace(replace(second_orgid,chr(10),''),chr(13),'') as second_orgid
,replace(replace(second_orgnum,chr(10),''),chr(13),'') as second_orgnum
,replace(replace(second_orgname,chr(10),''),chr(13),'') as second_orgname
,replace(replace(third_orgid,chr(10),''),chr(13),'') as third_orgid
,replace(replace(third_orgnum,chr(10),''),chr(13),'') as third_orgnum
,replace(replace(third_orgname,chr(10),''),chr(13),'') as third_orgname
,replace(replace(tran_code,chr(10),''),chr(13),'') as tran_code
,replace(replace(water_check,chr(10),''),chr(13),'') as water_check
,replace(replace(water_net,chr(10),''),chr(13),'') as water_net
,replace(replace(again_supervise_status,chr(10),''),chr(13),'') as again_supervise_status
,replace(replace(tran_name,chr(10),''),chr(13),'') as tran_name                                               
,start_dt                                                                                                
,end_dt                                                                                                  
,id_mark                                                                                                 
,etl_timestamp                                                                                           
from  ${iol_schema}.orws_t_flow_water                                                                    
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_flow_water_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes