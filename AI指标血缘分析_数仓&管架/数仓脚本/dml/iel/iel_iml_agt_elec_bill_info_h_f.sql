: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_elec_bill_info_h_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_elec_bill_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,bill_amt
,draw_dt
,exp_dt
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'') as drawer_cate_cd
,replace(replace(t1.drawer_orgnz_cd,chr(13),''),chr(10),'') as drawer_orgnz_cd
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_acct_id,chr(13),''),chr(10),'') as drawer_acct_id
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.accptor_cate_cd,chr(13),''),chr(10),'') as accptor_cate_cd
,replace(replace(t1.accptor_orgnz_cd,chr(13),''),chr(10),'') as accptor_orgnz_cd
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_acct_id,chr(13),''),chr(10),'') as accptor_acct_id
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.bill_obg_cate_cd,chr(13),''),chr(10),'') as bill_obg_cate_cd
,replace(replace(t1.bill_obg_orgnz_cd,chr(13),''),chr(10),'') as bill_obg_orgnz_cd
,replace(replace(t1.bill_obg_name,chr(13),''),chr(10),'') as bill_obg_name
,replace(replace(t1.bill_obg_acct_id,chr(13),''),chr(10),'') as bill_obg_acct_id
,replace(replace(t1.bill_obg_open_bank_no,chr(13),''),chr(10),'') as bill_obg_open_bank_no
,replace(replace(t1.bill_last_status_cd,chr(13),''),chr(10),'') as bill_last_status_cd
,replace(replace(t1.bill_send_ps_status_cd,chr(13),''),chr(10),'') as bill_send_ps_status_cd
,replace(replace(t1.bill_recv_ps_status_cd,chr(13),''),chr(10),'') as bill_recv_ps_status_cd
,create_tm
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,replace(replace(t1.curr_status_cd,chr(13),''),chr(10),'') as curr_status_cd
,replace(replace(t1.recs_type_cd,chr(13),''),chr(10),'') as recs_type_cd

from ${iml_schema}.agt_elec_bill_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_elec_bill_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
