/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_payment_sched_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_payment_sched_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_payment_sched_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_payment_sched_rep_three(
    orgid varchar2(20) -- 机构号
    ,loanno varchar2(64) -- 主借据号
    ,term varchar2(10) -- 当前期数
    ,paydate varchar2(10) -- 到期日期
    ,intedate varchar2(10) -- 宽限后到期日
    ,prepay number(20,4) -- 当期应还本金
    ,prepayact number(20,4) -- 当期实还本金
    ,payinterestamt number(20,4) -- 应还利息
    ,payprincipalpenaltyamt number(20,4) -- 应还本金罚息
    ,payinterestpenaltyamt number(20,4) -- 应还利息罚息
    ,actualpayinterestamt number(20,4) -- 实还利息
    ,actualpayprincipalpenaltyamt number(20,4) -- 实还本金罚息
    ,actualpayinterestpenaltyamt number(20,4) -- 实还利息罚息
    ,reginterestamat number(20,4) -- 免息金额
    ,finishflag varchar2(10) -- 结清标志
    ,finishdate varchar2(10) -- 结清日期
    ,pstype varchar2(10) -- 结清类型
    ,waiveinterestamt number(20,4) -- 减免利息
    ,waivepenaltyamt number(20,4) -- 减免罚息
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
grant select on ${iol_schema}.icms_temp_wyd_payment_sched_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_payment_sched_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_payment_sched_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_payment_sched_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_payment_sched_rep_three is '还款计划文件报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.loanno is '主借据号';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.term is '当前期数';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.paydate is '到期日期';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.intedate is '宽限后到期日';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.prepay is '当期应还本金';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.prepayact is '当期实还本金';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.payinterestamt is '应还利息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.payprincipalpenaltyamt is '应还本金罚息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.payinterestpenaltyamt is '应还利息罚息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.actualpayinterestamt is '实还利息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.actualpayprincipalpenaltyamt is '实还本金罚息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.actualpayinterestpenaltyamt is '实还利息罚息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.reginterestamat is '免息金额';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.finishflag is '结清标志';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.finishdate is '结清日期';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.pstype is '结清类型';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.waiveinterestamt is '减免利息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.waivepenaltyamt is '减免罚息';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_payment_sched_rep_three.etl_timestamp is 'ETL处理时间戳';
