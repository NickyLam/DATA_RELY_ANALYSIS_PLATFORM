/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_lx_repayment_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_lx_repayment_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_lx_repayment_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_lx_repayment_detail(
    assetid varchar2(64) -- 资产号
    ,capitalloanno varchar2(64) -- 借据号
    ,repayterm varchar2(20) -- 还款期数
    ,repaymenttype varchar2(20) -- 还款类型
    ,settledate varchar2(20) -- 结算日
    ,realamounttotal varchar2(200) -- 实还金额总额
    ,lxbusinesssum varchar2(200) -- 实还本金
    ,lxintamt varchar2(200) -- 实还利息
    ,lxqodpamt varchar2(200) -- 实还罚息
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
grant select on ${iol_schema}.icms_tmp_lx_repayment_detail to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_lx_repayment_detail to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_lx_repayment_detail to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_lx_repayment_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_lx_repayment_detail is '乐信还款明细中间表';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.assetid is '资产号';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.repayterm is '还款期数';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.repaymenttype is '还款类型';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.settledate is '结算日';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.realamounttotal is '实还金额总额';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.lxbusinesssum is '实还本金';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.lxintamt is '实还利息';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.lxqodpamt is '实还罚息';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_lx_repayment_detail.etl_timestamp is 'ETL处理时间戳';
