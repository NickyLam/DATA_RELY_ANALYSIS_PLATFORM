/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dms_elec_chn_active_acct_chg_rat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dms_elec_chn_active_acct_chg_rat
whenever sqlerror continue none;
drop table ${idl_schema}.dms_elec_chn_active_acct_chg_rat purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dms_elec_chn_active_acct_chg_rat(
    etl_dt date -- 数据日期
    ,chn_type varchar2(10) -- 渠道类型
    ,chn_id number(10) -- 渠道编号
    ,chn_tran_qtty number(22) -- 渠道交易量
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dms_elec_chn_active_acct_chg_rat to ${iel_schema};

-- comment
comment on table ${idl_schema}.dms_elec_chn_active_acct_chg_rat is '主要电子渠道活跃用户账户变化率';
comment on column ${idl_schema}.dms_elec_chn_active_acct_chg_rat.etl_dt is '数据日期';
comment on column ${idl_schema}.dms_elec_chn_active_acct_chg_rat.chn_type is '渠道类型';
comment on column ${idl_schema}.dms_elec_chn_active_acct_chg_rat.chn_id is '渠道编号';
comment on column ${idl_schema}.dms_elec_chn_active_acct_chg_rat.chn_tran_qtty is '渠道交易量';
comment on column ${idl_schema}.dms_elec_chn_active_acct_chg_rat.etl_timestamp is 'ETL处理时间戳';