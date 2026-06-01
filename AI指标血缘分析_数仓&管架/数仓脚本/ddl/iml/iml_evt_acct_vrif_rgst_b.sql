/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_acct_vrif_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_acct_vrif_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_acct_vrif_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acct_vrif_rgst_b(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_vrif_status_cd varchar2(30) -- 账户核实状态代码
    ,disp_way_cd varchar2(30) -- 处置方式代码
    ,vrif_dt date -- 核实日期
    ,check_fail_descb varchar2(500) -- 验证失败描述
    ,oper_teller_id varchar2(100) -- 操作柜员编号
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
grant select on ${iml_schema}.evt_acct_vrif_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_acct_vrif_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_acct_vrif_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_acct_vrif_rgst_b is '账户核实登记簿';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.agt_id is '协议编号';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.acct_vrif_status_cd is '账户核实状态代码';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.disp_way_cd is '处置方式代码';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.vrif_dt is '核实日期';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.check_fail_descb is '验证失败描述';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_acct_vrif_rgst_b.etl_timestamp is 'ETL处理时间戳';
