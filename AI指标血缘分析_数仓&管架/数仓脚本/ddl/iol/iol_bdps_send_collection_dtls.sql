/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_send_collection_dtls
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_send_collection_dtls
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_send_collection_dtls purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_send_collection_dtls(
    id number(22) -- 
    ,batch_id number(22) -- 
    ,src_type varchar2(2) -- 
    ,branch_id number(22) -- 
    ,send_date varchar2(12) -- 
    ,draft_id number(22) -- 
    ,isse_curcd varchar2(5) -- 
    ,isse_amt number(18,2) -- 
    ,drft_hldr_cmonid varchar2(45) -- 
    ,apply_amt number(18,2) -- 
    ,mesg_type varchar2(5) -- 
    ,sttlm_mk varchar2(6) -- 
    ,drft_hldr_role varchar2(6) -- 
    ,apply_date varchar2(12) -- 
    ,ovrdue_rsn varchar2(384) -- 
    ,apply_curcd varchar2(5) -- 
    ,drft_hldr_name varchar2(270) -- 
    ,drft_hldr_actno varchar2(48) -- 
    ,drft_hldr_ubank varchar2(18) -- 
    ,drft_hldr_agcy_ubank varchar2(18) -- 
    ,req_remark varchar2(1152) -- 
    ,req_prxy_prop_stn varchar2(6) -- 
    ,rcv_remark varchar2(1152) -- 
    ,rcv_prxy_sgntr varchar2(6) -- 
    ,prompt_status varchar2(3) -- 
    ,endst_date varchar2(12) -- 
    ,cancel_date varchar2(12) -- 
    ,cancel_opid number(22) -- 
    ,receive_date varchar2(12) -- 
    ,sig_mk varchar2(6) -- 
    ,dish_code varchar2(6) -- 
    ,dish_rsn varchar2(1152) -- 
    ,cm_status varchar2(3) -- 
    ,cm_err_procd varchar2(12) -- 
    ,ecds_prc_msg varchar2(1152) -- 
    ,account_date varchar2(12) -- 
    ,account_flag varchar2(2) -- 
    ,actlog_id number(22) -- 
    ,swt_biz_id number(22) -- 
    ,trf_ref varchar2(18) -- 
    ,trf_id varchar2(12) -- 
    ,entity_regstat varchar2(2) -- 
    ,entity_reg_id number(22) -- 
    ,misc varchar2(150) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,cancel_flag varchar2(2) -- 
    ,branch_id_opt number(22) -- 
    ,ebank_pool_id number(22) -- 
    ,fee number(18,2) -- 
    ,rcv_back_id number(22) -- 
    ,refid number(22) -- 
    ,virtual_account_no varchar2(29) -- 
    ,is_problem_draft varchar2(2) -- 
    ,return_cash_account varchar2(30) -- 回款账户
    ,serino varchar2(6) -- 序列号
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
grant select on ${iol_schema}.bdps_send_collection_dtls to ${iml_schema};
grant select on ${iol_schema}.bdps_send_collection_dtls to ${icl_schema};
grant select on ${iol_schema}.bdps_send_collection_dtls to ${idl_schema};
grant select on ${iol_schema}.bdps_send_collection_dtls to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_send_collection_dtls is '发出托收明细表';
comment on column ${iol_schema}.bdps_send_collection_dtls.id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.batch_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.src_type is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.branch_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.send_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.draft_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.isse_curcd is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.isse_amt is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.drft_hldr_cmonid is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.apply_amt is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.mesg_type is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.sttlm_mk is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.drft_hldr_role is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.apply_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.ovrdue_rsn is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.apply_curcd is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.drft_hldr_name is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.drft_hldr_actno is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.drft_hldr_ubank is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.drft_hldr_agcy_ubank is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.req_remark is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.req_prxy_prop_stn is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.rcv_remark is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.rcv_prxy_sgntr is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.prompt_status is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.endst_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.cancel_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.cancel_opid is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.receive_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.sig_mk is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.dish_code is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.dish_rsn is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.cm_status is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.cm_err_procd is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.ecds_prc_msg is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.account_date is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.account_flag is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.actlog_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.swt_biz_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.trf_ref is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.trf_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.entity_regstat is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.entity_reg_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.misc is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.last_upd_time is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.cancel_flag is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.branch_id_opt is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.ebank_pool_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.fee is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.rcv_back_id is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.refid is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.virtual_account_no is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.is_problem_draft is '';
comment on column ${iol_schema}.bdps_send_collection_dtls.return_cash_account is '回款账户';
comment on column ${iol_schema}.bdps_send_collection_dtls.serino is '序列号';
comment on column ${iol_schema}.bdps_send_collection_dtls.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_send_collection_dtls.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_send_collection_dtls.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_send_collection_dtls.etl_timestamp is 'ETL处理时间戳';
