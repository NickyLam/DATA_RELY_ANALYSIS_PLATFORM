/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_rela_h
CreateDate: 20230404
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_rela_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_rela_h(
etl_dt date --数据日期
,party_rela_type_cd varchar2(30) --
,seq_num varchar2(60) --序号
,rela_party_id varchar2(100) --关联当事人编号
,valid_flg varchar2(30) --关联关系状态代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,party_id varchar2(60) --当事人编号
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
grant select on ${idl_schema}.oass_pty_party_rela_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_rela_h is '当事人关系历史';
comment on column ${idl_schema}.oass_pty_party_rela_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_rela_h.party_rela_type_cd is '';
comment on column ${idl_schema}.oass_pty_party_rela_h.seq_num is '序号';
comment on column ${idl_schema}.oass_pty_party_rela_h.rela_party_id is '关联当事人编号';
comment on column ${idl_schema}.oass_pty_party_rela_h.valid_flg is '关联关系状态代码';
comment on column ${idl_schema}.oass_pty_party_rela_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_rela_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_rela_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_rela_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party_rela_h.lp_id is '法人编号';

