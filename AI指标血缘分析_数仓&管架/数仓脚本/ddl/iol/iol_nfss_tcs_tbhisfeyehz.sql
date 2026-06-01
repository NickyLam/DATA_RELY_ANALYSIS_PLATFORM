/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbhisfeyehz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbhisfeyehz
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbhisfeyehz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbhisfeyehz(
    sum_date number(38,0) -- 汇总日期
    ,sum_flag varchar2(2) -- 汇总方式,0-按交易机构，1-按开户机构
    ,internal_branch varchar2(18) -- 机构内码
    ,client_type varchar2(2) -- 客户类型,1-个人客户，0-对公客户
    ,prd_code varchar2(30) -- 产品代码
    ,branch_no varchar2(24) -- 机构代码
    ,ta_code varchar2(14) -- TA代码
    ,tot_vol number(18,3) -- 份额总数
    ,long_frozen_vol number(18,3) -- 长期冻结份额
    ,nav number(18,8) -- 产品净值
    ,client_num number(38,0) -- 有效户数
    ,prd_type varchar2(2) -- 产品类别,0-基金，1-理财
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
grant select on ${iol_schema}.nfss_tcs_tbhisfeyehz to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbhisfeyehz to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhisfeyehz to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhisfeyehz to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbhisfeyehz is '份额余额汇总表';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.sum_date is '汇总日期';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.sum_flag is '汇总方式,0-按交易机构，1-按开户机构';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.internal_branch is '机构内码';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.client_type is '客户类型,1-个人客户，0-对公客户';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.branch_no is '机构代码';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.ta_code is 'TA代码';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.tot_vol is '份额总数';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.long_frozen_vol is '长期冻结份额';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.nav is '产品净值';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.client_num is '有效户数';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.prd_type is '产品类别,0-基金，1-理财';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_tcs_tbhisfeyehz.etl_timestamp is 'ETL处理时间戳';
