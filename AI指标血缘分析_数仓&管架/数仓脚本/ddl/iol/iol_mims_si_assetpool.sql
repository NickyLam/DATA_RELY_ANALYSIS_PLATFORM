/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_assetpool
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_assetpool
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_assetpool purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_assetpool(
    sccode varchar2(48) -- 
    ,poolcode varchar2(48) -- 
    ,poolaccount varchar2(300) -- 
    ,poolamount number(22) -- 
    ,poolmoney number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,money number(20,2) -- 
    ,tdcurrency varchar2(5) -- 
    ,islimit varchar2(3) -- 是否占用集团额度
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
grant select on ${iol_schema}.mims_si_assetpool to ${iml_schema};
grant select on ${iol_schema}.mims_si_assetpool to ${icl_schema};
grant select on ${iol_schema}.mims_si_assetpool to ${idl_schema};
grant select on ${iol_schema}.mims_si_assetpool to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_assetpool is '资产池';
comment on column ${iol_schema}.mims_si_assetpool.sccode is '';
comment on column ${iol_schema}.mims_si_assetpool.poolcode is '';
comment on column ${iol_schema}.mims_si_assetpool.poolaccount is '';
comment on column ${iol_schema}.mims_si_assetpool.poolamount is '';
comment on column ${iol_schema}.mims_si_assetpool.poolmoney is '';
comment on column ${iol_schema}.mims_si_assetpool.remark is '';
comment on column ${iol_schema}.mims_si_assetpool.money is '';
comment on column ${iol_schema}.mims_si_assetpool.tdcurrency is '';
comment on column ${iol_schema}.mims_si_assetpool.islimit is '是否占用集团额度';
comment on column ${iol_schema}.mims_si_assetpool.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_assetpool.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_assetpool.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_assetpool.etl_timestamp is 'ETL处理时间戳';
