/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tm_business_enterprise_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tm_business_enterprise_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tm_business_enterprise_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tm_business_enterprise_info(
    custid number(20,0) -- 客户编号
    ,name varchar2(160) -- 姓名
    ,idno varchar2(30) -- 证件号码
    ,identifybizno varchar2(32) -- 认定流水号
    ,identifytype varchar2(40) -- 经营身份类型
    ,identifystatus varchar2(40) -- 经营身份状态
    ,fundedratio number -- 出资比例
    ,affirmtime date -- 认定时间
    ,entcreditcode varchar2(50) -- 统一社会信用代码
    ,entregno varchar2(64) -- 企业注册号
    ,orgcode varchar2(50) -- 组织机构代码
    ,entname varchar2(360) -- 企业名称
    ,enttype varchar2(64) -- 企业类型
    ,entbusinessstatus varchar2(64) -- 企业经营状态
    ,esdate date -- 企业成立日期
    ,industryname varchar2(400) -- 行业名称
    ,industrycode varchar2(40) -- 行业代码
    ,industrycategory varchar2(200) -- 行业分类
    ,affirmorg varchar2(400) -- 登记机构
    ,reserve1 varchar2(400) -- 注册地址
    ,reserve2 varchar2(200) -- 注册地址编码
    ,reserve3 varchar2(400) -- 备份字段
    ,reserve4 varchar2(400) -- 备份字段
    ,reserve5 varchar2(400) -- 备份字段
    ,reserve6 varchar2(400) -- 备份字段
    ,reserve7 varchar2(400) -- 备份字段
    ,reserve8 varchar2(400) -- 备份字段
    ,reserve9 varchar2(400) -- 备份字段
    ,reserve10 varchar2(400) -- 备份字段
    ,reserve11 varchar2(400) -- 备份字段
    ,reserve12 varchar2(400) -- 备份字段
    ,reserve13 varchar2(400) -- 备份字段
    ,reserve14 varchar2(400) -- 备份字段
    ,reserve15 varchar2(400) -- 备份字段
    ,reserve16 varchar2(400) -- 备份字段
    ,reserve17 varchar2(400) -- 备份字段
    ,reserve18 varchar2(400) -- 备份字段
    ,reserve19 varchar2(400) -- 备份字段
    ,reserve20 varchar2(400) -- 备份字段
    ,reserve21 varchar2(400) -- 备份字段
    ,reserve22 varchar2(400) -- 备份字段
    ,reserve23 varchar2(400) -- 备份字段
    ,reserve24 varchar2(400) -- 备份字段
    ,reserve25 varchar2(400) -- 备份字段
    ,reserve26 varchar2(400) -- 备份字段
    ,reserve27 varchar2(400) -- 备份字段
    ,reserve28 varchar2(400) -- 备份字段
    ,reserve29 varchar2(400) -- 备份字段
    ,reserve30 varchar2(400) -- 备份字段
    ,reserve31 varchar2(400) -- 备份字段
    ,reserve32 varchar2(400) -- 备份字段
    ,reserve33 varchar2(400) -- 备份字段
    ,reserve34 varchar2(400) -- 备份字段
    ,reserve35 varchar2(400) -- 备份字段
    ,reserve36 varchar2(400) -- 备份字段
    ,reserve37 varchar2(400) -- 备份字段
    ,reserve38 varchar2(400) -- 备份字段
    ,reserve39 varchar2(400) -- 备份字段
    ,reserve40 varchar2(4000) -- 备份字段
    ,reserve41 varchar2(4000) -- 备份字段
    ,reserve42 varchar2(4000) -- 备份字段
    ,reserve43 varchar2(4000) -- 备份字段
    ,reserve44 varchar2(4000) -- 备份字段
    ,reserve45 varchar2(4000) -- 备份字段
    ,reserve46 varchar2(4000) -- 备份字段
    ,reserve47 varchar2(4000) -- 备份字段
    ,reserve48 varchar2(4000) -- 备份字段
    ,reserve49 varchar2(4000) -- 备份字段
    ,reserve50 varchar2(4000) -- 备份字段
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
grant select on ${iol_schema}.icms_tm_business_enterprise_info to ${iml_schema};
grant select on ${iol_schema}.icms_tm_business_enterprise_info to ${icl_schema};
grant select on ${iol_schema}.icms_tm_business_enterprise_info to ${idl_schema};
grant select on ${iol_schema}.icms_tm_business_enterprise_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tm_business_enterprise_info is '客户经营身份认定信息表';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.custid is '客户编号';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.name is '姓名';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.idno is '证件号码';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.identifybizno is '认定流水号';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.identifytype is '经营身份类型';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.identifystatus is '经营身份状态';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.fundedratio is '出资比例';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.affirmtime is '认定时间';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.entcreditcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.entregno is '企业注册号';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.orgcode is '组织机构代码';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.entname is '企业名称';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.enttype is '企业类型';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.entbusinessstatus is '企业经营状态';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.esdate is '企业成立日期';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.industryname is '行业名称';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.industrycode is '行业代码';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.industrycategory is '行业分类';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.affirmorg is '登记机构';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve1 is '注册地址';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve2 is '注册地址编码';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve3 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve4 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve5 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve6 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve7 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve8 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve9 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve10 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve11 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve12 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve13 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve14 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve15 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve16 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve17 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve18 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve19 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve20 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve21 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve22 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve23 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve24 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve25 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve26 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve27 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve28 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve29 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve30 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve31 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve32 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve33 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve34 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve35 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve36 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve37 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve38 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve39 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve40 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve41 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve42 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve43 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve44 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve45 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve46 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve47 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve48 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve49 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.reserve50 is '备份字段';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_tm_business_enterprise_info.etl_timestamp is 'ETL处理时间戳';
