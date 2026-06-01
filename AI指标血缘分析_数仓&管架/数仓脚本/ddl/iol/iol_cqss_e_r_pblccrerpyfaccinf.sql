/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_pblccrerpyfaccinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_pblccrerpyfaccinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_pblccrerpyfaccinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_pblccrerpyfaccinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,pblc_crer_pyf_acc_id varchar2(9) -- 公用事业缴费账户编号:ee01ai01
    ,pblc_crerun_nm varchar2(360) -- 公用事业单位名称:ee01aq01
    ,pblc_crer_btp varchar2(9) -- 公用事业业务类型(业务类型):ee01ad01
    ,pblc_crer_pyf_st varchar2(2) -- 公用事业缴费状态(缴费状态):ee01ad02
    ,acm_ow_amt number(38,0) -- 累计欠费金额:ee01aj01
    ,stat_yrmo varchar2(11) -- 统计年月:ee01ar01
    ,pyf_rcrd_num number(22) -- 缴费记录条数:ee01bs01
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
grant select on ${iol_schema}.cqss_e_r_pblccrerpyfaccinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_pblccrerpyfaccinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_pblccrerpyfaccinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_pblccrerpyfaccinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_pblccrerpyfaccinf is '公用事业缴费账户信息';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.pblc_crer_pyf_acc_id is '公用事业缴费账户编号:ee01ai01';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.pblc_crerun_nm is '公用事业单位名称:ee01aq01';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.pblc_crer_btp is '公用事业业务类型(业务类型):ee01ad01';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.pblc_crer_pyf_st is '公用事业缴费状态(缴费状态):ee01ad02';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.acm_ow_amt is '累计欠费金额:ee01aj01';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.stat_yrmo is '统计年月:ee01ar01';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.pyf_rcrd_num is '缴费记录条数:ee01bs01';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_pblccrerpyfaccinf.etl_timestamp is 'ETL处理时间戳';
