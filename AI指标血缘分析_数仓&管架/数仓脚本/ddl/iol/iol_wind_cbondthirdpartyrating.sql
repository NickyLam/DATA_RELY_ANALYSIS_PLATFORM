/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondthirdpartyrating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondthirdpartyrating
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondthirdpartyrating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondthirdpartyrating(
    object_id varchar2(150) -- 对象ID
    ,s_info_compname varchar2(150) -- 公司名称
    ,s_info_compcode varchar2(15) -- 品种ID
    ,b_rate_style number(9,0) -- 品种类别代码
    ,b_info_listdate varchar2(12) -- 发布日期
    ,b_typcode number(9,0) -- 评级类型代码
    ,b_est_rating_inst varchar2(60) -- 信用等级
    ,b_est_institute varchar2(150) -- 评估机构公司
    ,b_rate_ratingoutlook varchar2(450) -- 评级展望
    ,b_est_prerating_inst varchar2(60) -- 前次评级
    ,b_rate_preratingoutlook varchar2(450) -- 前次评级展望
    ,b_est_rating_change varchar2(15) -- 评级变动方向
    ,opdate date -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_cbondthirdpartyrating to ${iml_schema};
grant select on ${iol_schema}.wind_cbondthirdpartyrating to ${icl_schema};
grant select on ${iol_schema}.wind_cbondthirdpartyrating to ${idl_schema};
grant select on ${iol_schema}.wind_cbondthirdpartyrating to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondthirdpartyrating is '中国债券第三方信用评级';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.s_info_compcode is '品种ID';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_rate_style is '品种类别代码';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_info_listdate is '发布日期';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_typcode is '评级类型代码';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_est_rating_inst is '信用等级';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_est_institute is '评估机构公司';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_rate_ratingoutlook is '评级展望';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_est_prerating_inst is '前次评级';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_rate_preratingoutlook is '前次评级展望';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.b_est_rating_change is '评级变动方向';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.opdate is '';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondthirdpartyrating.etl_timestamp is 'ETL处理时间戳';
