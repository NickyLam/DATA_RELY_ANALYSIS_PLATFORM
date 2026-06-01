/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_gct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_gct
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_gct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gct(
    inr varchar2(12) -- 进口信用证id号
    ,ver varchar2(6) -- 版本号
    ,fldmodblk varchar2(4000) -- 修改信息
    ,contag72 varchar2(4000) -- 报文72场内容
    ,contag79 varchar2(4000) -- 报文79场内容
    ,clmtxt varchar2(3075) -- 
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
grant select on ${iol_schema}.isbs_gct to ${iml_schema};
grant select on ${iol_schema}.isbs_gct to ${icl_schema};
grant select on ${iol_schema}.isbs_gct to ${idl_schema};
grant select on ${iol_schema}.isbs_gct to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_gct is '保函下索赔业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_gct.inr is '进口信用证id号';
comment on column ${iol_schema}.isbs_gct.ver is '版本号';
comment on column ${iol_schema}.isbs_gct.fldmodblk is '修改信息';
comment on column ${iol_schema}.isbs_gct.contag72 is '报文72场内容';
comment on column ${iol_schema}.isbs_gct.contag79 is '报文79场内容';
comment on column ${iol_schema}.isbs_gct.clmtxt is '';
comment on column ${iol_schema}.isbs_gct.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_gct.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_gct.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_gct.etl_timestamp is 'ETL处理时间戳';
