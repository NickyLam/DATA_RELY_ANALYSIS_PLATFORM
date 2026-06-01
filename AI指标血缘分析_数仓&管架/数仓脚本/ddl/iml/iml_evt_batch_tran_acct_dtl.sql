/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_batch_tran_acct_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_batch_tran_acct_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_batch_tran_acct_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_tran_acct_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_no varchar2(60) -- 批次号
    ,seq_num varchar2(60) -- 序号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,subj_id varchar2(100) -- 科目编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,heat_insu_acct_flg varchar2(10) -- 医保账户标志
    ,acct_name varchar2(500) -- 账户名称
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,clear_dt date -- 清算日期
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_dt date -- 交易日期
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_descb varchar2(500) -- 交易描述
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_postsc varchar2(1000) -- 交易附言
    ,cap_froz_flow_num varchar2(100) -- 资金冻结流水号
    ,memo_code varchar2(100) -- 摘要码
    ,memo varchar2(500) -- 摘要
    ,cntpty_tran_type_cd varchar2(30) -- 交易对手交易类型代码
    ,cntpty_tran_ref_no varchar2(60) -- 交易对手交易参考号
    ,cntpty_tran_flow_num varchar2(100) -- 交易对手交易流水号
    ,cntpty_subj_id varchar2(100) -- 交易对手科目编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,cntpty_open_acct_org_id varchar2(100) -- 交易对手开户机构编号
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_prod_id varchar2(100) -- 交易对手账户产品编号
    ,cntpty_acct_curr_cd varchar2(30) -- 交易对手账户币种代码
    ,cntpty_sub_acct_num varchar2(60) -- 交易对手子账号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,real_cntpty_cust_acct_num varchar2(60) -- 真实交易对手客户账号
    ,real_cntpty_name varchar2(500) -- 真实交易对手名称
    ,real_cntpty_acct_type_cd varchar2(30) -- 真实交易对手账户类型代码
    ,real_cntpty_org_id varchar2(100) -- 真实交易对手机构编号
    ,real_cntpty_org_name varchar2(500) -- 真实交易对手机构名称
    ,real_cntpty_cert_no varchar2(100) -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd varchar2(30) -- 真实交易对手证件类型代码
    ,real_tran_happ_site varchar2(1000) -- 真实交易发生地点
    ,serv_status_descb varchar2(4000) -- 服务状态描述
    ,err_cd varchar2(60) -- 错误码
    ,err_descb varchar2(4000) -- 错误描述
    ,remark varchar2(4000) -- 备注
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_batch_tran_acct_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_batch_tran_acct_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_batch_tran_acct_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_batch_tran_acct_dtl is '批量转账明细';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.batch_no is '批次号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.seq_num is '序号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.subj_id is '科目编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.heat_insu_acct_flg is '医保账户标志';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.acct_name is '账户名称';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.tran_postsc is '交易附言';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cap_froz_flow_num is '资金冻结流水号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.memo_code is '摘要码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.memo is '摘要';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_tran_type_cd is '交易对手交易类型代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_tran_ref_no is '交易对手交易参考号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_tran_flow_num is '交易对手交易流水号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_subj_id is '交易对手科目编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_open_acct_org_id is '交易对手开户机构编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_acct_prod_id is '交易对手账户产品编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_acct_curr_cd is '交易对手账户币种代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_sub_acct_num is '交易对手子账号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_cust_acct_num is '真实交易对手客户账号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_name is '真实交易对手名称';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_acct_type_cd is '真实交易对手账户类型代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_org_id is '真实交易对手机构编号';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_org_name is '真实交易对手机构名称';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_cert_no is '真实交易对手证件号码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_cntpty_cert_type_cd is '真实交易对手证件类型代码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.real_tran_happ_site is '真实交易发生地点';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.serv_status_descb is '服务状态描述';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.err_cd is '错误码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.err_descb is '错误描述';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.remark is '备注';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_batch_tran_acct_dtl.etl_timestamp is 'ETL处理时间戳';
