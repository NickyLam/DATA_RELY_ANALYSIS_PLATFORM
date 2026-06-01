/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_rating
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_rating(
    security_code varchar2(24) -- 债券代码
    ,firm_id varchar2(24) -- 评级公司id
    ,rating varchar2(24) -- 评级
    ,modify_time date -- 修改时间
    ,rating_date varchar2(12) -- 评级日期
    ,rating_category varchar2(2) -- 评级类别
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
grant select on ${iol_schema}.ctms_tbs_v_security_rating to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_rating to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_rating to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_rating to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_rating is '债券评级';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.firm_id is '评级公司id';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.rating is '评级';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.modify_time is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.rating_date is '评级日期';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.rating_category is '评级类别';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security_rating.etl_timestamp is 'ETL处理时间戳';
