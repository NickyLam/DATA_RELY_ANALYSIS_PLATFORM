/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_debt_payment_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_debt_payment_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_debt_payment_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_debt_payment_list(
    serialno varchar2(64) -- 流水号
    ,relativeserialno varchar2(64) -- 关联流水号
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,debtrepayassetid varchar2(64) -- 抵债资产编号
    ,debtrepayassetname varchar2(200) -- 抵债资产名称
    ,debtrepaysum number(24,6) -- 抵扣债权金额
    ,debtoffsetamount number(24,6) -- 抵债金额
    ,receivedate date -- 抵债日期
    ,debtrepayassettype varchar2(48) -- 抵债资产类型(code:DebtRepaymentType)
    ,debtrepaymenttype varchar2(48) -- 抵债类型(code:DebtRepayAssetType)
    ,status varchar2(10) -- 处理状态(code:CollectResult)
    ,amount number(38,0) -- 数量
    ,stockcode varchar2(100) -- 股票代码/权证号
    ,propertylocation varchar2(200) -- 房产位置
    ,remark varchar2(3000) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,operateuserid varchar2(64) -- 经办客户经理
    ,operateorgid varchar2(64) -- 经办客户经理所属机构
    ,operatedate date -- 经办时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,putoutorgid varchar2(20) -- 账务机构
    ,originaltaxfees number(24,6) -- 原相关税费
    ,lastevaltime date -- 估值日期
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
grant select on ${iol_schema}.icms_debt_payment_list to ${iml_schema};
grant select on ${iol_schema}.icms_debt_payment_list to ${icl_schema};
grant select on ${iol_schema}.icms_debt_payment_list to ${idl_schema};
grant select on ${iol_schema}.icms_debt_payment_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_debt_payment_list is '抵债资产信息表';
comment on column ${iol_schema}.icms_debt_payment_list.serialno is '流水号';
comment on column ${iol_schema}.icms_debt_payment_list.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_debt_payment_list.customerid is '客户编号';
comment on column ${iol_schema}.icms_debt_payment_list.customername is '客户名称';
comment on column ${iol_schema}.icms_debt_payment_list.debtrepayassetid is '抵债资产编号';
comment on column ${iol_schema}.icms_debt_payment_list.debtrepayassetname is '抵债资产名称';
comment on column ${iol_schema}.icms_debt_payment_list.debtrepaysum is '抵扣债权金额';
comment on column ${iol_schema}.icms_debt_payment_list.debtoffsetamount is '抵债金额';
comment on column ${iol_schema}.icms_debt_payment_list.receivedate is '抵债日期';
comment on column ${iol_schema}.icms_debt_payment_list.debtrepayassettype is '抵债资产类型(code:DebtRepaymentType)';
comment on column ${iol_schema}.icms_debt_payment_list.debtrepaymenttype is '抵债类型(code:DebtRepayAssetType)';
comment on column ${iol_schema}.icms_debt_payment_list.status is '处理状态(code:CollectResult)';
comment on column ${iol_schema}.icms_debt_payment_list.amount is '数量';
comment on column ${iol_schema}.icms_debt_payment_list.stockcode is '股票代码/权证号';
comment on column ${iol_schema}.icms_debt_payment_list.propertylocation is '房产位置';
comment on column ${iol_schema}.icms_debt_payment_list.remark is '备注';
comment on column ${iol_schema}.icms_debt_payment_list.inputuserid is '登记人';
comment on column ${iol_schema}.icms_debt_payment_list.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_debt_payment_list.inputdate is '登记日期';
comment on column ${iol_schema}.icms_debt_payment_list.operateuserid is '经办客户经理';
comment on column ${iol_schema}.icms_debt_payment_list.operateorgid is '经办客户经理所属机构';
comment on column ${iol_schema}.icms_debt_payment_list.operatedate is '经办时间';
comment on column ${iol_schema}.icms_debt_payment_list.updateuserid is '更新人';
comment on column ${iol_schema}.icms_debt_payment_list.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_debt_payment_list.updatedate is '更新日期';
comment on column ${iol_schema}.icms_debt_payment_list.putoutorgid is '账务机构';
comment on column ${iol_schema}.icms_debt_payment_list.originaltaxfees is '原相关税费';
comment on column ${iol_schema}.icms_debt_payment_list.lastevaltime is '估值日期';
comment on column ${iol_schema}.icms_debt_payment_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_debt_payment_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_debt_payment_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_debt_payment_list.etl_timestamp is 'ETL处理时间戳';
