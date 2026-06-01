/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_m_coll_pty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_m_coll_pty_info
whenever sqlerror continue none;
drop table ${iol_schema}.mims_m_coll_pty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_m_coll_pty_info(
    etl_dt_ora date -- 
    ,pty_id varchar2(60) -- 
    ,legal_name varchar2(100) -- 
    ,pty_typ_cd varchar2(20) -- 
    ,crdt_rat_resu_cd varchar2(2) -- 
    ,blng_pty_mgr_id varchar2(30) -- 
    ,blng_org_id varchar2(30) -- 
    ,pty_loc_cd varchar2(6) -- 
    ,corp_size_gb_cd varchar2(1) -- 
    ,corp_size_hb_cd varchar2(4) -- 
    ,indu_typ_cd_gb varchar2(5) -- 
    ,org_cn_full_name varchar2(100) -- 
    ,iden_typ_cd varchar2(4) -- 
    ,iden_num varchar2(40) -- 
    ,cbss_pty_id varchar2(60) -- 
    ,estab_dt date -- 
    ,ecif_pty_id varchar2(60) -- 
    ,reg_cty_cd varchar2(3) -- 
    ,line_cd varchar2(1) -- 
    ,data_src_cd varchar2(4) -- 
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
grant select on ${iol_schema}.mims_m_coll_pty_info to ${iml_schema};
grant select on ${iol_schema}.mims_m_coll_pty_info to ${icl_schema};
grant select on ${iol_schema}.mims_m_coll_pty_info to ${idl_schema};
grant select on ${iol_schema}.mims_m_coll_pty_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_m_coll_pty_info is '抵质押客户信息';
comment on column ${iol_schema}.mims_m_coll_pty_info.etl_dt_ora is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.pty_id is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.legal_name is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.pty_typ_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.crdt_rat_resu_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.blng_pty_mgr_id is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.blng_org_id is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.pty_loc_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.corp_size_gb_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.corp_size_hb_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.indu_typ_cd_gb is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.org_cn_full_name is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.iden_typ_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.iden_num is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.cbss_pty_id is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.estab_dt is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.ecif_pty_id is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.reg_cty_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.line_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.data_src_cd is '';
comment on column ${iol_schema}.mims_m_coll_pty_info.start_dt is '开始时间';
comment on column ${iol_schema}.mims_m_coll_pty_info.end_dt is '结束时间';
comment on column ${iol_schema}.mims_m_coll_pty_info.id_mark is '增删标志';
comment on column ${iol_schema}.mims_m_coll_pty_info.etl_timestamp is 'ETL处理时间戳';
