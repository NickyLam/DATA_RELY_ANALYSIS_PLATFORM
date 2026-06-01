/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_pre_turn_long_hang_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_pre_turn_long_hang_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pre_turn_long_hang_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,batch_no varchar2(60) -- 批次号
    ,acct_name varchar2(500) -- 账户名称
    ,sub_acct_num varchar2(60) -- 子账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,batch_proc_status_cd varchar2(30) -- 批次处理状态代码
    ,audit_dt date -- 审计日期
    ,turn_long_hang_dt date -- 转久悬日期
    ,pre_turn_idf_cd varchar2(30) -- 预转标识代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,fail_rs_descb varchar2(500) -- 失败原因描述
    ,remark varchar2(500) -- 备注
    ,check_dt date -- 复核日期
    ,core_flow_num varchar2(200) -- 核心流水号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark varchar2(4000) -- 限制及渠道控制信息备注
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
grant select on ${iml_schema}.agt_pre_turn_long_hang_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_pre_turn_long_hang_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_pre_turn_long_hang_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_pre_turn_long_hang_acct_h is '预转久悬户信息历史';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.batch_no is '批次号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.batch_proc_status_cd is '批次处理状态代码';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.audit_dt is '审计日期';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.turn_long_hang_dt is '转久悬日期';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.pre_turn_idf_cd is '预转标识代码';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.fail_rs_descb is '失败原因描述';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.remark is '备注';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.check_dt is '复核日期';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.core_flow_num is '核心流水号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.lmt_and_chn_ctrl_info_remark is '限制及渠道控制信息备注';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_pre_turn_long_hang_acct_h.etl_timestamp is 'ETL处理时间戳';
