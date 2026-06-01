/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_invoice_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_invoice_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_invoice_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_invoice_info(
    serialno varchar2(32) -- 流水号
    ,objecttype varchar2(32) -- 对象类型
    ,objectno varchar2(18) -- 对象编号
    ,invoiceno varchar2(30) -- 发票号码
    ,tradetype varchar2(18) -- 贸易方式
    ,makeoutdate varchar2(10) -- 开票日期
    ,inputuserid varchar2(32) -- 登记人
    ,purchaserid varchar2(32) -- 买方代码
    ,purchasername varchar2(80) -- 买方名称
    ,remark varchar2(200) -- 备注
    ,bargainorid varchar2(32) -- 卖方代码
    ,inputorgid varchar2(32) -- 登记机构
    ,tradeproduct varchar2(200) -- 贸易产品
    ,invoicecurrency varchar2(18) -- 发票币种
    ,bargainorname varchar2(80) -- 卖方名称
    ,updatedate varchar2(10) -- 更新日期
    ,invoicesum number(24,6) -- 发票金额
    ,inputdate varchar2(10) -- 登记日期
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
grant select on ${iol_schema}.icms_invoice_info to ${iml_schema};
grant select on ${iol_schema}.icms_invoice_info to ${icl_schema};
grant select on ${iol_schema}.icms_invoice_info to ${idl_schema};
grant select on ${iol_schema}.icms_invoice_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_invoice_info is '相关发票信息';
comment on column ${iol_schema}.icms_invoice_info.serialno is '流水号';
comment on column ${iol_schema}.icms_invoice_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_invoice_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_invoice_info.invoiceno is '发票号码';
comment on column ${iol_schema}.icms_invoice_info.tradetype is '贸易方式';
comment on column ${iol_schema}.icms_invoice_info.makeoutdate is '开票日期';
comment on column ${iol_schema}.icms_invoice_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_invoice_info.purchaserid is '买方代码';
comment on column ${iol_schema}.icms_invoice_info.purchasername is '买方名称';
comment on column ${iol_schema}.icms_invoice_info.remark is '备注';
comment on column ${iol_schema}.icms_invoice_info.bargainorid is '卖方代码';
comment on column ${iol_schema}.icms_invoice_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_invoice_info.tradeproduct is '贸易产品';
comment on column ${iol_schema}.icms_invoice_info.invoicecurrency is '发票币种';
comment on column ${iol_schema}.icms_invoice_info.bargainorname is '卖方名称';
comment on column ${iol_schema}.icms_invoice_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_invoice_info.invoicesum is '发票金额';
comment on column ${iol_schema}.icms_invoice_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_invoice_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_invoice_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_invoice_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_invoice_info.etl_timestamp is 'ETL处理时间戳';
