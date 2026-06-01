/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_batch_open_info_dtl_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_batch_open_info_dtl_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_open_info_dtl_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,seq_num varchar2(60) -- 序号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_subdv_type_cd varchar2(30) -- 客户细分类型代码
    ,corp_name varchar2(500) -- 单位名称
    ,open_dt date -- 开立日期
    ,open_org_id varchar2(100) -- 开立机构编号
    ,card_draw_way_cd varchar2(30) -- 卡片领取方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,begin_card_no varchar2(60) -- 起始卡号
    ,termnt_card_no varchar2(60) -- 终止卡号
    ,card_psbook_idf_cd varchar2(30) -- 卡折标识代码
    ,prod_id varchar2(100) -- 产品编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,acct_attr_cd varchar2(30) -- 账户属性代码
    ,general_storage_flg varchar2(10) -- 通存标志
    ,general_exch_flg varchar2(10) -- 通兑标志
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,vouch_prefix varchar2(100) -- 凭证前缀
    ,vouch_id varchar2(100) -- 凭证编号
    ,tran_amt number(30,2) -- 交易金额
    ,wdraw_way_cd varchar2(30) -- 支取方式代码
    ,tran_revd_flg varchar2(10) -- 交易已冲正标志
    ,batch_proc_status_cd varchar2(30) -- 批次处理状态代码
    ,tran_tm timestamp -- 交易时间
    ,batch_open_type_cd varchar2(30) -- 批量开立类型代码
    ,memo_code varchar2(60) -- 摘要码
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,int_accr_flg varchar2(10) -- 计息标志
    ,tran_remark_descb varchar2(500) -- 交易备注描述
    ,dep_char_cd varchar2(30) -- 存款性质代码
    ,allow_sell_check_flg varchar2(10) -- 允许出售支票标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_batch_open_info_dtl_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_batch_open_info_dtl_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_batch_open_info_dtl_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_batch_open_info_dtl_rgst_b is '批量开立信息明细登记簿';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.seq_num is '序号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.cust_subdv_type_cd is '客户细分类型代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.corp_name is '单位名称';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.open_dt is '开立日期';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.open_org_id is '开立机构编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.card_draw_way_cd is '卡片领取方式代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.begin_card_no is '起始卡号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.termnt_card_no is '终止卡号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.card_psbook_idf_cd is '卡折标识代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.prod_id is '产品编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.acct_attr_cd is '账户属性代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.general_storage_flg is '通存标志';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.general_exch_flg is '通兑标志';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.vouch_prefix is '凭证前缀';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.vouch_id is '凭证编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.wdraw_way_cd is '支取方式代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.tran_revd_flg is '交易已冲正标志';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.batch_proc_status_cd is '批次处理状态代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.batch_open_type_cd is '批量开立类型代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.memo_code is '摘要码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.int_accr_flg is '计息标志';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.tran_remark_descb is '交易备注描述';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.dep_char_cd is '存款性质代码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.allow_sell_check_flg is '允许出售支票标志';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.start_dt is '开始时间';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.end_dt is '结束时间';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.id_mark is '增删标志';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_batch_open_info_dtl_rgst_b.etl_timestamp is 'ETL处理时间戳';
