/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_appeal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_appeal
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_appeal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_appeal(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,sentencedate date -- 判决执行日期
    ,plaintiffname varchar2(4000) -- 起诉人名称
    ,implementresult varchar2(1000) -- 执行结果
    ,inputorgid varchar2(64) -- 登记机构
    ,remark varchar2(1000) -- 备注
    ,updatedate date -- 更新日期
    ,plaintiffreason varchar2(1000) -- 被起诉原因
    ,bondcurrency varchar2(3) -- 币种
    ,inputuserid varchar2(64) -- 登记人
    ,sentencebondsum number(24,6) -- 判决执行金额
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
grant select on ${iol_schema}.icms_customer_appeal to ${iml_schema};
grant select on ${iol_schema}.icms_customer_appeal to ${icl_schema};
grant select on ${iol_schema}.icms_customer_appeal to ${idl_schema};
grant select on ${iol_schema}.icms_customer_appeal to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_appeal is '客户涉诉信息客户涉诉信息';
comment on column ${iol_schema}.icms_customer_appeal.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_appeal.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_appeal.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_appeal.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_appeal.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_appeal.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_appeal.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_appeal.sentencedate is '判决执行日期';
comment on column ${iol_schema}.icms_customer_appeal.plaintiffname is '起诉人名称';
comment on column ${iol_schema}.icms_customer_appeal.implementresult is '执行结果';
comment on column ${iol_schema}.icms_customer_appeal.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_appeal.remark is '备注';
comment on column ${iol_schema}.icms_customer_appeal.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_appeal.plaintiffreason is '被起诉原因';
comment on column ${iol_schema}.icms_customer_appeal.bondcurrency is '币种';
comment on column ${iol_schema}.icms_customer_appeal.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_appeal.sentencebondsum is '判决执行金额';
comment on column ${iol_schema}.icms_customer_appeal.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_appeal.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_appeal.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_appeal.etl_timestamp is 'ETL处理时间戳';
