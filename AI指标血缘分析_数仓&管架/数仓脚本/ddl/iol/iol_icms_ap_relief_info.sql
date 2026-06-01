/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_relief_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_relief_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_relief_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_relief_info(
    reliefno varchar2(64) -- 减免明细编号
    ,prereliefbalance number(24,6) -- 减免前本金余额元）
    ,updatedate date -- 更新日期
    ,currency varchar2(3) -- 币种
    ,reliefonbalinterest number(24,6) -- 减免表内利息金额元）
    ,inputuserid varchar2(64) -- 登记人
    ,preoutdebitinterest number(24,6) -- 减免前表外欠息金额元）
    ,reliefbalance number(24,6) -- 减免本金金额元）
    ,payonbalinterest number(24,6) -- 应还表内利息金额元）
    ,reliefoutbalinterest number(24,6) -- 减免表外利息金额元）
    ,programno varchar2(64) -- 方案编号
    ,paybalance number(24,6) -- 应还本金金额元）
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,preondebitinterest number(24,6) -- 减免前表内欠息金额元）
    ,payoutbalinterest number(24,6) -- 应还表外利息金额元）
    ,contractno varchar2(2000) -- 合同流水号
    ,intamt number(24,6) -- 欠息
    ,odiamt number(24,6) -- 复息
    ,odpamt number(24,6) -- 罚息
    ,reduceintamt number(24,6) -- 减免欠息
    ,reduceodiamt number(24,6) -- 减免复息
    ,reduceodpamt number(24,6) -- 减免罚息
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
grant select on ${iol_schema}.icms_ap_relief_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_relief_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_relief_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_relief_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_relief_info is '减免详情明细表';
comment on column ${iol_schema}.icms_ap_relief_info.reliefno is '减免明细编号';
comment on column ${iol_schema}.icms_ap_relief_info.prereliefbalance is '减免前本金余额元）';
comment on column ${iol_schema}.icms_ap_relief_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_relief_info.currency is '币种';
comment on column ${iol_schema}.icms_ap_relief_info.reliefonbalinterest is '减免表内利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_relief_info.preoutdebitinterest is '减免前表外欠息金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.reliefbalance is '减免本金金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.payonbalinterest is '应还表内利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.reliefoutbalinterest is '减免表外利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_relief_info.paybalance is '应还本金金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_relief_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_relief_info.preondebitinterest is '减免前表内欠息金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.payoutbalinterest is '应还表外利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_info.contractno is '合同流水号';
comment on column ${iol_schema}.icms_ap_relief_info.intamt is '欠息';
comment on column ${iol_schema}.icms_ap_relief_info.odiamt is '复息';
comment on column ${iol_schema}.icms_ap_relief_info.odpamt is '罚息';
comment on column ${iol_schema}.icms_ap_relief_info.reduceintamt is '减免欠息';
comment on column ${iol_schema}.icms_ap_relief_info.reduceodiamt is '减免复息';
comment on column ${iol_schema}.icms_ap_relief_info.reduceodpamt is '减免罚息';
comment on column ${iol_schema}.icms_ap_relief_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_relief_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_relief_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_relief_info.etl_timestamp is 'ETL处理时间戳';
