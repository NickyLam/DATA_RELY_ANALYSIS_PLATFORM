/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_corp_rgst_bill_info_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_corp_rgst_bill_info_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_corp_rgst_bill_info_para(
    rgst_id varchar2(60) -- 登记编号
    ,lp_id varchar2(60) -- 法人编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间编号
    ,bill_amt number(30,2) -- 票据金额
    ,bill_intrv_std_amt number(30,2) -- 票据区间标准金额
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bill_src_plat_cd varchar2(10) -- 票据来源平台代码
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,allow_split_pkg_ccution_flg varchar2(10) -- 允许分包流转标志
    ,init_bill_id varchar2(60) -- 原始票据编号
    ,actl_bf_split_bill_id varchar2(60) -- 实际拆前票据编号
    ,actl_bf_split_intrv_id varchar2(60) -- 实际拆前区间编号
    ,drawer_mem_cd varchar2(30) -- 出票人会员代码
    ,drawer_name varchar2(375) -- 出票人名称
    ,drawer_soci_crdt_cd varchar2(30) -- 出票人社会信用代码
    ,drawer_acct_type_cd varchar2(10) -- 出票人账户类型代码
    ,drawer_acct_id varchar2(60) -- 出票人账户编号
    ,drawer_acct_name varchar2(750) -- 出票人账户名称
    ,drawer_open_bank_no varchar2(30) -- 出票人开户行行号
    ,drawer_open_bank_name varchar2(375) -- 出票人开户行名称
    ,drawer_open_bank_org_cd varchar2(30) -- 出票人开户行机构代码
    ,drawer_open_bank_org_name varchar2(750) -- 出票人开户行机构名称
    ,accptor_mem_cd varchar2(30) -- 承兑人会员代码
    ,accptor_name varchar2(375) -- 承兑人名称
    ,accptor_soci_crdt_cd varchar2(30) -- 承兑人社会信用代码
    ,accptor_acct_type_cd varchar2(10) -- 承兑人账户类型代码
    ,accptor_acct_id varchar2(60) -- 承兑人账户编号
    ,accptor_acct_name varchar2(750) -- 承兑人账户名称
    ,accptor_open_bank_no varchar2(30) -- 承兑人开户行行号
    ,accptor_open_bank_name varchar2(375) -- 承兑人开户行名称
    ,accptor_open_bank_org_cd varchar2(30) -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name varchar2(750) -- 承兑人开户行机构名称
    ,recver_mem_cd varchar2(30) -- 收款人会员代码
    ,recver_name varchar2(375) -- 收款人名称
    ,recver_soci_crdt_cd varchar2(30) -- 收款人社会信用代码
    ,recver_acct_type_cd varchar2(10) -- 收款人账户类型代码
    ,recver_acct_id varchar2(60) -- 收款人账户编号
    ,recver_acct_name varchar2(750) -- 收款人账户名称
    ,recver_open_bank_no varchar2(30) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(375) -- 收款人开户行名称
    ,recver_open_bank_org_cd varchar2(30) -- 收款人开户行机构代码
    ,recver_open_bank_org_name varchar2(750) -- 收款人开户行机构名称
    ,pay_bank_bank_no varchar2(30) -- 付款行行号
    ,pay_bank_org_cd varchar2(30) -- 付款行机构代码
    ,pay_bank_name varchar2(375) -- 付款行名称
    ,acpt_guar_bk_bank_no varchar2(30) -- 承兑保证行行号
    ,acpt_guar_bk_org_cd varchar2(30) -- 承兑保证行机构代码
    ,coll_bank_bank_no varchar2(30) -- 托收行行号
    ,discnt_dt date -- 贴现日期
    ,discnt_bk_org_cd varchar2(30) -- 贴现行机构代码
    ,discnt_bank_name varchar2(375) -- 贴现行名称
    ,init_belong_rgst_org_cd varchar2(30) -- 初始权属登记机构代码
    ,risk_bill_status_cd varchar2(10) -- 风险票据状态代码
    ,not_ngbl_cd varchar2(10) -- 不得转让代码
    ,exp_uncond_pay_entr_cd varchar2(10) -- 到期无条件支付委托代码
    ,payoff_flg varchar2(10) -- 结清标志
    ,payoff_dt date -- 结清日期
    ,recs_type_cd varchar2(10) -- 追索类型代码
    ,bf_discnt_manual_recs_cd varchar2(10) -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd varchar2(10) -- 手动追索锁定标志代码
    ,endors_cnt number(10) -- 背书次数
    ,bill_obg_mem_cd varchar2(30) -- 票据权利人会员代码
    ,bill_obg_name varchar2(375) -- 票据权利人名称
    ,bill_obg_soci_crdt_cd varchar2(30) -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd varchar2(10) -- 票据权利人账户类型代码
    ,bill_obg_acct_id varchar2(60) -- 票据权利人账户编号
    ,bill_obg_open_bank_no varchar2(30) -- 票据权利人开户行行号
    ,bill_obg_open_bank_name varchar2(375) -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd varchar2(30) -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name varchar2(750) -- 票据权利人开户行机构名称
    ,lock_flg varchar2(10) -- 锁定标志
    ,bill_src_tran_cd varchar2(10) -- 票据来源交易代码
    ,bill_ccution_status_cd varchar2(10) -- 票据流转状态代码
    ,bill_status_cd varchar2(10) -- 票据状态代码
    ,bill_belong_name varchar2(375) -- 票据所属人名称
    ,bill_belong_soci_crdt_cd varchar2(30) -- 票据所属人社会信用代码
    ,bill_belong_acct_id varchar2(60) -- 票据所属人账户编号
    ,bill_belong_open_bank_no varchar2(30) -- 票据所属人开户行行号
    ,bill_belong_open_bank_name varchar2(375) -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd varchar2(30) -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name varchar2(500) -- 票据所属人开户行机构名称
    ,fir_rgst_id varchar2(60) -- 首次登记编号
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.ref_corp_rgst_bill_info_para to ${icl_schema};
grant select on ${iml_schema}.ref_corp_rgst_bill_info_para to ${idl_schema};
grant select on ${iml_schema}.ref_corp_rgst_bill_info_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_corp_rgst_bill_info_para is '企业登记中心票据信息参数';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.rgst_id is '登记编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_num is '票据号码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_sub_intrv_id is '票据子区间编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_amt is '票据金额';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_intrv_std_amt is '票据区间标准金额';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_src_plat_cd is '票据来源平台代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.draw_dt is '出票日期';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.exp_dt is '到期日期';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.allow_split_pkg_ccution_flg is '允许分包流转标志';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.init_bill_id is '原始票据编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.actl_bf_split_bill_id is '实际拆前票据编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.actl_bf_split_intrv_id is '实际拆前区间编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_mem_cd is '出票人会员代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_name is '出票人名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_soci_crdt_cd is '出票人社会信用代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_acct_type_cd is '出票人账户类型代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_acct_id is '出票人账户编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_acct_name is '出票人账户名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_open_bank_no is '出票人开户行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_open_bank_name is '出票人开户行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_open_bank_org_cd is '出票人开户行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.drawer_open_bank_org_name is '出票人开户行机构名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_mem_cd is '承兑人会员代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_name is '承兑人名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_soci_crdt_cd is '承兑人社会信用代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_acct_type_cd is '承兑人账户类型代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_acct_id is '承兑人账户编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_acct_name is '承兑人账户名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_open_bank_org_cd is '承兑人开户行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.accptor_open_bank_org_name is '承兑人开户行机构名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_mem_cd is '收款人会员代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_name is '收款人名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_soci_crdt_cd is '收款人社会信用代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_acct_type_cd is '收款人账户类型代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_acct_name is '收款人账户名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_open_bank_org_cd is '收款人开户行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recver_open_bank_org_name is '收款人开户行机构名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.pay_bank_bank_no is '付款行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.pay_bank_org_cd is '付款行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.pay_bank_name is '付款行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.acpt_guar_bk_bank_no is '承兑保证行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.acpt_guar_bk_org_cd is '承兑保证行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.coll_bank_bank_no is '托收行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.discnt_dt is '贴现日期';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.discnt_bk_org_cd is '贴现行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.discnt_bank_name is '贴现行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.init_belong_rgst_org_cd is '初始权属登记机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.risk_bill_status_cd is '风险票据状态代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.not_ngbl_cd is '不得转让代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.exp_uncond_pay_entr_cd is '到期无条件支付委托代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.payoff_flg is '结清标志';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.payoff_dt is '结清日期';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.recs_type_cd is '追索类型代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bf_discnt_manual_recs_cd is '贴现前手动追索代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.manual_recs_lock_flg_cd is '手动追索锁定标志代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.endors_cnt is '背书次数';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_mem_cd is '票据权利人会员代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_name is '票据权利人名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_soci_crdt_cd is '票据权利人社会信用代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_acct_type_cd is '票据权利人账户类型代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_acct_id is '票据权利人账户编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_open_bank_no is '票据权利人开户行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_open_bank_name is '票据权利人开户行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_open_bank_org_cd is '票据权利人开户行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_obg_open_bank_org_name is '票据权利人开户行机构名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.lock_flg is '锁定标志';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_src_tran_cd is '票据来源交易代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_ccution_status_cd is '票据流转状态代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_status_cd is '票据状态代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_name is '票据所属人名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_soci_crdt_cd is '票据所属人社会信用代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_acct_id is '票据所属人账户编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_open_bank_no is '票据所属人开户行行号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_open_bank_name is '票据所属人开户行名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_open_bank_org_cd is '票据所属人开户行机构代码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.bill_belong_open_bank_org_name is '票据所属人开户行机构名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.fir_rgst_id is '首次登记编号';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_corp_rgst_bill_info_para.etl_timestamp is 'ETL处理时间戳';
