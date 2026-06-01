/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_fact_fin_zh_total_n001
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_fact_fin_zh_total_n001
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_fact_fin_zh_total_n001 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_fact_fin_zh_total_n001(
    data_dt date -- 数据日期
    ,branch_no varchar2(20) -- 查询机构号
    ,currency_code varchar2(40) -- 币种
    ,subject_type varchar2(10) -- 资产负债标志
    ,department varchar2(30) -- 归属部门
    ,fin_group varchar2(20) -- 资金组
    ,range_cd varchar2(100) -- 口径编号
    ,range_name varchar2(100) -- 口径名称
    ,cur_bal number(24,6) -- 余额
    ,accbal_month number(24,6) -- 月累计余额
    ,accbal_quar number(24,6) -- 季累计余额
    ,accbal_year number(24,6) -- 年累计余额
    ,final_ftp_accint_day number(24,6) -- 当天FTP收支
    ,final_ftp_accint_month number(24,6) -- 月累计FTP收支
    ,final_ftp_accint_quar number(24,6) -- 季累计FTP收支
    ,final_ftp_accint_year number(24,6) -- 年累计FTP收支
    ,accint_day number(24,6) -- 当天外部利息
    ,accint_month number(24,6) -- 月累计外部利息
    ,accint_quar number(24,6) -- 季累计外部利息
    ,accint_year number(24,6) -- 年累计外部利息
    ,avgbal_month number(24,6) -- 月日均余额
    ,avgbal_year number(24,6) -- 年日均余额
    ,t_days number(5) -- 当年天数
    ,subject_code varchar2(40) -- 科目号
    ,tp_fund varchar2(10) -- 定价类型
    ,tp_ftp varchar2(10) -- 余额类型（ACTUAL-实际，VIRTUAL-虚拟）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ftps_fact_fin_zh_total_n001 to ${iml_schema};
grant select on ${iol_schema}.ftps_fact_fin_zh_total_n001 to ${icl_schema};
grant select on ${iol_schema}.ftps_fact_fin_zh_total_n001 to ${idl_schema};
grant select on ${iol_schema}.ftps_fact_fin_zh_total_n001 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_fact_fin_zh_total_n001 is '票据业务部FTP收支汇总表';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.data_dt is '数据日期';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.branch_no is '查询机构号';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.currency_code is '币种';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.subject_type is '资产负债标志';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.department is '归属部门';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.fin_group is '资金组';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.range_cd is '口径编号';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.range_name is '口径名称';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.cur_bal is '余额';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accbal_month is '月累计余额';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accbal_quar is '季累计余额';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accbal_year is '年累计余额';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.final_ftp_accint_day is '当天FTP收支';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.final_ftp_accint_month is '月累计FTP收支';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.final_ftp_accint_quar is '季累计FTP收支';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.final_ftp_accint_year is '年累计FTP收支';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accint_day is '当天外部利息';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accint_month is '月累计外部利息';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accint_quar is '季累计外部利息';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.accint_year is '年累计外部利息';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.avgbal_month is '月日均余额';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.avgbal_year is '年日均余额';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.t_days is '当年天数';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.subject_code is '科目号';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.tp_fund is '定价类型';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.tp_ftp is '余额类型（ACTUAL-实际，VIRTUAL-虚拟）';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_fact_fin_zh_total_n001.etl_timestamp is 'ETL处理时间戳';
