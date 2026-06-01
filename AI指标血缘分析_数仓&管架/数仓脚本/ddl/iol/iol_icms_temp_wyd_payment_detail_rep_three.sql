/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_payment_detail_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_payment_detail_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_payment_detail_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_payment_detail_rep_three(
    orgid varchar2(20) -- 合作机构号
    ,loanno varchar2(64) -- 主借据号
    ,refno varchar2(32) -- 交易流水号
    ,ppay number(16,2) -- 还本金额
    ,ipay number(16,2) -- 还利息金额
    ,pppay number(16,2) -- 还罚息
    ,type varchar2(16) -- 还款类型
    ,transdate varchar2(10) -- 交易日期
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
grant select on ${iol_schema}.icms_temp_wyd_payment_detail_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_payment_detail_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_payment_detail_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_payment_detail_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_payment_detail_rep_three is '还款明细文件报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.orgid is '合作机构号';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.loanno is '主借据号';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.refno is '交易流水号';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.ppay is '还本金额';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.ipay is '还利息金额';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.pppay is '还罚息';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.type is '还款类型';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.transdate is '交易日期';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_payment_detail_rep_three.etl_timestamp is 'ETL处理时间戳';
