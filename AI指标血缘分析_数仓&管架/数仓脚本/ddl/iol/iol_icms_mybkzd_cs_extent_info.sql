/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_cs_extent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_cs_extent_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_cs_extent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_cs_extent_info(
    serialno varchar2(32) -- 流水号
    ,applyno varchar2(64) -- 蚂蚁申请编号
    ,mobile varchar2(32) -- 手机号码
    ,address varchar2(1200) -- 地址信息
    ,prov varchar2(60) -- 省份
    ,city varchar2(120) -- 城市
    ,area varchar2(120) -- 地区
    ,certvalidenddate varchar2(128) -- 证件有效期
    ,busdatareqdate varchar2(64) -- 采集时间
    ,businfoexistflag varchar2(8) -- 是否存有效商信息
    ,notexistreason varchar2(500) -- 无有效工商信息原因
    ,companyinfoname varchar2(600) -- 公司名
    ,companyinfolawer varchar2(150) -- 法定代表
    ,registerno varchar2(64) -- 工商注册号
    ,registerdate varchar2(32) -- 注册时间
    ,registeraddress varchar2(1024) -- 注册地址
    ,registeraddressareacode varchar2(64) -- 注册地址行政区编号
    ,registeraddressarea varchar2(300) -- 注册地省市区
    ,registerfund number(18,2) -- 注册资本(万元)
    ,fundcurrency varchar2(64) -- 币种
    ,tradecode varchar2(64) -- 行业代码
    ,managerange varchar2(4000) -- 经营范围
    ,orgcode varchar2(64) -- 组织机构号
    ,registerdepartment varchar2(300) -- 注册工商局
    ,statusid varchar2(30) -- 经营状态
    ,statusdesc varchar2(1000) -- 经营状态描述
    ,lastcheckyear varchar2(64) -- 最后年检年度
    ,managebegindate varchar2(64) -- 经营开始时间
    ,manageenddate varchar2(64) -- 经营结束时间
    ,opendate varchar2(64) -- 开业时间
    ,companytype varchar2(256) -- 公司类型
    ,economictype varchar2(256) -- 公司经济类型
    ,targetjyflag1 varchar2(256) -- 客群经营标签（经营场景)
    ,industryname varchar2(256) -- 客群主营行业
    ,certvalidstartdate varchar2(20) -- 证件有效期起始日
    ,sex varchar2(2) -- 性别
    ,indivocc varchar2(256) -- 职业
    ,nationality varchar2(6) -- 国籍
    ,businessscene varchar2(64) -- 业务场景
    ,businesstag varchar2(64) -- 业务标识
    ,pushreason varchar2(8) -- 客群区分标识
    ,custverifytype varchar2(32) -- 核身方式
    ,custverifyresult varchar2(8) -- 核身结果
    ,custverifytime varchar2(24) -- 核身通过时间
    ,customertag varchar2(32) -- 客群标
    ,employee_id varchar2(128) -- 推广者员工号
    ,nation varchar2(32) -- 民族
    ,company_info_org_code varchar2(64) -- 统一社会信用代码
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
grant select on ${iol_schema}.icms_mybkzd_cs_extent_info to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_cs_extent_info to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_cs_extent_info to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_cs_extent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_cs_extent_info is '网商贷助贷初审扩展信息';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.serialno is '流水号';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.applyno is '蚂蚁申请编号';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.mobile is '手机号码';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.address is '地址信息';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.prov is '省份';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.city is '城市';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.area is '地区';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.certvalidenddate is '证件有效期';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.busdatareqdate is '采集时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.businfoexistflag is '是否存有效商信息';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.notexistreason is '无有效工商信息原因';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.companyinfoname is '公司名';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.companyinfolawer is '法定代表';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registerno is '工商注册号';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registerdate is '注册时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registeraddress is '注册地址';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registeraddressareacode is '注册地址行政区编号';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registeraddressarea is '注册地省市区';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registerfund is '注册资本(万元)';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.fundcurrency is '币种';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.tradecode is '行业代码';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.managerange is '经营范围';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.orgcode is '组织机构号';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.registerdepartment is '注册工商局';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.statusid is '经营状态';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.statusdesc is '经营状态描述';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.lastcheckyear is '最后年检年度';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.managebegindate is '经营开始时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.manageenddate is '经营结束时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.opendate is '开业时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.companytype is '公司类型';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.economictype is '公司经济类型';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.targetjyflag1 is '客群经营标签（经营场景)';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.industryname is '客群主营行业';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.certvalidstartdate is '证件有效期起始日';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.sex is '性别';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.indivocc is '职业';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.nationality is '国籍';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.businessscene is '业务场景';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.businesstag is '业务标识';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.pushreason is '客群区分标识';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.custverifytype is '核身方式';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.custverifyresult is '核身结果';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.custverifytime is '核身通过时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.customertag is '客群标';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.employee_id is '推广者员工号';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.nation is '民族';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.company_info_org_code is '统一社会信用代码';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_cs_extent_info.etl_timestamp is 'ETL处理时间戳';
