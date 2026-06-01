/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondintroduction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondintroduction
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondintroduction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondintroduction(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,s_info_province varchar2(30) -- 省份
    ,s_info_city varchar2(75) -- 城市
    ,s_info_chairman varchar2(75) -- 法人代表
    ,s_info_president varchar2(57) -- 总经理
    ,s_info_bdsecretary varchar2(750) -- 董事会秘书
    ,s_info_regcapital number(20,4) -- 注册资本(万元)
    ,s_info_founddate varchar2(12) -- 成立日期
    ,s_info_chineseintroduction varchar2(3000) -- 公司中文简介
    ,s_info_comptype varchar2(30) -- 公司类型
    ,s_info_website varchar2(240) -- 主页
    ,s_info_email varchar2(240) -- 电子邮箱
    ,s_info_office varchar2(1200) -- 办公地址
    ,ann_dt varchar2(12) -- 公告日期
    ,s_info_country varchar2(30) -- 国籍
    ,s_info_businessscope varchar2(4000) -- 经营范围
    ,s_info_company_type varchar2(15) -- 公司类别
    ,s_info_totalemployees number(20,0) -- 员工总数(人)
    ,s_info_main_business varchar2(1500) -- 主要产品及业务
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
grant select on ${iol_schema}.wind_cbondintroduction to ${iml_schema};
grant select on ${iol_schema}.wind_cbondintroduction to ${icl_schema};
grant select on ${iol_schema}.wind_cbondintroduction to ${idl_schema};
grant select on ${iol_schema}.wind_cbondintroduction to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondintroduction is '中国债券公司简介';
comment on column ${iol_schema}.wind_cbondintroduction.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_province is '省份';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_city is '城市';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_chairman is '法人代表';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_president is '总经理';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_bdsecretary is '董事会秘书';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_regcapital is '注册资本(万元)';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_founddate is '成立日期';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_chineseintroduction is '公司中文简介';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_comptype is '公司类型';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_website is '主页';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_email is '电子邮箱';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_office is '办公地址';
comment on column ${iol_schema}.wind_cbondintroduction.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_country is '国籍';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_businessscope is '经营范围';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_company_type is '公司类别';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_totalemployees is '员工总数(人)';
comment on column ${iol_schema}.wind_cbondintroduction.s_info_main_business is '主要产品及业务';
comment on column ${iol_schema}.wind_cbondintroduction.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondintroduction.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondintroduction.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondintroduction.etl_timestamp is 'ETL处理时间戳';
