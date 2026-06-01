/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hxyhcombasinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hxyhcombasinfo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hxyhcombasinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hxyhcombasinfo(
    object_id varchar2(150) -- 对象ID
    ,comp_id varchar2(15) -- 公司ID
    ,comp_name varchar2(450) -- 公司名称
    ,comp_sname varchar2(60) -- 公司中文简称
    ,province varchar2(30) -- 省份
    ,city varchar2(75) -- 城市
    ,address varchar2(300) -- 注册地址
    ,office varchar2(300) -- 办公地址
    ,register_number varchar2(30) -- 工商登记号
    ,regcapital number(20,4) -- 注册资本(万元)
    ,currencycode varchar2(15) -- 货币代码
    ,chairman varchar2(60) -- 法人代表
    ,founddate varchar2(12) -- 成立日期
    ,enddate varchar2(14) -- 公司终止日期
    ,s_info_totalemployees number(20,0) -- 员工总数(人)
    ,business_scope varchar2(4000) -- 经营范围
    ,s_info_org_code varchar2(60) -- 组织机构代码
    ,wind_ind_code varchar2(75) -- WIND行业代码
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
grant select on ${iol_schema}.wind_hxyhcombasinfo to ${iml_schema};
grant select on ${iol_schema}.wind_hxyhcombasinfo to ${icl_schema};
grant select on ${iol_schema}.wind_hxyhcombasinfo to ${idl_schema};
grant select on ${iol_schema}.wind_hxyhcombasinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hxyhcombasinfo is '华兴银行企业库基本信息';
comment on column ${iol_schema}.wind_hxyhcombasinfo.object_id is '对象ID';
comment on column ${iol_schema}.wind_hxyhcombasinfo.comp_id is '公司ID';
comment on column ${iol_schema}.wind_hxyhcombasinfo.comp_name is '公司名称';
comment on column ${iol_schema}.wind_hxyhcombasinfo.comp_sname is '公司中文简称';
comment on column ${iol_schema}.wind_hxyhcombasinfo.province is '省份';
comment on column ${iol_schema}.wind_hxyhcombasinfo.city is '城市';
comment on column ${iol_schema}.wind_hxyhcombasinfo.address is '注册地址';
comment on column ${iol_schema}.wind_hxyhcombasinfo.office is '办公地址';
comment on column ${iol_schema}.wind_hxyhcombasinfo.register_number is '工商登记号';
comment on column ${iol_schema}.wind_hxyhcombasinfo.regcapital is '注册资本(万元)';
comment on column ${iol_schema}.wind_hxyhcombasinfo.currencycode is '货币代码';
comment on column ${iol_schema}.wind_hxyhcombasinfo.chairman is '法人代表';
comment on column ${iol_schema}.wind_hxyhcombasinfo.founddate is '成立日期';
comment on column ${iol_schema}.wind_hxyhcombasinfo.enddate is '公司终止日期';
comment on column ${iol_schema}.wind_hxyhcombasinfo.s_info_totalemployees is '员工总数(人)';
comment on column ${iol_schema}.wind_hxyhcombasinfo.business_scope is '经营范围';
comment on column ${iol_schema}.wind_hxyhcombasinfo.s_info_org_code is '组织机构代码';
comment on column ${iol_schema}.wind_hxyhcombasinfo.wind_ind_code is 'WIND行业代码';
comment on column ${iol_schema}.wind_hxyhcombasinfo.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hxyhcombasinfo.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hxyhcombasinfo.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hxyhcombasinfo.etl_timestamp is 'ETL处理时间戳';
