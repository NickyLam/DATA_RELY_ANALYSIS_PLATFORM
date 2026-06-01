/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_fm_business_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_fm_business_attach
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_fm_business_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_fm_business_attach(
    serialno varchar2(64) -- 流水号
    ,baserialno varchar2(64) -- 授信编号
    ,bcserialno varchar2(64) -- 合同编号
    ,bpserialno varchar2(64) -- 放款编号
    ,fundno varchar2(32) -- 资方编号
    ,applyno varchar2(64) -- 全局流水号（第三方）
    ,repaytype varchar2(4) -- 还款方式
    ,customerrate number(15,8) -- 对客利率
    ,recommendyearrate number(15,8) -- 推荐资金方合同年利率
    ,guaranteeinstitution varchar2(32) -- 担保机构标识
    ,assetidentification varchar2(32) -- 资产标识
    ,creditflag varchar2(10) -- 征信标识
    ,bankreservephone varchar2(16) -- 银行卡预留手机号
    ,paymentaccountno varchar2(64) -- 入账账户
    ,paymentaccountname varchar2(500) -- 入账账户名
    ,paymentaccountbankname varchar2(500) -- 入账账户开户机构
    ,paymentaccounttype varchar2(64) -- 入账账户类型
    ,finaldecisioncode varchar2(20) -- 最终决策结果标识
    ,finalapplyamount number(24,6) -- 最终审批额度(元)
    ,finalapplyterm number(22,0) -- 最终审批期限
    ,extinfo varchar2(4000) -- 扩展信息
    ,riskfactorinfo varchar2(4000) -- 风险信息
    ,putoutfailcode varchar2(64) -- 放款失败编码
    ,putoutfailreason varchar2(500) -- 放款失败原因
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新时间
    ,imageprocstatus varchar2(10) -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
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
grant select on ${iol_schema}.icms_lhwd_fm_business_attach to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_fm_business_attach to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_fm_business_attach to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_fm_business_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_fm_business_attach is '联合网贷富民业务附属信息表';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.baserialno is '授信编号';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.bcserialno is '合同编号';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.bpserialno is '放款编号';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.fundno is '资方编号';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.applyno is '全局流水号（第三方）';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.repaytype is '还款方式';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.customerrate is '对客利率';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.recommendyearrate is '推荐资金方合同年利率';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.guaranteeinstitution is '担保机构标识';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.assetidentification is '资产标识';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.creditflag is '征信标识';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.bankreservephone is '银行卡预留手机号';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.paymentaccountno is '入账账户';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.paymentaccountname is '入账账户名';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.paymentaccountbankname is '入账账户开户机构';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.paymentaccounttype is '入账账户类型';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.finaldecisioncode is '最终决策结果标识';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.finalapplyamount is '最终审批额度(元)';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.finalapplyterm is '最终审批期限';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.extinfo is '扩展信息';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.riskfactorinfo is '风险信息';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.putoutfailcode is '放款失败编码';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.putoutfailreason is '放款失败原因';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.inputdate is '登记时间';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.imageprocstatus is '影像文件处理状态 1处理完全 2超过处理时限，影像有缺失';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_fm_business_attach.etl_timestamp is 'ETL处理时间戳';
