/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzq_cs_extent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzq_cs_extent_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzq_cs_extent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzq_cs_extent_info(
    serialno varchar2(32) -- 信贷流水号
    ,applyno varchar2(64) -- 债转申请单据号
    ,businessscene varchar2(64) -- 业务类型
    ,businesstag varchar2(64) -- 与合作机构合作的业务标识
    ,mobile varchar2(64) -- 借款人手机号
    ,address varchar2(1024) -- 地址详情
    ,prov varchar2(32) -- 省份
    ,city varchar2(64) -- 城市
    ,area varchar2(64) -- 区域
    ,certvalidenddate varchar2(128) -- 证件有效期
    ,busdatareqdate varchar2(64) -- 数据采集时间
    ,businfoexistflag varchar2(8) -- 是否存有效工商信息
    ,notexistreason varchar2(64) -- 无有效工商信息原因
    ,companyinfoname varchar2(1024) -- 公司名
    ,companyinfolawer varchar2(64) -- 法定代表人
    ,companyinforegisterno varchar2(64) -- 工商注册号
    ,companyinforegisterdate varchar2(32) -- 注册时间
    ,companyinforegisteraddress varchar2(1024) -- 注册地址
    ,companyinforegisteraddressareacode varchar2(64) -- 注册地址行政区编号
    ,companyinforegisteraddressarea varchar2(128) -- 注册地省市区
    ,companyinforegisterfund varchar2(64) -- 注册资本(万元)
    ,companyinfofundcurrency varchar2(64) -- 币种
    ,companyinfotradecode varchar2(64) -- 2017行业代码
    ,companyinfomanagerange varchar2(4000) -- 经营范围
    ,companyinfoorgcode varchar2(64) -- 统一社会信用代码
    ,companyinforegisterdepartment varchar2(128) -- 注册工商局
    ,companyinfostatusid varchar2(8) -- 经营状态
    ,companyinfostatusdesc varchar2(512) -- 经营状态描述
    ,companyinfolastcheckyear varchar2(64) -- 最后年检年度
    ,companyinfomanagebegindate varchar2(64) -- 经营开始时间
    ,companyinfomanageenddate varchar2(64) -- 经营结束时间
    ,companyinfoopendate varchar2(64) -- 开业时间
    ,companyinfocompanytype varchar2(128) -- 公司类型
    ,companyinfoeconomictype varchar2(128) -- 公司经济类型
    ,targetjyflag1 varchar2(256) -- 客群经营标识
    ,industryname varchar2(512) -- 客群主营行业
    ,custipid varchar2(64) -- 借款人在网商的会员ID
    ,custiproleid varchar2(64) -- 借款人在网商的会员角色ID
    ,sex varchar2(2) -- 性别
    ,transmode varchar2(64) -- 债转模式
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
grant select on ${iol_schema}.icms_mybkzq_cs_extent_info to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzq_cs_extent_info to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzq_cs_extent_info to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzq_cs_extent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzq_cs_extent_info is '网商贷债权直转初审数据信息';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.serialno is '信贷流水号';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.applyno is '债转申请单据号';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.businessscene is '业务类型';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.businesstag is '与合作机构合作的业务标识';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.mobile is '借款人手机号';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.address is '地址详情';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.prov is '省份';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.city is '城市';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.area is '区域';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.certvalidenddate is '证件有效期';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.busdatareqdate is '数据采集时间';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.businfoexistflag is '是否存有效工商信息';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.notexistreason is '无有效工商信息原因';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfoname is '公司名';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfolawer is '法定代表人';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisterno is '工商注册号';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisterdate is '注册时间';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisteraddress is '注册地址';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisteraddressareacode is '注册地址行政区编号';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisteraddressarea is '注册地省市区';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisterfund is '注册资本(万元)';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfofundcurrency is '币种';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfotradecode is '2017行业代码';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfomanagerange is '经营范围';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfoorgcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinforegisterdepartment is '注册工商局';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfostatusid is '经营状态';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfostatusdesc is '经营状态描述';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfolastcheckyear is '最后年检年度';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfomanagebegindate is '经营开始时间';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfomanageenddate is '经营结束时间';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfoopendate is '开业时间';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfocompanytype is '公司类型';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.companyinfoeconomictype is '公司经济类型';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.targetjyflag1 is '客群经营标识';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.industryname is '客群主营行业';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.custipid is '借款人在网商的会员ID';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.custiproleid is '借款人在网商的会员角色ID';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.sex is '性别';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.transmode is '债转模式';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybkzq_cs_extent_info.etl_timestamp is 'ETL处理时间戳';
