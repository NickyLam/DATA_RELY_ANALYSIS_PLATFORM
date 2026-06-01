/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_investment_client
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_investment_client
whenever sqlerror continue none;
drop table ${iol_schema}.icms_investment_client purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_investment_client(
    serialno varchar2(32) -- 流水号
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,custdecison varchar2(10) -- 投资级客户判定
    ,financialdate date -- 财务报表日
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,approvestatus varchar2(64) -- 审批状态
    ,isestatecorp varchar2(2) -- 
    ,isgovernfinancezq varchar2(2) -- 
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
grant select on ${iol_schema}.icms_investment_client to ${iml_schema};
grant select on ${iol_schema}.icms_investment_client to ${icl_schema};
grant select on ${iol_schema}.icms_investment_client to ${idl_schema};
grant select on ${iol_schema}.icms_investment_client to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_investment_client is '投资级客户认定';
comment on column ${iol_schema}.icms_investment_client.serialno is '流水号';
comment on column ${iol_schema}.icms_investment_client.customerid is '客户编号';
comment on column ${iol_schema}.icms_investment_client.customername is '客户名称';
comment on column ${iol_schema}.icms_investment_client.custdecison is '投资级客户判定';
comment on column ${iol_schema}.icms_investment_client.financialdate is '财务报表日';
comment on column ${iol_schema}.icms_investment_client.inputuserid is '登记人';
comment on column ${iol_schema}.icms_investment_client.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_investment_client.inputdate is '登记日期';
comment on column ${iol_schema}.icms_investment_client.updateuserid is '更新人';
comment on column ${iol_schema}.icms_investment_client.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_investment_client.updatedate is '更新日期';
comment on column ${iol_schema}.icms_investment_client.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_investment_client.isestatecorp is '';
comment on column ${iol_schema}.icms_investment_client.isgovernfinancezq is '';
comment on column ${iol_schema}.icms_investment_client.start_dt is '开始时间';
comment on column ${iol_schema}.icms_investment_client.end_dt is '结束时间';
comment on column ${iol_schema}.icms_investment_client.id_mark is '增删标志';
comment on column ${iol_schema}.icms_investment_client.etl_timestamp is 'ETL处理时间戳';
