/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_neeqsintroduction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_neeqsintroduction
whenever sqlerror continue none;
drop table ${iol_schema}.wind_neeqsintroduction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqsintroduction(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,s_info_compname varchar2(300) -- 公司名称
    ,s_info_compnameeng varchar2(300) -- 英文名称
    ,s_info_country varchar2(45) -- 国家及地区
    ,s_info_province varchar2(45) -- 省份
    ,s_info_city varchar2(45) -- 城市
    ,s_info_chairman varchar2(150) -- 法人代表
    ,s_info_president varchar2(60) -- 总经理
    ,s_info_bdsecretary varchar2(750) -- 董事会秘书
    ,s_info_regcapital number(20,4) -- 注册资本(万元)
    ,s_info_founddate varchar2(30) -- 成立日期
    ,s_info_website varchar2(240) -- 主页
    ,s_info_email varchar2(240) -- 电子邮箱
    ,s_info_office varchar2(1200) -- 办公地址
    ,ann_dt varchar2(30) -- 公告日期
    ,s_info_totalemployees number(20,0) -- 员工总数(人)
    ,s_info_businessscope varchar2(4000) -- 经营范围
    ,s_info_main_business varchar2(3000) -- 主要产品及业务
    ,s_info_chineseintroduction varchar2(3000) -- 公司简介
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
grant select on ${iol_schema}.wind_neeqsintroduction to ${iml_schema};
grant select on ${iol_schema}.wind_neeqsintroduction to ${icl_schema};
grant select on ${iol_schema}.wind_neeqsintroduction to ${idl_schema};
grant select on ${iol_schema}.wind_neeqsintroduction to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_neeqsintroduction is '股转系统公司简介';
comment on column ${iol_schema}.wind_neeqsintroduction.object_id is '对象ID';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_compnameeng is '英文名称';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_country is '国家及地区';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_province is '省份';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_city is '城市';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_chairman is '法人代表';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_president is '总经理';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_bdsecretary is '董事会秘书';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_regcapital is '注册资本(万元)';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_founddate is '成立日期';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_website is '主页';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_email is '电子邮箱';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_office is '办公地址';
comment on column ${iol_schema}.wind_neeqsintroduction.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_totalemployees is '员工总数(人)';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_businessscope is '经营范围';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_main_business is '主要产品及业务';
comment on column ${iol_schema}.wind_neeqsintroduction.s_info_chineseintroduction is '公司简介';
comment on column ${iol_schema}.wind_neeqsintroduction.start_dt is '开始时间';
comment on column ${iol_schema}.wind_neeqsintroduction.end_dt is '结束时间';
comment on column ${iol_schema}.wind_neeqsintroduction.id_mark is '增删标志';
comment on column ${iol_schema}.wind_neeqsintroduction.etl_timestamp is 'ETL处理时间戳';
