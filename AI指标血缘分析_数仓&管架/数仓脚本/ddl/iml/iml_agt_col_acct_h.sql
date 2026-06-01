/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_col_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_col_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_col_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,org_id varchar2(100) -- 机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_seq_num varchar2(60) -- 交易序号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,col_id varchar2(100) -- 押品编号
    ,col_type_cd varchar2(30) -- 押品类型代码
    ,acpt_pay_idf_cd varchar2(30) -- 收付标识代码
    ,col_rgst_b_type_cd varchar2(30) -- 押品登记簿类型代码
    ,col_amt number(30,2) -- 押品金额
    ,remark varchar2(500) -- 备注
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,prod_id varchar2(60) -- 产品编号
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
grant select on ${iml_schema}.agt_col_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_col_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_col_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_col_acct_h is '押品账户历史';
comment on column ${iml_schema}.agt_col_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_col_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_col_acct_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_col_acct_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_col_acct_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_col_acct_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_col_acct_h.tran_seq_num is '交易序号';
comment on column ${iml_schema}.agt_col_acct_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_col_acct_h.col_id is '押品编号';
comment on column ${iml_schema}.agt_col_acct_h.col_type_cd is '押品类型代码';
comment on column ${iml_schema}.agt_col_acct_h.acpt_pay_idf_cd is '收付标识代码';
comment on column ${iml_schema}.agt_col_acct_h.col_rgst_b_type_cd is '押品登记簿类型代码';
comment on column ${iml_schema}.agt_col_acct_h.col_amt is '押品金额';
comment on column ${iml_schema}.agt_col_acct_h.remark is '备注';
comment on column ${iml_schema}.agt_col_acct_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_col_acct_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_col_acct_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_col_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_col_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_col_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_col_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_col_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_col_acct_h.etl_timestamp is 'ETL处理时间戳';
