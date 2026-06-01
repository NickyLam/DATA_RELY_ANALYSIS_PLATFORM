/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_commercial_doc_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_commercial_doc_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_commercial_doc_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_commercial_doc_info(
    serialno varchar2(64) -- 流水号
    ,contractserialno varchar2(30) -- 合同流水号
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,payername varchar2(200) -- 开票人客户名称
    ,currency varchar2(3) -- 商业单据币种
    ,amounttax number(24,6) -- 商业单据金额（发票含税金额）
    ,billdoctype varchar2(3) -- 商业单据类型(BillDocType)
    ,issuerdate date -- 开票时间
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,invoicecode varchar2(64) -- 单据ID
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
grant select on ${iol_schema}.icms_commercial_doc_info to ${iml_schema};
grant select on ${iol_schema}.icms_commercial_doc_info to ${icl_schema};
grant select on ${iol_schema}.icms_commercial_doc_info to ${idl_schema};
grant select on ${iol_schema}.icms_commercial_doc_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_commercial_doc_info is '商业单据信息表';
comment on column ${iol_schema}.icms_commercial_doc_info.serialno is '流水号';
comment on column ${iol_schema}.icms_commercial_doc_info.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_commercial_doc_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_commercial_doc_info.customername is '客户名称';
comment on column ${iol_schema}.icms_commercial_doc_info.payername is '开票人客户名称';
comment on column ${iol_schema}.icms_commercial_doc_info.currency is '商业单据币种';
comment on column ${iol_schema}.icms_commercial_doc_info.amounttax is '商业单据金额（发票含税金额）';
comment on column ${iol_schema}.icms_commercial_doc_info.billdoctype is '商业单据类型(BillDocType)';
comment on column ${iol_schema}.icms_commercial_doc_info.issuerdate is '开票时间';
comment on column ${iol_schema}.icms_commercial_doc_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_commercial_doc_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_commercial_doc_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_commercial_doc_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_commercial_doc_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_commercial_doc_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_commercial_doc_info.invoicecode is '单据ID';
comment on column ${iol_schema}.icms_commercial_doc_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_commercial_doc_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_commercial_doc_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_commercial_doc_info.etl_timestamp is 'ETL处理时间戳';
