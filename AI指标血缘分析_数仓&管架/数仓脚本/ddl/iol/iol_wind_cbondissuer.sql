/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondissuer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondissuer
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondissuer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondissuer(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_compname varchar2(450) -- 债券主体公司名称
    ,s_info_compcode varchar2(15) -- 债券主体公司id
    ,used number(1,0) -- 是否有效
    ,s_info_compind_code1 varchar2(75) -- 债券主体公司所属Wind一级行业代码
    ,s_info_compind_name1 varchar2(150) -- 债券主体公司所属Wind一级行业名称
    ,s_info_compind_code2 varchar2(75) -- 债券主体公司所属Wind二级行业代码
    ,s_info_compind_name2 varchar2(150) -- 债券主体公司所属Wind二级行业名称
    ,s_info_compind_code3 varchar2(75) -- 债券主体公司所属Wind三级行业代码
    ,s_info_compind_name3 varchar2(150) -- 债券主体公司所属Wind三级行业名称
    ,s_info_compind_code4 varchar2(75) -- 债券主体公司所属Wind四级行业代码
    ,s_info_compind_name4 varchar2(150) -- 债券主体公司所属Wind四级行业名称
    ,s_info_compregaddress varchar2(750) -- 债券主体公司国籍(注册地)
    ,s_info_comptype varchar2(60) -- 债券主体类型
    ,s_info_listcompornot number(1,0) -- 是否上市公司
    ,s_info_effective_dt varchar2(12) -- 生效日期
    ,s_info_invalid_dt varchar2(12) -- 失效日期
    ,b_agency_guarantornature varchar2(60) -- 公司属性
    ,is_fin_inst number(1,0) -- 是否金融机构
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
grant select on ${iol_schema}.wind_cbondissuer to ${iml_schema};
grant select on ${iol_schema}.wind_cbondissuer to ${icl_schema};
grant select on ${iol_schema}.wind_cbondissuer to ${idl_schema};
grant select on ${iol_schema}.wind_cbondissuer to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondissuer is '中国债券主体';
comment on column ${iol_schema}.wind_cbondissuer.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondissuer.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compname is '债券主体公司名称';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compcode is '债券主体公司id';
comment on column ${iol_schema}.wind_cbondissuer.used is '是否有效';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_code1 is '债券主体公司所属Wind一级行业代码';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_name1 is '债券主体公司所属Wind一级行业名称';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_code2 is '债券主体公司所属Wind二级行业代码';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_name2 is '债券主体公司所属Wind二级行业名称';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_code3 is '债券主体公司所属Wind三级行业代码';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_name3 is '债券主体公司所属Wind三级行业名称';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_code4 is '债券主体公司所属Wind四级行业代码';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compind_name4 is '债券主体公司所属Wind四级行业名称';
comment on column ${iol_schema}.wind_cbondissuer.s_info_compregaddress is '债券主体公司国籍(注册地)';
comment on column ${iol_schema}.wind_cbondissuer.s_info_comptype is '债券主体类型';
comment on column ${iol_schema}.wind_cbondissuer.s_info_listcompornot is '是否上市公司';
comment on column ${iol_schema}.wind_cbondissuer.s_info_effective_dt is '生效日期';
comment on column ${iol_schema}.wind_cbondissuer.s_info_invalid_dt is '失效日期';
comment on column ${iol_schema}.wind_cbondissuer.b_agency_guarantornature is '公司属性';
comment on column ${iol_schema}.wind_cbondissuer.is_fin_inst is '是否金融机构';
comment on column ${iol_schema}.wind_cbondissuer.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondissuer.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondissuer.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondissuer.etl_timestamp is 'ETL处理时间戳';
