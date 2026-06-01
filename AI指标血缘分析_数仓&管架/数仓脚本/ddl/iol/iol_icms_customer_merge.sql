/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_merge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_merge
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_merge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_merge(
    serialno varchar2(64) -- 流水号
    ,megcustomerid varchar2(64) -- 合并客户号
    ,status varchar2(36) -- 当前状态
    ,inputuserid varchar2(64) -- 登记人
    ,customerid varchar2(16) -- 客户编号
    ,updateuserid varchar2(64) -- 更新人
    ,inputtime date -- 录入时间
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,reservecustomerid varchar2(32) -- 客户编号
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,customertype varchar2(36) -- 客户类型
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
grant select on ${iol_schema}.icms_customer_merge to ${iml_schema};
grant select on ${iol_schema}.icms_customer_merge to ${icl_schema};
grant select on ${iol_schema}.icms_customer_merge to ${idl_schema};
grant select on ${iol_schema}.icms_customer_merge to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_merge is '客户合并历史记录表客户合并历史记录表';
comment on column ${iol_schema}.icms_customer_merge.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_merge.megcustomerid is '合并客户号';
comment on column ${iol_schema}.icms_customer_merge.status is '当前状态';
comment on column ${iol_schema}.icms_customer_merge.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_merge.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_merge.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_merge.inputtime is '录入时间';
comment on column ${iol_schema}.icms_customer_merge.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_merge.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_merge.reservecustomerid is '客户编号';
comment on column ${iol_schema}.icms_customer_merge.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_merge.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_merge.remark is '备注';
comment on column ${iol_schema}.icms_customer_merge.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_merge.customertype is '客户类型';
comment on column ${iol_schema}.icms_customer_merge.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_merge.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_merge.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_merge.etl_timestamp is 'ETL处理时间戳';
