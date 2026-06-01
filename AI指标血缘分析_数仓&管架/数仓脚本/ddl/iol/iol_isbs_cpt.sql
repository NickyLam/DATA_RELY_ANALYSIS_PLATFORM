/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cpt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cpt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cpt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cpt(
    inr varchar2(12) -- 唯一id
    ,fldmodblk varchar2(4000) -- 模块下修正过的字段
    ,narhis varchar2(4000) -- 历史附言
    ,contag72 varchar2(4000) -- 附言
    ,contag79 varchar2(4000) -- 79域
    ,contag70 varchar2(4000) -- 付款详情
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
grant select on ${iol_schema}.isbs_cpt to ${iml_schema};
grant select on ${iol_schema}.isbs_cpt to ${icl_schema};
grant select on ${iol_schema}.isbs_cpt to ${idl_schema};
grant select on ${iol_schema}.isbs_cpt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cpt is '汇款业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_cpt.inr is '唯一id';
comment on column ${iol_schema}.isbs_cpt.fldmodblk is '模块下修正过的字段';
comment on column ${iol_schema}.isbs_cpt.narhis is '历史附言';
comment on column ${iol_schema}.isbs_cpt.contag72 is '附言';
comment on column ${iol_schema}.isbs_cpt.contag79 is '79域';
comment on column ${iol_schema}.isbs_cpt.contag70 is '付款详情';
comment on column ${iol_schema}.isbs_cpt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cpt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cpt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cpt.etl_timestamp is 'ETL处理时间戳';
