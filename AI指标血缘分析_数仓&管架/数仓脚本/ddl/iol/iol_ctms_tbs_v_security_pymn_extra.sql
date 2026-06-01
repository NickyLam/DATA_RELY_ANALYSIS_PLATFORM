/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_pymn_extra
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_pymn_extra
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_extra purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_pymn_extra(
    security_code varchar2(24) -- 债券代码
    ,seq number(5,0) -- 序号
    ,real_payment_date varchar2(12) -- 付息日
    ,define_interest varchar2(2) -- 是否自定义利息
    ,delay_payment varchar2(2) -- 是否延迟付款
    ,coupon_amt number(18,10) -- 每万元付息金额
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
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_extra to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_extra to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_extra to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_pymn_extra to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_pymn_extra is '债券还本付息附加';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.seq is '序号';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.real_payment_date is '付息日';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.define_interest is '是否自定义利息';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.delay_payment is '是否延迟付款';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.coupon_amt is '每万元付息金额';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security_pymn_extra.etl_timestamp is 'ETL处理时间戳';
