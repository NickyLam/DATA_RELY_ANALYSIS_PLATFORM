/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_credit_line
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_credit_line
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_credit_line purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_credit_line(
    datadt varchar2(10) -- 数据日期
    ,limitno varchar2(64) -- 额度编号
    ,custid varchar2(40) -- 客户号
    ,custidtype varchar2(20) -- 客户证件类型
    ,custidno varchar2(30) -- 客户证件号码
    ,custname varchar2(60) -- 客户名称
    ,ccycd varchar2(10) -- 币种
    ,orgid varchar2(20) -- 机构号
    ,circulflg varchar2(1) -- 循环额度标志
    ,startdate varchar2(10) -- 微众授信起始日期
    ,maturitydate varchar2(10) -- 额度到期日期
    ,creditline number(20,4) -- 授信额度
    ,uncreditline number(20,4) -- 未动拨授信额度
    ,credittype varchar2(10) -- 授信业务类型
    ,begindate varchar2(10) -- 生效日期
    ,trandate varchar2(10) -- 发生日期
    ,initdate varchar2(10) -- 授信开始日期
    ,limitreportno varchar2(32) -- 授信协议号
    ,status varchar2(10) -- 协议状态
    ,freezeflag varchar2(10) -- 冻结标志
    ,adjustdate varchar2(10) -- 续期日期
    ,extenddate varchar2(10) -- 更新时间
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,balstatus varchar2(32) -- 额度状态
    ,customerid varchar2(64) -- 我行客户号
    ,inputid varchar2(20) -- 行内客户经理编号
    ,baserialno varchar2(64) -- 授信编号
    ,quotamod number(24,6) -- 模型核额额度
    ,hxcontractserialno varchar2(30) -- 华兴额度合同编号
    ,hxproductid varchar2(32) -- 华兴额度产品类型
    ,hxoperateorgid varchar2(64) -- 华兴经办机构
    ,hxmanageorgid varchar2(32) -- 华兴管理机构
    ,hxstartdate date -- 华兴额度合同开始日期
    ,hxmaturity date -- 华兴额度合同到期日期
    ,hxstatus varchar2(48) -- 华兴额度合同状态
    ,hxiscycle varchar2(5) -- 华兴额度循环标志
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
grant select on ${iol_schema}.icms_wyd_credit_line to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_credit_line to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_credit_line to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_credit_line to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_credit_line is '额度信息';
comment on column ${iol_schema}.icms_wyd_credit_line.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_credit_line.limitno is '额度编号';
comment on column ${iol_schema}.icms_wyd_credit_line.custid is '客户号';
comment on column ${iol_schema}.icms_wyd_credit_line.custidtype is '客户证件类型';
comment on column ${iol_schema}.icms_wyd_credit_line.custidno is '客户证件号码';
comment on column ${iol_schema}.icms_wyd_credit_line.custname is '客户名称';
comment on column ${iol_schema}.icms_wyd_credit_line.ccycd is '币种';
comment on column ${iol_schema}.icms_wyd_credit_line.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_credit_line.circulflg is '循环额度标志';
comment on column ${iol_schema}.icms_wyd_credit_line.startdate is '微众授信起始日期';
comment on column ${iol_schema}.icms_wyd_credit_line.maturitydate is '额度到期日期';
comment on column ${iol_schema}.icms_wyd_credit_line.creditline is '授信额度';
comment on column ${iol_schema}.icms_wyd_credit_line.uncreditline is '未动拨授信额度';
comment on column ${iol_schema}.icms_wyd_credit_line.credittype is '授信业务类型';
comment on column ${iol_schema}.icms_wyd_credit_line.begindate is '生效日期';
comment on column ${iol_schema}.icms_wyd_credit_line.trandate is '发生日期';
comment on column ${iol_schema}.icms_wyd_credit_line.initdate is '授信开始日期';
comment on column ${iol_schema}.icms_wyd_credit_line.limitreportno is '授信协议号';
comment on column ${iol_schema}.icms_wyd_credit_line.status is '协议状态';
comment on column ${iol_schema}.icms_wyd_credit_line.freezeflag is '冻结标志';
comment on column ${iol_schema}.icms_wyd_credit_line.adjustdate is '续期日期';
comment on column ${iol_schema}.icms_wyd_credit_line.extenddate is '更新时间';
comment on column ${iol_schema}.icms_wyd_credit_line.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_credit_line.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_credit_line.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_credit_line.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_credit_line.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_credit_line.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_credit_line.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_credit_line.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_credit_line.balstatus is '额度状态';
comment on column ${iol_schema}.icms_wyd_credit_line.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_credit_line.inputid is '行内客户经理编号';
comment on column ${iol_schema}.icms_wyd_credit_line.baserialno is '授信编号';
comment on column ${iol_schema}.icms_wyd_credit_line.quotamod is '模型核额额度';
comment on column ${iol_schema}.icms_wyd_credit_line.hxcontractserialno is '华兴额度合同编号';
comment on column ${iol_schema}.icms_wyd_credit_line.hxproductid is '华兴额度产品类型';
comment on column ${iol_schema}.icms_wyd_credit_line.hxoperateorgid is '华兴经办机构';
comment on column ${iol_schema}.icms_wyd_credit_line.hxmanageorgid is '华兴管理机构';
comment on column ${iol_schema}.icms_wyd_credit_line.hxstartdate is '华兴额度合同开始日期';
comment on column ${iol_schema}.icms_wyd_credit_line.hxmaturity is '华兴额度合同到期日期';
comment on column ${iol_schema}.icms_wyd_credit_line.hxstatus is '华兴额度合同状态';
comment on column ${iol_schema}.icms_wyd_credit_line.hxiscycle is '华兴额度循环标志';
comment on column ${iol_schema}.icms_wyd_credit_line.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_credit_line.etl_timestamp is 'ETL处理时间戳';
