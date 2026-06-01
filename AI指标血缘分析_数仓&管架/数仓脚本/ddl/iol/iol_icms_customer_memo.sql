/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_memo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_memo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_memo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_memo(
    serialno varchar2(32) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,migtflag varchar2(80) -- 
    ,inputorgid varchar2(32) -- 登记机构
    ,eventdescribe varchar2(1000) -- 事件描述及原因
    ,degree varchar2(27) -- 程度
    ,eventname varchar2(80) -- 事件名称
    ,eventtype varchar2(18) -- 事件类型
    ,influence varchar2(2) -- 正负面影响
    ,remark varchar2(1000) -- 备注
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(32) -- 更新人
    ,occurdate date -- 发生日期
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(32) -- 更新机构
    ,corporgid varchar2(32) -- 法人机构编号
    ,influencelevel varchar2(2) -- 正负面程度
    ,signface varchar2(32) -- 正负面
    ,inputuserid varchar2(32) -- 登记人
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
grant select on ${iol_schema}.icms_customer_memo to ${iml_schema};
grant select on ${iol_schema}.icms_customer_memo to ${icl_schema};
grant select on ${iol_schema}.icms_customer_memo to ${idl_schema};
grant select on ${iol_schema}.icms_customer_memo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_memo is '客户大事记客户大事记';
comment on column ${iol_schema}.icms_customer_memo.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_memo.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_memo.migtflag is '';
comment on column ${iol_schema}.icms_customer_memo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_memo.eventdescribe is '事件描述及原因';
comment on column ${iol_schema}.icms_customer_memo.degree is '程度';
comment on column ${iol_schema}.icms_customer_memo.eventname is '事件名称';
comment on column ${iol_schema}.icms_customer_memo.eventtype is '事件类型';
comment on column ${iol_schema}.icms_customer_memo.influence is '正负面影响';
comment on column ${iol_schema}.icms_customer_memo.remark is '备注';
comment on column ${iol_schema}.icms_customer_memo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_memo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_memo.occurdate is '发生日期';
comment on column ${iol_schema}.icms_customer_memo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_memo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_memo.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_memo.influencelevel is '正负面程度';
comment on column ${iol_schema}.icms_customer_memo.signface is '正负面';
comment on column ${iol_schema}.icms_customer_memo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_memo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_customer_memo.etl_timestamp is 'ETL处理时间戳';
