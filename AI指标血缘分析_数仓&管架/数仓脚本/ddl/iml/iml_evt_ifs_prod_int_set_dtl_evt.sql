/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ifs_prod_int_set_dtl_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ifs_prod_int_set_dtl_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ifs_prod_int_set_dtl_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_prod_int_set_dtl_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(20) -- 交易时间
    ,tran_type_cd varchar2(10) -- 交易类型代码
    ,acct_id varchar2(60) -- 账户编号
    ,dep_sub_acct_id varchar2(60) -- 存款子户编号
    ,stl_pric number(30,2) -- 结算本金
    ,exec_int_rat number(18,8) -- 执行利率
    ,ths_tm_int number(30,2) -- 本次利息
    ,tran_proc_status_cd varchar2(10) -- 交易处理状态代码
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
grant select on ${iml_schema}.evt_ifs_prod_int_set_dtl_evt to ${icl_schema};
grant select on ${iml_schema}.evt_ifs_prod_int_set_dtl_evt to ${idl_schema};
grant select on ${iml_schema}.evt_ifs_prod_int_set_dtl_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ifs_prod_int_set_dtl_evt is '联合存款产品结息明细事件';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.acct_id is '账户编号';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.dep_sub_acct_id is '存款子户编号';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.stl_pric is '结算本金';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.exec_int_rat is '执行利率';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.ths_tm_int is '本次利息';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.tran_proc_status_cd is '交易处理状态代码';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ifs_prod_int_set_dtl_evt.etl_timestamp is 'ETL处理时间戳';
