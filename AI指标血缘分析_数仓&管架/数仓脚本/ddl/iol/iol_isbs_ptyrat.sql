/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ptyrat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ptyrat
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ptyrat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ptyrat(
    cur varchar2(5) -- 
    ,buyrat number(5,2) -- 
    ,seltyp varchar2(2) -- 
    ,begdat date -- 
    ,inr varchar2(12) -- 
    ,ptyinr varchar2(12) -- 
    ,selrat number(5,2) -- 
    ,buytyp varchar2(2) -- 
    ,enddat date -- 
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
grant select on ${iol_schema}.isbs_ptyrat to ${iml_schema};
grant select on ${iol_schema}.isbs_ptyrat to ${icl_schema};
grant select on ${iol_schema}.isbs_ptyrat to ${idl_schema};
grant select on ${iol_schema}.isbs_ptyrat to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ptyrat is '结售汇优惠信息表';
comment on column ${iol_schema}.isbs_ptyrat.cur is '';
comment on column ${iol_schema}.isbs_ptyrat.buyrat is '';
comment on column ${iol_schema}.isbs_ptyrat.seltyp is '';
comment on column ${iol_schema}.isbs_ptyrat.begdat is '';
comment on column ${iol_schema}.isbs_ptyrat.inr is '';
comment on column ${iol_schema}.isbs_ptyrat.ptyinr is '';
comment on column ${iol_schema}.isbs_ptyrat.selrat is '';
comment on column ${iol_schema}.isbs_ptyrat.buytyp is '';
comment on column ${iol_schema}.isbs_ptyrat.enddat is '';
comment on column ${iol_schema}.isbs_ptyrat.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ptyrat.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ptyrat.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ptyrat.etl_timestamp is 'ETL处理时间戳';
