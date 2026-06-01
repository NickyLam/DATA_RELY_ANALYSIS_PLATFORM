/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_lp_od_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_lp_od_acct_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_lp_od_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_lp_od_acct_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,agt_id varchar2(250) -- 协议编号
    ,loan_num varchar2(60) -- 贷款号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,tran_dt date -- 交易日期
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,tran_amt number(30,2) -- 交易金额
    ,actl_tran_amt number(30,2) -- 实际交易金额
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,tran_tm timestamp -- 交易时间
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,dubil_id varchar2(100) -- 借据编号
    ,remark varchar2(1000) -- 备注
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
grant select on ${iml_schema}.evt_lp_od_acct_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_lp_od_acct_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_lp_od_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_lp_od_acct_tran_dtl is '法透账户交易明细';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.loan_num is '贷款号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.actl_tran_amt is '实际交易金额';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.remark is '备注';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_lp_od_acct_tran_dtl.etl_timestamp is 'ETL处理时间戳';
