/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_rela_party_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_rela_party_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_rela_party_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_rela_party_info_h(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,main_cust_id varchar2(100) -- 主客户编号
    ,rela_ps_cust_id varchar2(100) -- 关联人客户编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,party_name varchar2(500) -- 当事人名称
    ,party_rela_type_cd varchar2(30) -- 关联关系类型代码
    ,legal_rep_name varchar2(500) -- 法人代表名称
    ,rela_party_loan_card_no varchar2(60) -- 关联方贷款卡号
    ,rela_setup_dt date -- 关系建立日期
    ,sup_prod_name varchar2(500) -- 供应产品名称
    ,sup_curr_cd varchar2(30) -- 供应币种代码
    ,sup_amt number(30,2) -- 供应金额
    ,sup_ratio number(18,6) -- 供应比例
    ,remark varchar2(500) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,belong_sup_chain_client_bs_id varchar2(100) -- 所属供应链客户群编号
    ,co_years number(10) -- 合作年限
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,org_crdt_id varchar2(100) -- 机构信用编号
    ,stru_rela_party_reason_descb varchar2(500) -- 构成关联方理由描述
    ,hxb_rela_corp_flg varchar2(10) -- 我行关联企业标志
    ,can_sup_prod_descb varchar2(500) -- 可供应产品描述
    ,move_flg varchar2(10) -- 迁移标志
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
grant select on ${iml_schema}.pty_cust_rela_party_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_cust_rela_party_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_cust_rela_party_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_rela_party_info_h is '客户关联方信息历史';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.main_cust_id is '主客户编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.rela_ps_cust_id is '关联人客户编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.party_name is '当事人名称';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.party_rela_type_cd is '关联关系类型代码';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.legal_rep_name is '法人代表名称';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.rela_party_loan_card_no is '关联方贷款卡号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.rela_setup_dt is '关系建立日期';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.sup_prod_name is '供应产品名称';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.sup_curr_cd is '供应币种代码';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.sup_amt is '供应金额';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.sup_ratio is '供应比例';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.remark is '备注';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.belong_sup_chain_client_bs_id is '所属供应链客户群编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.co_years is '合作年限';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.org_crdt_id is '机构信用编号';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.stru_rela_party_reason_descb is '构成关联方理由描述';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.hxb_rela_corp_flg is '我行关联企业标志';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.can_sup_prod_descb is '可供应产品描述';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.move_flg is '迁移标志';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_rela_party_info_h.etl_timestamp is 'ETL处理时间戳';
