/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_rightcert_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_rightcert_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_rightcert_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_rightcert_relative(
    clrid varchar2(32) -- 押品编号
    ,rightcertid varchar2(64) -- 权证编号
    ,ismaincert varchar2(2) -- 是否主权证
    ,relativebusinesstype varchar2(64) -- 关联业务类型
    ,relativebusinessno varchar2(64) -- 关联业务编号
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
grant select on ${iol_schema}.icms_clr_rightcert_relative to ${iml_schema};
grant select on ${iol_schema}.icms_clr_rightcert_relative to ${icl_schema};
grant select on ${iol_schema}.icms_clr_rightcert_relative to ${idl_schema};
grant select on ${iol_schema}.icms_clr_rightcert_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_rightcert_relative is '押品权证关联关系表';
comment on column ${iol_schema}.icms_clr_rightcert_relative.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_rightcert_relative.rightcertid is '权证编号';
comment on column ${iol_schema}.icms_clr_rightcert_relative.ismaincert is '是否主权证';
comment on column ${iol_schema}.icms_clr_rightcert_relative.relativebusinesstype is '关联业务类型';
comment on column ${iol_schema}.icms_clr_rightcert_relative.relativebusinessno is '关联业务编号';
comment on column ${iol_schema}.icms_clr_rightcert_relative.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_rightcert_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_rightcert_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_rightcert_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_rightcert_relative.etl_timestamp is 'ETL处理时间戳';
