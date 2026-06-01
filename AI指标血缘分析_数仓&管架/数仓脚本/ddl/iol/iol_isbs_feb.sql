/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_feb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_feb
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_feb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_feb(
    actiondesc varchar2(198) -- 
    ,credit number(22,3) -- 
    ,deal_date date -- 
    ,balance number(22,3) -- 
    ,branch_code varchar2(18) -- 
    ,currency_code varchar2(5) -- 
    ,ver varchar2(6) -- 
    ,remark varchar2(390) -- 
    ,actiontype varchar2(2) -- 
    ,accountno varchar2(96) -- 
    ,feb_type varchar2(12) -- 
    ,debit number(22,3) -- 
    ,inr varchar2(12) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_feb to ${iml_schema};
grant select on ${iol_schema}.isbs_feb to ${icl_schema};
grant select on ${iol_schema}.isbs_feb to ${idl_schema};
grant select on ${iol_schema}.isbs_feb to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_feb is '外汇账户收支余信息';
comment on column ${iol_schema}.isbs_feb.actiondesc is '';
comment on column ${iol_schema}.isbs_feb.credit is '';
comment on column ${iol_schema}.isbs_feb.deal_date is '';
comment on column ${iol_schema}.isbs_feb.balance is '';
comment on column ${iol_schema}.isbs_feb.branch_code is '';
comment on column ${iol_schema}.isbs_feb.currency_code is '';
comment on column ${iol_schema}.isbs_feb.ver is '';
comment on column ${iol_schema}.isbs_feb.remark is '';
comment on column ${iol_schema}.isbs_feb.actiontype is '';
comment on column ${iol_schema}.isbs_feb.accountno is '';
comment on column ${iol_schema}.isbs_feb.feb_type is '';
comment on column ${iol_schema}.isbs_feb.debit is '';
comment on column ${iol_schema}.isbs_feb.inr is '';
comment on column ${iol_schema}.isbs_feb.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_feb.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_feb.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_feb.etl_timestamp is 'ETL处理时间戳';
