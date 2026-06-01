/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_relief_infoappr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_relief_infoappr
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_relief_infoappr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_relief_infoappr(
    serialno varchar2(64) -- 流水号
    ,preondebitinterest number(24,6) -- 减免前表内欠息金额元）
    ,inputorgid varchar2(64) -- 登记机构
    ,reliefonbalinterest number(24,6) -- 减免表内利息金额元）
    ,inputuserid varchar2(64) -- 登记人
    ,currency varchar2(3) -- 币种
    ,payonbalinterest number(24,6) -- 应还表内利息金额元）
    ,approveno varchar2(64) -- 批复编号
    ,updatedate date -- 更新日期
    ,reliefbalance number(24,6) -- 减免本金金额元）
    ,contractno varchar2(2000) -- 合同编号
    ,programno varchar2(64) -- 方案编号
    ,paybalance number(24,6) -- 应还本金金额元）
    ,inputdate date -- 登记日期
    ,preoutdebitinterest number(24,6) -- 减免前表外欠息金额元
    ,prereliefbalance number(24,6) -- 减免前本金余额元）
    ,reliefoutbalinterest number(24,6) -- 减免表外利息金额元）
    ,reliefno varchar2(64) -- 减免详情编号
    ,payoutbalinterest number(24,6) -- 应还表外利息金额元）
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
grant select on ${iol_schema}.icms_ap_relief_infoappr to ${iml_schema};
grant select on ${iol_schema}.icms_ap_relief_infoappr to ${icl_schema};
grant select on ${iol_schema}.icms_ap_relief_infoappr to ${idl_schema};
grant select on ${iol_schema}.icms_ap_relief_infoappr to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_relief_infoappr is '减免详情批复表';
comment on column ${iol_schema}.icms_ap_relief_infoappr.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_relief_infoappr.preondebitinterest is '减免前表内欠息金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_relief_infoappr.reliefonbalinterest is '减免表内利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_relief_infoappr.currency is '币种';
comment on column ${iol_schema}.icms_ap_relief_infoappr.payonbalinterest is '应还表内利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.approveno is '批复编号';
comment on column ${iol_schema}.icms_ap_relief_infoappr.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_relief_infoappr.reliefbalance is '减免本金金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.contractno is '合同编号';
comment on column ${iol_schema}.icms_ap_relief_infoappr.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_relief_infoappr.paybalance is '应还本金金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_relief_infoappr.preoutdebitinterest is '减免前表外欠息金额元';
comment on column ${iol_schema}.icms_ap_relief_infoappr.prereliefbalance is '减免前本金余额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.reliefoutbalinterest is '减免表外利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.reliefno is '减免详情编号';
comment on column ${iol_schema}.icms_ap_relief_infoappr.payoutbalinterest is '应还表外利息金额元）';
comment on column ${iol_schema}.icms_ap_relief_infoappr.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_relief_infoappr.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_relief_infoappr.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_relief_infoappr.etl_timestamp is 'ETL处理时间戳';
