/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_icms_mybk_cs_extent_info
CreateDate: 20230608
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_icms_mybk_cs_extent_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_icms_mybk_cs_extent_info(
etl_dt date --etl处理日期
,serno varchar2(32) --流水号
,registeraddressarea varchar2(150) --注册地省市区
,statusid varchar2(30) --经营状态
,sex varchar2(2) --性别
,city varchar2(60) --城市
,registerno varchar2(64) --工商注册号
,orgcode varchar2(64) --组织机构号
,managebegindate varchar2(64) --经营开始时间
,opendate varchar2(64) --开业时间
,economictype varchar2(128) --公司经济类型
,registeraddressareacode varchar2(64) --注册地址行政区编号
,area varchar2(60) --地区
,companytype varchar2(128) --公司类型
,registerdate varchar2(32) --注册时间
,industryname varchar2(256) --客群主营行业
,nationality varchar2(6) --国籍
,registeraddress varchar2(512) --注册地址
,registerdepartment varchar2(150) --注册工商局
,migtflag varchar2(80) --迁移标志：crsrcrilcupl
,busdatareqdate varchar2(64) --采集时间
,businfoexistflag varchar2(8) --是否存有效商信息
,fundcurrency varchar2(64) --币种
,companyinfoname varchar2(300) --公司名
,tradecode varchar2(64) --行业代码
,managerange varchar2(4000) --经营范围
,mobile varchar2(32) --手机号码
,certvalidenddate varchar2(128) --证件有效期
,statusdesc varchar2(500) --经营状态描述
,certvalidstartdate varchar2(20) --证件有效期起始日
,manageenddate varchar2(64) --经营结束时间
,targetjyflag1 varchar2(256) --客群经营标签（经营场景)
,applyno varchar2(64) --蚂蚁申请编号
,companyinfolawer varchar2(75) --法定代表
,registerfund number(18,2) --注册资本(万元)
,address varchar2(600) --地址信息
,prov varchar2(30) --省份
,notexistreason varchar2(500) --无有效工商信息原因
,lastcheckyear varchar2(64) --最后年检年度
,indivocc varchar2(128) --职业

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_icms_mybk_cs_extent_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_icms_mybk_cs_extent_info is '网商贷初审扩展信息';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.etl_dt is 'etl处理日期';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.serno is '流水号';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registeraddressarea is '注册地省市区';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.statusid is '经营状态';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.sex is '性别';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.city is '城市';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registerno is '工商注册号';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.orgcode is '组织机构号';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.managebegindate is '经营开始时间';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.opendate is '开业时间';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.economictype is '公司经济类型';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registeraddressareacode is '注册地址行政区编号';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.area is '地区';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.companytype is '公司类型';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registerdate is '注册时间';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.industryname is '客群主营行业';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.nationality is '国籍';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registeraddress is '注册地址';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registerdepartment is '注册工商局';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.busdatareqdate is '采集时间';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.businfoexistflag is '是否存有效商信息';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.fundcurrency is '币种';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.companyinfoname is '公司名';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.tradecode is '行业代码';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.managerange is '经营范围';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.mobile is '手机号码';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.certvalidenddate is '证件有效期';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.statusdesc is '经营状态描述';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.certvalidstartdate is '证件有效期起始日';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.manageenddate is '经营结束时间';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.targetjyflag1 is '客群经营标签（经营场景)';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.applyno is '蚂蚁申请编号';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.companyinfolawer is '法定代表';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.registerfund is '注册资本(万元)';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.address is '地址信息';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.prov is '省份';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.notexistreason is '无有效工商信息原因';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.lastcheckyear is '最后年检年度';
comment on column ${idl_schema}.crps_icms_mybk_cs_extent_info.indivocc is '职业';

