/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_issuer_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_issuer_rating
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_issuer_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_issuer_rating(
    issuer_id varchar2(60) -- 发行人id
    ,issuer_name_zh varchar2(96) -- 发行人中文名称
    ,issuer_name_en varchar2(96) -- 发行人英文名称
    ,firm_id varchar2(24) -- 评级公司id
    ,rating varchar2(24) -- 评级
    ,modify_time date -- 修改时间
    ,rating_date varchar2(12) -- 评级日期
    ,rating_category varchar2(2) -- 评级分类
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
grant select on ${iol_schema}.ctms_tbs_v_issuer_rating to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_issuer_rating to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_issuer_rating to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_issuer_rating to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_issuer_rating is '发行人评级';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.issuer_id is '发行人id';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.issuer_name_zh is '发行人中文名称';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.issuer_name_en is '发行人英文名称';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.firm_id is '评级公司id';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.rating is '评级';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.modify_time is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.rating_date is '评级日期';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.rating_category is '评级分类';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_issuer_rating.etl_timestamp is 'ETL处理时间戳';
