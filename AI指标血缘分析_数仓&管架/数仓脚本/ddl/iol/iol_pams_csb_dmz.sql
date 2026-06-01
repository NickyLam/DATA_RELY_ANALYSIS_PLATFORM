/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_dmz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_dmz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_dmz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_dmz(
    mzbh varchar2(23) -- 码值编号
    ,mzmc varchar2(300) -- 
    ,dmms varchar2(300) -- 代码描述
    ,dmz varchar2(45) -- 代码值
    ,dmzms varchar2(750) -- 代码值描述
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
grant select on ${iol_schema}.pams_csb_dmz to ${iml_schema};
grant select on ${iol_schema}.pams_csb_dmz to ${icl_schema};
grant select on ${iol_schema}.pams_csb_dmz to ${idl_schema};
grant select on ${iol_schema}.pams_csb_dmz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_dmz is '参数表-代码值';
comment on column ${iol_schema}.pams_csb_dmz.mzbh is '码值编号';
comment on column ${iol_schema}.pams_csb_dmz.mzmc is '';
comment on column ${iol_schema}.pams_csb_dmz.dmms is '代码描述';
comment on column ${iol_schema}.pams_csb_dmz.dmz is '代码值';
comment on column ${iol_schema}.pams_csb_dmz.dmzms is '代码值描述';
comment on column ${iol_schema}.pams_csb_dmz.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_dmz.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_dmz.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_dmz.etl_timestamp is 'ETL处理时间戳';
