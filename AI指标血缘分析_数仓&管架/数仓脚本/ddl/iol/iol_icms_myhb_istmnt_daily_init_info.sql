/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myhb_istmnt_daily_init_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myhb_istmnt_daily_init_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myhb_istmnt_daily_init_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_istmnt_daily_init_info(
    contractno varchar2(64) -- 花呗平台贷款合同号
    ,termno varchar2(32) -- 期次号
    ,settledate varchar2(8) -- 会计日期
    ,intovddate varchar2(8) -- 利息转逾期日期
    ,accruedstatus varchar2(2) -- 应计非应计标识，应计0，非应计1
    ,beginint number(24,6) -- 应还利息
    ,enddate varchar2(8) -- 分期结束日期
    ,ovdprinpnltbal number(24,6) -- 逾期本金罚息余额
    ,intbal number(24,6) -- 利息余额
    ,startdate varchar2(8) -- 分期开始日期
    ,prinbal number(24,6) -- 本金余额
    ,creditcode varchar2(8) -- 额度类型
    ,prinovddays number(22) -- 本金逾期天数
    ,intovddays number(22) -- 利息逾期天数
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,prinovddate varchar2(8) -- 本金转逾期日期
    ,ovdintpnltbal number(24,6) -- 逾期利息罚息余额
    ,beginprin number(24,6) -- 应还本金
    ,cleardate varchar2(8) -- 结清日期
    ,status varchar2(10) -- 分期状态
    ,contracttype varchar2(8) -- 借据类型
    ,regioncode varchar2(8) -- 行政区划代码
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
grant select on ${iol_schema}.icms_myhb_istmnt_daily_init_info to ${iml_schema};
grant select on ${iol_schema}.icms_myhb_istmnt_daily_init_info to ${icl_schema};
grant select on ${iol_schema}.icms_myhb_istmnt_daily_init_info to ${idl_schema};
grant select on ${iol_schema}.icms_myhb_istmnt_daily_init_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myhb_istmnt_daily_init_info is '日终(还款计划)信息文件';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.contractno is '花呗平台贷款合同号';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.termno is '期次号';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.settledate is '会计日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.intovddate is '利息转逾期日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.beginint is '应还利息';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.intbal is '利息余额';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.prinbal is '本金余额';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.creditcode is '额度类型';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.prinovddate is '本金转逾期日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.beginprin is '应还本金';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.cleardate is '结清日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.status is '分期状态';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.contracttype is '借据类型';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myhb_istmnt_daily_init_info.etl_timestamp is 'ETL处理时间戳';
