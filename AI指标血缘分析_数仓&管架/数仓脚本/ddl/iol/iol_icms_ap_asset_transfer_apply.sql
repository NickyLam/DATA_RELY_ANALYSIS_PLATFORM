/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_asset_transfer_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_asset_transfer_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_asset_transfer_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_asset_transfer_apply(
    serialno varchar2(64) -- 流水号
    ,customername varchar2(200) -- 客户名称
    ,updateuserid varchar2(64) -- 更新人
    ,customersum number(24,6) -- 涉及客户数量
    ,allbusinesssum number(24,6) -- 总授信金额
    ,customertype varchar2(9) -- 问题客户种类
    ,allbdbusinesssum number(24,6) -- 总借据金额
    ,applytype varchar2(48) -- 申请类型
    ,handinreason varchar2(900) -- 移交原因
    ,inputuserid varchar2(64) -- 登记人
    ,transfertype varchar2(12) -- 转移状态01人工移入02人工移出)
    ,approvestatus varchar2(48) -- 流程状态
    ,handoutreason varchar2(900) -- 逆移交原因
    ,groupid varchar2(48) -- 集团编号
    ,assetinreason varchar2(900) -- 认定原因
    ,allbalance number(24,6) -- 总借据余额
    ,assetno varchar2(64) -- 风险资产编号
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,assetoutreason varchar2(900) -- 恢复原因
    ,inputdate date -- 登记日期
    ,inputorgid varchar2(64) -- 登记机构
    ,customerlevel varchar2(9) -- 最低客户评级
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
grant select on ${iol_schema}.icms_ap_asset_transfer_apply to ${iml_schema};
grant select on ${iol_schema}.icms_ap_asset_transfer_apply to ${icl_schema};
grant select on ${iol_schema}.icms_ap_asset_transfer_apply to ${idl_schema};
grant select on ${iol_schema}.icms_ap_asset_transfer_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_asset_transfer_apply is '风险资产转移申请';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.customersum is '涉及客户数量';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.allbusinesssum is '总授信金额';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.customertype is '问题客户种类';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.allbdbusinesssum is '总借据金额';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.applytype is '申请类型';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.handinreason is '移交原因';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.transfertype is '转移状态01人工移入02人工移出)';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.handoutreason is '逆移交原因';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.groupid is '集团编号';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.assetinreason is '认定原因';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.allbalance is '总借据余额';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.assetno is '风险资产编号';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.assetoutreason is '恢复原因';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.customerlevel is '最低客户评级';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_asset_transfer_apply.etl_timestamp is 'ETL处理时间戳';
