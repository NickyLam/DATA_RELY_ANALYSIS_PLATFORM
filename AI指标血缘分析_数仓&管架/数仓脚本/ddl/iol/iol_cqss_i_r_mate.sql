/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_mate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_mate
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_mate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_mate(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,pbc_cr_mar_sttn varchar2(3) -- 人行征信婚姻状况:pb020d01
    ,sps_nm varchar2(135) -- 配偶姓名:pb020q01
    ,pbc_tngncr_pts_tpcd varchar2(11) -- 人行二代证件类型代码:pb020d02
    ,sps_crdt_no varchar2(90) -- 配偶证件号码:pb020i01
    ,wrk_unit_nm varchar2(360) -- 工作单位名称:pb020q02
    ,move_telno varchar2(113) -- 移动电话号码:pb020q03
    ,multi_tenancy_id varchar2(30) -- 多实体标识
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
grant select on ${iol_schema}.cqss_i_r_mate to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_mate to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_mate to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_mate to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_mate is '二代婚姻信息';
comment on column ${iol_schema}.cqss_i_r_mate.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_mate.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_mate.pbc_cr_mar_sttn is '人行征信婚姻状况:pb020d01';
comment on column ${iol_schema}.cqss_i_r_mate.sps_nm is '配偶姓名:pb020q01';
comment on column ${iol_schema}.cqss_i_r_mate.pbc_tngncr_pts_tpcd is '人行二代证件类型代码:pb020d02';
comment on column ${iol_schema}.cqss_i_r_mate.sps_crdt_no is '配偶证件号码:pb020i01';
comment on column ${iol_schema}.cqss_i_r_mate.wrk_unit_nm is '工作单位名称:pb020q02';
comment on column ${iol_schema}.cqss_i_r_mate.move_telno is '移动电话号码:pb020q03';
comment on column ${iol_schema}.cqss_i_r_mate.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_mate.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_mate.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_mate.etl_timestamp is 'ETL处理时间戳';
