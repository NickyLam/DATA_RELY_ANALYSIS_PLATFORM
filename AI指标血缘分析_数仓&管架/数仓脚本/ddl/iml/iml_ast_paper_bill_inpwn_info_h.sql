/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_paper_bill_inpwn_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_paper_bill_inpwn_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_paper_bill_inpwn_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_paper_bill_inpwn_info_h(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(100) -- 法人编号
    ,col_id varchar2(100) -- 押品编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_amt number(30,2) -- 票据金额
    ,bill_exp_dt date -- 票据到期日期
    ,acpt_bank_no varchar2(60) -- 承兑行行号
    ,acpt_bank_name varchar2(750) -- 承兑行行名称
    ,inpwn_dt date -- 质押日期
    ,pledgor_name varchar2(750) -- 出质人名称
    ,pledgor_acct_id varchar2(100) -- 出质人账户编号
    ,pledgor_open_bank_no varchar2(60) -- 出质人开户行行号
    ,pledgor_open_bank_name varchar2(750) -- 出质人开户行名称
    ,pledgor_unify_soci_crdt_id varchar2(100) -- 出质人统一社会信用编号
    ,org_id varchar2(100) -- 机构编号
    ,pawnee_open_bank_name varchar2(750) -- 质权人开户行名称
    ,inpwn_flg varchar2(10) -- 质押标志
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
grant select on ${iml_schema}.ast_paper_bill_inpwn_info_h to ${icl_schema};
grant select on ${iml_schema}.ast_paper_bill_inpwn_info_h to ${idl_schema};
grant select on ${iml_schema}.ast_paper_bill_inpwn_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_paper_bill_inpwn_info_h is '纸质票据质押信息历史';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.col_id is '押品编号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.bill_num is '票据号码';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.bill_amt is '票据金额';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.bill_exp_dt is '票据到期日期';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.acpt_bank_no is '承兑行行号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.acpt_bank_name is '承兑行行名称';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.inpwn_dt is '质押日期';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.pledgor_name is '出质人名称';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.pledgor_acct_id is '出质人账户编号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.pledgor_open_bank_no is '出质人开户行行号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.pledgor_open_bank_name is '出质人开户行名称';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.pledgor_unify_soci_crdt_id is '出质人统一社会信用编号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.org_id is '机构编号';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.pawnee_open_bank_name is '质权人开户行名称';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.inpwn_flg is '质押标志';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_paper_bill_inpwn_info_h.etl_timestamp is 'ETL处理时间戳';
