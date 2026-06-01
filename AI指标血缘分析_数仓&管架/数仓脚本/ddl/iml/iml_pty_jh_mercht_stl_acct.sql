/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_jh_mercht_stl_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_jh_mercht_stl_acct
whenever sqlerror continue none;
drop table ${iml_schema}.pty_jh_mercht_stl_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_jh_mercht_stl_acct(
    mercht_id varchar2(60) -- 商户编号
    ,lp_id varchar2(60) -- 法人编号
    ,agency_id varchar2(60) -- 代理商编号
    ,clear_way_cd varchar2(30) -- 清算方式代码
    ,clear_ped_cd varchar2(30) -- 清算周期代码
    ,open_bank_no varchar2(60) -- 开户行行号
    ,open_bank_name varchar2(750) -- 开户行名称
    ,acct_name varchar2(750) -- 账户名称
    ,acct_id varchar2(60) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,open_acct_acct_addr varchar2(1500) -- 开户账户地址
    ,t1_fee_rat number(30,8) -- T1费率
    ,d0_fee_rat number(30,8) -- D0费率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_jh_mercht_stl_acct to ${icl_schema};
grant select on ${iml_schema}.pty_jh_mercht_stl_acct to ${idl_schema};
grant select on ${iml_schema}.pty_jh_mercht_stl_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_jh_mercht_stl_acct is '聚合商户结算账户';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.mercht_id is '商户编号';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.lp_id is '法人编号';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.agency_id is '代理商编号';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.clear_way_cd is '清算方式代码';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.clear_ped_cd is '清算周期代码';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.open_bank_no is '开户行行号';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.open_bank_name is '开户行名称';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.acct_name is '账户名称';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.acct_id is '账户编号';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.open_acct_acct_addr is '开户账户地址';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.t1_fee_rat is 'T1费率';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.d0_fee_rat is 'D0费率';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.start_dt is '开始时间';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.end_dt is '结束时间';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.id_mark is '增删标志';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.job_cd is '任务编码';
comment on column ${iml_schema}.pty_jh_mercht_stl_acct.etl_timestamp is 'ETL处理时间戳';
