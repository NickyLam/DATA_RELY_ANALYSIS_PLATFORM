/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cbec_acct_stl_tot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cbec_acct_stl_tot
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cbec_acct_stl_tot purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cbec_acct_stl_tot(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,tot_mon varchar2(100) -- 汇总月份
    ,acm_abmt number(30,2) -- 累计汇入
    ,acm_remit_out number(30,2) -- 累计汇出
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
grant select on ${iml_schema}.evt_cbec_acct_stl_tot to ${icl_schema};
grant select on ${iml_schema}.evt_cbec_acct_stl_tot to ${idl_schema};
grant select on ${iml_schema}.evt_cbec_acct_stl_tot to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cbec_acct_stl_tot is '跨境电商账户结算汇总';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.acct_id is '账户编号';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.cust_id is '客户编号';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.tot_mon is '汇总月份';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.acm_abmt is '累计汇入';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.acm_remit_out is '累计汇出';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cbec_acct_stl_tot.etl_timestamp is 'ETL处理时间戳';
