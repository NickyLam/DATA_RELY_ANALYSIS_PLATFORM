/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_salary_plat_payoff_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_salary_plat_payoff_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_salary_plat_payoff_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_salary_plat_payoff_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,dtl_id varchar2(250) -- 明细编号
    ,batch_id varchar2(250) -- 批次编号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,cntpty_acct_id varchar2(250) -- 对手账户编号
    ,tran_amt number(30,2) -- 交易金额
    ,over_lmt_amt_lmt number(30,2) -- 超限金额
    ,remark varchar2(2000) -- 备注
    ,emply_id varchar2(250) -- 员工编号
    ,emply_name varchar2(2000) -- 员工姓名
    ,emply_tel varchar2(100) -- 员工电话
    ,staf_cd_piece_no_code varchar2(250) -- 员工证件号码
    ,corp_id varchar2(250) -- 企业编号
    ,corp_name varchar2(1000) -- 企业名称
    ,batch_create_dt date -- 批次创建日期
    ,batch_update_dt date -- 批次更新日期
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
grant select on ${iml_schema}.evt_salary_plat_payoff_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_salary_plat_payoff_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_salary_plat_payoff_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_salary_plat_payoff_dtl is '薪酬平台代发明细';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.dtl_id is '明细编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.batch_id is '批次编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.cntpty_acct_id is '对手账户编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.over_lmt_amt_lmt is '超限金额';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.remark is '备注';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.emply_id is '员工编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.emply_name is '员工姓名';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.emply_tel is '员工电话';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.staf_cd_piece_no_code is '员工证件号码';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.corp_id is '企业编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.corp_name is '企业名称';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.batch_create_dt is '批次创建日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.batch_update_dt is '批次更新日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_salary_plat_payoff_dtl.etl_timestamp is 'ETL处理时间戳';
