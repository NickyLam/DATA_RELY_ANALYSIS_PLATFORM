/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_bill_adj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_bill_adj_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_bill_adj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_bill_adj_info(
    serno varchar2(32) -- 流水号
    ,failreason varchar2(500) -- 备注
    ,inputdate date -- 登记日期
    ,applytype varchar2(64) -- 申请类型
    ,packagenoold varchar2(32) -- 原批次包编号
    ,cusname varchar2(100) -- 客户名称
    ,pakagenameold varchar2(500) -- 原批次包名称
    ,inputuserid varchar2(64) -- 登记人
    ,approvestatus varchar2(10) -- 审批状态
    ,pakagename varchar2(300) -- 调整后批次包名称
    ,inputorgid varchar2(64) -- 登记机构
    ,flowtype varchar2(64) -- 流程类型
    ,packageno varchar2(32) -- 调整后批次包编号
    ,billno varchar2(32) -- 借据号
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
grant select on ${iol_schema}.icms_zxz_bill_adj_info to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_bill_adj_info to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_bill_adj_info to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_bill_adj_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_bill_adj_info is '支小再借据批次包调整';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.serno is '流水号';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.failreason is '备注';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.applytype is '申请类型';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.packagenoold is '原批次包编号';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.cusname is '客户名称';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.pakagenameold is '原批次包名称';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.pakagename is '调整后批次包名称';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.flowtype is '流程类型';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.packageno is '调整后批次包编号';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.billno is '借据号';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_bill_adj_info.etl_timestamp is 'ETL处理时间戳';
