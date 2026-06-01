/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_rgstcptlandmfndpsninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,pbc_cr_fndd_psn_tp varchar2(3) -- 人行征信出资人类型（出资人类型):ec020d01
    ,fndd_psn_part_cgy varchar2(2) -- 出资人身份类别:ec020d02
    ,fndd_psn_nm varchar2(360) -- 出资人名称:ec020q01
    ,fndd_psn_part_idr_tp varchar2(11) -- 企业出资人身份标识类型:ec020d03
    ,fndd_psn_part_idr_no varchar2(180) -- 出资人身份标识号码:ec020i01
    ,entp_cr_fndd_pctg number(20,2) -- 企业征信出资比例（出资比例):ec020q02
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
grant select on ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf is '注册资本及主要出资人信息';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.pbc_cr_fndd_psn_tp is '人行征信出资人类型（出资人类型):ec020d01';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.fndd_psn_part_cgy is '出资人身份类别:ec020d02';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.fndd_psn_nm is '出资人名称:ec020q01';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.fndd_psn_part_idr_tp is '企业出资人身份标识类型:ec020d03';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.fndd_psn_part_idr_no is '出资人身份标识号码:ec020i01';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.entp_cr_fndd_pctg is '企业征信出资比例（出资比例):ec020q02';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_rgstcptlandmfndpsninf.etl_timestamp is 'ETL处理时间戳';
