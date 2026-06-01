/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_ghc0009t
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_ghc0009t
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_ghc0009t purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_ghc0009t(
    sccode varchar2(48) -- 
    ,hostdate varchar2(15) -- 
    ,hostnbr varchar2(30) -- 
    ,tranam number(18,2) -- 
    ,flag varchar2(2) -- 
    ,backdate varchar2(15) -- 
    ,backnbr varchar2(30) -- 
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
grant select on ${iol_schema}.mims_yp_ghc0009t to ${iml_schema};
grant select on ${iol_schema}.mims_yp_ghc0009t to ${icl_schema};
grant select on ${iol_schema}.mims_yp_ghc0009t to ${idl_schema};
grant select on ${iol_schema}.mims_yp_ghc0009t to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_ghc0009t is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.sccode is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.hostdate is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.hostnbr is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.tranam is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.flag is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.backdate is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.backnbr is '';
comment on column ${iol_schema}.mims_yp_ghc0009t.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_ghc0009t.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_ghc0009t.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_ghc0009t.etl_timestamp is 'ETL处理时间戳';
