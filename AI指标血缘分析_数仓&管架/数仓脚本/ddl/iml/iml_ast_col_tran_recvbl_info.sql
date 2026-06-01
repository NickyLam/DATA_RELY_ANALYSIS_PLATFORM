/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_tran_recvbl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_tran_recvbl_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_tran_recvbl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_tran_recvbl_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,lc_num varchar2(60) -- 信用证号码
    ,fac_val_amt number(30,8) -- 票面金额
    ,inv_id varchar2(60) -- 发票编号
    ,inv_dt date -- 发票日期
    ,inv_exp_dt date -- 发票到期日期
    ,aging number(38) -- 账龄
    ,payer_name varchar2(150) -- 付款人名称
    ,bkrpt_clear_flg varchar2(10) -- 破产清算标志
    ,payer_acct_id varchar2(250) -- 付款人账户编号
    ,advise_acct_recvbl_flg varchar2(10) -- 通知应收账款义务人标志
    ,cred_rht_prod_flg varchar2(10) -- 债权产生标志
    ,other_comnt varchar2(4000) -- 其他说明
    ,rela_flg varchar2(10) -- 关系标志
    ,curr_cd varchar2(30) -- 币种代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.ast_col_tran_recvbl_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_tran_recvbl_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_tran_recvbl_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_tran_recvbl_info is '押品交易类应收账款信息';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.lc_num is '信用证号码';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.fac_val_amt is '票面金额';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.inv_id is '发票编号';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.inv_dt is '发票日期';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.inv_exp_dt is '发票到期日期';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.aging is '账龄';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.payer_name is '付款人名称';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.bkrpt_clear_flg is '破产清算标志';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.advise_acct_recvbl_flg is '通知应收账款义务人标志';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.cred_rht_prod_flg is '债权产生标志';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.rela_flg is '关系标志';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_tran_recvbl_info.etl_timestamp is 'ETL处理时间戳';
