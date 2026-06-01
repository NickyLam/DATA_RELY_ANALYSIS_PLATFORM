: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mrms_tbl_direct_mchnt_inf_f
CreateDate: 20250611
FileName:   ${iel_data_path}/mrms_tbl_direct_mchnt_inf.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.mchtserial,chr(13),''),chr(10),'') as mchtserial
,replace(replace(t1.mcht_no,chr(13),''),chr(10),'') as mcht_no
,replace(replace(t1.mcht_nm,chr(13),''),chr(10),'') as mcht_nm
,replace(replace(t1.mcht_official_nm,chr(13),''),chr(10),'') as mcht_official_nm
,replace(replace(t1.mcht_addr,chr(13),''),chr(10),'') as mcht_addr
,replace(replace(t1.acq_bank,chr(13),''),chr(10),'') as acq_bank
,replace(replace(t1.open_stlno,chr(13),''),chr(10),'') as open_stlno
,replace(replace(t1.settle_bank_no,chr(13),''),chr(10),'') as settle_bank_no
,replace(replace(t1.contact,chr(13),''),chr(10),'') as contact
,replace(replace(t1.contact_nick,chr(13),''),chr(10),'') as contact_nick
,replace(replace(t1.contact_job,chr(13),''),chr(10),'') as contact_job
,replace(replace(t1.contact_tel,chr(13),''),chr(10),'') as contact_tel
,replace(replace(t1.contact_fix,chr(13),''),chr(10),'') as contact_fix
,replace(replace(t1.electrofax,chr(13),''),chr(10),'') as electrofax
,replace(replace(t1.install_contact,chr(13),''),chr(10),'') as install_contact
,replace(replace(t1.install_tel,chr(13),''),chr(10),'') as install_tel
,replace(replace(t1.install_fix,chr(13),''),chr(10),'') as install_fix
,replace(replace(t1.busi_type_id,chr(13),''),chr(10),'') as busi_type_id
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,back_rate
,fee_mng
,replace(replace(t1.enable_dt,chr(13),''),chr(10),'') as enable_dt
,replace(replace(t1.enable_lmt_dt,chr(13),''),chr(10),'') as enable_lmt_dt
,replace(replace(t1.expired_date,chr(13),''),chr(10),'') as expired_date
,replace(replace(t1.reg_dt,chr(13),''),chr(10),'') as reg_dt
,replace(replace(t1.opr_unit,chr(13),''),chr(10),'') as opr_unit
,replace(replace(t1.sign_man,chr(13),''),chr(10),'') as sign_man
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.is_costfee,chr(13),''),chr(10),'') as is_costfee
,replace(replace(t1.contract_cd,chr(13),''),chr(10),'') as contract_cd
,replace(replace(t1.press_card,chr(13),''),chr(10),'') as press_card
,replace(replace(t1.press_card_dt,chr(13),''),chr(10),'') as press_card_dt
,replace(replace(t1.addition_cd,chr(13),''),chr(10),'') as addition_cd
,replace(replace(t1.freeze,chr(13),''),chr(10),'') as freeze
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,replace(replace(t1.area_cd,chr(13),''),chr(10),'') as area_cd
,replace(replace(t1.isrisk,chr(13),''),chr(10),'') as isrisk
,apply_term
,replace(replace(t1.apply_cd,chr(13),''),chr(10),'') as apply_cd
,replace(replace(t1.dealwith,chr(13),''),chr(10),'') as dealwith
,replace(replace(t1.dealwith_cd,chr(13),''),chr(10),'') as dealwith_cd
,replace(replace(t1.dealwith_dsp,chr(13),''),chr(10),'') as dealwith_dsp
,replace(replace(t1.finish,chr(13),''),chr(10),'') as finish
,replace(replace(t1.under_platform,chr(13),''),chr(10),'') as under_platform
,fee_rate2
,replace(replace(t1.fee_rate_in,chr(13),''),chr(10),'') as fee_rate_in
,replace(replace(t1.fee_rate_out,chr(13),''),chr(10),'') as fee_rate_out
,replace(replace(t1.acct_nm,chr(13),''),chr(10),'') as acct_nm
,replace(replace(t1.origi_mcht_cd,chr(13),''),chr(10),'') as origi_mcht_cd
,replace(replace(t1.buss_type,chr(13),''),chr(10),'') as buss_type
,replace(replace(t1.buss_cd,chr(13),''),chr(10),'') as buss_cd
,replace(replace(t1.licence_no,chr(13),''),chr(10),'') as licence_no
,replace(replace(t1.spe_settle_tp,chr(13),''),chr(10),'') as spe_settle_tp
,replace(replace(t1.allot_algo,chr(13),''),chr(10),'') as allot_algo
,replace(replace(t1.allot_index,chr(13),''),chr(10),'') as allot_index
,replace(replace(t1.allot_ins,chr(13),''),chr(10),'') as allot_ins
,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
,replace(replace(t1.exp_type,chr(13),''),chr(10),'') as exp_type
,replace(replace(t1.bus_lic_tp,chr(13),''),chr(10),'') as bus_lic_tp
,replace(replace(t1.invo_open_bank,chr(13),''),chr(10),'') as invo_open_bank
,replace(replace(t1.invo_acct,chr(13),''),chr(10),'') as invo_acct
,replace(replace(t1.invo_acct_nm,chr(13),''),chr(10),'') as invo_acct_nm
,replace(replace(t1.apply_prefer,chr(13),''),chr(10),'') as apply_prefer
,replace(replace(t1.brand,chr(13),''),chr(10),'') as brand
,replace(replace(t1.reg_addr,chr(13),''),chr(10),'') as reg_addr
,replace(replace(t1.fee_crd,chr(13),''),chr(10),'') as fee_crd
,replace(replace(t1.fee_dbt,chr(13),''),chr(10),'') as fee_dbt
,replace(replace(t1.fee_bdb,chr(13),''),chr(10),'') as fee_bdb
,replace(replace(t1.trans_ctrl,chr(13),''),chr(10),'') as trans_ctrl
,replace(replace(t1.apply_sta,chr(13),''),chr(10),'') as apply_sta
,replace(replace(t1.deal_sta,chr(13),''),chr(10),'') as deal_sta
,replace(replace(t1.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t1.mcht_type,chr(13),''),chr(10),'') as mcht_type
,replace(replace(t1.conn_type,chr(13),''),chr(10),'') as conn_type
,replace(replace(t1.acq_inst_id,chr(13),''),chr(10),'') as acq_inst_id
,replace(replace(t1.mcc,chr(13),''),chr(10),'') as mcc
,replace(replace(t1.licence_nm,chr(13),''),chr(10),'') as licence_nm
,replace(replace(t1.tax_no,chr(13),''),chr(10),'') as tax_no
,replace(replace(t1.bank_licence_no,chr(13),''),chr(10),'') as bank_licence_no
,replace(replace(t1.director_nm,chr(13),''),chr(10),'') as director_nm
,replace(replace(t1.director_no,chr(13),''),chr(10),'') as director_no
,replace(replace(t1.scale,chr(13),''),chr(10),'') as scale
,replace(replace(t1.clear_type,chr(13),''),chr(10),'') as clear_type
,replace(replace(t1.settle_type,chr(13),''),chr(10),'') as settle_type
,replace(replace(t1.oper_id,chr(13),''),chr(10),'') as oper_id
,replace(replace(t1.create_date,chr(13),''),chr(10),'') as create_date
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.rec_upd_ts,chr(13),''),chr(10),'') as rec_upd_ts
,replace(replace(t1.upd_oper,chr(13),''),chr(10),'') as upd_oper
,replace(replace(t1.inspact_date,chr(13),''),chr(10),'') as inspact_date
,replace(replace(t1.inspact_cycle,chr(13),''),chr(10),'') as inspact_cycle
,replace(replace(t1.return_sta,chr(13),''),chr(10),'') as return_sta
,replace(replace(t1.train_date,chr(13),''),chr(10),'') as train_date
,replace(replace(t1.train_cycle,chr(13),''),chr(10),'') as train_cycle
,replace(replace(t1.exp_bank,chr(13),''),chr(10),'') as exp_bank
,replace(replace(t1.out_mcht_no,chr(13),''),chr(10),'') as out_mcht_no
,replace(replace(t1.comm_email,chr(13),''),chr(10),'') as comm_email
,replace(replace(t1.comm_mobil,chr(13),''),chr(10),'') as comm_mobil
,replace(replace(t1.artif_certif_tp,chr(13),''),chr(10),'') as artif_certif_tp
,replace(replace(t1.manager_tel,chr(13),''),chr(10),'') as manager_tel
,replace(replace(t1.agr_br,chr(13),''),chr(10),'') as agr_br
,replace(replace(t1.net_tel,chr(13),''),chr(10),'') as net_tel
,replace(replace(t1.ztflag,chr(13),''),chr(10),'') as ztflag
,replace(replace(t1.acct_chnl,chr(13),''),chr(10),'') as acct_chnl
,replace(replace(t1.prof_type,chr(13),''),chr(10),'') as prof_type
,replace(replace(t1.license_deadline,chr(13),''),chr(10),'') as license_deadline
,replace(replace(t1.acc_add,chr(13),''),chr(10),'') as acc_add
,replace(replace(t1.acc_ip,chr(13),''),chr(10),'') as acc_ip
,replace(replace(t1.acc_icp_no,chr(13),''),chr(10),'') as acc_icp_no
,replace(replace(t1.reg_amt,chr(13),''),chr(10),'') as reg_amt
,replace(replace(t1.coo_state,chr(13),''),chr(10),'') as coo_state

from ${iol_schema}.mrms_tbl_direct_mchnt_inf t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mrms_tbl_direct_mchnt_inf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
