/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_latest5yearinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_latest5yearinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_latest5yearinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_latest5yearinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,mo varchar2(11) -- 月份:pd01er03
    ,cr_ln_repy_st varchar2(90) -- 征信贷款还款状态:pd01ed01
    ,cur_odue_tamt number(38,0) -- 当前逾期总额:pd01ej01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
    ,odue_cnu_mo_num_cd varchar2(2) -- 还款状态pd01ed01
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
grant select on ${iol_schema}.cqss_i_r_latest5yearinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_latest5yearinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_latest5yearinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_latest5yearinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_latest5yearinfo is '二代借贷账户最近5年内的历史表现信息';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.mo is '月份:pd01er03';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.cr_ln_repy_st is '征信贷款还款状态:pd01ed01';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.cur_odue_tamt is '当前逾期总额:pd01ej01';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.odue_cnu_mo_num_cd is '还款状态pd01ed01';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_latest5yearinfo.etl_timestamp is 'ETL处理时间戳';
