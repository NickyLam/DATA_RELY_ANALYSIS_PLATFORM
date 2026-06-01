/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_term_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_term_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_term_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_term_inf(
    mcht_cd varchar2(23) -- 
    ,term_id varchar2(18) -- 
    ,mcht_cd_sub varchar2(23) -- 
    ,term_id_id varchar2(23) -- 
    ,record_sta varchar2(2) -- 
    ,term_sta varchar2(2) -- 
    ,term_sign_sta varchar2(2) -- 
    ,chk_sta varchar2(2) -- 
    ,term_send_flag varchar2(2) -- 
    ,term_i_card_flag varchar2(2) -- 
    ,reserve_flag1 varchar2(2) -- 
    ,reserve_flag2 varchar2(2) -- 
    ,reserve_flag3 varchar2(2) -- 
    ,reserve_flag4 varchar2(2) -- 
    ,term_set_cur varchar2(2) -- 
    ,term_mcc varchar2(6) -- 
    ,term_factory varchar2(45) -- 
    ,term_mach_tp varchar2(15) -- 
    ,term_ver varchar2(3) -- 
    ,term_single_limit varchar2(18) -- 
    ,pay_stage_num number(22,0) -- 
    ,pay_stage_limit number(13,2) -- 
    ,finance_card1 varchar2(24) -- 
    ,finance_card2 varchar2(24) -- 
    ,finance_card3 varchar2(30) -- 
    ,reserve_amount1 number(13,2) -- 
    ,reserve_amount2 number(13,2) -- 
    ,term_tp varchar2(3) -- 
    ,param_down_sign varchar2(2) -- 
    ,param1_down_sign varchar2(2) -- 
    ,ic_down_sign varchar2(2) -- 
    ,key_down_sign varchar2(2) -- 
    ,prop_tp varchar2(2) -- 
    ,prop_ins_nm varchar2(120) -- 
    ,f_card_sup_flag varchar2(2) -- 
    ,f_card_company varchar2(23) -- 
    ,support_ic varchar2(2) -- 
    ,psam_id varchar2(12) -- 
    ,term_place varchar2(2) -- 
    ,connect_mode varchar2(2) -- 
    ,dial_tp varchar2(2) -- 
    ,term_branch varchar2(18) -- 
    ,term_bank varchar2(18) -- 
    ,term_ins varchar2(17) -- 
    ,term_ver_tp varchar2(3) -- 
    ,term_batch_nm varchar2(9) -- 
    ,term_stlm_dt varchar2(12) -- 
    ,term_txn_sup varchar2(9) -- 
    ,term_para varchar2(768) -- 
    ,term_para_1 varchar2(768) -- 
    ,term_para_2 varchar2(768) -- 
    ,bind_tel1 varchar2(23) -- 
    ,bind_tel2 varchar2(23) -- 
    ,bind_tel3 varchar2(23) -- 
    ,zone_num varchar2(9) -- 
    ,term_addr varchar2(525) -- 
    ,opr_nm varchar2(30) -- 
    ,cont_tel varchar2(30) -- 
    ,equip_inv_id varchar2(20) -- 
    ,equip_inv_nm varchar2(75) -- 
    ,deposit_flag varchar2(2) -- 
    ,deposit_amt number(13,2) -- 
    ,run_main_id_1 varchar2(20) -- 
    ,run_main_nm_1 varchar2(75) -- 
    ,run_main_id_2 varchar2(20) -- 
    ,run_main_nm_2 varchar2(75) -- 
    ,oth_svr_id varchar2(20) -- 
    ,oth_svr_nm varchar2(75) -- 
    ,rec_opr_id varchar2(2) -- 
    ,rec_upd_opr varchar2(12) -- 
    ,rec_crt_opr varchar2(12) -- 
    ,rec_che_opr varchar2(12) -- 
    ,reserve_date varchar2(12) -- 
    ,rec_crt_ts varchar2(12) -- 
    ,rec_upd_ts varchar2(12) -- 
    ,rec_del_ts varchar2(12) -- 
    ,misc_1 varchar2(30) -- 
    ,misc_2 varchar2(60) -- 
    ,misc_3 varchar2(120) -- 
    ,product_cd varchar2(60) -- 
    ,lease_id varchar2(23) -- 
    ,term_sync_status varchar2(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mrms_tbl_term_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_term_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_term_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_term_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_term_inf is '终端信息表';
comment on column ${iol_schema}.mrms_tbl_term_inf.mcht_cd is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.mcht_cd_sub is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_id_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.record_sta is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_sta is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_sign_sta is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.chk_sta is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_send_flag is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_i_card_flag is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_flag1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_flag2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_flag3 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_flag4 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_set_cur is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_mcc is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_factory is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_mach_tp is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_ver is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_single_limit is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.pay_stage_num is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.pay_stage_limit is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.finance_card1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.finance_card2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.finance_card3 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_amount1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_amount2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_tp is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.param_down_sign is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.param1_down_sign is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.ic_down_sign is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.key_down_sign is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.prop_tp is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.prop_ins_nm is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.f_card_sup_flag is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.f_card_company is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.support_ic is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.psam_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_place is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.connect_mode is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.dial_tp is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_branch is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_bank is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_ins is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_ver_tp is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_batch_nm is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_stlm_dt is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_txn_sup is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_para is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_para_1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_para_2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.bind_tel1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.bind_tel2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.bind_tel3 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.zone_num is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_addr is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.opr_nm is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.cont_tel is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.equip_inv_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.equip_inv_nm is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.deposit_flag is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.deposit_amt is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.run_main_id_1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.run_main_nm_1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.run_main_id_2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.run_main_nm_2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.oth_svr_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.oth_svr_nm is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_opr_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_upd_opr is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_crt_opr is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_che_opr is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.reserve_date is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_crt_ts is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_upd_ts is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.rec_del_ts is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.misc_1 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.misc_2 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.misc_3 is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.product_cd is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.lease_id is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.term_sync_status is '';
comment on column ${iol_schema}.mrms_tbl_term_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_term_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_term_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_term_inf.etl_timestamp is 'ETL处理时间戳';
