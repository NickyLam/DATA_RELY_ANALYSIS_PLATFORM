/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_send_collection_dtls_xydbk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_send_collection_dtls_xydbk
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_send_collection_dtls_xydbk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_send_collection_dtls_xydbk(
    id number(22) -- 
    ,batch_id number(22) -- 
    ,src_type varchar2(1) -- 
    ,branch_id number(22) -- 
    ,send_date varchar2(8) -- 
    ,draft_id number(22) -- 
    ,isse_curcd varchar2(3) -- 
    ,isse_amt number(18,2) -- 
    ,drft_hldr_cmonid varchar2(30) -- 
    ,apply_amt number(18,2) -- 
    ,mesg_type varchar2(3) -- 
    ,sttlm_mk varchar2(4) -- 
    ,drft_hldr_role varchar2(4) -- 
    ,apply_date varchar2(8) -- 
    ,ovrdue_rsn varchar2(256) -- 
    ,apply_curcd varchar2(3) -- 
    ,drft_hldr_name varchar2(180) -- 
    ,drft_hldr_actno varchar2(32) -- 
    ,drft_hldr_ubank varchar2(12) -- 
    ,drft_hldr_agcy_ubank varchar2(12) -- 
    ,req_remark varchar2(768) -- 
    ,req_prxy_prop_stn varchar2(4) -- 
    ,rcv_remark varchar2(768) -- 
    ,rcv_prxy_sgntr varchar2(4) -- 
    ,prompt_status varchar2(2) -- 
    ,endst_date varchar2(8) -- 
    ,cancel_date varchar2(8) -- 
    ,cancel_opid number(22) -- 
    ,receive_date varchar2(8) -- 
    ,sig_mk varchar2(4) -- 
    ,dish_code varchar2(4) -- 
    ,dish_rsn varchar2(768) -- 
    ,cm_status varchar2(2) -- 
    ,cm_err_procd varchar2(8) -- 
    ,ecds_prc_msg varchar2(768) -- 
    ,account_date varchar2(8) -- 
    ,account_flag varchar2(1) -- 
    ,actlog_id number(22) -- 
    ,swt_biz_id number(22) -- 
    ,trf_ref varchar2(12) -- 
    ,trf_id varchar2(8) -- 
    ,entity_regstat varchar2(1) -- 
    ,entity_reg_id number(22) -- 
    ,misc varchar2(100) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(14) -- 
    ,cancel_flag varchar2(1) -- 
    ,branch_id_opt number(22) -- 
    ,ebank_pool_id number(22) -- 
    ,fee number(18,2) -- 
    ,rcv_back_id number(22) -- 
    ,refid number(22) -- 
    ,virtual_account_no varchar2(19) -- 
    ,is_problem_draft varchar2(1) -- 
    ,return_cash_account varchar2(20) -- 回款账户
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
grant select on ${iol_schema}.bdps_send_collection_dtls_xydbk to ${iml_schema};
grant select on ${iol_schema}.bdps_send_collection_dtls_xydbk to ${icl_schema};
grant select on ${iol_schema}.bdps_send_collection_dtls_xydbk to ${idl_schema};
grant select on ${iol_schema}.bdps_send_collection_dtls_xydbk to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_send_collection_dtls_xydbk is '发出托收明细表';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.batch_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.src_type is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.branch_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.send_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.draft_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.isse_curcd is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.isse_amt is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.drft_hldr_cmonid is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.apply_amt is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.mesg_type is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.sttlm_mk is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.drft_hldr_role is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.apply_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.ovrdue_rsn is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.apply_curcd is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.drft_hldr_name is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.drft_hldr_actno is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.drft_hldr_ubank is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.drft_hldr_agcy_ubank is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.req_remark is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.req_prxy_prop_stn is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.rcv_remark is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.rcv_prxy_sgntr is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.prompt_status is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.endst_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.cancel_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.cancel_opid is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.receive_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.sig_mk is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.dish_code is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.dish_rsn is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.cm_status is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.cm_err_procd is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.ecds_prc_msg is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.account_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.account_flag is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.actlog_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.swt_biz_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.trf_ref is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.trf_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.entity_regstat is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.entity_reg_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.misc is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.last_upd_time is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.cancel_flag is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.branch_id_opt is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.ebank_pool_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.fee is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.rcv_back_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.refid is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.virtual_account_no is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.is_problem_draft is '';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.return_cash_account is '回款账户';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_send_collection_dtls_xydbk.etl_timestamp is 'ETL处理时间戳';
