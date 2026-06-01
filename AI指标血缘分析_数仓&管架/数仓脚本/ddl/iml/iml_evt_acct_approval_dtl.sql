/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_acct_approval_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_acct_approval_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_acct_approval_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acct_approval_dtl(
    evt_id varchar2(250) -- 事件编号
    ,approval_id varchar2(100) -- 核准件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,cust_id varchar2(100) -- 客户编号
    ,open_dt date -- 开立日期
    ,exp_dt date -- 到期日期
    ,approval_type_cd varchar2(30) -- 核准件类型代码
    ,approval_cap_use_usage varchar2(1000) -- 核准件资金使用用途
    ,approval_cap_src varchar2(500) -- 核准件资金来源
    ,approval_open_amt number(30,2) -- 核准件开立金额
    ,apprv_acct_imp_item varchar2(500) -- 核准账户要项
    ,acct_type_descb varchar2(500) -- 账户类型描述
    ,expns_range varchar2(500) -- 支出范围
    ,inco_range varchar2(500) -- 收入范围
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
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
grant select on ${iml_schema}.evt_acct_approval_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_acct_approval_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_acct_approval_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_acct_approval_dtl is '账户核准件明细';
comment on column ${iml_schema}.evt_acct_approval_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_acct_approval_dtl.approval_id is '核准件编号';
comment on column ${iml_schema}.evt_acct_approval_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_acct_approval_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_acct_approval_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_acct_approval_dtl.open_dt is '开立日期';
comment on column ${iml_schema}.evt_acct_approval_dtl.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_acct_approval_dtl.approval_type_cd is '核准件类型代码';
comment on column ${iml_schema}.evt_acct_approval_dtl.approval_cap_use_usage is '核准件资金使用用途';
comment on column ${iml_schema}.evt_acct_approval_dtl.approval_cap_src is '核准件资金来源';
comment on column ${iml_schema}.evt_acct_approval_dtl.approval_open_amt is '核准件开立金额';
comment on column ${iml_schema}.evt_acct_approval_dtl.apprv_acct_imp_item is '核准账户要项';
comment on column ${iml_schema}.evt_acct_approval_dtl.acct_type_descb is '账户类型描述';
comment on column ${iml_schema}.evt_acct_approval_dtl.expns_range is '支出范围';
comment on column ${iml_schema}.evt_acct_approval_dtl.inco_range is '收入范围';
comment on column ${iml_schema}.evt_acct_approval_dtl.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_acct_approval_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_acct_approval_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_acct_approval_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_acct_approval_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_acct_approval_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_acct_approval_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_acct_approval_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_acct_approval_dtl.etl_timestamp is 'ETL处理时间戳';
