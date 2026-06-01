/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_latestinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_latestinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_latestinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_latestinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,dbtcr_acc_st varchar2(9) -- 借贷账户状态:pd01bd01
    ,cls_dt date -- 关闭日期:pd01br01
    ,tfrout_mo varchar2(11) -- 转出月份:pd01br04
    ,dbtcr_acba number(38,0) -- 借贷账户余额:pd01bj01
    ,rctly_oc_repydy_prd date -- 最近一次还款日期:pd01br02
    ,rctly_oc_repy_amt number(38,0) -- 最近一次还款金额:pd01bj02
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类:pd01bd03
    ,cr_ln_repy_st varchar2(90) -- 还款状态:pd01bd04
    ,rpt_dt date -- 信息报告日期:pd01br03
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
grant select on ${iol_schema}.cqss_i_r_latestinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_latestinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_latestinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_latestinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_latestinfo is '二代借贷账户最新表现信息';
comment on column ${iol_schema}.cqss_i_r_latestinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_latestinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_latestinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_latestinfo.dbtcr_acc_st is '借贷账户状态:pd01bd01';
comment on column ${iol_schema}.cqss_i_r_latestinfo.cls_dt is '关闭日期:pd01br01';
comment on column ${iol_schema}.cqss_i_r_latestinfo.tfrout_mo is '转出月份:pd01br04';
comment on column ${iol_schema}.cqss_i_r_latestinfo.dbtcr_acba is '借贷账户余额:pd01bj01';
comment on column ${iol_schema}.cqss_i_r_latestinfo.rctly_oc_repydy_prd is '最近一次还款日期:pd01br02';
comment on column ${iol_schema}.cqss_i_r_latestinfo.rctly_oc_repy_amt is '最近一次还款金额:pd01bj02';
comment on column ${iol_schema}.cqss_i_r_latestinfo.pbc_lv5cl_cd is '人行征信五级分类:pd01bd03';
comment on column ${iol_schema}.cqss_i_r_latestinfo.cr_ln_repy_st is '还款状态:pd01bd04';
comment on column ${iol_schema}.cqss_i_r_latestinfo.rpt_dt is '信息报告日期:pd01br03';
comment on column ${iol_schema}.cqss_i_r_latestinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_latestinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_latestinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_latestinfo.etl_timestamp is 'ETL处理时间戳';
