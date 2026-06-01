/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_v_yyw_inifrmlod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_v_yyw_inifrmlod
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_v_yyw_inifrmlod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_yyw_inifrmlod(
    b1 varchar2(100) -- 交易时间
    ,b2 varchar2(200) -- 交易机构
    ,b3 varchar2(100) -- 经办业务人员岗位
    ,b4 varchar2(100) -- 用户号
    ,b5 varchar2(100) -- 用户姓名
    ,b6 varchar2(100) -- 授权柜员号
    ,b7 varchar2(100) -- 授权柜员姓名
    ,b8 varchar2(100) -- 授权机构
    ,b9 varchar2(100) -- 交易码值
    ,b10 varchar2(300) -- 交易名称
    ,b11 timestamp -- 交易开始时间
    ,b12 timestamp -- 交易结束时间
    ,b13 varchar2(100) -- 业务流水号
    ,b14 varchar2(100) -- 系统名称
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
grant select on ${iol_schema}.isbs_v_yyw_inifrmlod to ${iml_schema};
grant select on ${iol_schema}.isbs_v_yyw_inifrmlod to ${icl_schema};
grant select on ${iol_schema}.isbs_v_yyw_inifrmlod to ${idl_schema};
grant select on ${iol_schema}.isbs_v_yyw_inifrmlod to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_v_yyw_inifrmlod is '国际结算系统业务量累计';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b1 is '交易时间';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b2 is '交易机构';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b3 is '经办业务人员岗位';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b4 is '用户号';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b5 is '用户姓名';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b6 is '授权柜员号';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b7 is '授权柜员姓名';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b8 is '授权机构';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b9 is '交易码值';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b10 is '交易名称';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b11 is '交易开始时间';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b12 is '交易结束时间';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b13 is '业务流水号';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.b14 is '系统名称';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_v_yyw_inifrmlod.etl_timestamp is 'ETL处理时间戳';
