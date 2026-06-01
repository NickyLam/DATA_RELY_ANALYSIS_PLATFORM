/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_commonatts_all
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_commonatts_all
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_commonatts_all purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_commonatts_all(
    commonatts_id number -- 交易对手分类ID
    ,aspclient_id number -- 部门ID
    ,singleormulti varchar2(2) -- 单一/多数
    ,commonatts_shortname varchar2(75) -- 发行人分类简称
    ,commonatts_desc varchar2(150) -- 发行人分类描述
    ,commonatts_id_parent number -- 发行人分类父节点
    ,type varchar2(15) -- 类型
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
grant select on ${iol_schema}.ctms_tbs_vs_commonatts_all to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_commonatts_all to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_commonatts_all to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_commonatts_all to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_commonatts_all is '发行人分类视图';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.commonatts_id is '交易对手分类ID';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.singleormulti is '单一/多数';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.commonatts_shortname is '发行人分类简称';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.commonatts_desc is '发行人分类描述';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.commonatts_id_parent is '发行人分类父节点';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.type is '类型';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_commonatts_all.etl_timestamp is 'ETL处理时间戳';
