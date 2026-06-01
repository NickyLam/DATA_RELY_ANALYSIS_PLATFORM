/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_moy_box_card_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_moy_box_card_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_moy_box_card_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_moy_box_card_info_h(
    card_no varchar2(60) -- 卡号
    ,lp_id varchar2(100) -- 法人编号
    ,card_vouch_status varchar2(30) -- 卡凭证状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,nomi_card_flg varchar2(10) -- 记名卡标志
    ,supp_card_flg varchar2(10) -- 附属卡标志
    ,main_card_card_no varchar2(60) -- 主卡卡号
    ,appl_id varchar2(100) -- 申请编号
    ,make_card_doc_batch_no varchar2(60) -- 制卡文件批次号
    ,card_cnv varchar2(500) -- 卡片CVN信息
    ,card_med_type_cd varchar2(30) -- 卡介质类型代码
    ,card_psbook_merge_one_flg varchar2(10) -- 卡折合一标志
    ,card_status_cd varchar2(30) -- 卡状态代码
    ,change_card_cnt number(10) -- 换卡次数
    ,issue_dt date -- 发行日期
    ,tran_tm date -- 交易时间
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,appl_teller_id varchar2(100) -- 申请柜员编号
    ,card_iss_teller_id varchar2(100) -- 发卡柜员编号
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
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
grant select on ${iml_schema}.ref_moy_box_card_info_h to ${icl_schema};
grant select on ${iml_schema}.ref_moy_box_card_info_h to ${idl_schema};
grant select on ${iml_schema}.ref_moy_box_card_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_moy_box_card_info_h is '钱箱里卡片信息历史';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_no is '卡号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_vouch_status is '卡凭证状态代码';
comment on column ${iml_schema}.ref_moy_box_card_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.nomi_card_flg is '记名卡标志';
comment on column ${iml_schema}.ref_moy_box_card_info_h.supp_card_flg is '附属卡标志';
comment on column ${iml_schema}.ref_moy_box_card_info_h.main_card_card_no is '主卡卡号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.make_card_doc_batch_no is '制卡文件批次号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_cnv is '卡片CVN信息';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_med_type_cd is '卡介质类型代码';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_psbook_merge_one_flg is '卡折合一标志';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_status_cd is '卡状态代码';
comment on column ${iml_schema}.ref_moy_box_card_info_h.change_card_cnt is '换卡次数';
comment on column ${iml_schema}.ref_moy_box_card_info_h.issue_dt is '发行日期';
comment on column ${iml_schema}.ref_moy_box_card_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.ref_moy_box_card_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_moy_box_card_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_moy_box_card_info_h.appl_teller_id is '申请柜员编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.card_iss_teller_id is '发卡柜员编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.ref_moy_box_card_info_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_moy_box_card_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_moy_box_card_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_moy_box_card_info_h.etl_timestamp is 'ETL处理时间戳';
