/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_term_managment_bind
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_term_managment_bind
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_term_managment_bind purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_term_managment_bind(
    term_id varchar2(12) -- 
    ,term_id_id varchar2(12) -- 
    ,pin_term varchar2(60) -- 
    ,pad_id_id varchar2(12) -- 
    ,pin_pad varchar2(60) -- 
    ,rec_crt_ts varchar2(30) -- 
    ,rec_upd_ts varchar2(30) -- 
    ,crt_opr_id varchar2(30) -- 
    ,upd_opr_id varchar2(30) -- 
    ,reserved1 varchar2(375) -- 
    ,reserved2 varchar2(375) -- 
    ,pad_factory varchar2(60) -- 
    ,pad_mach_tp varchar2(60) -- 
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
grant select on ${iol_schema}.mrms_tbl_term_managment_bind to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_term_managment_bind to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_term_managment_bind to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_term_managment_bind to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_term_managment_bind is '终端库存绑定表';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.term_id is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.term_id_id is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.pin_term is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.pad_id_id is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.pin_pad is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.rec_crt_ts is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.rec_upd_ts is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.crt_opr_id is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.upd_opr_id is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.reserved1 is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.reserved2 is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.pad_factory is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.pad_mach_tp is '';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_term_managment_bind.etl_timestamp is 'ETL处理时间戳';
