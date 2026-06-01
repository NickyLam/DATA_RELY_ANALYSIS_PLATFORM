/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_debt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_debt_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_debt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_debt_info(
    serialno varchar2(64) -- 流水号
    ,interestbalance number(24,6) -- 基准日利息余额元）
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate date -- 更新日期
    ,actpayinterest number(24,6) -- 实际偿还利息元）
    ,contractno varchar2(64) -- 合同流水号
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,principalbalance number(24,6) -- 基准日本金余额元）
    ,inputdate date -- 登记日期
    ,singledividebal number(24,6) -- 单户分配金额元）
    ,singleliqrate number(12,8) -- 单户清收比例%）
    ,legalitycost number(24,6) -- 基准日法律性费用元）
    ,actpaylegalitycost number(24,6) -- 实际偿还法律性费用元）
    ,programno varchar2(64) -- 方案编号
    ,standarddate date -- 基准日期
    ,updateuserid varchar2(64) -- 更新人
    ,actpaybalance number(24,6) -- 实际偿还本金元）
    ,debtsum number(24,6) -- 基准日债权总额元）
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
grant select on ${iol_schema}.icms_ap_debt_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_debt_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_debt_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_debt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_debt_info is '基准日债权金额明细';
comment on column ${iol_schema}.icms_ap_debt_info.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_debt_info.interestbalance is '基准日利息余额元）';
comment on column ${iol_schema}.icms_ap_debt_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_debt_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_debt_info.actpayinterest is '实际偿还利息元）';
comment on column ${iol_schema}.icms_ap_debt_info.contractno is '合同流水号';
comment on column ${iol_schema}.icms_ap_debt_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_debt_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_debt_info.principalbalance is '基准日本金余额元）';
comment on column ${iol_schema}.icms_ap_debt_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_debt_info.singledividebal is '单户分配金额元）';
comment on column ${iol_schema}.icms_ap_debt_info.singleliqrate is '单户清收比例%）';
comment on column ${iol_schema}.icms_ap_debt_info.legalitycost is '基准日法律性费用元）';
comment on column ${iol_schema}.icms_ap_debt_info.actpaylegalitycost is '实际偿还法律性费用元）';
comment on column ${iol_schema}.icms_ap_debt_info.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_debt_info.standarddate is '基准日期';
comment on column ${iol_schema}.icms_ap_debt_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_debt_info.actpaybalance is '实际偿还本金元）';
comment on column ${iol_schema}.icms_ap_debt_info.debtsum is '基准日债权总额元）';
comment on column ${iol_schema}.icms_ap_debt_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_debt_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_debt_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_debt_info.etl_timestamp is 'ETL处理时间戳';
