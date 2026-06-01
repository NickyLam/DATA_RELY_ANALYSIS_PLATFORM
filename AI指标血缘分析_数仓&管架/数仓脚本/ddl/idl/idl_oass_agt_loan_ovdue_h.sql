/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_ovdue_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_ovdue_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_ovdue_h(
etl_dt date --数据日期
,pric_ovdue_days number(10,0) --本金逾期天数
,int_ovdue_days number(10,0) --利息逾期天数
,ovdue_pric number(30,2) --逾期本金
,ovdue_int number(30,8) --逾期利息
,ovdue_pric_pnlt number(30,8) --逾期本金罚息
,ovdue_int_pnlt number(30,8) --逾期利息罚息
,pric_turn_ovdue_dt date --本金转逾期日期
,int_turn_ovdue_dt date --利息转逾期日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(100) --协议编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_ovdue_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_ovdue_h is '贷款逾期历史';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.pric_ovdue_days is '本金逾期天数';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.int_ovdue_days is '利息逾期天数';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.ovdue_pric is '逾期本金';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.ovdue_int is '逾期利息';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.ovdue_pric_pnlt is '逾期本金罚息';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.ovdue_int_pnlt is '逾期利息罚息';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.pric_turn_ovdue_dt is '本金转逾期日期';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.int_turn_ovdue_dt is '利息转逾期日期';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_loan_ovdue_h.lp_id is '法人编号';

