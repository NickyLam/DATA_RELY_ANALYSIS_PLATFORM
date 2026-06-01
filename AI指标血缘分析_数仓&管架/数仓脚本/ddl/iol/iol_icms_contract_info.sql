/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_contract_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_contract_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_contract_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_contract_info(
    serialno varchar2(32) -- 流水号
    ,objecttype varchar2(32) -- 对象类型
    ,objectno varchar2(18) -- 对象编号
    ,contractcurrency varchar2(18) -- 合同币种
    ,remark varchar2(200) -- 备注
    ,purchaserid varchar2(32) -- 买方代码
    ,bargainorname varchar2(80) -- 卖方名称
    ,inputdate varchar2(10) -- 登记日期
    ,contractsum number(24,6) -- 合同金额
    ,paymethod varchar2(18) -- 付款方式
    ,begindate varchar2(10) -- 合同生效日
    ,bargainorid varchar2(32) -- 卖方代码
    ,enddate varchar2(10) -- 合同到期日
    ,contractdescribe varchar2(200) -- 货物名称
    ,inputuserid varchar2(32) -- 登记人
    ,purchasername varchar2(80) -- 买方名称
    ,invoiceno varchar2(32) -- 增值税发票号码
    ,contractno varchar2(32) -- 贸易合同号
    ,signdate varchar2(10) -- 合同签订日
    ,inputorgid varchar2(32) -- 登记机构
    ,updatedate varchar2(10) -- 更新日期
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
grant select on ${iol_schema}.icms_contract_info to ${iml_schema};
grant select on ${iol_schema}.icms_contract_info to ${icl_schema};
grant select on ${iol_schema}.icms_contract_info to ${idl_schema};
grant select on ${iol_schema}.icms_contract_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_contract_info is '贸易合同信息';
comment on column ${iol_schema}.icms_contract_info.serialno is '流水号';
comment on column ${iol_schema}.icms_contract_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_contract_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_contract_info.contractcurrency is '合同币种';
comment on column ${iol_schema}.icms_contract_info.remark is '备注';
comment on column ${iol_schema}.icms_contract_info.purchaserid is '买方代码';
comment on column ${iol_schema}.icms_contract_info.bargainorname is '卖方名称';
comment on column ${iol_schema}.icms_contract_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_contract_info.contractsum is '合同金额';
comment on column ${iol_schema}.icms_contract_info.paymethod is '付款方式';
comment on column ${iol_schema}.icms_contract_info.begindate is '合同生效日';
comment on column ${iol_schema}.icms_contract_info.bargainorid is '卖方代码';
comment on column ${iol_schema}.icms_contract_info.enddate is '合同到期日';
comment on column ${iol_schema}.icms_contract_info.contractdescribe is '货物名称';
comment on column ${iol_schema}.icms_contract_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_contract_info.purchasername is '买方名称';
comment on column ${iol_schema}.icms_contract_info.invoiceno is '增值税发票号码';
comment on column ${iol_schema}.icms_contract_info.contractno is '贸易合同号';
comment on column ${iol_schema}.icms_contract_info.signdate is '合同签订日';
comment on column ${iol_schema}.icms_contract_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_contract_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_contract_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_contract_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_contract_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_contract_info.etl_timestamp is 'ETL处理时间戳';
