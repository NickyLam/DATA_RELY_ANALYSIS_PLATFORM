/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_business_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_business_contract(
    serialno varchar2(32) -- 合同号
    ,relativelhdserialno varchar2(32) -- 关联联合贷申请号
    ,relativezdserialno varchar2(32) -- 关联助贷申请号
    ,parentserialno varchar2(32) -- 关联额度合同号
    ,accountid varchar2(64) -- 授信ID
    ,approvestatus varchar2(32) -- 审批状态
    ,status varchar2(16) -- 合同状态
    ,customerid varchar2(16) -- 客户号
    ,customername varchar2(200) -- 姓名
    ,certtype varchar2(32) -- 证件类型
    ,certid varchar2(64) -- 证件号码
    ,phone varchar2(64) -- 手机号
    ,productid varchar2(32) -- 产品编号
    ,productmode varchar2(16) -- 产品类别
    ,businesssum number(24,6) -- 合同金额
    ,balance number(24,6) -- 合同余额
    ,intrate number(20,6) -- 利率
    ,currency varchar2(16) -- 币种
    ,businessflag varchar2(10) -- 业务类型
    ,startdate date -- 合同起始日
    ,enddate date -- 合同到期日
    ,termmonth number(22) -- 期限
    ,usage varchar2(32) -- 用途
    ,loanid varchar2(64) -- 用信申请流水号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,newcrdtestimatlmt number(24,6) -- 预估额度
    ,closedate varchar2(8) -- 字节账户关闭日期
    ,closetype varchar2(1) -- 字节关闭类型：1：账户注销 2：账户关闭
    ,dailyrate number(20,6) -- 授信日利率
    ,availablebalance number(24,6) -- 可用额度余额
    ,companyindustry varchar2(64) -- 所属行业
    ,intraindustrytype varchar2(64) -- 贷款投向
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
grant select on ${iol_schema}.icms_zjbk_business_contract to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_business_contract to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_business_contract to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_business_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_business_contract is '字节合同信息表';
comment on column ${iol_schema}.icms_zjbk_business_contract.serialno is '合同号';
comment on column ${iol_schema}.icms_zjbk_business_contract.relativelhdserialno is '关联联合贷申请号';
comment on column ${iol_schema}.icms_zjbk_business_contract.relativezdserialno is '关联助贷申请号';
comment on column ${iol_schema}.icms_zjbk_business_contract.parentserialno is '关联额度合同号';
comment on column ${iol_schema}.icms_zjbk_business_contract.accountid is '授信ID';
comment on column ${iol_schema}.icms_zjbk_business_contract.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_zjbk_business_contract.status is '合同状态';
comment on column ${iol_schema}.icms_zjbk_business_contract.customerid is '客户号';
comment on column ${iol_schema}.icms_zjbk_business_contract.customername is '姓名';
comment on column ${iol_schema}.icms_zjbk_business_contract.certtype is '证件类型';
comment on column ${iol_schema}.icms_zjbk_business_contract.certid is '证件号码';
comment on column ${iol_schema}.icms_zjbk_business_contract.phone is '手机号';
comment on column ${iol_schema}.icms_zjbk_business_contract.productid is '产品编号';
comment on column ${iol_schema}.icms_zjbk_business_contract.productmode is '产品类别';
comment on column ${iol_schema}.icms_zjbk_business_contract.businesssum is '合同金额';
comment on column ${iol_schema}.icms_zjbk_business_contract.balance is '合同余额';
comment on column ${iol_schema}.icms_zjbk_business_contract.intrate is '利率';
comment on column ${iol_schema}.icms_zjbk_business_contract.currency is '币种';
comment on column ${iol_schema}.icms_zjbk_business_contract.businessflag is '业务类型';
comment on column ${iol_schema}.icms_zjbk_business_contract.startdate is '合同起始日';
comment on column ${iol_schema}.icms_zjbk_business_contract.enddate is '合同到期日';
comment on column ${iol_schema}.icms_zjbk_business_contract.termmonth is '期限';
comment on column ${iol_schema}.icms_zjbk_business_contract.usage is '用途';
comment on column ${iol_schema}.icms_zjbk_business_contract.loanid is '用信申请流水号';
comment on column ${iol_schema}.icms_zjbk_business_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zjbk_business_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zjbk_business_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zjbk_business_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_zjbk_business_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_zjbk_business_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_zjbk_business_contract.newcrdtestimatlmt is '预估额度';
comment on column ${iol_schema}.icms_zjbk_business_contract.closedate is '字节账户关闭日期';
comment on column ${iol_schema}.icms_zjbk_business_contract.closetype is '字节关闭类型：1：账户注销 2：账户关闭';
comment on column ${iol_schema}.icms_zjbk_business_contract.dailyrate is '授信日利率';
comment on column ${iol_schema}.icms_zjbk_business_contract.availablebalance is '可用额度余额';
comment on column ${iol_schema}.icms_zjbk_business_contract.companyindustry is '所属行业';
comment on column ${iol_schema}.icms_zjbk_business_contract.intraindustrytype is '贷款投向';
comment on column ${iol_schema}.icms_zjbk_business_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_business_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_business_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_business_contract.etl_timestamp is 'ETL处理时间戳';
