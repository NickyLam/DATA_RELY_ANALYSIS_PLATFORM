/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hlw_loan_product_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hlw_loan_product_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hlw_loan_product_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hlw_loan_product_info(
    serialno varchar2(32) -- 流水号
    ,productid varchar2(12) -- 产品编号
    ,productname varchar2(200) -- 产品名称
    ,managename varchar2(200) -- 管理方名称
    ,channelno varchar2(100) -- 渠道性质
    ,certid varchar2(60) -- 管理方统一社会信用代码
    ,investmentprop number(24,8) -- 出资比例
    ,operationtype varchar2(6) -- 数据操作类型:01-新增02-编辑
    ,oldserialno varchar2(32) -- 原数据流水号
    ,datastatus varchar2(32) -- 数据状态：01-启用；02-停用
    ,approvestatus varchar2(64) -- 流程状态
    ,inputuserid varchar2(16) -- 登记人
    ,inputorgid varchar2(16) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(16) -- 更新人
    ,updateorgid varchar2(16) -- 更新机构
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_hlw_loan_product_info to ${iml_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_info to ${icl_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_info to ${idl_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hlw_loan_product_info is '互联网贷款产品信息表';
comment on column ${iol_schema}.icms_hlw_loan_product_info.serialno is '流水号';
comment on column ${iol_schema}.icms_hlw_loan_product_info.productid is '产品编号';
comment on column ${iol_schema}.icms_hlw_loan_product_info.productname is '产品名称';
comment on column ${iol_schema}.icms_hlw_loan_product_info.managename is '管理方名称';
comment on column ${iol_schema}.icms_hlw_loan_product_info.channelno is '渠道性质';
comment on column ${iol_schema}.icms_hlw_loan_product_info.certid is '管理方统一社会信用代码';
comment on column ${iol_schema}.icms_hlw_loan_product_info.investmentprop is '出资比例';
comment on column ${iol_schema}.icms_hlw_loan_product_info.operationtype is '数据操作类型:01-新增02-编辑';
comment on column ${iol_schema}.icms_hlw_loan_product_info.oldserialno is '原数据流水号';
comment on column ${iol_schema}.icms_hlw_loan_product_info.datastatus is '数据状态：01-启用；02-停用';
comment on column ${iol_schema}.icms_hlw_loan_product_info.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_hlw_loan_product_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_hlw_loan_product_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_hlw_loan_product_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_hlw_loan_product_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_hlw_loan_product_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_hlw_loan_product_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_hlw_loan_product_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_hlw_loan_product_info.etl_timestamp is 'ETL处理时间戳';
