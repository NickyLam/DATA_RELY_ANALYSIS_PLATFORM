/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_business_writeoff
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_business_writeoff
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_business_writeoff purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_business_writeoff(
    writeoffno varchar2(64) -- 入账单编号
    ,onarrears number(24,6) -- 已核销表内息
    ,inputdate varchar2(64) -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,finreceivables number(24,6) -- 已核销财务应收款
    ,contractno varchar2(64) -- 合同流水号
    ,tmsp varchar2(64) -- 时间戳
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate varchar2(64) -- 更新日期
    ,customerid varchar2(64) -- 借款人编号
    ,duebillno varchar2(64) -- 借据流水号
    ,deleteflag varchar2(2) -- 删除标志
    ,principal number(24,6) -- 已核销本金金额
    ,offarrears number(24,6) -- 已核销表外息
    ,programno varchar2(64) -- 方案编号
    ,updateuserid varchar2(64) -- 更新人
    ,maturity date -- 到期日
    ,currency varchar2(3) -- 币种
    ,customername varchar2(100) -- 借款人名称
    ,remark varchar2(1000) -- 备注
    ,putoutdate date -- 发放日
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
grant select on ${iol_schema}.icms_ap_business_writeoff to ${iml_schema};
grant select on ${iol_schema}.icms_ap_business_writeoff to ${icl_schema};
grant select on ${iol_schema}.icms_ap_business_writeoff to ${idl_schema};
grant select on ${iol_schema}.icms_ap_business_writeoff to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_business_writeoff is '核销入账通知单';
comment on column ${iol_schema}.icms_ap_business_writeoff.writeoffno is '入账单编号';
comment on column ${iol_schema}.icms_ap_business_writeoff.onarrears is '已核销表内息';
comment on column ${iol_schema}.icms_ap_business_writeoff.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_business_writeoff.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_business_writeoff.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_business_writeoff.finreceivables is '已核销财务应收款';
comment on column ${iol_schema}.icms_ap_business_writeoff.contractno is '合同流水号';
comment on column ${iol_schema}.icms_ap_business_writeoff.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_business_writeoff.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_business_writeoff.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_business_writeoff.customerid is '借款人编号';
comment on column ${iol_schema}.icms_ap_business_writeoff.duebillno is '借据流水号';
comment on column ${iol_schema}.icms_ap_business_writeoff.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_business_writeoff.principal is '已核销本金金额';
comment on column ${iol_schema}.icms_ap_business_writeoff.offarrears is '已核销表外息';
comment on column ${iol_schema}.icms_ap_business_writeoff.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_business_writeoff.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_business_writeoff.maturity is '到期日';
comment on column ${iol_schema}.icms_ap_business_writeoff.currency is '币种';
comment on column ${iol_schema}.icms_ap_business_writeoff.customername is '借款人名称';
comment on column ${iol_schema}.icms_ap_business_writeoff.remark is '备注';
comment on column ${iol_schema}.icms_ap_business_writeoff.putoutdate is '发放日';
comment on column ${iol_schema}.icms_ap_business_writeoff.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_business_writeoff.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_business_writeoff.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_business_writeoff.etl_timestamp is 'ETL处理时间戳';
