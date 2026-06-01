/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_rgst_cter_bill_info_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_rgst_cter_bill_info_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_rgst_cter_bill_info_para(
    rgst_id varchar2(60) -- 登记编号
    ,lp_id varchar2(60) -- 法人编号
    ,init_bill_sys_bill_id varchar2(60) -- 原票据系统票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,bill_amt number(30,2) -- 贴现票据金额
    ,drawer_name varchar2(150) -- 出票人名称
    ,drawer_acct_num varchar2(60) -- 出票人账号
    ,drawer_open_bank_no varchar2(60) -- 出票人开户行行号
    ,drawer_open_bank_name varchar2(750) -- 出票人开户行名称
    ,drawer_soci_crdt_cd varchar2(60) -- 出票人社会信用代码
    ,accptor_name varchar2(150) -- 承兑人名称
    ,accptor_acct_num varchar2(60) -- 承兑人账号
    ,accptor_open_bank_no varchar2(60) -- 承兑人开户行行号
    ,accptor_open_bank_name varchar2(750) -- 承兑人开户行名称
    ,accptor_soci_crdt_cd varchar2(60) -- 承兑人社会信用代码
    ,recver_name varchar2(150) -- 收款人名称
    ,recver_open_bank_name varchar2(750) -- 收款人开户行名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_soci_crdt_cd varchar2(60) -- 收款人社会信用代码
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_org_cd varchar2(30) -- 付款行机构代码
    ,pay_bank_name varchar2(750) -- 付款行名称
    ,pay_cfm_org_cd varchar2(30) -- 付款确认机构代码
    ,acpt_guar_bank_no varchar2(60) -- 承兑保证行行号
    ,coll_bank_no varchar2(60) -- 托收行行号
    ,holder_name varchar2(150) -- 持票人名称
    ,holder_soci_crdt_cd varchar2(60) -- 持票人社会信用代码
    ,holder_acct_num varchar2(60) -- 持票人账号
    ,holder_org_cd varchar2(30) -- 持票人机构代码
    ,holder_org_name varchar2(750) -- 持票人机构名称
    ,risk_bill_status_cd varchar2(10) -- 风险票据状态代码
    ,bill_invtry_status_cd varchar2(30) -- 票据库存状态代码
    ,bill_src_cd varchar2(10) -- 票据来源代码
    ,bill_ccution_status_cd varchar2(10) -- 票据流转状态代码
    ,bill_status_cd varchar2(10) -- 票据状态代码
    ,comb_status_cd varchar2(200) -- 组合状态代码
    ,discnt_bk_org_cd varchar2(30) -- 贴现行机构代码
    ,discnt_bank_name varchar2(750) -- 贴现行名称
    ,invtry_org_cd varchar2(30) -- 库存机构代码
    ,init_belong_rgst_org_cd varchar2(30) -- 初始权属登记机构代码
    ,bill_belong_org_id varchar2(60) -- 票据所属机构编号
    ,hq_org_id varchar2(60) -- 总行机构编号
    ,hxb_acpt_flg varchar2(10) -- 我行承兑标志
    ,pay_cfm_flg varchar2(30) -- 付款确认标志
    ,lock_flg varchar2(10) -- 锁定标志
    ,payoff_flg varchar2(10) -- 结清标志
    ,recs_flg varchar2(10) -- 追偿标志
    ,discnt_dt date -- 贴现日期
    ,tran_cd varchar2(30) -- 转让代码
    ,receipt_flg varchar2(10) -- 小票标志
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号
    ,bill_intrv_std_amt number(30,2) -- 票据区间标准金额
    ,init_bill_id varchar2(60) -- 原始票据编号
    ,select_id varchar2(60) -- 挑票编号
    ,actl_bf_split_bill_id varchar2(60) -- 实际拆前票据编号
    ,actl_bf_split_intrv_id varchar2(60) -- 实际拆前区间编号
    ,remark_1 varchar2(750) -- 备注1
    ,payoff_dt date -- 结清日期
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
grant select on ${iml_schema}.ref_rgst_cter_bill_info_para to ${icl_schema};
grant select on ${iml_schema}.ref_rgst_cter_bill_info_para to ${idl_schema};
grant select on ${iml_schema}.ref_rgst_cter_bill_info_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_rgst_cter_bill_info_para is '登记中心票据信息参数';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.rgst_id is '登记编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.init_bill_sys_bill_id is '原票据系统票据编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_num is '票据号码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.draw_dt is '出票日期';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.exp_dt is '到期日期';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_amt is '贴现票据金额';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.drawer_name is '出票人名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.drawer_acct_num is '出票人账号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.drawer_open_bank_no is '出票人开户行行号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.drawer_open_bank_name is '出票人开户行名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.drawer_soci_crdt_cd is '出票人社会信用代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.accptor_name is '承兑人名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.accptor_acct_num is '承兑人账号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.accptor_soci_crdt_cd is '承兑人社会信用代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.recver_name is '收款人名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.recver_soci_crdt_cd is '收款人社会信用代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.pay_bank_org_cd is '付款行机构代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.pay_bank_name is '付款行名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.pay_cfm_org_cd is '付款确认机构代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.acpt_guar_bank_no is '承兑保证行行号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.coll_bank_no is '托收行行号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.holder_name is '持票人名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.holder_soci_crdt_cd is '持票人社会信用代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.holder_acct_num is '持票人账号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.holder_org_cd is '持票人机构代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.holder_org_name is '持票人机构名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.risk_bill_status_cd is '风险票据状态代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_invtry_status_cd is '票据库存状态代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_src_cd is '票据来源代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_ccution_status_cd is '票据流转状态代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_status_cd is '票据状态代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.comb_status_cd is '组合状态代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.discnt_bk_org_cd is '贴现行机构代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.discnt_bank_name is '贴现行名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.invtry_org_cd is '库存机构代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.init_belong_rgst_org_cd is '初始权属登记机构代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_belong_org_id is '票据所属机构编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.hxb_acpt_flg is '我行承兑标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.pay_cfm_flg is '付款确认标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.lock_flg is '锁定标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.payoff_flg is '结清标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.recs_flg is '追偿标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.discnt_dt is '贴现日期';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.tran_cd is '转让代码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.receipt_flg is '小票标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_sub_intrv_id is '票据子区间号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.bill_intrv_std_amt is '票据区间标准金额';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.init_bill_id is '原始票据编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.select_id is '挑票编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.actl_bf_split_bill_id is '实际拆前票据编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.actl_bf_split_intrv_id is '实际拆前区间编号';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.remark_1 is '备注1';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.payoff_dt is '结清日期';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_rgst_cter_bill_info_para.etl_timestamp is 'ETL处理时间戳';
