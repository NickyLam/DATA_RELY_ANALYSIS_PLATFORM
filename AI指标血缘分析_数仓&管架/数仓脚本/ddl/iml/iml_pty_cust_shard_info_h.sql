/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_shard_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_shard_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_shard_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_shard_info_h(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,party_name varchar2(500) -- 当事人名称
    ,party_rela_type_cd varchar2(30) -- 关联关系类型代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,invest_curr_cd varchar2(30) -- 投资币种代码
    ,invest_ratio number(18,6) -- 投资比例
    ,invest_amt number(30,2) -- 出资金额
    ,actl_pay_amt number(30,2) -- 实缴金额
    ,tot_invest_amt_latest_ready_dt date -- 总投资金额最迟到位日期
    ,share_right_cert_num varchar2(60) -- 股权证号码
    ,remark varchar2(500) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,cty_rg_cd varchar2(30) -- 股东国别代码
    ,corp_actl_ctrler_flg varchar2(10) -- 企业实际控制人标志
    ,share_ratio number(18,6) -- 持股比例
    ,contri_latest_ready_dt date -- 出资最迟到位日期
    ,legal_rep_name varchar2(500) -- 法人代表名称
    ,contrior_type_cd varchar2(30) -- 出资人类型代码
    ,contrior_idti_cate_cd varchar2(30) -- 出资人身份类别代码
    ,valid_flg varchar2(10) -- 有效标志
    ,start_hold_stock_dt date -- 开始持股日期
    ,org_crdt_id varchar2(100) -- 机构信用编号
    ,unify_soci_crdt_cd varchar2(30) -- 统一社会信用代码
    ,comer_rgst_and_non_comer_rgst_cert_num varchar2(60) -- 商事与非商事登记证号
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
grant select on ${iml_schema}.pty_cust_shard_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_cust_shard_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_cust_shard_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_shard_info_h is '客户股东信息历史';
comment on column ${iml_schema}.pty_cust_shard_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.party_name is '当事人名称';
comment on column ${iml_schema}.pty_cust_shard_info_h.party_rela_type_cd is '关联关系类型代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_cust_shard_info_h.invest_curr_cd is '投资币种代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.invest_ratio is '投资比例';
comment on column ${iml_schema}.pty_cust_shard_info_h.invest_amt is '出资金额';
comment on column ${iml_schema}.pty_cust_shard_info_h.actl_pay_amt is '实缴金额';
comment on column ${iml_schema}.pty_cust_shard_info_h.tot_invest_amt_latest_ready_dt is '总投资金额最迟到位日期';
comment on column ${iml_schema}.pty_cust_shard_info_h.share_right_cert_num is '股权证号码';
comment on column ${iml_schema}.pty_cust_shard_info_h.remark is '备注';
comment on column ${iml_schema}.pty_cust_shard_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_cust_shard_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.pty_cust_shard_info_h.cty_rg_cd is '股东国别代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.corp_actl_ctrler_flg is '企业实际控制人标志';
comment on column ${iml_schema}.pty_cust_shard_info_h.share_ratio is '持股比例';
comment on column ${iml_schema}.pty_cust_shard_info_h.contri_latest_ready_dt is '出资最迟到位日期';
comment on column ${iml_schema}.pty_cust_shard_info_h.legal_rep_name is '法人代表名称';
comment on column ${iml_schema}.pty_cust_shard_info_h.contrior_type_cd is '出资人类型代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.contrior_idti_cate_cd is '出资人身份类别代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.valid_flg is '有效标志';
comment on column ${iml_schema}.pty_cust_shard_info_h.start_hold_stock_dt is '开始持股日期';
comment on column ${iml_schema}.pty_cust_shard_info_h.org_crdt_id is '机构信用编号';
comment on column ${iml_schema}.pty_cust_shard_info_h.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.pty_cust_shard_info_h.comer_rgst_and_non_comer_rgst_cert_num is '商事与非商事登记证号';
comment on column ${iml_schema}.pty_cust_shard_info_h.move_flg is '迁移标志';
comment on column ${iml_schema}.pty_cust_shard_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cust_shard_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cust_shard_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cust_shard_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_shard_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_shard_info_h.etl_timestamp is 'ETL处理时间戳';
