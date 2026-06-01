/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_term_inf
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
create table ${iol_schema}.mrms_tbl_term_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_term_inf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_term_inf_op purge;
drop table ${iol_schema}.mrms_tbl_term_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_term_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_term_inf where 0=1;

create table ${iol_schema}.mrms_tbl_term_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_term_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_term_inf_cl(
            mcht_cd -- 
            ,term_id -- 
            ,mcht_cd_sub -- 
            ,term_id_id -- 
            ,record_sta -- 
            ,term_sta -- 
            ,term_sign_sta -- 
            ,chk_sta -- 
            ,term_send_flag -- 
            ,term_i_card_flag -- 
            ,reserve_flag1 -- 
            ,reserve_flag2 -- 
            ,reserve_flag3 -- 
            ,reserve_flag4 -- 
            ,term_set_cur -- 
            ,term_mcc -- 
            ,term_factory -- 
            ,term_mach_tp -- 
            ,term_ver -- 
            ,term_single_limit -- 
            ,pay_stage_num -- 
            ,pay_stage_limit -- 
            ,finance_card1 -- 
            ,finance_card2 -- 
            ,finance_card3 -- 
            ,reserve_amount1 -- 
            ,reserve_amount2 -- 
            ,term_tp -- 
            ,param_down_sign -- 
            ,param1_down_sign -- 
            ,ic_down_sign -- 
            ,key_down_sign -- 
            ,prop_tp -- 
            ,prop_ins_nm -- 
            ,f_card_sup_flag -- 
            ,f_card_company -- 
            ,support_ic -- 
            ,psam_id -- 
            ,term_place -- 
            ,connect_mode -- 
            ,dial_tp -- 
            ,term_branch -- 
            ,term_bank -- 
            ,term_ins -- 
            ,term_ver_tp -- 
            ,term_batch_nm -- 
            ,term_stlm_dt -- 
            ,term_txn_sup -- 
            ,term_para -- 
            ,term_para_1 -- 
            ,term_para_2 -- 
            ,bind_tel1 -- 
            ,bind_tel2 -- 
            ,bind_tel3 -- 
            ,zone_num -- 
            ,term_addr -- 
            ,opr_nm -- 
            ,cont_tel -- 
            ,equip_inv_id -- 
            ,equip_inv_nm -- 
            ,deposit_flag -- 
            ,deposit_amt -- 
            ,run_main_id_1 -- 
            ,run_main_nm_1 -- 
            ,run_main_id_2 -- 
            ,run_main_nm_2 -- 
            ,oth_svr_id -- 
            ,oth_svr_nm -- 
            ,rec_opr_id -- 
            ,rec_upd_opr -- 
            ,rec_crt_opr -- 
            ,rec_che_opr -- 
            ,reserve_date -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,rec_del_ts -- 
            ,misc_1 -- 
            ,misc_2 -- 
            ,misc_3 -- 
            ,product_cd -- 
            ,lease_id -- 
            ,term_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_term_inf_op(
            mcht_cd -- 
            ,term_id -- 
            ,mcht_cd_sub -- 
            ,term_id_id -- 
            ,record_sta -- 
            ,term_sta -- 
            ,term_sign_sta -- 
            ,chk_sta -- 
            ,term_send_flag -- 
            ,term_i_card_flag -- 
            ,reserve_flag1 -- 
            ,reserve_flag2 -- 
            ,reserve_flag3 -- 
            ,reserve_flag4 -- 
            ,term_set_cur -- 
            ,term_mcc -- 
            ,term_factory -- 
            ,term_mach_tp -- 
            ,term_ver -- 
            ,term_single_limit -- 
            ,pay_stage_num -- 
            ,pay_stage_limit -- 
            ,finance_card1 -- 
            ,finance_card2 -- 
            ,finance_card3 -- 
            ,reserve_amount1 -- 
            ,reserve_amount2 -- 
            ,term_tp -- 
            ,param_down_sign -- 
            ,param1_down_sign -- 
            ,ic_down_sign -- 
            ,key_down_sign -- 
            ,prop_tp -- 
            ,prop_ins_nm -- 
            ,f_card_sup_flag -- 
            ,f_card_company -- 
            ,support_ic -- 
            ,psam_id -- 
            ,term_place -- 
            ,connect_mode -- 
            ,dial_tp -- 
            ,term_branch -- 
            ,term_bank -- 
            ,term_ins -- 
            ,term_ver_tp -- 
            ,term_batch_nm -- 
            ,term_stlm_dt -- 
            ,term_txn_sup -- 
            ,term_para -- 
            ,term_para_1 -- 
            ,term_para_2 -- 
            ,bind_tel1 -- 
            ,bind_tel2 -- 
            ,bind_tel3 -- 
            ,zone_num -- 
            ,term_addr -- 
            ,opr_nm -- 
            ,cont_tel -- 
            ,equip_inv_id -- 
            ,equip_inv_nm -- 
            ,deposit_flag -- 
            ,deposit_amt -- 
            ,run_main_id_1 -- 
            ,run_main_nm_1 -- 
            ,run_main_id_2 -- 
            ,run_main_nm_2 -- 
            ,oth_svr_id -- 
            ,oth_svr_nm -- 
            ,rec_opr_id -- 
            ,rec_upd_opr -- 
            ,rec_crt_opr -- 
            ,rec_che_opr -- 
            ,reserve_date -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,rec_del_ts -- 
            ,misc_1 -- 
            ,misc_2 -- 
            ,misc_3 -- 
            ,product_cd -- 
            ,lease_id -- 
            ,term_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mcht_cd, o.mcht_cd) as mcht_cd -- 
    ,nvl(n.term_id, o.term_id) as term_id -- 
    ,nvl(n.mcht_cd_sub, o.mcht_cd_sub) as mcht_cd_sub -- 
    ,nvl(n.term_id_id, o.term_id_id) as term_id_id -- 
    ,nvl(n.record_sta, o.record_sta) as record_sta -- 
    ,nvl(n.term_sta, o.term_sta) as term_sta -- 
    ,nvl(n.term_sign_sta, o.term_sign_sta) as term_sign_sta -- 
    ,nvl(n.chk_sta, o.chk_sta) as chk_sta -- 
    ,nvl(n.term_send_flag, o.term_send_flag) as term_send_flag -- 
    ,nvl(n.term_i_card_flag, o.term_i_card_flag) as term_i_card_flag -- 
    ,nvl(n.reserve_flag1, o.reserve_flag1) as reserve_flag1 -- 
    ,nvl(n.reserve_flag2, o.reserve_flag2) as reserve_flag2 -- 
    ,nvl(n.reserve_flag3, o.reserve_flag3) as reserve_flag3 -- 
    ,nvl(n.reserve_flag4, o.reserve_flag4) as reserve_flag4 -- 
    ,nvl(n.term_set_cur, o.term_set_cur) as term_set_cur -- 
    ,nvl(n.term_mcc, o.term_mcc) as term_mcc -- 
    ,nvl(n.term_factory, o.term_factory) as term_factory -- 
    ,nvl(n.term_mach_tp, o.term_mach_tp) as term_mach_tp -- 
    ,nvl(n.term_ver, o.term_ver) as term_ver -- 
    ,nvl(n.term_single_limit, o.term_single_limit) as term_single_limit -- 
    ,nvl(n.pay_stage_num, o.pay_stage_num) as pay_stage_num -- 
    ,nvl(n.pay_stage_limit, o.pay_stage_limit) as pay_stage_limit -- 
    ,nvl(n.finance_card1, o.finance_card1) as finance_card1 -- 
    ,nvl(n.finance_card2, o.finance_card2) as finance_card2 -- 
    ,nvl(n.finance_card3, o.finance_card3) as finance_card3 -- 
    ,nvl(n.reserve_amount1, o.reserve_amount1) as reserve_amount1 -- 
    ,nvl(n.reserve_amount2, o.reserve_amount2) as reserve_amount2 -- 
    ,nvl(n.term_tp, o.term_tp) as term_tp -- 
    ,nvl(n.param_down_sign, o.param_down_sign) as param_down_sign -- 
    ,nvl(n.param1_down_sign, o.param1_down_sign) as param1_down_sign -- 
    ,nvl(n.ic_down_sign, o.ic_down_sign) as ic_down_sign -- 
    ,nvl(n.key_down_sign, o.key_down_sign) as key_down_sign -- 
    ,nvl(n.prop_tp, o.prop_tp) as prop_tp -- 
    ,nvl(n.prop_ins_nm, o.prop_ins_nm) as prop_ins_nm -- 
    ,nvl(n.f_card_sup_flag, o.f_card_sup_flag) as f_card_sup_flag -- 
    ,nvl(n.f_card_company, o.f_card_company) as f_card_company -- 
    ,nvl(n.support_ic, o.support_ic) as support_ic -- 
    ,nvl(n.psam_id, o.psam_id) as psam_id -- 
    ,nvl(n.term_place, o.term_place) as term_place -- 
    ,nvl(n.connect_mode, o.connect_mode) as connect_mode -- 
    ,nvl(n.dial_tp, o.dial_tp) as dial_tp -- 
    ,nvl(n.term_branch, o.term_branch) as term_branch -- 
    ,nvl(n.term_bank, o.term_bank) as term_bank -- 
    ,nvl(n.term_ins, o.term_ins) as term_ins -- 
    ,nvl(n.term_ver_tp, o.term_ver_tp) as term_ver_tp -- 
    ,nvl(n.term_batch_nm, o.term_batch_nm) as term_batch_nm -- 
    ,nvl(n.term_stlm_dt, o.term_stlm_dt) as term_stlm_dt -- 
    ,nvl(n.term_txn_sup, o.term_txn_sup) as term_txn_sup -- 
    ,nvl(n.term_para, o.term_para) as term_para -- 
    ,nvl(n.term_para_1, o.term_para_1) as term_para_1 -- 
    ,nvl(n.term_para_2, o.term_para_2) as term_para_2 -- 
    ,nvl(n.bind_tel1, o.bind_tel1) as bind_tel1 -- 
    ,nvl(n.bind_tel2, o.bind_tel2) as bind_tel2 -- 
    ,nvl(n.bind_tel3, o.bind_tel3) as bind_tel3 -- 
    ,nvl(n.zone_num, o.zone_num) as zone_num -- 
    ,nvl(n.term_addr, o.term_addr) as term_addr -- 
    ,nvl(n.opr_nm, o.opr_nm) as opr_nm -- 
    ,nvl(n.cont_tel, o.cont_tel) as cont_tel -- 
    ,nvl(n.equip_inv_id, o.equip_inv_id) as equip_inv_id -- 
    ,nvl(n.equip_inv_nm, o.equip_inv_nm) as equip_inv_nm -- 
    ,nvl(n.deposit_flag, o.deposit_flag) as deposit_flag -- 
    ,nvl(n.deposit_amt, o.deposit_amt) as deposit_amt -- 
    ,nvl(n.run_main_id_1, o.run_main_id_1) as run_main_id_1 -- 
    ,nvl(n.run_main_nm_1, o.run_main_nm_1) as run_main_nm_1 -- 
    ,nvl(n.run_main_id_2, o.run_main_id_2) as run_main_id_2 -- 
    ,nvl(n.run_main_nm_2, o.run_main_nm_2) as run_main_nm_2 -- 
    ,nvl(n.oth_svr_id, o.oth_svr_id) as oth_svr_id -- 
    ,nvl(n.oth_svr_nm, o.oth_svr_nm) as oth_svr_nm -- 
    ,nvl(n.rec_opr_id, o.rec_opr_id) as rec_opr_id -- 
    ,nvl(n.rec_upd_opr, o.rec_upd_opr) as rec_upd_opr -- 
    ,nvl(n.rec_crt_opr, o.rec_crt_opr) as rec_crt_opr -- 
    ,nvl(n.rec_che_opr, o.rec_che_opr) as rec_che_opr -- 
    ,nvl(n.reserve_date, o.reserve_date) as reserve_date -- 
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 
    ,nvl(n.rec_del_ts, o.rec_del_ts) as rec_del_ts -- 
    ,nvl(n.misc_1, o.misc_1) as misc_1 -- 
    ,nvl(n.misc_2, o.misc_2) as misc_2 -- 
    ,nvl(n.misc_3, o.misc_3) as misc_3 -- 
    ,nvl(n.product_cd, o.product_cd) as product_cd -- 
    ,nvl(n.lease_id, o.lease_id) as lease_id -- 
    ,nvl(n.term_sync_status, o.term_sync_status) as term_sync_status -- 
    ,case when
            n.mcht_cd is null
            and n.term_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mcht_cd is null
            and n.term_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mcht_cd is null
            and n.term_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_term_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_term_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mcht_cd = n.mcht_cd
            and o.term_id = n.term_id
where (
        o.mcht_cd is null
        and o.term_id is null
    )
    or (
        n.mcht_cd is null
        and n.term_id is null
    )
    or (
        o.mcht_cd_sub <> n.mcht_cd_sub
        or o.term_id_id <> n.term_id_id
        or o.record_sta <> n.record_sta
        or o.term_sta <> n.term_sta
        or o.term_sign_sta <> n.term_sign_sta
        or o.chk_sta <> n.chk_sta
        or o.term_send_flag <> n.term_send_flag
        or o.term_i_card_flag <> n.term_i_card_flag
        or o.reserve_flag1 <> n.reserve_flag1
        or o.reserve_flag2 <> n.reserve_flag2
        or o.reserve_flag3 <> n.reserve_flag3
        or o.reserve_flag4 <> n.reserve_flag4
        or o.term_set_cur <> n.term_set_cur
        or o.term_mcc <> n.term_mcc
        or o.term_factory <> n.term_factory
        or o.term_mach_tp <> n.term_mach_tp
        or o.term_ver <> n.term_ver
        or o.term_single_limit <> n.term_single_limit
        or o.pay_stage_num <> n.pay_stage_num
        or o.pay_stage_limit <> n.pay_stage_limit
        or o.finance_card1 <> n.finance_card1
        or o.finance_card2 <> n.finance_card2
        or o.finance_card3 <> n.finance_card3
        or o.reserve_amount1 <> n.reserve_amount1
        or o.reserve_amount2 <> n.reserve_amount2
        or o.term_tp <> n.term_tp
        or o.param_down_sign <> n.param_down_sign
        or o.param1_down_sign <> n.param1_down_sign
        or o.ic_down_sign <> n.ic_down_sign
        or o.key_down_sign <> n.key_down_sign
        or o.prop_tp <> n.prop_tp
        or o.prop_ins_nm <> n.prop_ins_nm
        or o.f_card_sup_flag <> n.f_card_sup_flag
        or o.f_card_company <> n.f_card_company
        or o.support_ic <> n.support_ic
        or o.psam_id <> n.psam_id
        or o.term_place <> n.term_place
        or o.connect_mode <> n.connect_mode
        or o.dial_tp <> n.dial_tp
        or o.term_branch <> n.term_branch
        or o.term_bank <> n.term_bank
        or o.term_ins <> n.term_ins
        or o.term_ver_tp <> n.term_ver_tp
        or o.term_batch_nm <> n.term_batch_nm
        or o.term_stlm_dt <> n.term_stlm_dt
        or o.term_txn_sup <> n.term_txn_sup
        or o.term_para <> n.term_para
        or o.term_para_1 <> n.term_para_1
        or o.term_para_2 <> n.term_para_2
        or o.bind_tel1 <> n.bind_tel1
        or o.bind_tel2 <> n.bind_tel2
        or o.bind_tel3 <> n.bind_tel3
        or o.zone_num <> n.zone_num
        or o.term_addr <> n.term_addr
        or o.opr_nm <> n.opr_nm
        or o.cont_tel <> n.cont_tel
        or o.equip_inv_id <> n.equip_inv_id
        or o.equip_inv_nm <> n.equip_inv_nm
        or o.deposit_flag <> n.deposit_flag
        or o.deposit_amt <> n.deposit_amt
        or o.run_main_id_1 <> n.run_main_id_1
        or o.run_main_nm_1 <> n.run_main_nm_1
        or o.run_main_id_2 <> n.run_main_id_2
        or o.run_main_nm_2 <> n.run_main_nm_2
        or o.oth_svr_id <> n.oth_svr_id
        or o.oth_svr_nm <> n.oth_svr_nm
        or o.rec_opr_id <> n.rec_opr_id
        or o.rec_upd_opr <> n.rec_upd_opr
        or o.rec_crt_opr <> n.rec_crt_opr
        or o.rec_che_opr <> n.rec_che_opr
        or o.reserve_date <> n.reserve_date
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.rec_del_ts <> n.rec_del_ts
        or o.misc_1 <> n.misc_1
        or o.misc_2 <> n.misc_2
        or o.misc_3 <> n.misc_3
        or o.product_cd <> n.product_cd
        or o.lease_id <> n.lease_id
        or o.term_sync_status <> n.term_sync_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_term_inf_cl(
            mcht_cd -- 
            ,term_id -- 
            ,mcht_cd_sub -- 
            ,term_id_id -- 
            ,record_sta -- 
            ,term_sta -- 
            ,term_sign_sta -- 
            ,chk_sta -- 
            ,term_send_flag -- 
            ,term_i_card_flag -- 
            ,reserve_flag1 -- 
            ,reserve_flag2 -- 
            ,reserve_flag3 -- 
            ,reserve_flag4 -- 
            ,term_set_cur -- 
            ,term_mcc -- 
            ,term_factory -- 
            ,term_mach_tp -- 
            ,term_ver -- 
            ,term_single_limit -- 
            ,pay_stage_num -- 
            ,pay_stage_limit -- 
            ,finance_card1 -- 
            ,finance_card2 -- 
            ,finance_card3 -- 
            ,reserve_amount1 -- 
            ,reserve_amount2 -- 
            ,term_tp -- 
            ,param_down_sign -- 
            ,param1_down_sign -- 
            ,ic_down_sign -- 
            ,key_down_sign -- 
            ,prop_tp -- 
            ,prop_ins_nm -- 
            ,f_card_sup_flag -- 
            ,f_card_company -- 
            ,support_ic -- 
            ,psam_id -- 
            ,term_place -- 
            ,connect_mode -- 
            ,dial_tp -- 
            ,term_branch -- 
            ,term_bank -- 
            ,term_ins -- 
            ,term_ver_tp -- 
            ,term_batch_nm -- 
            ,term_stlm_dt -- 
            ,term_txn_sup -- 
            ,term_para -- 
            ,term_para_1 -- 
            ,term_para_2 -- 
            ,bind_tel1 -- 
            ,bind_tel2 -- 
            ,bind_tel3 -- 
            ,zone_num -- 
            ,term_addr -- 
            ,opr_nm -- 
            ,cont_tel -- 
            ,equip_inv_id -- 
            ,equip_inv_nm -- 
            ,deposit_flag -- 
            ,deposit_amt -- 
            ,run_main_id_1 -- 
            ,run_main_nm_1 -- 
            ,run_main_id_2 -- 
            ,run_main_nm_2 -- 
            ,oth_svr_id -- 
            ,oth_svr_nm -- 
            ,rec_opr_id -- 
            ,rec_upd_opr -- 
            ,rec_crt_opr -- 
            ,rec_che_opr -- 
            ,reserve_date -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,rec_del_ts -- 
            ,misc_1 -- 
            ,misc_2 -- 
            ,misc_3 -- 
            ,product_cd -- 
            ,lease_id -- 
            ,term_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_term_inf_op(
            mcht_cd -- 
            ,term_id -- 
            ,mcht_cd_sub -- 
            ,term_id_id -- 
            ,record_sta -- 
            ,term_sta -- 
            ,term_sign_sta -- 
            ,chk_sta -- 
            ,term_send_flag -- 
            ,term_i_card_flag -- 
            ,reserve_flag1 -- 
            ,reserve_flag2 -- 
            ,reserve_flag3 -- 
            ,reserve_flag4 -- 
            ,term_set_cur -- 
            ,term_mcc -- 
            ,term_factory -- 
            ,term_mach_tp -- 
            ,term_ver -- 
            ,term_single_limit -- 
            ,pay_stage_num -- 
            ,pay_stage_limit -- 
            ,finance_card1 -- 
            ,finance_card2 -- 
            ,finance_card3 -- 
            ,reserve_amount1 -- 
            ,reserve_amount2 -- 
            ,term_tp -- 
            ,param_down_sign -- 
            ,param1_down_sign -- 
            ,ic_down_sign -- 
            ,key_down_sign -- 
            ,prop_tp -- 
            ,prop_ins_nm -- 
            ,f_card_sup_flag -- 
            ,f_card_company -- 
            ,support_ic -- 
            ,psam_id -- 
            ,term_place -- 
            ,connect_mode -- 
            ,dial_tp -- 
            ,term_branch -- 
            ,term_bank -- 
            ,term_ins -- 
            ,term_ver_tp -- 
            ,term_batch_nm -- 
            ,term_stlm_dt -- 
            ,term_txn_sup -- 
            ,term_para -- 
            ,term_para_1 -- 
            ,term_para_2 -- 
            ,bind_tel1 -- 
            ,bind_tel2 -- 
            ,bind_tel3 -- 
            ,zone_num -- 
            ,term_addr -- 
            ,opr_nm -- 
            ,cont_tel -- 
            ,equip_inv_id -- 
            ,equip_inv_nm -- 
            ,deposit_flag -- 
            ,deposit_amt -- 
            ,run_main_id_1 -- 
            ,run_main_nm_1 -- 
            ,run_main_id_2 -- 
            ,run_main_nm_2 -- 
            ,oth_svr_id -- 
            ,oth_svr_nm -- 
            ,rec_opr_id -- 
            ,rec_upd_opr -- 
            ,rec_crt_opr -- 
            ,rec_che_opr -- 
            ,reserve_date -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,rec_del_ts -- 
            ,misc_1 -- 
            ,misc_2 -- 
            ,misc_3 -- 
            ,product_cd -- 
            ,lease_id -- 
            ,term_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mcht_cd -- 
    ,o.term_id -- 
    ,o.mcht_cd_sub -- 
    ,o.term_id_id -- 
    ,o.record_sta -- 
    ,o.term_sta -- 
    ,o.term_sign_sta -- 
    ,o.chk_sta -- 
    ,o.term_send_flag -- 
    ,o.term_i_card_flag -- 
    ,o.reserve_flag1 -- 
    ,o.reserve_flag2 -- 
    ,o.reserve_flag3 -- 
    ,o.reserve_flag4 -- 
    ,o.term_set_cur -- 
    ,o.term_mcc -- 
    ,o.term_factory -- 
    ,o.term_mach_tp -- 
    ,o.term_ver -- 
    ,o.term_single_limit -- 
    ,o.pay_stage_num -- 
    ,o.pay_stage_limit -- 
    ,o.finance_card1 -- 
    ,o.finance_card2 -- 
    ,o.finance_card3 -- 
    ,o.reserve_amount1 -- 
    ,o.reserve_amount2 -- 
    ,o.term_tp -- 
    ,o.param_down_sign -- 
    ,o.param1_down_sign -- 
    ,o.ic_down_sign -- 
    ,o.key_down_sign -- 
    ,o.prop_tp -- 
    ,o.prop_ins_nm -- 
    ,o.f_card_sup_flag -- 
    ,o.f_card_company -- 
    ,o.support_ic -- 
    ,o.psam_id -- 
    ,o.term_place -- 
    ,o.connect_mode -- 
    ,o.dial_tp -- 
    ,o.term_branch -- 
    ,o.term_bank -- 
    ,o.term_ins -- 
    ,o.term_ver_tp -- 
    ,o.term_batch_nm -- 
    ,o.term_stlm_dt -- 
    ,o.term_txn_sup -- 
    ,o.term_para -- 
    ,o.term_para_1 -- 
    ,o.term_para_2 -- 
    ,o.bind_tel1 -- 
    ,o.bind_tel2 -- 
    ,o.bind_tel3 -- 
    ,o.zone_num -- 
    ,o.term_addr -- 
    ,o.opr_nm -- 
    ,o.cont_tel -- 
    ,o.equip_inv_id -- 
    ,o.equip_inv_nm -- 
    ,o.deposit_flag -- 
    ,o.deposit_amt -- 
    ,o.run_main_id_1 -- 
    ,o.run_main_nm_1 -- 
    ,o.run_main_id_2 -- 
    ,o.run_main_nm_2 -- 
    ,o.oth_svr_id -- 
    ,o.oth_svr_nm -- 
    ,o.rec_opr_id -- 
    ,o.rec_upd_opr -- 
    ,o.rec_crt_opr -- 
    ,o.rec_che_opr -- 
    ,o.reserve_date -- 
    ,o.rec_crt_ts -- 
    ,o.rec_upd_ts -- 
    ,o.rec_del_ts -- 
    ,o.misc_1 -- 
    ,o.misc_2 -- 
    ,o.misc_3 -- 
    ,o.product_cd -- 
    ,o.lease_id -- 
    ,o.term_sync_status -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_term_inf_bk o
    left join ${iol_schema}.mrms_tbl_term_inf_op n
        on
            o.mcht_cd = n.mcht_cd
            and o.term_id = n.term_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_term_inf_cl d
        on
            o.mcht_cd = d.mcht_cd
            and o.term_id = d.term_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mrms_tbl_term_inf;

-- 4.2 exchange partition
alter table ${iol_schema}.mrms_tbl_term_inf exchange partition p_19000101 with table ${iol_schema}.mrms_tbl_term_inf_cl;
alter table ${iol_schema}.mrms_tbl_term_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_term_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_term_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_term_inf_op purge;
drop table ${iol_schema}.mrms_tbl_term_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_term_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_term_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
