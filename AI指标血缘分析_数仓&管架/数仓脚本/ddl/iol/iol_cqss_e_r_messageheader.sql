/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_messageheader
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_messageheader
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_messageheader purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_messageheader(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,idv_cr_rpt_file_id varchar2(33) -- 报告编号:ea01ai01
    ,msgrp_gen_tm date -- 报文生成时间:ea01ar01
    ,cnrt_exrt number(6,2) -- 美元折人民币汇率:ea01eq01
    ,exrt_vld_dt varchar2(11) -- 汇率有效日期:ea01er01
    ,cr_enqd_insid varchar2(90) -- 征信被查询机构编号:ea01bi01
    ,entnm varchar2(360) -- 企业名称:ea01cq01
    ,entp_idnt_idr_num number(22) -- 企业身份标识个数:ea01cs01
    ,pbc_enqr_rscd varchar2(9) -- 人行查询原因代码:ea01bd02
    ,cr_objtn_num number(22) -- 征信异议数目:ea01ds01
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
grant select on ${iol_schema}.cqss_e_r_messageheader to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_messageheader to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_messageheader to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_messageheader to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_messageheader is '个人重要信息提示表';
comment on column ${iol_schema}.cqss_e_r_messageheader.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_messageheader.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_messageheader.idv_cr_rpt_file_id is '报告编号:ea01ai01';
comment on column ${iol_schema}.cqss_e_r_messageheader.msgrp_gen_tm is '报文生成时间:ea01ar01';
comment on column ${iol_schema}.cqss_e_r_messageheader.cnrt_exrt is '美元折人民币汇率:ea01eq01';
comment on column ${iol_schema}.cqss_e_r_messageheader.exrt_vld_dt is '汇率有效日期:ea01er01';
comment on column ${iol_schema}.cqss_e_r_messageheader.cr_enqd_insid is '征信被查询机构编号:ea01bi01';
comment on column ${iol_schema}.cqss_e_r_messageheader.entnm is '企业名称:ea01cq01';
comment on column ${iol_schema}.cqss_e_r_messageheader.entp_idnt_idr_num is '企业身份标识个数:ea01cs01';
comment on column ${iol_schema}.cqss_e_r_messageheader.pbc_enqr_rscd is '人行查询原因代码:ea01bd02';
comment on column ${iol_schema}.cqss_e_r_messageheader.cr_objtn_num is '征信异议数目:ea01ds01';
comment on column ${iol_schema}.cqss_e_r_messageheader.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_messageheader.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_messageheader.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_messageheader.etl_timestamp is 'ETL处理时间戳';
