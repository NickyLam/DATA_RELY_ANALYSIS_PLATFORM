/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_payment_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_payment_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_payment_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_payment_detail(
    datadt varchar2(10) -- 数据日期
    ,operorg varchar2(10) -- 合作机构号
    ,contractno varchar2(64) -- 借款合同号
    ,lendingref varchar2(64) -- 借据号
    ,refno varchar2(32) -- 交易流水号
    ,ppay number(16,2) -- 还本金额
    ,ipay number(16,2) -- 还利息金额
    ,pppay number(16,2) -- 还罚息
    ,feerepay number(16,2) -- 还费用
    ,type varchar2(2) -- 还款类型
    ,insurancepaymentflag varchar2(1) -- 保险代偿标志
    ,insurancepaymentdate varchar2(10) -- 保险代偿日期
    ,transdate varchar2(8) -- 交易日期
    ,fundprincipal number(16,2) -- 归属于资金端还本金额
    ,fundinterest number(16,2) -- 归属于资金端还利息金额
    ,fundpenalty number(16,2) -- 归属于资金端还罚息
    ,fundfee number(16,2) -- 归属于资金端还费用
    ,billprincipal number(16,2) -- 归属于票据还本金额
    ,billinterest number(16,2) -- 归属于票据还利息金额
    ,billpenalty number(16,2) -- 归属于票据还罚息
    ,billfee number(16,2) -- 归属于票据还费用
    ,ipaybn number(16,2) -- 还表内利息
    ,fpaybn number(16,2) -- 还表内罚息
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
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
grant select on ${iol_schema}.icms_wyd_payment_detail to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_payment_detail to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_payment_detail to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_payment_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_payment_detail is '还款明细文件';
comment on column ${iol_schema}.icms_wyd_payment_detail.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_payment_detail.operorg is '合作机构号';
comment on column ${iol_schema}.icms_wyd_payment_detail.contractno is '借款合同号';
comment on column ${iol_schema}.icms_wyd_payment_detail.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_payment_detail.refno is '交易流水号';
comment on column ${iol_schema}.icms_wyd_payment_detail.ppay is '还本金额';
comment on column ${iol_schema}.icms_wyd_payment_detail.ipay is '还利息金额';
comment on column ${iol_schema}.icms_wyd_payment_detail.pppay is '还罚息';
comment on column ${iol_schema}.icms_wyd_payment_detail.feerepay is '还费用';
comment on column ${iol_schema}.icms_wyd_payment_detail.type is '还款类型';
comment on column ${iol_schema}.icms_wyd_payment_detail.insurancepaymentflag is '保险代偿标志';
comment on column ${iol_schema}.icms_wyd_payment_detail.insurancepaymentdate is '保险代偿日期';
comment on column ${iol_schema}.icms_wyd_payment_detail.transdate is '交易日期';
comment on column ${iol_schema}.icms_wyd_payment_detail.fundprincipal is '归属于资金端还本金额';
comment on column ${iol_schema}.icms_wyd_payment_detail.fundinterest is '归属于资金端还利息金额';
comment on column ${iol_schema}.icms_wyd_payment_detail.fundpenalty is '归属于资金端还罚息';
comment on column ${iol_schema}.icms_wyd_payment_detail.fundfee is '归属于资金端还费用';
comment on column ${iol_schema}.icms_wyd_payment_detail.billprincipal is '归属于票据还本金额';
comment on column ${iol_schema}.icms_wyd_payment_detail.billinterest is '归属于票据还利息金额';
comment on column ${iol_schema}.icms_wyd_payment_detail.billpenalty is '归属于票据还罚息';
comment on column ${iol_schema}.icms_wyd_payment_detail.billfee is '归属于票据还费用';
comment on column ${iol_schema}.icms_wyd_payment_detail.ipaybn is '还表内利息';
comment on column ${iol_schema}.icms_wyd_payment_detail.fpaybn is '还表内罚息';
comment on column ${iol_schema}.icms_wyd_payment_detail.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_payment_detail.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_payment_detail.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_payment_detail.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_payment_detail.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_payment_detail.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_payment_detail.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_payment_detail.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_payment_detail.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_payment_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_payment_detail.etl_timestamp is 'ETL处理时间戳';
