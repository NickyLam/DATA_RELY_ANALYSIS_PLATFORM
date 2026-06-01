/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_fin_ind_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_fin_ind_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_fin_ind_h(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,sorc_sys_cd varchar2(10) --源系统代码
,ind_val number(30,2) --指标值
,sal_acct_num varchar2(60) --工资账号
,open_acct_bank varchar2(100) --工资账号开户银行
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,fin_ind_cd varchar2(10) --财务指标代码
,party_id varchar2(60) --当事人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_pty_party_fin_ind_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_fin_ind_h is '当事人财务指标历史';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.ind_val is '指标值';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.sal_acct_num is '工资账号';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.open_acct_bank is '工资账号开户银行';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.fin_ind_cd is '财务指标代码';
comment on column ${idl_schema}.oass_pty_party_fin_ind_h.party_id is '当事人编号';

