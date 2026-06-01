/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_guarantee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_guarantee
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_guarantee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_guarantee(
    security_code varchar2(24) -- 债券代码
    ,seq number -- 担保次序
    ,cid varchar2(96) -- 担保人id
    ,cname varchar2(384) -- 担保人中文名称
    ,parts number -- 担保份额
    ,modify_date date -- 修改时间
    ,i_or_g varchar2(2) -- 发行人/担保人
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
grant select on ${iol_schema}.ctms_tbs_v_security_guarantee to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_guarantee to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_guarantee to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_guarantee to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_guarantee is '担保人';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.seq is '担保次序';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.cid is '担保人id';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.cname is '担保人中文名称';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.parts is '担保份额';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.modify_date is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.i_or_g is '发行人/担保人';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security_guarantee.etl_timestamp is 'ETL处理时间戳';
