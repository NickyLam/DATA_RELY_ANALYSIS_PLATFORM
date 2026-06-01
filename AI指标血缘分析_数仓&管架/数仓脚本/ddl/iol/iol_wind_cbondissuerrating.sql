/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondissuerrating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondissuerrating
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondissuerrating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondissuerrating(
    object_id varchar2(150) -- 对象ID
    ,s_info_compname varchar2(150) -- 公司中文名称
    ,ann_dt varchar2(12) -- 评级日期
    ,b_rate_style varchar2(150) -- 评级类型
    ,b_info_creditrating varchar2(60) -- 信用评级
    ,b_rate_ratingoutlook number(9,0) -- 评级展望
    ,b_info_creditratingagency varchar2(15) -- 评级机构代码
    ,s_info_compcode varchar2(15) -- 债券主体公司id
    ,b_info_creditratingexplain varchar2(1500) -- 信用评级说明
    ,b_info_precreditrating varchar2(60) -- 前次信用评级
    ,b_creditrating_change varchar2(15) -- 评级变动方向
    ,b_info_issuerratetype number(9,0) -- 评级对象类型代码
    ,ann_dt2 varchar2(12) -- 公告日期
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
grant select on ${iol_schema}.wind_cbondissuerrating to ${iml_schema};
grant select on ${iol_schema}.wind_cbondissuerrating to ${icl_schema};
grant select on ${iol_schema}.wind_cbondissuerrating to ${idl_schema};
grant select on ${iol_schema}.wind_cbondissuerrating to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondissuerrating is '中国债券发行主体信用评级';
comment on column ${iol_schema}.wind_cbondissuerrating.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondissuerrating.s_info_compname is '公司中文名称';
comment on column ${iol_schema}.wind_cbondissuerrating.ann_dt is '评级日期';
comment on column ${iol_schema}.wind_cbondissuerrating.b_rate_style is '评级类型';
comment on column ${iol_schema}.wind_cbondissuerrating.b_info_creditrating is '信用评级';
comment on column ${iol_schema}.wind_cbondissuerrating.b_rate_ratingoutlook is '评级展望';
comment on column ${iol_schema}.wind_cbondissuerrating.b_info_creditratingagency is '评级机构代码';
comment on column ${iol_schema}.wind_cbondissuerrating.s_info_compcode is '债券主体公司id';
comment on column ${iol_schema}.wind_cbondissuerrating.b_info_creditratingexplain is '信用评级说明';
comment on column ${iol_schema}.wind_cbondissuerrating.b_info_precreditrating is '前次信用评级';
comment on column ${iol_schema}.wind_cbondissuerrating.b_creditrating_change is '评级变动方向';
comment on column ${iol_schema}.wind_cbondissuerrating.b_info_issuerratetype is '评级对象类型代码';
comment on column ${iol_schema}.wind_cbondissuerrating.ann_dt2 is '公告日期';
comment on column ${iol_schema}.wind_cbondissuerrating.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondissuerrating.etl_timestamp is 'ETL处理时间戳';
