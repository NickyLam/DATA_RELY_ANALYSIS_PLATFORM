/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_batch_open_info_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_batch_open_info_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_batch_open_info_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_open_info_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,seq_num varchar2(60) -- 序号
    ,batch_descb varchar2(500) -- 批处理描述
    ,tran_mode_cd varchar2(30) -- 交易模式代码
    ,open_dt date -- 开立日期
    ,batch_open_type_cd varchar2(30) -- 批量开立类型代码
    ,batch_tot_qtty number(30) -- 批量总数量
    ,batch_tot_amt number(30,2) -- 批量总金额
    ,open_org_id varchar2(100) -- 开立机构编号
    ,bus_tran_dt date -- 业务交易日期
    ,cust_subdv_type_cd varchar2(30) -- 客户细分类型代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,card_psbook_idf_cd varchar2(30) -- 卡折标识代码
    ,prod_id varchar2(100) -- 产品编号
    ,card_draw_way_cd varchar2(30) -- 卡片领取方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,corp_name varchar2(500) -- 单位名称
    ,wdraw_way_cd varchar2(30) -- 支取方式代码
    ,begin_card_no varchar2(60) -- 起始卡号
    ,termnt_card_no varchar2(60) -- 终止卡号
    ,batch_proc_status_cd varchar2(30) -- 批次处理状态代码
    ,sucs_qtty number(30) -- 成功数量
    ,fail_qtty number(30) -- 失败数量
    ,src_org_id varchar2(100) -- 源机构编号
    ,target_org_id varchar2(100) -- 目标机构编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,core_tran_teller_id varchar2(100) -- 核心交易柜员编号
    ,src_chn_id varchar2(100) -- 源渠道编号
    ,core_tran_dt date -- 核心交易日期
    ,acct_aldy_check_flg varchar2(10) -- 账户已复核标志
    ,ba_auth_flg varchar2(10) -- 银承授权标志
    ,acct_apv_teller_id varchar2(100) -- 账户审批柜员编号
    ,ba_auth_teller_id varchar2(100) -- 银承授权柜员编号
    ,batch_begin_tm timestamp -- 批处理起始时间
    ,tran_tm timestamp -- 交易时间
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_batch_open_info_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_batch_open_info_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_batch_open_info_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_batch_open_info_rgst_b is '批量开立信息登记簿';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.seq_num is '序号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.batch_descb is '批处理描述';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.tran_mode_cd is '交易模式代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.open_dt is '开立日期';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.batch_open_type_cd is '批量开立类型代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.batch_tot_qtty is '批量总数量';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.batch_tot_amt is '批量总金额';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.open_org_id is '开立机构编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.cust_subdv_type_cd is '客户细分类型代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.card_psbook_idf_cd is '卡折标识代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.prod_id is '产品编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.card_draw_way_cd is '卡片领取方式代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.corp_name is '单位名称';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.wdraw_way_cd is '支取方式代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.begin_card_no is '起始卡号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.termnt_card_no is '终止卡号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.batch_proc_status_cd is '批次处理状态代码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.sucs_qtty is '成功数量';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.fail_qtty is '失败数量';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.src_org_id is '源机构编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.target_org_id is '目标机构编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.core_tran_teller_id is '核心交易柜员编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.src_chn_id is '源渠道编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.acct_aldy_check_flg is '账户已复核标志';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.ba_auth_flg is '银承授权标志';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.acct_apv_teller_id is '账户审批柜员编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.ba_auth_teller_id is '银承授权柜员编号';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.batch_begin_tm is '批处理起始时间';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_batch_open_info_rgst_b.etl_timestamp is 'ETL处理时间戳';
