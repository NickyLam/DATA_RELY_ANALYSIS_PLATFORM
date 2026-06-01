/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_public
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_public
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_public purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_public(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,pblc_inf_tp varchar2(9) -- 公共信息类型:pc040d01
    ,rcrd_num number(22) -- 记录数:pc040s02
    ,ivl_amt number(24,3) -- 涉及金额:pc040j01
    ,multi_tenancy_id varchar2(8) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_i_r_public to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_public to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_public to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_public to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_public is '二代公共信息概要信息';
comment on column ${iol_schema}.cqss_i_r_public.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_public.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_public.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_public.pblc_inf_tp is '公共信息类型:pc040d01';
comment on column ${iol_schema}.cqss_i_r_public.rcrd_num is '记录数:pc040s02';
comment on column ${iol_schema}.cqss_i_r_public.ivl_amt is '涉及金额:pc040j01';
comment on column ${iol_schema}.cqss_i_r_public.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_public.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_public.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_public.etl_timestamp is 'ETL处理时间戳';
