/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_putout_state
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_putout_state
whenever sqlerror continue none;
drop table ${iol_schema}.icms_putout_state purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_putout_state(
    serialno varchar2(50) -- 流水号
    ,status varchar2(10) -- 复核放款状态
    ,contractserialno varchar2(32) -- 合同号
    ,duebillserialno varchar2(40) -- 借据号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
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
grant select on ${iol_schema}.icms_putout_state to ${iml_schema};
grant select on ${iol_schema}.icms_putout_state to ${icl_schema};
grant select on ${iol_schema}.icms_putout_state to ${idl_schema};
grant select on ${iol_schema}.icms_putout_state to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_putout_state is '线上放款出账状态';
comment on column ${iol_schema}.icms_putout_state.serialno is '流水号';
comment on column ${iol_schema}.icms_putout_state.status is '复核放款状态';
comment on column ${iol_schema}.icms_putout_state.contractserialno is '合同号';
comment on column ${iol_schema}.icms_putout_state.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_putout_state.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_putout_state.start_dt is '开始时间';
comment on column ${iol_schema}.icms_putout_state.end_dt is '结束时间';
comment on column ${iol_schema}.icms_putout_state.id_mark is '增删标志';
comment on column ${iol_schema}.icms_putout_state.etl_timestamp is 'ETL处理时间戳';
