/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_up_clarify_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_up_clarify_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_up_clarify_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_up_clarify_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,ser_num varchar2(100) -- 序列号
    ,batch_no varchar2(250) -- 批次号
    ,fund_corp_id varchar2(250) -- 基金公司编号
    ,belong_org_id varchar2(250) -- 所属机构编号
    ,cnter_org_id varchar2(250) -- 柜台机构编号
    ,remit_acct_dt date -- 划账日期
    ,remit_acct_status_cd varchar2(250) -- 划账状态代码
    ,should_remit_acct_amt number(30,2) -- 应划账金额
    ,actl_remit_acct_amt number(30,2) -- 实际划账金额
    ,fail_rs varchar2(500) -- 失败原因
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(500) -- 付款账户名称
    ,pay_acct_type_cd varchar2(60) -- 付款账户类型代码
    ,pay_acct_open_bank_num varchar2(60) -- 付款账户开户行号
    ,pay_acct_open_bank_name varchar2(500) -- 付款账户开户行名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_type_cd varchar2(60) -- 收款账户类型代码
    ,valid_flg varchar2(10) -- 有效标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_up_clarify_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_up_clarify_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_up_clarify_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_up_clarify_dtl is '银联代付清分明细';
comment on column ${iml_schema}.evt_up_clarify_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.ser_num is '序列号';
comment on column ${iml_schema}.evt_up_clarify_dtl.batch_no is '批次号';
comment on column ${iml_schema}.evt_up_clarify_dtl.fund_corp_id is '基金公司编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.cnter_org_id is '柜台机构编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.remit_acct_dt is '划账日期';
comment on column ${iml_schema}.evt_up_clarify_dtl.remit_acct_status_cd is '划账状态代码';
comment on column ${iml_schema}.evt_up_clarify_dtl.should_remit_acct_amt is '应划账金额';
comment on column ${iml_schema}.evt_up_clarify_dtl.actl_remit_acct_amt is '实际划账金额';
comment on column ${iml_schema}.evt_up_clarify_dtl.fail_rs is '失败原因';
comment on column ${iml_schema}.evt_up_clarify_dtl.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_up_clarify_dtl.pay_acct_type_cd is '付款账户类型代码';
comment on column ${iml_schema}.evt_up_clarify_dtl.pay_acct_open_bank_num is '付款账户开户行号';
comment on column ${iml_schema}.evt_up_clarify_dtl.pay_acct_open_bank_name is '付款账户开户行名称';
comment on column ${iml_schema}.evt_up_clarify_dtl.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_up_clarify_dtl.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_up_clarify_dtl.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.evt_up_clarify_dtl.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_up_clarify_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_up_clarify_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_up_clarify_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_up_clarify_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_up_clarify_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_up_clarify_dtl.etl_timestamp is 'ETL处理时间戳';
