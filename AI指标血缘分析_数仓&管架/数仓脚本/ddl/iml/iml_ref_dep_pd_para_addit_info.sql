/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_dep_pd_para_addit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_dep_pd_para_addit_info
whenever sqlerror continue none;
drop table ${iml_schema}.ref_dep_pd_para_addit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_pd_para_addit_info(
    lp_id varchar2(100) -- 法人编号
    ,pd_cd varchar2(30) -- 期次编号
    ,min_chg_amt number(30,2) -- 最小变动金额
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,stl_acct_type_cd varchar2(30) -- 结算账户类型代码
    ,core_tran_teller_id varchar2(100) -- 核心交易柜员编号
    ,dom_flg varchar2(10) -- 境内标志
    ,transf_flg varchar2(10) -- 转让标志
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,aval_lmt number(30,2) -- 可用额度
    ,min_retnd_amt number(30,2) -- 最小留存金额
    ,exec_int_rat number(18,8) -- 执行利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,float_ratio number(18,6) -- 浮动比例
    ,redem_int_rat number(18,8) -- 赎回利率
    ,sellbl_chn_id varchar2(100) -- 可售渠道编号
    ,redem_int_rat_type_cd varchar2(30) -- 赎回利率类型代码
    ,tran_in_fee number(30,2) -- 转入费用
    ,allow_cap_src_inside_acct_flg varchar2(10) -- 允许资金来源为内部户标志
    ,redem_int_rat_idf varchar2(10) -- 赎回利率标识
    ,value_idf_cd varchar2(30) -- 起息标识代码
    ,spec_col_int_flg varchar2(10) -- 指定收息标志
    ,init_apot_redem_dt date -- 原约定赎回日期
    ,tran_out_fee number(30,2) -- 转出费用
    ,tran_out_fee_type_cd varchar2(30) -- 转出费用类型编号
    ,sell_org_id varchar2(500) -- 出售机构编号
    ,sig_min_wdraw_amt number(30,2) -- 单次最小支取金额
    ,sig_subscr_max_amt number(30,2) -- 单笔认购最大金额
    ,tran_in_fee_type_cd varchar2(30) -- 转入费用类型编号
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,mailbox varchar2(375) -- 邮箱
    ,comb_prod_flg varchar2(10) -- 组合产品标志
    ,non_cust_visib_flg varchar2(10) -- 非专享客户可见标志
    ,modif_id varchar2(100) -- OM变更编号
    ,roll_issue_flg varchar2(10) -- 滚动发行标志
    ,roll_begin_dt date -- 滚动起始日期
    ,roll_termnt_dt date -- 滚动终止日期
    ,redem_freq_corp_cd varchar2(30) -- 赎回频率单位代码
    ,redem_freq number(10) -- 赎回频率
    ,white_list_modif_flg varchar2(10) -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id varchar2(1000) -- 支持变更白名单分行机构编号
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
grant select on ${iml_schema}.ref_dep_pd_para_addit_info to ${icl_schema};
grant select on ${iml_schema}.ref_dep_pd_para_addit_info to ${idl_schema};
grant select on ${iml_schema}.ref_dep_pd_para_addit_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_dep_pd_para_addit_info is '存款期次参数附加信息';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.lp_id is '法人编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.pd_cd is '期次编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.min_chg_amt is '最小变动金额';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.stl_acct_type_cd is '结算账户类型代码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.core_tran_teller_id is '核心交易柜员编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.dom_flg is '境内标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.transf_flg is '转让标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.value_dt is '起息日期';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.exp_dt is '到期日期';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.aval_lmt is '可用额度';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.min_retnd_amt is '最小留存金额';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.exec_int_rat is '执行利率';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.float_int_rat is '浮动利率';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.float_ratio is '浮动比例';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.redem_int_rat is '赎回利率';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.sellbl_chn_id is '可售渠道编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.redem_int_rat_type_cd is '赎回利率类型代码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.tran_in_fee is '转入费用';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.allow_cap_src_inside_acct_flg is '允许资金来源为内部户标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.redem_int_rat_idf is '赎回利率标识';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.value_idf_cd is '起息标识代码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.spec_col_int_flg is '指定收息标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.init_apot_redem_dt is '原约定赎回日期';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.tran_out_fee is '转出费用';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.tran_out_fee_type_cd is '转出费用类型编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.sell_org_id is '出售机构编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.sig_min_wdraw_amt is '单次最小支取金额';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.sig_subscr_max_amt is '单笔认购最大金额';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.tran_in_fee_type_cd is '转入费用类型编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.mailbox is '邮箱';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.comb_prod_flg is '组合产品标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.non_cust_visib_flg is '非专享客户可见标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.modif_id is 'OM变更编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.roll_issue_flg is '滚动发行标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.roll_begin_dt is '滚动起始日期';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.roll_termnt_dt is '滚动终止日期';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.redem_freq_corp_cd is '赎回频率单位代码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.redem_freq is '赎回频率';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.white_list_modif_flg is '白名单变更标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.supt_modif_white_list_brch_org_id is '支持变更白名单分行机构编号';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.start_dt is '开始时间';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.end_dt is '结束时间';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.id_mark is '增删标志';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.job_cd is '任务编码';
comment on column ${iml_schema}.ref_dep_pd_para_addit_info.etl_timestamp is 'ETL处理时间戳';
