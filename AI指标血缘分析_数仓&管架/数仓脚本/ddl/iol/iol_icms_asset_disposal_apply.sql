/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_asset_disposal_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_asset_disposal_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_asset_disposal_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_disposal_apply(
    serialno varchar2(64) -- 流水号
    ,accountno varchar2(100) -- 账户
    ,accountname varchar2(200) -- 账户名称
    ,subacctnum varchar2(60) -- 子账户
    ,accountcurrency varchar2(10) -- 账户币种
    ,transactionamt number(24,6) -- 交易价格
    ,accountrodtype varchar2(64) -- 账户产品类型
    ,handletype varchar2(48) -- 处置方式
    ,handledate date -- 处置日期
    ,handlebalancesum number(24,6) -- 回收金额汇总
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
    ,counterpartyzh varchar2(64) -- 交易对手账号
    ,counterpartyname varchar2(200) -- 受让方（交易对手）
    ,counterpartyzhbank varchar2(200) -- 交易对手账号开户行名称
    ,programno varchar2(64) -- 方案编号
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
grant select on ${iol_schema}.icms_asset_disposal_apply to ${iml_schema};
grant select on ${iol_schema}.icms_asset_disposal_apply to ${icl_schema};
grant select on ${iol_schema}.icms_asset_disposal_apply to ${idl_schema};
grant select on ${iol_schema}.icms_asset_disposal_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_asset_disposal_apply is '抵债资产处置流程申请记录表';
comment on column ${iol_schema}.icms_asset_disposal_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_asset_disposal_apply.accountno is '账户';
comment on column ${iol_schema}.icms_asset_disposal_apply.accountname is '账户名称';
comment on column ${iol_schema}.icms_asset_disposal_apply.subacctnum is '子账户';
comment on column ${iol_schema}.icms_asset_disposal_apply.accountcurrency is '账户币种';
comment on column ${iol_schema}.icms_asset_disposal_apply.transactionamt is '交易价格';
comment on column ${iol_schema}.icms_asset_disposal_apply.accountrodtype is '账户产品类型';
comment on column ${iol_schema}.icms_asset_disposal_apply.handletype is '处置方式';
comment on column ${iol_schema}.icms_asset_disposal_apply.handledate is '处置日期';
comment on column ${iol_schema}.icms_asset_disposal_apply.handlebalancesum is '回收金额汇总';
comment on column ${iol_schema}.icms_asset_disposal_apply.handledesc is '处置说明';
comment on column ${iol_schema}.icms_asset_disposal_apply.handlenum is '处置数量';
comment on column ${iol_schema}.icms_asset_disposal_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_asset_disposal_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_asset_disposal_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_asset_disposal_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_asset_disposal_apply.operateuserid is '经办客户经理';
comment on column ${iol_schema}.icms_asset_disposal_apply.operateorgid is '经办客户经理所属机构';
comment on column ${iol_schema}.icms_asset_disposal_apply.operatedate is '经办时间';
comment on column ${iol_schema}.icms_asset_disposal_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_asset_disposal_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_asset_disposal_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_asset_disposal_apply.counterpartyzh is '交易对手账号';
comment on column ${iol_schema}.icms_asset_disposal_apply.counterpartyname is '受让方（交易对手）';
comment on column ${iol_schema}.icms_asset_disposal_apply.counterpartyzhbank is '交易对手账号开户行名称';
comment on column ${iol_schema}.icms_asset_disposal_apply.programno is '方案编号';
comment on column ${iol_schema}.icms_asset_disposal_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_asset_disposal_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_asset_disposal_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_asset_disposal_apply.etl_timestamp is 'ETL处理时间戳';
