/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_invoice_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_invoice_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_invoice_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_invoice_info(
    id varchar2(60) -- ID
    ,product_no varchar2(12) -- 产品类型编号
    ,contract_id varchar2(60) -- 协议ID
    ,branch_no varchar2(18) -- 交易机构编号
    ,draft_number varchar2(45) -- 票据号码
    ,invoice_code varchar2(75) -- 发票代码
    ,invoice_number varchar2(45) -- 发票号码
    ,invoice_btno varchar2(150) -- 发票批次号
    ,invoice_date varchar2(12) -- 发票日期
    ,scale number(5,2) -- 占用比例
    ,invoice_amount number(18,2) -- 发票金额
    ,draft_ocp_amount number(18,2) -- 票据占用金额
    ,disaffirm_status varchar2(3) -- 状态
    ,invoice_curcd varchar2(5) -- 发票据代码
    ,invoice_type varchar2(6) -- 发票据类型
    ,remark varchar2(1152) -- 澶囨敞
    ,checkcode varchar2(150) -- 校验码
    ,create_time timestamp -- 创建时间
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
grant select on ${iol_schema}.bdms_cpes_invoice_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_invoice_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_invoice_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_invoice_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_invoice_info is '发票信息表';
comment on column ${iol_schema}.bdms_cpes_invoice_info.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_invoice_info.product_no is '产品类型编号';
comment on column ${iol_schema}.bdms_cpes_invoice_info.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_cpes_invoice_info.branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_cpes_invoice_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_code is '发票代码';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_number is '发票号码';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_btno is '发票批次号';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_date is '发票日期';
comment on column ${iol_schema}.bdms_cpes_invoice_info.scale is '占用比例';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_amount is '发票金额';
comment on column ${iol_schema}.bdms_cpes_invoice_info.draft_ocp_amount is '票据占用金额';
comment on column ${iol_schema}.bdms_cpes_invoice_info.disaffirm_status is '状态';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_curcd is '发票据代码';
comment on column ${iol_schema}.bdms_cpes_invoice_info.invoice_type is '发票据类型';
comment on column ${iol_schema}.bdms_cpes_invoice_info.remark is '澶囨敞';
comment on column ${iol_schema}.bdms_cpes_invoice_info.checkcode is '校验码';
comment on column ${iol_schema}.bdms_cpes_invoice_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cpes_invoice_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_invoice_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_invoice_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_invoice_info.etl_timestamp is 'ETL处理时间戳';
