/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_commonatts
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_commonatts
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_commonatts purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_commonatts(
    commonatts_id number -- 交易对手分类ID
    ,aspclient_id number -- 部门ID
    ,singleormulti varchar2(2) -- 单一/多数
    ,commonatts_shortname varchar2(75) -- 交易对手分类简称
    ,commonatts_desc varchar2(150) -- 交易对手分类描述
    ,commonatts_id_parent number -- 交易对手分类父节点
    ,lastmodified timestamp -- 最后修改时间
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
grant select on ${iol_schema}.ctms_tbs_vs_commonatts to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_commonatts to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_commonatts to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_commonatts to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_commonatts is '交易对手分类视图';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.commonatts_id is '交易对手分类ID';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.singleormulti is '单一/多数';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.commonatts_shortname is '交易对手分类简称';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.commonatts_desc is '交易对手分类描述';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.commonatts_id_parent is '交易对手分类父节点';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts.etl_timestamp is 'ETL处理时间戳';
