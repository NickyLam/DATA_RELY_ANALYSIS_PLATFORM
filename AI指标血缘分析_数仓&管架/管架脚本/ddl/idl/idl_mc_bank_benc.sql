/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_bank_benc
CreateDate: 20180515
FileType:   DDL
Logs:
    gj 2020-08-20 新建表本
*/

prompt creating table ${idl_schema}.mc_bank_benc
whenever sqlerror continue none;
drop table ${idl_schema}.mc_bank_benc purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_bank_benc(
     etl_dt         DATE              -- etl数据日期
    ,wind_code      VARCHAR2(10)      -- 万德ID
    ,org_no         VARCHAR2(60)      -- 机构编码
    ,org_name       VARCHAR2(200)     -- 机构名称
    ,curr_no        VARCHAR2(200)     -- 币种编号
    ,curr_name      VARCHAR2(200)     -- 币种
    ,bank_name      VARCHAR2(200)     -- 银行名称
    ,assets_total   NUMBER(38,8)      -- 资产总额
    ,deposits       NUMBER(38,8)      -- 存款总额
    ,lending_total  NUMBER(38,8)      -- 贷款总额
    ,net_profits    NUMBER(38,8)      -- 净利润
    ,roaa           NUMBER(38,8)      -- ROAA
    ,roae           NUMBER(38,8)      -- ROAE
    ,defect_rate    NUMBER(38,8)      -- 不良率
    ,frequency      VARCHAR2(4)       -- 频度
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
-- comment
comment on table  ${idl_schema}.mc_bank_benc                  is '同业结果表';
comment on column ${idl_schema}.mc_bank_benc.etl_dt           is 'etl数据日期';
comment on column ${idl_schema}.mc_bank_benc.wind_code        is '万德ID';
comment on column ${idl_schema}.mc_bank_benc.org_no           is '机构编码';
comment on column ${idl_schema}.mc_bank_benc.org_name         is '机构名称';
comment on column ${idl_schema}.mc_bank_benc.curr_no       	  is '币种编号';
comment on column ${idl_schema}.mc_bank_benc.curr_name        is '币种';
comment on column ${idl_schema}.mc_bank_benc.bank_name        is '银行名称';
comment on column ${idl_schema}.mc_bank_benc.assets_total     is '资产总额';
comment on column ${idl_schema}.mc_bank_benc.deposits         is '存款总额';
comment on column ${idl_schema}.mc_bank_benc.lending_total    is '贷款总额';
comment on column ${idl_schema}.mc_bank_benc.net_profits      is '净利润';
comment on column ${idl_schema}.mc_bank_benc.roaa             is 'ROAA';
comment on column ${idl_schema}.mc_bank_benc.roae             is 'ROAE';
comment on column ${idl_schema}.mc_bank_benc.defect_rate      is '不良率';
comment on column ${idl_schema}.mc_bank_benc.frequency        is '频度';


