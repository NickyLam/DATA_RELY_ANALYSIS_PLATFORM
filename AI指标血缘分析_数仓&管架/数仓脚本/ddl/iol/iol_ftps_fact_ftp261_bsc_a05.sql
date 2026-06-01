/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_fact_ftp261_bsc_a05
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_fact_ftp261_bsc_a05
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_fact_ftp261_bsc_a05 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_fact_ftp261_bsc_a05(
    data_dt date -- 数据日期
    ,org_type_cd varchar2(1) -- 机构类型代码（核算/考核）
    ,org_unit_id varchar2(20) -- 机构代码
    ,iso_currency_cd varchar2(10) -- 币种编码（含折币）
    ,subject_cd varchar2(20) -- 科目代码
    ,subject_level number -- 科目汇总层级
    ,unit_id varchar2(2) -- 货币单位代码
    ,id_ varchar2(30) -- 机构时间戳关联字段
    ,t_days number -- 本年总天数
    ,cur_bal number(24,6) -- 当前余额
    ,avg_bal number(24,6) -- 日均余额
    ,acc_bal number(24,6) -- 累计余额
    ,acc_int number(24,6) -- 利息收支累计
    ,exercise_interest_rate_x number(24,6) -- 执行利率加权乘积
    ,base_ftp_rate_x number(24,6) -- 原始ftp利率加权乘积
    ,mid_ftp_rate_x number(24,6) -- 内生性调节后ftp利率加权乘积
    ,final_ftp_rate_x number(24,6) -- 最终ftp利率加权乘积
    ,base_ftp_accint number(24,6) -- 原始ftp利息累计
    ,mid_ftp_accint number(24,6) -- 内生性调节后ftp利息累计
    ,final_ftp_accint number(24,6) -- 最终ftp利息累计
    ,base_ftp_accprofit number(24,6) -- 原始ftp利润累计
    ,mid_ftp_accprofit number(24,6) -- 内生性调节后ftp利润累计
    ,final_ftp_accprofit number(24,6) -- 最终ftp利润累计
    ,adjust_inner_accint number(24,6) -- 内生性调节项金额累计
    ,adjust_policy_accint number(24,6) -- 政策性调节项金额累计
    ,adjust_01_accint number(24,6) -- 调节项1金额累计
    ,adjust_02_accint number(24,6) -- 调节项2金额累计
    ,adjust_03_accint number(24,6) -- 调节项3金额累计
    ,adjust_04_accint number(24,6) -- 调节项4金额累计
    ,adjust_05_accint number(24,6) -- 调节项5金额累计
    ,adjust_06_accint number(24,6) -- 调节项6金额累计
    ,adjust_07_accint number(24,6) -- 调节项7金额累计
    ,adjust_08_accint number(24,6) -- 调节项8金额累计
    ,adjust_09_accint number(24,6) -- 调节项9金额累计
    ,adjust_10_accint number(24,6) -- 调节项10金额累计
    ,adjust_11_accint number(24,6) -- 调节项11金额累计
    ,adjust_12_accint number(24,6) -- 调节项12金额累计
    ,adjust_13_accint number(24,6) -- 调节项13金额累计
    ,adjust_14_accint number(24,6) -- 调节项14金额累计
    ,adjust_15_accint number(24,6) -- 调节项15金额累计
    ,adjust_16_accint number(24,6) -- 调节项16金额累计
    ,adjust_17_accint number(24,6) -- 调节项17金额累计
    ,adjust_18_accint number(24,6) -- 调节项18金额累计
    ,adjust_19_accint number(24,6) -- 调节项19金额累计
    ,adjust_20_accint number(24,6) -- 调节项20金额累计
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
grant select on ${iol_schema}.ftps_fact_ftp261_bsc_a05 to ${iml_schema};
grant select on ${iol_schema}.ftps_fact_ftp261_bsc_a05 to ${icl_schema};
grant select on ${iol_schema}.ftps_fact_ftp261_bsc_a05 to ${idl_schema};
grant select on ${iol_schema}.ftps_fact_ftp261_bsc_a05 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_fact_ftp261_bsc_a05 is 'A05_科目FTP利润分析事实表';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.data_dt is '数据日期';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.org_type_cd is '机构类型代码（核算/考核）';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.org_unit_id is '机构代码';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.iso_currency_cd is '币种编码（含折币）';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.subject_cd is '科目代码';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.subject_level is '科目汇总层级';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.unit_id is '货币单位代码';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.id_ is '机构时间戳关联字段';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.t_days is '本年总天数';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.cur_bal is '当前余额';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.avg_bal is '日均余额';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.acc_bal is '累计余额';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.acc_int is '利息收支累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.exercise_interest_rate_x is '执行利率加权乘积';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.base_ftp_rate_x is '原始ftp利率加权乘积';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.mid_ftp_rate_x is '内生性调节后ftp利率加权乘积';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.final_ftp_rate_x is '最终ftp利率加权乘积';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.base_ftp_accint is '原始ftp利息累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.mid_ftp_accint is '内生性调节后ftp利息累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.final_ftp_accint is '最终ftp利息累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.base_ftp_accprofit is '原始ftp利润累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.mid_ftp_accprofit is '内生性调节后ftp利润累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.final_ftp_accprofit is '最终ftp利润累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_inner_accint is '内生性调节项金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_policy_accint is '政策性调节项金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_01_accint is '调节项1金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_02_accint is '调节项2金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_03_accint is '调节项3金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_04_accint is '调节项4金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_05_accint is '调节项5金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_06_accint is '调节项6金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_07_accint is '调节项7金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_08_accint is '调节项8金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_09_accint is '调节项9金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_10_accint is '调节项10金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_11_accint is '调节项11金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_12_accint is '调节项12金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_13_accint is '调节项13金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_14_accint is '调节项14金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_15_accint is '调节项15金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_16_accint is '调节项16金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_17_accint is '调节项17金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_18_accint is '调节项18金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_19_accint is '调节项19金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.adjust_20_accint is '调节项20金额累计';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_fact_ftp261_bsc_a05.etl_timestamp is 'ETL处理时间戳';
