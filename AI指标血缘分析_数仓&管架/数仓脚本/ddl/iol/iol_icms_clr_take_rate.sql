/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_take_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_take_rate
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_take_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_take_rate(
    seqno varchar2(30) -- 流水号
    ,province varchar2(60) -- 省份
    ,city varchar2(60) -- 城市
    ,counties varchar2(60) -- 县、区
    ,deptcode varchar2(30) -- 所属分行
    ,barsign varchar2(9) -- 条线
    ,guartype varchar2(32) -- 押品类型
    ,procode varchar2(60) -- 产品编号
    ,replyno varchar2(60) -- 关联编号
    ,guarrate number(24,4) -- 抵质押率
    ,procodename varchar2(100) -- 产品名称
    ,reportinfo varchar2(4000) -- 描述
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_take_rate to ${iml_schema};
grant select on ${iol_schema}.icms_clr_take_rate to ${icl_schema};
grant select on ${iol_schema}.icms_clr_take_rate to ${idl_schema};
grant select on ${iol_schema}.icms_clr_take_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_take_rate is '突破抵质押率配置';
comment on column ${iol_schema}.icms_clr_take_rate.seqno is '流水号';
comment on column ${iol_schema}.icms_clr_take_rate.province is '省份';
comment on column ${iol_schema}.icms_clr_take_rate.city is '城市';
comment on column ${iol_schema}.icms_clr_take_rate.counties is '县、区';
comment on column ${iol_schema}.icms_clr_take_rate.deptcode is '所属分行';
comment on column ${iol_schema}.icms_clr_take_rate.barsign is '条线';
comment on column ${iol_schema}.icms_clr_take_rate.guartype is '押品类型';
comment on column ${iol_schema}.icms_clr_take_rate.procode is '产品编号';
comment on column ${iol_schema}.icms_clr_take_rate.replyno is '关联编号';
comment on column ${iol_schema}.icms_clr_take_rate.guarrate is '抵质押率';
comment on column ${iol_schema}.icms_clr_take_rate.procodename is '产品名称';
comment on column ${iol_schema}.icms_clr_take_rate.reportinfo is '描述';
comment on column ${iol_schema}.icms_clr_take_rate.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_take_rate.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_take_rate.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_take_rate.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_take_rate.etl_timestamp is 'ETL处理时间戳';
