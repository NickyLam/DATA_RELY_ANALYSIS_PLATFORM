/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_direct_mchnt_inf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mrms_tbl_direct_mchnt_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_direct_mchnt_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf_op purge;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_direct_mchnt_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_direct_mchnt_inf where 0=1;

create table ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_direct_mchnt_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl(
            mchtserial -- 
            ,mcht_no -- 
            ,mcht_nm -- 
            ,mcht_official_nm -- 
            ,mcht_addr -- 
            ,acq_bank -- 
            ,open_stlno -- 
            ,settle_bank_no -- 
            ,contact -- 
            ,contact_nick -- 
            ,contact_job -- 
            ,contact_tel -- 
            ,contact_fix -- 
            ,electrofax -- 
            ,install_contact -- 
            ,install_tel -- 
            ,install_fix -- 
            ,busi_type_id -- 
            ,fee_type -- 
            ,back_rate -- 
            ,fee_mng -- 
            ,enable_dt -- 
            ,enable_lmt_dt -- 
            ,expired_date -- 
            ,reg_dt -- 
            ,opr_unit -- 
            ,sign_man -- 
            ,status -- 
            ,is_costfee -- 
            ,contract_cd -- 
            ,press_card -- 
            ,press_card_dt -- 
            ,addition_cd -- 
            ,freeze -- 
            ,postcode -- 
            ,area_cd -- 
            ,isrisk -- 
            ,apply_term -- 
            ,apply_cd -- 
            ,dealwith -- 
            ,dealwith_cd -- 
            ,dealwith_dsp -- 
            ,finish -- 
            ,under_platform -- 
            ,fee_rate2 -- 
            ,fee_rate_in -- 
            ,fee_rate_out -- 
            ,acct_nm -- 
            ,origi_mcht_cd -- 
            ,buss_type -- 
            ,buss_cd -- 
            ,licence_no -- 
            ,spe_settle_tp -- 
            ,allot_algo -- 
            ,allot_index -- 
            ,allot_ins -- 
            ,open_bank_no -- 
            ,exp_type -- 
            ,bus_lic_tp -- 
            ,invo_open_bank -- 
            ,invo_acct -- 
            ,invo_acct_nm -- 
            ,apply_prefer -- 
            ,brand -- 
            ,reg_addr -- 
            ,fee_crd -- 
            ,fee_dbt -- 
            ,fee_bdb -- 
            ,trans_ctrl -- 
            ,apply_sta -- 
            ,deal_sta -- 
            ,filename -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,mcht_type -- 
            ,conn_type -- 
            ,acq_inst_id -- 
            ,mcc -- 
            ,licence_nm -- 
            ,tax_no -- 
            ,bank_licence_no -- 
            ,director_nm -- 
            ,director_no -- 
            ,scale -- 
            ,clear_type -- 
            ,settle_type -- 
            ,oper_id -- 
            ,create_date -- 
            ,id -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,inspact_date -- 
            ,inspact_cycle -- 
            ,return_sta -- 
            ,train_date -- 
            ,train_cycle -- 
            ,exp_bank -- //用于拓展行
            ,out_mcht_no -- 
            ,comm_email -- 
            ,comm_mobil -- 
            ,artif_certif_tp -- 
            ,manager_tel -- 
            ,agr_br -- 
            ,net_tel -- 
            ,ztflag -- 
            ,acct_chnl -- 
            ,prof_type -- 业务种类
            ,license_deadline -- 法定代表人或负责人证件有效期截止日
            ,acc_add -- 网络商户登记网址
            ,acc_ip -- 网络商户登记ip
            ,acc_icp_no -- 网络商户icp备案/许可证号
            ,reg_amt -- 注册资本金
            ,coo_state -- 合作状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_direct_mchnt_inf_op(
            mchtserial -- 
            ,mcht_no -- 
            ,mcht_nm -- 
            ,mcht_official_nm -- 
            ,mcht_addr -- 
            ,acq_bank -- 
            ,open_stlno -- 
            ,settle_bank_no -- 
            ,contact -- 
            ,contact_nick -- 
            ,contact_job -- 
            ,contact_tel -- 
            ,contact_fix -- 
            ,electrofax -- 
            ,install_contact -- 
            ,install_tel -- 
            ,install_fix -- 
            ,busi_type_id -- 
            ,fee_type -- 
            ,back_rate -- 
            ,fee_mng -- 
            ,enable_dt -- 
            ,enable_lmt_dt -- 
            ,expired_date -- 
            ,reg_dt -- 
            ,opr_unit -- 
            ,sign_man -- 
            ,status -- 
            ,is_costfee -- 
            ,contract_cd -- 
            ,press_card -- 
            ,press_card_dt -- 
            ,addition_cd -- 
            ,freeze -- 
            ,postcode -- 
            ,area_cd -- 
            ,isrisk -- 
            ,apply_term -- 
            ,apply_cd -- 
            ,dealwith -- 
            ,dealwith_cd -- 
            ,dealwith_dsp -- 
            ,finish -- 
            ,under_platform -- 
            ,fee_rate2 -- 
            ,fee_rate_in -- 
            ,fee_rate_out -- 
            ,acct_nm -- 
            ,origi_mcht_cd -- 
            ,buss_type -- 
            ,buss_cd -- 
            ,licence_no -- 
            ,spe_settle_tp -- 
            ,allot_algo -- 
            ,allot_index -- 
            ,allot_ins -- 
            ,open_bank_no -- 
            ,exp_type -- 
            ,bus_lic_tp -- 
            ,invo_open_bank -- 
            ,invo_acct -- 
            ,invo_acct_nm -- 
            ,apply_prefer -- 
            ,brand -- 
            ,reg_addr -- 
            ,fee_crd -- 
            ,fee_dbt -- 
            ,fee_bdb -- 
            ,trans_ctrl -- 
            ,apply_sta -- 
            ,deal_sta -- 
            ,filename -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,mcht_type -- 
            ,conn_type -- 
            ,acq_inst_id -- 
            ,mcc -- 
            ,licence_nm -- 
            ,tax_no -- 
            ,bank_licence_no -- 
            ,director_nm -- 
            ,director_no -- 
            ,scale -- 
            ,clear_type -- 
            ,settle_type -- 
            ,oper_id -- 
            ,create_date -- 
            ,id -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,inspact_date -- 
            ,inspact_cycle -- 
            ,return_sta -- 
            ,train_date -- 
            ,train_cycle -- 
            ,exp_bank -- //用于拓展行
            ,out_mcht_no -- 
            ,comm_email -- 
            ,comm_mobil -- 
            ,artif_certif_tp -- 
            ,manager_tel -- 
            ,agr_br -- 
            ,net_tel -- 
            ,ztflag -- 
            ,acct_chnl -- 
            ,prof_type -- 业务种类
            ,license_deadline -- 法定代表人或负责人证件有效期截止日
            ,acc_add -- 网络商户登记网址
            ,acc_ip -- 网络商户登记ip
            ,acc_icp_no -- 网络商户icp备案/许可证号
            ,reg_amt -- 注册资本金
            ,coo_state -- 合作状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mchtserial, o.mchtserial) as mchtserial -- 
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 
    ,nvl(n.mcht_nm, o.mcht_nm) as mcht_nm -- 
    ,nvl(n.mcht_official_nm, o.mcht_official_nm) as mcht_official_nm -- 
    ,nvl(n.mcht_addr, o.mcht_addr) as mcht_addr -- 
    ,nvl(n.acq_bank, o.acq_bank) as acq_bank -- 
    ,nvl(n.open_stlno, o.open_stlno) as open_stlno -- 
    ,nvl(n.settle_bank_no, o.settle_bank_no) as settle_bank_no -- 
    ,nvl(n.contact, o.contact) as contact -- 
    ,nvl(n.contact_nick, o.contact_nick) as contact_nick -- 
    ,nvl(n.contact_job, o.contact_job) as contact_job -- 
    ,nvl(n.contact_tel, o.contact_tel) as contact_tel -- 
    ,nvl(n.contact_fix, o.contact_fix) as contact_fix -- 
    ,nvl(n.electrofax, o.electrofax) as electrofax -- 
    ,nvl(n.install_contact, o.install_contact) as install_contact -- 
    ,nvl(n.install_tel, o.install_tel) as install_tel -- 
    ,nvl(n.install_fix, o.install_fix) as install_fix -- 
    ,nvl(n.busi_type_id, o.busi_type_id) as busi_type_id -- 
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 
    ,nvl(n.back_rate, o.back_rate) as back_rate -- 
    ,nvl(n.fee_mng, o.fee_mng) as fee_mng -- 
    ,nvl(n.enable_dt, o.enable_dt) as enable_dt -- 
    ,nvl(n.enable_lmt_dt, o.enable_lmt_dt) as enable_lmt_dt -- 
    ,nvl(n.expired_date, o.expired_date) as expired_date -- 
    ,nvl(n.reg_dt, o.reg_dt) as reg_dt -- 
    ,nvl(n.opr_unit, o.opr_unit) as opr_unit -- 
    ,nvl(n.sign_man, o.sign_man) as sign_man -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.is_costfee, o.is_costfee) as is_costfee -- 
    ,nvl(n.contract_cd, o.contract_cd) as contract_cd -- 
    ,nvl(n.press_card, o.press_card) as press_card -- 
    ,nvl(n.press_card_dt, o.press_card_dt) as press_card_dt -- 
    ,nvl(n.addition_cd, o.addition_cd) as addition_cd -- 
    ,nvl(n.freeze, o.freeze) as freeze -- 
    ,nvl(n.postcode, o.postcode) as postcode -- 
    ,nvl(n.area_cd, o.area_cd) as area_cd -- 
    ,nvl(n.isrisk, o.isrisk) as isrisk -- 
    ,nvl(n.apply_term, o.apply_term) as apply_term -- 
    ,nvl(n.apply_cd, o.apply_cd) as apply_cd -- 
    ,nvl(n.dealwith, o.dealwith) as dealwith -- 
    ,nvl(n.dealwith_cd, o.dealwith_cd) as dealwith_cd -- 
    ,nvl(n.dealwith_dsp, o.dealwith_dsp) as dealwith_dsp -- 
    ,nvl(n.finish, o.finish) as finish -- 
    ,nvl(n.under_platform, o.under_platform) as under_platform -- 
    ,nvl(n.fee_rate2, o.fee_rate2) as fee_rate2 -- 
    ,nvl(n.fee_rate_in, o.fee_rate_in) as fee_rate_in -- 
    ,nvl(n.fee_rate_out, o.fee_rate_out) as fee_rate_out -- 
    ,nvl(n.acct_nm, o.acct_nm) as acct_nm -- 
    ,nvl(n.origi_mcht_cd, o.origi_mcht_cd) as origi_mcht_cd -- 
    ,nvl(n.buss_type, o.buss_type) as buss_type -- 
    ,nvl(n.buss_cd, o.buss_cd) as buss_cd -- 
    ,nvl(n.licence_no, o.licence_no) as licence_no -- 
    ,nvl(n.spe_settle_tp, o.spe_settle_tp) as spe_settle_tp -- 
    ,nvl(n.allot_algo, o.allot_algo) as allot_algo -- 
    ,nvl(n.allot_index, o.allot_index) as allot_index -- 
    ,nvl(n.allot_ins, o.allot_ins) as allot_ins -- 
    ,nvl(n.open_bank_no, o.open_bank_no) as open_bank_no -- 
    ,nvl(n.exp_type, o.exp_type) as exp_type -- 
    ,nvl(n.bus_lic_tp, o.bus_lic_tp) as bus_lic_tp -- 
    ,nvl(n.invo_open_bank, o.invo_open_bank) as invo_open_bank -- 
    ,nvl(n.invo_acct, o.invo_acct) as invo_acct -- 
    ,nvl(n.invo_acct_nm, o.invo_acct_nm) as invo_acct_nm -- 
    ,nvl(n.apply_prefer, o.apply_prefer) as apply_prefer -- 
    ,nvl(n.brand, o.brand) as brand -- 
    ,nvl(n.reg_addr, o.reg_addr) as reg_addr -- 
    ,nvl(n.fee_crd, o.fee_crd) as fee_crd -- 
    ,nvl(n.fee_dbt, o.fee_dbt) as fee_dbt -- 
    ,nvl(n.fee_bdb, o.fee_bdb) as fee_bdb -- 
    ,nvl(n.trans_ctrl, o.trans_ctrl) as trans_ctrl -- 
    ,nvl(n.apply_sta, o.apply_sta) as apply_sta -- 
    ,nvl(n.deal_sta, o.deal_sta) as deal_sta -- 
    ,nvl(n.filename, o.filename) as filename -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.mcht_type, o.mcht_type) as mcht_type -- 
    ,nvl(n.conn_type, o.conn_type) as conn_type -- 
    ,nvl(n.acq_inst_id, o.acq_inst_id) as acq_inst_id -- 
    ,nvl(n.mcc, o.mcc) as mcc -- 
    ,nvl(n.licence_nm, o.licence_nm) as licence_nm -- 
    ,nvl(n.tax_no, o.tax_no) as tax_no -- 
    ,nvl(n.bank_licence_no, o.bank_licence_no) as bank_licence_no -- 
    ,nvl(n.director_nm, o.director_nm) as director_nm -- 
    ,nvl(n.director_no, o.director_no) as director_no -- 
    ,nvl(n.scale, o.scale) as scale -- 
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 
    ,nvl(n.oper_id, o.oper_id) as oper_id -- 
    ,nvl(n.create_date, o.create_date) as create_date -- 
    ,nvl(n.id, o.id) as id -- 
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 
    ,nvl(n.upd_oper, o.upd_oper) as upd_oper -- 
    ,nvl(n.inspact_date, o.inspact_date) as inspact_date -- 
    ,nvl(n.inspact_cycle, o.inspact_cycle) as inspact_cycle -- 
    ,nvl(n.return_sta, o.return_sta) as return_sta -- 
    ,nvl(n.train_date, o.train_date) as train_date -- 
    ,nvl(n.train_cycle, o.train_cycle) as train_cycle -- 
    ,nvl(n.exp_bank, o.exp_bank) as exp_bank -- //用于拓展行
    ,nvl(n.out_mcht_no, o.out_mcht_no) as out_mcht_no -- 
    ,nvl(n.comm_email, o.comm_email) as comm_email -- 
    ,nvl(n.comm_mobil, o.comm_mobil) as comm_mobil -- 
    ,nvl(n.artif_certif_tp, o.artif_certif_tp) as artif_certif_tp -- 
    ,nvl(n.manager_tel, o.manager_tel) as manager_tel -- 
    ,nvl(n.agr_br, o.agr_br) as agr_br -- 
    ,nvl(n.net_tel, o.net_tel) as net_tel -- 
    ,nvl(n.ztflag, o.ztflag) as ztflag -- 
    ,nvl(n.acct_chnl, o.acct_chnl) as acct_chnl -- 
    ,nvl(n.prof_type, o.prof_type) as prof_type -- 业务种类
    ,nvl(n.license_deadline, o.license_deadline) as license_deadline -- 法定代表人或负责人证件有效期截止日
    ,nvl(n.acc_add, o.acc_add) as acc_add -- 网络商户登记网址
    ,nvl(n.acc_ip, o.acc_ip) as acc_ip -- 网络商户登记ip
    ,nvl(n.acc_icp_no, o.acc_icp_no) as acc_icp_no -- 网络商户icp备案/许可证号
    ,nvl(n.reg_amt, o.reg_amt) as reg_amt -- 注册资本金
    ,nvl(n.coo_state, o.coo_state) as coo_state -- 合作状态
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_direct_mchnt_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_direct_mchnt_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.mchtserial <> n.mchtserial
        or o.mcht_no <> n.mcht_no
        or o.mcht_nm <> n.mcht_nm
        or o.mcht_official_nm <> n.mcht_official_nm
        or o.mcht_addr <> n.mcht_addr
        or o.acq_bank <> n.acq_bank
        or o.open_stlno <> n.open_stlno
        or o.settle_bank_no <> n.settle_bank_no
        or o.contact <> n.contact
        or o.contact_nick <> n.contact_nick
        or o.contact_job <> n.contact_job
        or o.contact_tel <> n.contact_tel
        or o.contact_fix <> n.contact_fix
        or o.electrofax <> n.electrofax
        or o.install_contact <> n.install_contact
        or o.install_tel <> n.install_tel
        or o.install_fix <> n.install_fix
        or o.busi_type_id <> n.busi_type_id
        or o.fee_type <> n.fee_type
        or o.back_rate <> n.back_rate
        or o.fee_mng <> n.fee_mng
        or o.enable_dt <> n.enable_dt
        or o.enable_lmt_dt <> n.enable_lmt_dt
        or o.expired_date <> n.expired_date
        or o.reg_dt <> n.reg_dt
        or o.opr_unit <> n.opr_unit
        or o.sign_man <> n.sign_man
        or o.status <> n.status
        or o.is_costfee <> n.is_costfee
        or o.contract_cd <> n.contract_cd
        or o.press_card <> n.press_card
        or o.press_card_dt <> n.press_card_dt
        or o.addition_cd <> n.addition_cd
        or o.freeze <> n.freeze
        or o.postcode <> n.postcode
        or o.area_cd <> n.area_cd
        or o.isrisk <> n.isrisk
        or o.apply_term <> n.apply_term
        or o.apply_cd <> n.apply_cd
        or o.dealwith <> n.dealwith
        or o.dealwith_cd <> n.dealwith_cd
        or o.dealwith_dsp <> n.dealwith_dsp
        or o.finish <> n.finish
        or o.under_platform <> n.under_platform
        or o.fee_rate2 <> n.fee_rate2
        or o.fee_rate_in <> n.fee_rate_in
        or o.fee_rate_out <> n.fee_rate_out
        or o.acct_nm <> n.acct_nm
        or o.origi_mcht_cd <> n.origi_mcht_cd
        or o.buss_type <> n.buss_type
        or o.buss_cd <> n.buss_cd
        or o.licence_no <> n.licence_no
        or o.spe_settle_tp <> n.spe_settle_tp
        or o.allot_algo <> n.allot_algo
        or o.allot_index <> n.allot_index
        or o.allot_ins <> n.allot_ins
        or o.open_bank_no <> n.open_bank_no
        or o.exp_type <> n.exp_type
        or o.bus_lic_tp <> n.bus_lic_tp
        or o.invo_open_bank <> n.invo_open_bank
        or o.invo_acct <> n.invo_acct
        or o.invo_acct_nm <> n.invo_acct_nm
        or o.apply_prefer <> n.apply_prefer
        or o.brand <> n.brand
        or o.reg_addr <> n.reg_addr
        or o.fee_crd <> n.fee_crd
        or o.fee_dbt <> n.fee_dbt
        or o.fee_bdb <> n.fee_bdb
        or o.trans_ctrl <> n.trans_ctrl
        or o.apply_sta <> n.apply_sta
        or o.deal_sta <> n.deal_sta
        or o.filename <> n.filename
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.mcht_type <> n.mcht_type
        or o.conn_type <> n.conn_type
        or o.acq_inst_id <> n.acq_inst_id
        or o.mcc <> n.mcc
        or o.licence_nm <> n.licence_nm
        or o.tax_no <> n.tax_no
        or o.bank_licence_no <> n.bank_licence_no
        or o.director_nm <> n.director_nm
        or o.director_no <> n.director_no
        or o.scale <> n.scale
        or o.clear_type <> n.clear_type
        or o.settle_type <> n.settle_type
        or o.oper_id <> n.oper_id
        or o.create_date <> n.create_date
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.upd_oper <> n.upd_oper
        or o.inspact_date <> n.inspact_date
        or o.inspact_cycle <> n.inspact_cycle
        or o.return_sta <> n.return_sta
        or o.train_date <> n.train_date
        or o.train_cycle <> n.train_cycle
        or o.exp_bank <> n.exp_bank
        or o.out_mcht_no <> n.out_mcht_no
        or o.comm_email <> n.comm_email
        or o.comm_mobil <> n.comm_mobil
        or o.artif_certif_tp <> n.artif_certif_tp
        or o.manager_tel <> n.manager_tel
        or o.agr_br <> n.agr_br
        or o.net_tel <> n.net_tel
        or o.ztflag <> n.ztflag
        or o.acct_chnl <> n.acct_chnl
        or o.prof_type <> n.prof_type
        or o.license_deadline <> n.license_deadline
        or o.acc_add <> n.acc_add
        or o.acc_ip <> n.acc_ip
        or o.acc_icp_no <> n.acc_icp_no
        or o.reg_amt <> n.reg_amt
        or o.coo_state <> n.coo_state
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl(
            mchtserial -- 
            ,mcht_no -- 
            ,mcht_nm -- 
            ,mcht_official_nm -- 
            ,mcht_addr -- 
            ,acq_bank -- 
            ,open_stlno -- 
            ,settle_bank_no -- 
            ,contact -- 
            ,contact_nick -- 
            ,contact_job -- 
            ,contact_tel -- 
            ,contact_fix -- 
            ,electrofax -- 
            ,install_contact -- 
            ,install_tel -- 
            ,install_fix -- 
            ,busi_type_id -- 
            ,fee_type -- 
            ,back_rate -- 
            ,fee_mng -- 
            ,enable_dt -- 
            ,enable_lmt_dt -- 
            ,expired_date -- 
            ,reg_dt -- 
            ,opr_unit -- 
            ,sign_man -- 
            ,status -- 
            ,is_costfee -- 
            ,contract_cd -- 
            ,press_card -- 
            ,press_card_dt -- 
            ,addition_cd -- 
            ,freeze -- 
            ,postcode -- 
            ,area_cd -- 
            ,isrisk -- 
            ,apply_term -- 
            ,apply_cd -- 
            ,dealwith -- 
            ,dealwith_cd -- 
            ,dealwith_dsp -- 
            ,finish -- 
            ,under_platform -- 
            ,fee_rate2 -- 
            ,fee_rate_in -- 
            ,fee_rate_out -- 
            ,acct_nm -- 
            ,origi_mcht_cd -- 
            ,buss_type -- 
            ,buss_cd -- 
            ,licence_no -- 
            ,spe_settle_tp -- 
            ,allot_algo -- 
            ,allot_index -- 
            ,allot_ins -- 
            ,open_bank_no -- 
            ,exp_type -- 
            ,bus_lic_tp -- 
            ,invo_open_bank -- 
            ,invo_acct -- 
            ,invo_acct_nm -- 
            ,apply_prefer -- 
            ,brand -- 
            ,reg_addr -- 
            ,fee_crd -- 
            ,fee_dbt -- 
            ,fee_bdb -- 
            ,trans_ctrl -- 
            ,apply_sta -- 
            ,deal_sta -- 
            ,filename -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,mcht_type -- 
            ,conn_type -- 
            ,acq_inst_id -- 
            ,mcc -- 
            ,licence_nm -- 
            ,tax_no -- 
            ,bank_licence_no -- 
            ,director_nm -- 
            ,director_no -- 
            ,scale -- 
            ,clear_type -- 
            ,settle_type -- 
            ,oper_id -- 
            ,create_date -- 
            ,id -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,inspact_date -- 
            ,inspact_cycle -- 
            ,return_sta -- 
            ,train_date -- 
            ,train_cycle -- 
            ,exp_bank -- //用于拓展行
            ,out_mcht_no -- 
            ,comm_email -- 
            ,comm_mobil -- 
            ,artif_certif_tp -- 
            ,manager_tel -- 
            ,agr_br -- 
            ,net_tel -- 
            ,ztflag -- 
            ,acct_chnl -- 
            ,prof_type -- 业务种类
            ,license_deadline -- 法定代表人或负责人证件有效期截止日
            ,acc_add -- 网络商户登记网址
            ,acc_ip -- 网络商户登记ip
            ,acc_icp_no -- 网络商户icp备案/许可证号
            ,reg_amt -- 注册资本金
            ,coo_state -- 合作状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_direct_mchnt_inf_op(
            mchtserial -- 
            ,mcht_no -- 
            ,mcht_nm -- 
            ,mcht_official_nm -- 
            ,mcht_addr -- 
            ,acq_bank -- 
            ,open_stlno -- 
            ,settle_bank_no -- 
            ,contact -- 
            ,contact_nick -- 
            ,contact_job -- 
            ,contact_tel -- 
            ,contact_fix -- 
            ,electrofax -- 
            ,install_contact -- 
            ,install_tel -- 
            ,install_fix -- 
            ,busi_type_id -- 
            ,fee_type -- 
            ,back_rate -- 
            ,fee_mng -- 
            ,enable_dt -- 
            ,enable_lmt_dt -- 
            ,expired_date -- 
            ,reg_dt -- 
            ,opr_unit -- 
            ,sign_man -- 
            ,status -- 
            ,is_costfee -- 
            ,contract_cd -- 
            ,press_card -- 
            ,press_card_dt -- 
            ,addition_cd -- 
            ,freeze -- 
            ,postcode -- 
            ,area_cd -- 
            ,isrisk -- 
            ,apply_term -- 
            ,apply_cd -- 
            ,dealwith -- 
            ,dealwith_cd -- 
            ,dealwith_dsp -- 
            ,finish -- 
            ,under_platform -- 
            ,fee_rate2 -- 
            ,fee_rate_in -- 
            ,fee_rate_out -- 
            ,acct_nm -- 
            ,origi_mcht_cd -- 
            ,buss_type -- 
            ,buss_cd -- 
            ,licence_no -- 
            ,spe_settle_tp -- 
            ,allot_algo -- 
            ,allot_index -- 
            ,allot_ins -- 
            ,open_bank_no -- 
            ,exp_type -- 
            ,bus_lic_tp -- 
            ,invo_open_bank -- 
            ,invo_acct -- 
            ,invo_acct_nm -- 
            ,apply_prefer -- 
            ,brand -- 
            ,reg_addr -- 
            ,fee_crd -- 
            ,fee_dbt -- 
            ,fee_bdb -- 
            ,trans_ctrl -- 
            ,apply_sta -- 
            ,deal_sta -- 
            ,filename -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,mcht_type -- 
            ,conn_type -- 
            ,acq_inst_id -- 
            ,mcc -- 
            ,licence_nm -- 
            ,tax_no -- 
            ,bank_licence_no -- 
            ,director_nm -- 
            ,director_no -- 
            ,scale -- 
            ,clear_type -- 
            ,settle_type -- 
            ,oper_id -- 
            ,create_date -- 
            ,id -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,inspact_date -- 
            ,inspact_cycle -- 
            ,return_sta -- 
            ,train_date -- 
            ,train_cycle -- 
            ,exp_bank -- //用于拓展行
            ,out_mcht_no -- 
            ,comm_email -- 
            ,comm_mobil -- 
            ,artif_certif_tp -- 
            ,manager_tel -- 
            ,agr_br -- 
            ,net_tel -- 
            ,ztflag -- 
            ,acct_chnl -- 
            ,prof_type -- 业务种类
            ,license_deadline -- 法定代表人或负责人证件有效期截止日
            ,acc_add -- 网络商户登记网址
            ,acc_ip -- 网络商户登记ip
            ,acc_icp_no -- 网络商户icp备案/许可证号
            ,reg_amt -- 注册资本金
            ,coo_state -- 合作状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mchtserial -- 
    ,o.mcht_no -- 
    ,o.mcht_nm -- 
    ,o.mcht_official_nm -- 
    ,o.mcht_addr -- 
    ,o.acq_bank -- 
    ,o.open_stlno -- 
    ,o.settle_bank_no -- 
    ,o.contact -- 
    ,o.contact_nick -- 
    ,o.contact_job -- 
    ,o.contact_tel -- 
    ,o.contact_fix -- 
    ,o.electrofax -- 
    ,o.install_contact -- 
    ,o.install_tel -- 
    ,o.install_fix -- 
    ,o.busi_type_id -- 
    ,o.fee_type -- 
    ,o.back_rate -- 
    ,o.fee_mng -- 
    ,o.enable_dt -- 
    ,o.enable_lmt_dt -- 
    ,o.expired_date -- 
    ,o.reg_dt -- 
    ,o.opr_unit -- 
    ,o.sign_man -- 
    ,o.status -- 
    ,o.is_costfee -- 
    ,o.contract_cd -- 
    ,o.press_card -- 
    ,o.press_card_dt -- 
    ,o.addition_cd -- 
    ,o.freeze -- 
    ,o.postcode -- 
    ,o.area_cd -- 
    ,o.isrisk -- 
    ,o.apply_term -- 
    ,o.apply_cd -- 
    ,o.dealwith -- 
    ,o.dealwith_cd -- 
    ,o.dealwith_dsp -- 
    ,o.finish -- 
    ,o.under_platform -- 
    ,o.fee_rate2 -- 
    ,o.fee_rate_in -- 
    ,o.fee_rate_out -- 
    ,o.acct_nm -- 
    ,o.origi_mcht_cd -- 
    ,o.buss_type -- 
    ,o.buss_cd -- 
    ,o.licence_no -- 
    ,o.spe_settle_tp -- 
    ,o.allot_algo -- 
    ,o.allot_index -- 
    ,o.allot_ins -- 
    ,o.open_bank_no -- 
    ,o.exp_type -- 
    ,o.bus_lic_tp -- 
    ,o.invo_open_bank -- 
    ,o.invo_acct -- 
    ,o.invo_acct_nm -- 
    ,o.apply_prefer -- 
    ,o.brand -- 
    ,o.reg_addr -- 
    ,o.fee_crd -- 
    ,o.fee_dbt -- 
    ,o.fee_bdb -- 
    ,o.trans_ctrl -- 
    ,o.apply_sta -- 
    ,o.deal_sta -- 
    ,o.filename -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.mcht_type -- 
    ,o.conn_type -- 
    ,o.acq_inst_id -- 
    ,o.mcc -- 
    ,o.licence_nm -- 
    ,o.tax_no -- 
    ,o.bank_licence_no -- 
    ,o.director_nm -- 
    ,o.director_no -- 
    ,o.scale -- 
    ,o.clear_type -- 
    ,o.settle_type -- 
    ,o.oper_id -- 
    ,o.create_date -- 
    ,o.id -- 
    ,o.rec_upd_ts -- 
    ,o.upd_oper -- 
    ,o.inspact_date -- 
    ,o.inspact_cycle -- 
    ,o.return_sta -- 
    ,o.train_date -- 
    ,o.train_cycle -- 
    ,o.exp_bank -- //用于拓展行
    ,o.out_mcht_no -- 
    ,o.comm_email -- 
    ,o.comm_mobil -- 
    ,o.artif_certif_tp -- 
    ,o.manager_tel -- 
    ,o.agr_br -- 
    ,o.net_tel -- 
    ,o.ztflag -- 
    ,o.acct_chnl -- 
    ,o.prof_type -- 业务种类
    ,o.license_deadline -- 法定代表人或负责人证件有效期截止日
    ,o.acc_add -- 网络商户登记网址
    ,o.acc_ip -- 网络商户登记ip
    ,o.acc_icp_no -- 网络商户icp备案/许可证号
    ,o.reg_amt -- 注册资本金
    ,o.coo_state -- 合作状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_direct_mchnt_inf_bk o
    left join ${iol_schema}.mrms_tbl_direct_mchnt_inf_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_direct_mchnt_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_direct_mchnt_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_direct_mchnt_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_direct_mchnt_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_direct_mchnt_inf exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl;
alter table ${iol_schema}.mrms_tbl_direct_mchnt_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_direct_mchnt_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf_op purge;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_direct_mchnt_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
