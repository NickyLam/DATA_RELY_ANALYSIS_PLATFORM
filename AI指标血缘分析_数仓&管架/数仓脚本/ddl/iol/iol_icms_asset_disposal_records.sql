/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_asset_disposal_records
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_asset_disposal_records
whenever sqlerror continue none;
drop table ${iol_schema}.icms_asset_disposal_records purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_disposal_records(
    serialno varchar2(64) -- 流水号
    ,relativeserialno varchar2(64) -- 关联流水号
    ,debtrepayassetid varchar2(64) -- 抵债资产编号
    ,debtrepayassetname varchar2(200) -- 抵债资产名称
    ,accountno varchar2(100) -- 账户
    ,accountname varchar2(200) -- 账户名称
    ,subacctnum varchar2(60) -- 子账户
    ,accountcurrency varchar2(10) -- 账户币种
    ,transactionamt number(24,6) -- 交易价格
    ,accountrodtype varchar2(64) -- 账户产品类型
    ,handletype varchar2(48) -- 处置方式
    ,handledate date -- 处置日期
    ,handlebalance number(24,6) -- 回收金额
    ,handledesc varchar2(3000) -- 处置说明
    ,handlenum varchar2(32) -- 处置数量
    ,approvestatus varchar2(64) -- 审批状态
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,operateuserid varchar2(64) -- 经办客户经理
    ,operateorgid varchar2(64) -- 经办客户经理所属机构
    ,operatedate date -- 经办时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,relativeapplyserialno varchar2(64) -- 关联申请流水号
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
grant select on ${iol_schema}.icms_asset_disposal_records to ${iml_schema};
grant select on ${iol_schema}.icms_asset_disposal_records to ${icl_schema};
grant select on ${iol_schema}.icms_asset_disposal_records to ${idl_schema};
grant select on ${iol_schema}.icms_asset_disposal_records to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_asset_disposal_records is '抵债资产处置申请记录表';
comment on column ${iol_schema}.icms_asset_disposal_records.serialno is '流水号';
comment on column ${iol_schema}.icms_asset_disposal_records.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_asset_disposal_records.debtrepayassetid is '抵债资产编号';
comment on column ${iol_schema}.icms_asset_disposal_records.debtrepayassetname is '抵债资产名称';
comment on column ${iol_schema}.icms_asset_disposal_records.accountno is '账户';
comment on column ${iol_schema}.icms_asset_disposal_records.accountname is '账户名称';
comment on column ${iol_schema}.icms_asset_disposal_records.subacctnum is '子账户';
comment on column ${iol_schema}.icms_asset_disposal_records.accountcurrency is '账户币种';
comment on column ${iol_schema}.icms_asset_disposal_records.transactionamt is '交易价格';
comment on column ${iol_schema}.icms_asset_disposal_records.accountrodtype is '账户产品类型';
comment on column ${iol_schema}.icms_asset_disposal_records.handletype is '处置方式';
comment on column ${iol_schema}.icms_asset_disposal_records.handledate is '处置日期';
comment on column ${iol_schema}.icms_asset_disposal_records.handlebalance is '回收金额';
comment on column ${iol_schema}.icms_asset_disposal_records.handledesc is '处置说明';
comment on column ${iol_schema}.icms_asset_disposal_records.handlenum is '处置数量';
comment on column ${iol_schema}.icms_asset_disposal_records.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_asset_disposal_records.inputuserid is '登记人';
comment on column ${iol_schema}.icms_asset_disposal_records.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_asset_disposal_records.inputdate is '登记日期';
comment on column ${iol_schema}.icms_asset_disposal_records.operateuserid is '经办客户经理';
comment on column ${iol_schema}.icms_asset_disposal_records.operateorgid is '经办客户经理所属机构';
comment on column ${iol_schema}.icms_asset_disposal_records.operatedate is '经办时间';
comment on column ${iol_schema}.icms_asset_disposal_records.updateuserid is '更新人';
comment on column ${iol_schema}.icms_asset_disposal_records.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_asset_disposal_records.updatedate is '更新日期';
comment on column ${iol_schema}.icms_asset_disposal_records.relativeapplyserialno is '关联申请流水号';
comment on column ${iol_schema}.icms_asset_disposal_records.start_dt is '开始时间';
comment on column ${iol_schema}.icms_asset_disposal_records.end_dt is '结束时间';
comment on column ${iol_schema}.icms_asset_disposal_records.id_mark is '增删标志';
comment on column ${iol_schema}.icms_asset_disposal_records.etl_timestamp is 'ETL处理时间戳';
