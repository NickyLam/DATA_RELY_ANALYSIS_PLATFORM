/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkcompanyinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkcompanyinfo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkcompanyinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkcompanyinfo(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司ID
    ,s_info_compname varchar2(150) -- 公司名称
    ,comp_sname varchar2(150) -- 公司中文简称
    ,comp_name_eng varchar2(150) -- 英文名称
    ,founddate varchar2(30) -- 成立日期
    ,legalrepresentative varchar2(150) -- 法人代表
    ,regcapital number(20,4) -- 注册资本(万元)
    ,briefing varchar2(3000) -- 公司简介
    ,businessscope varchar2(4000) -- 经营范围
    ,businessscope_eng varchar2(3000) -- 经营范围(英文)
    ,totalemployees number(20,0) -- 员工总数(人)
    ,discloserid varchar2(750) -- 信息披露人ID
    ,crny_code varchar2(30) -- 货币代码
    ,address varchar2(750) -- 注册地址
    ,office varchar2(450) -- 办公地址
    ,phone varchar2(150) -- 电话
    ,fax varchar2(75) -- 传真
    ,country varchar2(45) -- 国家及地区
    ,website varchar2(120) -- 主页
    ,email varchar2(120) -- 电子邮箱
    ,ann_dt varchar2(30) -- 公告日期
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_hkcompanyinfo to ${iml_schema};
grant select on ${iol_schema}.wind_hkcompanyinfo to ${icl_schema};
grant select on ${iol_schema}.wind_hkcompanyinfo to ${idl_schema};
grant select on ${iol_schema}.wind_hkcompanyinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkcompanyinfo is '';
comment on column ${iol_schema}.wind_hkcompanyinfo.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkcompanyinfo.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_hkcompanyinfo.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_hkcompanyinfo.comp_sname is '公司中文简称';
comment on column ${iol_schema}.wind_hkcompanyinfo.comp_name_eng is '英文名称';
comment on column ${iol_schema}.wind_hkcompanyinfo.founddate is '成立日期';
comment on column ${iol_schema}.wind_hkcompanyinfo.legalrepresentative is '法人代表';
comment on column ${iol_schema}.wind_hkcompanyinfo.regcapital is '注册资本(万元)';
comment on column ${iol_schema}.wind_hkcompanyinfo.briefing is '公司简介';
comment on column ${iol_schema}.wind_hkcompanyinfo.businessscope is '经营范围';
comment on column ${iol_schema}.wind_hkcompanyinfo.businessscope_eng is '经营范围(英文)';
comment on column ${iol_schema}.wind_hkcompanyinfo.totalemployees is '员工总数(人)';
comment on column ${iol_schema}.wind_hkcompanyinfo.discloserid is '信息披露人ID';
comment on column ${iol_schema}.wind_hkcompanyinfo.crny_code is '货币代码';
comment on column ${iol_schema}.wind_hkcompanyinfo.address is '注册地址';
comment on column ${iol_schema}.wind_hkcompanyinfo.office is '办公地址';
comment on column ${iol_schema}.wind_hkcompanyinfo.phone is '电话';
comment on column ${iol_schema}.wind_hkcompanyinfo.fax is '传真';
comment on column ${iol_schema}.wind_hkcompanyinfo.country is '国家及地区';
comment on column ${iol_schema}.wind_hkcompanyinfo.website is '主页';
comment on column ${iol_schema}.wind_hkcompanyinfo.email is '电子邮箱';
comment on column ${iol_schema}.wind_hkcompanyinfo.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkcompanyinfo.opdate is '';
comment on column ${iol_schema}.wind_hkcompanyinfo.opmode is '';
comment on column ${iol_schema}.wind_hkcompanyinfo.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hkcompanyinfo.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hkcompanyinfo.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hkcompanyinfo.etl_timestamp is 'ETL处理时间戳';
