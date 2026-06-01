/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_batch_dig_main
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_batch_dig_main
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_batch_dig_main purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_batch_dig_main(
    tsk_seq_no number(10,0) -- 任务顺序号
    ,inf_rcrd_idr_no number(10,0) -- 信息记录标识号
    ,rslt_cd varchar2(135) -- 结果代码
    ,enqr_rslt_dsc varchar2(4000) -- 查询结果描述
    ,pbc_fnc_inst_ecd varchar2(21) -- 人民银行金融机构编码
    ,itt_psn varchar2(900) -- 发起人
    ,cr_enqd_ppl_nm varchar2(360) -- 征信被查询者姓名:pa01bq01
    ,pbc_tngncr_pts_tpcd varchar2(9) -- 人行二代证件类型代码:pa01bd01
    ,crrptenqd_psn_crdt_no varchar2(90) -- 信用报告被查询人证件号码:pa01bi01
    ,pbc_enqr_rscd varchar2(9) -- 人行查询原因代码:pa01bd02
    ,rel_svc_cd varchar2(360) -- 相关服务代码
    ,pd_dt date -- 产品日期
    ,digtiptn_enqr_rslt_tp varchar2(3) -- 数字解读查询结果类型
    ,pbc_digt_iptn number(4,0) -- 人行数字解读:pc010q01
    ,aft_num number(4,0) -- 影响因素个数
    ,rel_lo number(2,0) -- 相对位置:pc010q02
    ,clc_dt date -- 计算日期
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
grant select on ${iol_schema}.cqss_i_r_batch_dig_main to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_batch_dig_main to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_batch_dig_main to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_batch_dig_main to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_batch_dig_main is '个人数字解读主表';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.tsk_seq_no is '任务顺序号';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.inf_rcrd_idr_no is '信息记录标识号';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.rslt_cd is '结果代码';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.enqr_rslt_dsc is '查询结果描述';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.pbc_fnc_inst_ecd is '人民银行金融机构编码';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.itt_psn is '发起人';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.cr_enqd_ppl_nm is '征信被查询者姓名:pa01bq01';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.pbc_tngncr_pts_tpcd is '人行二代证件类型代码:pa01bd01';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.crrptenqd_psn_crdt_no is '信用报告被查询人证件号码:pa01bi01';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.pbc_enqr_rscd is '人行查询原因代码:pa01bd02';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.rel_svc_cd is '相关服务代码';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.pd_dt is '产品日期';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.digtiptn_enqr_rslt_tp is '数字解读查询结果类型';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.pbc_digt_iptn is '人行数字解读:pc010q01';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.aft_num is '影响因素个数';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.rel_lo is '相对位置:pc010q02';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.clc_dt is '计算日期';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_batch_dig_main.etl_timestamp is 'ETL处理时间戳';
