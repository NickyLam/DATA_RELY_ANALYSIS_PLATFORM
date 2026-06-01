/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_dibet_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_dibet_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_dibet_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_dibet_info(
    id number(22) -- 
    ,contract_no varchar2(60) -- 
    ,loan_seq varchar2(75) -- 
    ,txn_type varchar2(51) -- 
    ,maturity_date varchar2(12) -- 
    ,remitter_date varchar2(12) -- 
    ,loan_status number(22) -- 
    ,remitter_amt number(18,2) -- 
    ,bail_amt number(18,2) -- 开票保证金金额
    ,exposure_amt number(18,2) -- 
    ,dibet_pro_account varchar2(60) -- 
    ,remark varchar2(150) -- 
    ,is_draft varchar2(2) -- 
    ,draft_id number(22) -- 
    ,app_no varchar2(45) -- 
    ,source_flag varchar2(6) -- 
    ,audit_status varchar2(2) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,ref_no varchar2(45) -- 
    ,outloan_brh_no varchar2(30) -- 
    ,brh_no varchar2(30) -- 
    ,lncurcd varchar2(5) -- 
    ,curcdrate number(12,8) -- 
    ,exhibition_date varchar2(12) -- 
    ,appseq varchar2(75) -- 
    ,lntype varchar2(2) -- 
    ,loan_appno varchar2(60) -- 
    ,lncustno varchar2(17) -- 
    ,rate number(12,8) -- 利率
    ,is_clear varchar2(2) -- 0-未结清 1-已结清
    ,guarno varchar2(60) -- 押品编号
    ,draft_number varchar2(45) -- 票据号码
    ,draft_maturity_date varchar2(12) -- 票据到期日
    ,face_amount number(18,2) -- 票面金额
    ,draft_key varchar2(45) -- 票据唯一标识
    ,paragraph_amt number(18,2) -- 已追备款金额
    ,par_status varchar2(2) -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
    ,err_remarks varchar2(750) -- 异常信息备注
    ,para_date varchar2(12) -- 备款日期
    ,should_para_amt number(18,2) -- 应追加备款金额
    ,batch_no varchar2(60) -- 批次号
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
grant select on ${iol_schema}.bdps_dibet_info to ${iml_schema};
grant select on ${iol_schema}.bdps_dibet_info to ${icl_schema};
grant select on ${iol_schema}.bdps_dibet_info to ${idl_schema};
grant select on ${iol_schema}.bdps_dibet_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_dibet_info is '放款信息表';
comment on column ${iol_schema}.bdps_dibet_info.id is '';
comment on column ${iol_schema}.bdps_dibet_info.contract_no is '';
comment on column ${iol_schema}.bdps_dibet_info.loan_seq is '';
comment on column ${iol_schema}.bdps_dibet_info.txn_type is '';
comment on column ${iol_schema}.bdps_dibet_info.maturity_date is '';
comment on column ${iol_schema}.bdps_dibet_info.remitter_date is '';
comment on column ${iol_schema}.bdps_dibet_info.loan_status is '';
comment on column ${iol_schema}.bdps_dibet_info.remitter_amt is '';
comment on column ${iol_schema}.bdps_dibet_info.bail_amt is '开票保证金金额';
comment on column ${iol_schema}.bdps_dibet_info.exposure_amt is '';
comment on column ${iol_schema}.bdps_dibet_info.dibet_pro_account is '';
comment on column ${iol_schema}.bdps_dibet_info.remark is '';
comment on column ${iol_schema}.bdps_dibet_info.is_draft is '';
comment on column ${iol_schema}.bdps_dibet_info.draft_id is '';
comment on column ${iol_schema}.bdps_dibet_info.app_no is '';
comment on column ${iol_schema}.bdps_dibet_info.source_flag is '';
comment on column ${iol_schema}.bdps_dibet_info.audit_status is '';
comment on column ${iol_schema}.bdps_dibet_info.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_dibet_info.last_upd_time is '';
comment on column ${iol_schema}.bdps_dibet_info.ref_no is '';
comment on column ${iol_schema}.bdps_dibet_info.outloan_brh_no is '';
comment on column ${iol_schema}.bdps_dibet_info.brh_no is '';
comment on column ${iol_schema}.bdps_dibet_info.lncurcd is '';
comment on column ${iol_schema}.bdps_dibet_info.curcdrate is '';
comment on column ${iol_schema}.bdps_dibet_info.exhibition_date is '';
comment on column ${iol_schema}.bdps_dibet_info.appseq is '';
comment on column ${iol_schema}.bdps_dibet_info.lntype is '';
comment on column ${iol_schema}.bdps_dibet_info.loan_appno is '';
comment on column ${iol_schema}.bdps_dibet_info.lncustno is '';
comment on column ${iol_schema}.bdps_dibet_info.rate is '利率';
comment on column ${iol_schema}.bdps_dibet_info.is_clear is '0-未结清 1-已结清';
comment on column ${iol_schema}.bdps_dibet_info.guarno is '押品编号';
comment on column ${iol_schema}.bdps_dibet_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdps_dibet_info.draft_maturity_date is '票据到期日';
comment on column ${iol_schema}.bdps_dibet_info.face_amount is '票面金额';
comment on column ${iol_schema}.bdps_dibet_info.draft_key is '票据唯一标识';
comment on column ${iol_schema}.bdps_dibet_info.paragraph_amt is '已追备款金额';
comment on column ${iol_schema}.bdps_dibet_info.par_status is '备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款';
comment on column ${iol_schema}.bdps_dibet_info.err_remarks is '异常信息备注';
comment on column ${iol_schema}.bdps_dibet_info.para_date is '备款日期';
comment on column ${iol_schema}.bdps_dibet_info.should_para_amt is '应追加备款金额';
comment on column ${iol_schema}.bdps_dibet_info.batch_no is '批次号';
comment on column ${iol_schema}.bdps_dibet_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_dibet_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_dibet_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_dibet_info.etl_timestamp is 'ETL处理时间戳';
