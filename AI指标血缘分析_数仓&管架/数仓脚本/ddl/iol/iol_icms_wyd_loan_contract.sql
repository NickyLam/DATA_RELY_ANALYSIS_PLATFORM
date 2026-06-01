/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_loan_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_loan_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_loan_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_loan_contract(
    datadt varchar2(10) -- 数据日期
    ,contractno varchar2(64) -- 合同号
    ,limitno varchar2(64) -- 额度编号
    ,orgid varchar2(20) -- 机构号
    ,custid varchar2(40) -- 客户号
    ,custidtype varchar2(20) -- 客户证件类型
    ,custidno varchar2(30) -- 客户证件号码
    ,custname varchar2(60) -- 客户名称
    ,startdate varchar2(10) -- 贷款合同生效日期
    ,maturitydate varchar2(10) -- 贷款合同原始到期日
    ,enddate varchar2(10) -- 贷款合同终止日期
    ,ccycd varchar2(10) -- 币种
    ,loanflg varchar2(1) -- 银（社）团贷款标志
    ,subloanflg varchar2(1) -- 转贷款标志
    ,contractamt number(20,4) -- 贷款合同金额
    ,acctno varchar2(40) -- 帐号
    ,accttype varchar2(10) -- 账户类型
    ,enterpriseemail varchar2(100) -- 企业电子邮箱
    ,legalemail varchar2(100) -- 法定代表人邮箱
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,contractstatus varchar2(6) -- 合同状态
    ,credittype varchar2(64) -- 授信类型
    ,applytype varchar2(64) -- 申请类型
    ,baseratetype varchar2(4) -- 基准利率类型
    ,rateadjusttype varchar2(6) -- 利率调整方式
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
grant select on ${iol_schema}.icms_wyd_loan_contract to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_loan_contract to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_loan_contract to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_loan_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_loan_contract is '贷款合同信息';
comment on column ${iol_schema}.icms_wyd_loan_contract.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_loan_contract.contractno is '合同号';
comment on column ${iol_schema}.icms_wyd_loan_contract.limitno is '额度编号';
comment on column ${iol_schema}.icms_wyd_loan_contract.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_loan_contract.custid is '客户号';
comment on column ${iol_schema}.icms_wyd_loan_contract.custidtype is '客户证件类型';
comment on column ${iol_schema}.icms_wyd_loan_contract.custidno is '客户证件号码';
comment on column ${iol_schema}.icms_wyd_loan_contract.custname is '客户名称';
comment on column ${iol_schema}.icms_wyd_loan_contract.startdate is '贷款合同生效日期';
comment on column ${iol_schema}.icms_wyd_loan_contract.maturitydate is '贷款合同原始到期日';
comment on column ${iol_schema}.icms_wyd_loan_contract.enddate is '贷款合同终止日期';
comment on column ${iol_schema}.icms_wyd_loan_contract.ccycd is '币种';
comment on column ${iol_schema}.icms_wyd_loan_contract.loanflg is '银（社）团贷款标志';
comment on column ${iol_schema}.icms_wyd_loan_contract.subloanflg is '转贷款标志';
comment on column ${iol_schema}.icms_wyd_loan_contract.contractamt is '贷款合同金额';
comment on column ${iol_schema}.icms_wyd_loan_contract.acctno is '帐号';
comment on column ${iol_schema}.icms_wyd_loan_contract.accttype is '账户类型';
comment on column ${iol_schema}.icms_wyd_loan_contract.enterpriseemail is '企业电子邮箱';
comment on column ${iol_schema}.icms_wyd_loan_contract.legalemail is '法定代表人邮箱';
comment on column ${iol_schema}.icms_wyd_loan_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_loan_contract.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_loan_contract.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_loan_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_loan_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_loan_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_loan_contract.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_loan_contract.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_loan_contract.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_loan_contract.contractstatus is '合同状态';
comment on column ${iol_schema}.icms_wyd_loan_contract.credittype is '授信类型';
comment on column ${iol_schema}.icms_wyd_loan_contract.applytype is '申请类型';
comment on column ${iol_schema}.icms_wyd_loan_contract.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_wyd_loan_contract.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_wyd_loan_contract.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_loan_contract.etl_timestamp is 'ETL处理时间戳';
