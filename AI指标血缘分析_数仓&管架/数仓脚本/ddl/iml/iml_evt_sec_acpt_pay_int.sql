/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_sec_acpt_pay_int
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_sec_acpt_pay_int
whenever sqlerror continue none;
drop table ${iml_schema}.evt_sec_acpt_pay_int purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sec_acpt_pay_int(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_evt_id varchar2(60) -- 源事件编号
    ,quote_table_name varchar2(150) -- 引用表名称
    ,dept_id varchar2(60) -- 部门编号
    ,quote_tab_2_id varchar2(90) -- 引用表2ID
    ,rpp_int_dt date -- 还本付息日期
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,asset_cate_name varchar2(150) -- 资产类别名称
    ,bond_cd varchar2(20) -- 债券代码
    ,pric_int_type_cd varchar2(10) -- 本息类型代码
    ,rpp_amt number(30,2) -- 还本金额
    ,pay_int_amt number(30,2) -- 付息金额
    ,init_tran_id varchar2(60) -- 原始交易编号
    ,actl_pay_dt date -- 实际支付日期
    ,actl_rp_cfm_tm timestamp -- 实收付确认时间
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
grant select on ${iml_schema}.evt_sec_acpt_pay_int to ${icl_schema};
grant select on ${iml_schema}.evt_sec_acpt_pay_int to ${idl_schema};
grant select on ${iml_schema}.evt_sec_acpt_pay_int to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_sec_acpt_pay_int is '现券收付息';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.evt_id is '事件编号';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.lp_id is '法人编号';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.src_evt_id is '源事件编号';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.quote_table_name is '引用表名称';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.dept_id is '部门编号';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.quote_tab_2_id is '引用表2ID';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.rpp_int_dt is '还本付息日期';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.acct_id is '账户编号';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.acct_name is '账户名称';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.asset_cate_name is '资产类别名称';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.bond_cd is '债券代码';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.pric_int_type_cd is '本息类型代码';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.rpp_amt is '还本金额';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.pay_int_amt is '付息金额';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.init_tran_id is '原始交易编号';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.actl_pay_dt is '实际支付日期';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.actl_rp_cfm_tm is '实收付确认时间';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.job_cd is '任务编码';
comment on column ${iml_schema}.evt_sec_acpt_pay_int.etl_timestamp is 'ETL处理时间戳';
