/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ref_bill_info_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ref_bill_info_para
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ref_bill_info_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ref_bill_info_para(
    etl_dt date -- 数据日期
    ,bill_id varchar2(60) -- 票据编号
    ,lp_id varchar2(60) -- 法人编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_lev_ctrl_flg varchar2(10) -- 票据级别控制标志
    ,role_src_cd varchar2(10) -- 角色来源代码
    ,discnt_batch_id varchar2(60) -- 贴现批次编号
    ,pbc_tranbl_flg varchar2(10) -- 人行可转让标志
    ,hxb_acpt_flg varchar2(10) -- 我行承兑标志
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,draw_dt date -- 出票日期
    ,fac_val_exp_dt date -- 票面到期日期
    ,cust_id varchar2(60) -- 客户编号
    ,drawer_cate_cd varchar2(10) -- 出票人类别代码
    ,drawer_orgnz_cd varchar2(30) -- 出票人组织机构代码
    ,drawer_name varchar2(100) -- 出票人名称
    ,drawer_acct_num varchar2(60) -- 出票人账号
    ,drawer_open_bank_num varchar2(60) -- 出票人开户行号
    ,accptor_open_bank_name varchar2(250) -- 承兑人开户行名称
    ,drawer_open_bank_name varchar2(250) -- 出票人开户行名称
    ,accptor_name varchar2(250) -- 承兑人名称
    ,accptor_open_bank_num varchar2(60) -- 承兑人开户行号
    ,accptor_acct_num varchar2(100) -- 承兑人账号
    ,recver_name varchar2(250) -- 收款人名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_open_bank_num varchar2(60) -- 收款人开户行号
    ,recver_open_bank_name varchar2(250) -- 收款人开户行名称
    ,bill_amt number(30,2) -- 票据金额
    ,sys_in_acpt_flg varchar2(10) -- 系统内承兑标志
    ,bill_belong_org_id varchar2(60) -- 票据所属机构编号
    ,bill_invtry_status_cd varchar2(10) -- 票据库存状态代码
    ,bill_status_cd varchar2(30) -- 票据状态代码
    ,proc_mdl_status_cd varchar2(10) -- 处理中状态代码
    ,inpwn_status_cd varchar2(10) -- 质押状态代码
    ,inpwn_rgst_b_id varchar2(60) -- 质押登记簿编号
    ,loss_status_cd varchar2(10) -- 挂失状态代码
    ,loss_rgst_b_id varchar2(60) -- 挂失登记簿编号
    ,final_modif_operr_id varchar2(60) -- 最后修改操作员编号
    ,final_modif_tm timestamp -- 最后修改时间
    ,drawer_crdt_level_cd varchar2(10) -- 出票人信用等级代码
    ,drawer_rating_org_id varchar2(60) -- 出票人评级机构编号
    ,drawer_rating_exp_dt date -- 出票人评级到期日期
    ,recv_bank_name varchar2(100) -- 收款行名称
    ,cpes_acpt_rgst_status_flg varchar2(10) -- 票交所承兑登记状态标志
    ,cpes_discnt_rgst_status_flg varchar2(10) -- 票交所贴现登记状态标志
    ,drawer_unify_soci_crdt_cd varchar2(30) -- 出票人统一社会信用代码
    ,payoff_flg varchar2(10) -- 结清标志
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_ref_bill_info_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ref_bill_info_para is '票据信息参数';
comment on column ${idl_schema}.aml_ref_bill_info_para.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_id is '票据编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.lp_id is '法人编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_num is '票据号码';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_lev_ctrl_flg is '票据级别控制标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.role_src_cd is '角色来源代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.discnt_batch_id is '贴现批次编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.pbc_tranbl_flg is '人行可转让标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.hxb_acpt_flg is '我行承兑标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_type_cd is '票据类型代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.draw_dt is '出票日期';
comment on column ${idl_schema}.aml_ref_bill_info_para.fac_val_exp_dt is '票面到期日期';
comment on column ${idl_schema}.aml_ref_bill_info_para.cust_id is '客户编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_cate_cd is '出票人类别代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_orgnz_cd is '出票人组织机构代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_name is '出票人名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_acct_num is '出票人账号';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_open_bank_num is '出票人开户行号';
comment on column ${idl_schema}.aml_ref_bill_info_para.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_open_bank_name is '出票人开户行名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.accptor_name is '承兑人名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.accptor_open_bank_num is '承兑人开户行号';
comment on column ${idl_schema}.aml_ref_bill_info_para.accptor_acct_num is '承兑人账号';
comment on column ${idl_schema}.aml_ref_bill_info_para.recver_name is '收款人名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.recver_acct_num is '收款人账号';
comment on column ${idl_schema}.aml_ref_bill_info_para.recver_open_bank_num is '收款人开户行号';
comment on column ${idl_schema}.aml_ref_bill_info_para.recver_open_bank_name is '收款人开户行名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_amt is '票据金额';
comment on column ${idl_schema}.aml_ref_bill_info_para.sys_in_acpt_flg is '系统内承兑标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_belong_org_id is '票据所属机构编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_invtry_status_cd is '票据库存状态代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.bill_status_cd is '票据状态代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.proc_mdl_status_cd is '处理中状态代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.inpwn_status_cd is '质押状态代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.inpwn_rgst_b_id is '质押登记簿编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.loss_status_cd is '挂失状态代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.loss_rgst_b_id is '挂失登记簿编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.final_modif_operr_id is '最后修改操作员编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.final_modif_tm is '最后修改时间';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_crdt_level_cd is '出票人信用等级代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_rating_org_id is '出票人评级机构编号';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_rating_exp_dt is '出票人评级到期日期';
comment on column ${idl_schema}.aml_ref_bill_info_para.recv_bank_name is '收款行名称';
comment on column ${idl_schema}.aml_ref_bill_info_para.cpes_acpt_rgst_status_flg is '票交所承兑登记状态标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.cpes_discnt_rgst_status_flg is '票交所贴现登记状态标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.drawer_unify_soci_crdt_cd is '出票人统一社会信用代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.payoff_flg is '结清标志';
comment on column ${idl_schema}.aml_ref_bill_info_para.job_cd is '任务代码';
comment on column ${idl_schema}.aml_ref_bill_info_para.etl_timestamp is '数据处理时间';
