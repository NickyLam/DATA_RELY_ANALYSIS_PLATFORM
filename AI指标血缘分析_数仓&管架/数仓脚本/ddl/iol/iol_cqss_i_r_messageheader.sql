/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_messageheader
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_messageheader
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_messageheader purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_messageheader(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,idv_cr_rpt_file_id varchar2(180) -- 个人征信报告文件编号:pa01ai01
    ,msgrp_gen_tm date -- 报文生成时间:pa01ar01
    ,cr_enqd_ppl_nm varchar2(135) -- 征信被查询者姓名:pa01bq01
    ,pbc_tngncr_pts_tpcd varchar2(9) -- 人行二代证件类型代码:pa01bd01
    ,crrptenqd_psn_crdt_no varchar2(90) -- 信用报告被查询人证件号码:pa01bi01
    ,cr_enqd_insid varchar2(90) -- 征信被查询机构编号:pa01bi02
    ,pbc_enqr_rscd varchar2(9) -- 人行查询原因代码:pa01bd02
    ,crdt_inf_rcrd_num number(22) -- 证件信息记录数:pa01cs01
    ,cht_ind varchar2(2) -- 欺诈标志:pa01dq01
    ,ctc_tel varchar2(900) -- 联系电话:pa01dq02
    ,afrd_strtg_rlsdt_prd date -- 反欺诈策略发布日期:pa01dr01
    ,afrd_strtg_expdt date -- 反欺诈策略失效日期:pa01dr02
    ,cr_objtn_num number(22) -- 征信异议数目:pa01es01
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
grant select on ${iol_schema}.cqss_i_r_messageheader to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_messageheader to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_messageheader to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_messageheader to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_messageheader is '二代报告头描述';
comment on column ${iol_schema}.cqss_i_r_messageheader.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_messageheader.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_messageheader.idv_cr_rpt_file_id is '个人征信报告文件编号:pa01ai01';
comment on column ${iol_schema}.cqss_i_r_messageheader.msgrp_gen_tm is '报文生成时间:pa01ar01';
comment on column ${iol_schema}.cqss_i_r_messageheader.cr_enqd_ppl_nm is '征信被查询者姓名:pa01bq01';
comment on column ${iol_schema}.cqss_i_r_messageheader.pbc_tngncr_pts_tpcd is '人行二代证件类型代码:pa01bd01';
comment on column ${iol_schema}.cqss_i_r_messageheader.crrptenqd_psn_crdt_no is '信用报告被查询人证件号码:pa01bi01';
comment on column ${iol_schema}.cqss_i_r_messageheader.cr_enqd_insid is '征信被查询机构编号:pa01bi02';
comment on column ${iol_schema}.cqss_i_r_messageheader.pbc_enqr_rscd is '人行查询原因代码:pa01bd02';
comment on column ${iol_schema}.cqss_i_r_messageheader.crdt_inf_rcrd_num is '证件信息记录数:pa01cs01';
comment on column ${iol_schema}.cqss_i_r_messageheader.cht_ind is '欺诈标志:pa01dq01';
comment on column ${iol_schema}.cqss_i_r_messageheader.ctc_tel is '联系电话:pa01dq02';
comment on column ${iol_schema}.cqss_i_r_messageheader.afrd_strtg_rlsdt_prd is '反欺诈策略发布日期:pa01dr01';
comment on column ${iol_schema}.cqss_i_r_messageheader.afrd_strtg_expdt is '反欺诈策略失效日期:pa01dr02';
comment on column ${iol_schema}.cqss_i_r_messageheader.cr_objtn_num is '征信异议数目:pa01es01';
comment on column ${iol_schema}.cqss_i_r_messageheader.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_messageheader.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_messageheader.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_messageheader.etl_timestamp is 'ETL处理时间戳';
