/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondratingcicc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondratingcicc
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondratingcicc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondratingcicc(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_dt varchar2(15) -- 评级日期
    ,analyst varchar2(150) -- 分析师
    ,b_info_rating varchar2(30) -- 公布评级
    ,s_info_name varchar2(300) -- 公布证券简称
    ,b_info_ratingagency varchar2(60) -- 机构
    ,starlevel number(5,0) -- 星级
    ,memo varchar2(1500) -- 评级内容摘要
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
grant select on ${iol_schema}.wind_cbondratingcicc to ${iml_schema};
grant select on ${iol_schema}.wind_cbondratingcicc to ${icl_schema};
grant select on ${iol_schema}.wind_cbondratingcicc to ${idl_schema};
grant select on ${iol_schema}.wind_cbondratingcicc to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondratingcicc is '中国短期融资券投资评级';
comment on column ${iol_schema}.wind_cbondratingcicc.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondratingcicc.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondratingcicc.ann_dt is '评级日期';
comment on column ${iol_schema}.wind_cbondratingcicc.analyst is '分析师';
comment on column ${iol_schema}.wind_cbondratingcicc.b_info_rating is '公布评级';
comment on column ${iol_schema}.wind_cbondratingcicc.s_info_name is '公布证券简称';
comment on column ${iol_schema}.wind_cbondratingcicc.b_info_ratingagency is '机构';
comment on column ${iol_schema}.wind_cbondratingcicc.starlevel is '星级';
comment on column ${iol_schema}.wind_cbondratingcicc.memo is '评级内容摘要';
comment on column ${iol_schema}.wind_cbondratingcicc.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondratingcicc.etl_timestamp is 'ETL处理时间戳';
