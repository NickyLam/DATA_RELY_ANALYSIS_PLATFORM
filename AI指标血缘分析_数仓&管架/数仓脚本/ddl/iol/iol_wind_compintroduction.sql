/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_compintroduction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_compintroduction
whenever sqlerror continue none;
drop table ${iol_schema}.wind_compintroduction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_compintroduction(
    object_id varchar2(150) -- 对象ID
    ,comp_id varchar2(60) -- 公司ID
    ,comp_name varchar2(450) -- 公司名称
    ,comp_sname varchar2(150) -- 公司中文简称
    ,comp_name_eng varchar2(200) -- 英文名称
    ,comp_snameeng varchar2(182) -- 英文名称缩写
    ,province varchar2(45) -- 省份
    ,city varchar2(75) -- 城市
    ,address varchar2(750) -- 注册地址
    ,office varchar2(600) -- 办公地址
    ,zipcode varchar2(30) -- 邮编
    ,phone varchar2(150) -- 电话
    ,fax varchar2(75) -- 传真
    ,email varchar2(300) -- 电子邮件
    ,website varchar2(300) -- 公司网址
    ,registernumber varchar2(45) -- 工商登记号
    ,chairman varchar2(150) -- 法人代表
    ,president varchar2(174) -- 总经理
    ,discloser varchar2(750) -- 信息披露人
    ,regcapital number(20,4) -- 注册资本
    ,currencycode varchar2(30) -- 货币代码
    ,founddate varchar2(30) -- 成立日期
    ,enddate varchar2(12) -- 公司终止日期
    ,briefing varchar2(4000) -- 公司简介
    ,comp_type varchar2(150) -- 公司类型
    ,comp_property varchar2(150) -- 企业性质
    ,country varchar2(45) -- 国籍
    ,businessscope varchar2(4000) -- 经营范围
    ,company_type varchar2(30) -- 公司类别
    ,s_info_totalemployees number(20,0) -- 员工总数(人)
    ,main_business varchar2(4000) -- 主要产品及业务
    ,opdate date -- 
    ,opmode varchar2(2) -- 
    ,social_credit_code varchar2(30) -- 统一社会信用代码
    ,is_listed number(1,0) -- 是否上市公司
    ,s_info_comptype varchar2(30) -- 万得自定义的用来识别公司类型 的编码，如1代表证券公司
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
grant select on ${iol_schema}.wind_compintroduction to ${iml_schema};
grant select on ${iol_schema}.wind_compintroduction to ${icl_schema};
grant select on ${iol_schema}.wind_compintroduction to ${idl_schema};
grant select on ${iol_schema}.wind_compintroduction to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_compintroduction is '万德数据客户基本信息总表';
comment on column ${iol_schema}.wind_compintroduction.object_id is '对象ID';
comment on column ${iol_schema}.wind_compintroduction.comp_id is '公司ID';
comment on column ${iol_schema}.wind_compintroduction.comp_name is '公司名称';
comment on column ${iol_schema}.wind_compintroduction.comp_sname is '公司中文简称';
comment on column ${iol_schema}.wind_compintroduction.comp_name_eng is '英文名称';
comment on column ${iol_schema}.wind_compintroduction.comp_snameeng is '英文名称缩写';
comment on column ${iol_schema}.wind_compintroduction.province is '省份';
comment on column ${iol_schema}.wind_compintroduction.city is '城市';
comment on column ${iol_schema}.wind_compintroduction.address is '注册地址';
comment on column ${iol_schema}.wind_compintroduction.office is '办公地址';
comment on column ${iol_schema}.wind_compintroduction.zipcode is '邮编';
comment on column ${iol_schema}.wind_compintroduction.phone is '电话';
comment on column ${iol_schema}.wind_compintroduction.fax is '传真';
comment on column ${iol_schema}.wind_compintroduction.email is '电子邮件';
comment on column ${iol_schema}.wind_compintroduction.website is '公司网址';
comment on column ${iol_schema}.wind_compintroduction.registernumber is '工商登记号';
comment on column ${iol_schema}.wind_compintroduction.chairman is '法人代表';
comment on column ${iol_schema}.wind_compintroduction.president is '总经理';
comment on column ${iol_schema}.wind_compintroduction.discloser is '信息披露人';
comment on column ${iol_schema}.wind_compintroduction.regcapital is '注册资本';
comment on column ${iol_schema}.wind_compintroduction.currencycode is '货币代码';
comment on column ${iol_schema}.wind_compintroduction.founddate is '成立日期';
comment on column ${iol_schema}.wind_compintroduction.enddate is '公司终止日期';
comment on column ${iol_schema}.wind_compintroduction.briefing is '公司简介';
comment on column ${iol_schema}.wind_compintroduction.comp_type is '公司类型';
comment on column ${iol_schema}.wind_compintroduction.comp_property is '企业性质';
comment on column ${iol_schema}.wind_compintroduction.country is '国籍';
comment on column ${iol_schema}.wind_compintroduction.businessscope is '经营范围';
comment on column ${iol_schema}.wind_compintroduction.company_type is '公司类别';
comment on column ${iol_schema}.wind_compintroduction.s_info_totalemployees is '员工总数(人)';
comment on column ${iol_schema}.wind_compintroduction.main_business is '主要产品及业务';
comment on column ${iol_schema}.wind_compintroduction.opdate is '';
comment on column ${iol_schema}.wind_compintroduction.opmode is '';
comment on column ${iol_schema}.wind_compintroduction.social_credit_code is '统一社会信用代码';
comment on column ${iol_schema}.wind_compintroduction.is_listed is '是否上市公司';
comment on column ${iol_schema}.wind_compintroduction.s_info_comptype is '万得自定义的用来识别公司类型 的编码，如1代表证券公司';
comment on column ${iol_schema}.wind_compintroduction.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_compintroduction.etl_timestamp is 'ETL处理时间戳';
