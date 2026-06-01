/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dep_recvbl_fee_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dep_recvbl_fee_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dep_recvbl_fee_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_recvbl_fee_dtl(
    evt_id varchar2(250) -- 事件编号
    ,recvbl_fee_seq_num varchar2(60) -- 应收费用序号
    ,lp_id varchar2(100) -- 法人编号
    ,bus_tran_dt date -- 业务交易日期
    ,seq_num varchar2(60) -- 序号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_name varchar2(500) -- 账户名称
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,charge_acct_id varchar2(100) -- 收费账户编号
    ,charge_acct_prod_id varchar2(100) -- 收费账户产品编号
    ,charge_cust_acct_num varchar2(60) -- 收费客户账号
    ,charge_acct_curr_cd varchar2(30) -- 收费账户币种代码
    ,acct_id varchar2(100) -- 账户编号
    ,effect_dt date -- 生效日期
    ,last_charge_dt date -- 上一收费日期
    ,tran_revs_dt date -- 交易冲正日期
    ,revs_org_id varchar2(100) -- 冲正机构编号
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_id varchar2(250) -- 凭证编号
    ,vouch_sum_qtty number(30) -- 凭证合计数量
    ,dep_agt_id varchar2(100) -- 存款协议编号
    ,cntpty_bus_id varchar2(100) -- 对手业务编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,discnt_fee_amt number(30,2) -- 折扣费用金额
    ,fee_type_id varchar2(100) -- 费用类型编号
    ,fee_amt number(30,2) -- 收费金额
    ,init_fee_amt number(30,2) -- 原始费用金额
    ,next_charge_dt date -- 下一收费日期
    ,tax number(30,2) -- 税金
    ,init_recvbl_fee_amt number(30,2) -- 原应收费用金额
    ,fee_price number(30,2) -- 费用单价
    ,charge_freq_cd varchar2(30) -- 收费频率代码
    ,tax_rat number(18,8) -- 税率
    ,tax_category_cd varchar2(30) -- 税种代码
    ,need_prft_cut_flg varchar2(10) -- 需要分润标志
    ,tran_bank_prft_cut_amt number(30,2) -- 交易行分润金额
    ,fee_charge_way_cd varchar2(30) -- 费用收费方式代码
    ,grace_flg varchar2(10) -- 宽限标志
    ,tran_revd_flg varchar2(10) -- 交易已冲正标志
    ,fee_discnt_type_cd varchar2(30) -- 费用折扣类型代码
    ,tran_bank_ratio number(18,6) -- 交易行比例
    ,charge_curr_cd varchar2(30) -- 收费币种代码
    ,charge_sub_acct_num varchar2(60) -- 收费子账号
    ,charge_day varchar2(10) -- 收费日
    ,termnt_num varchar2(60) -- 终止号码
    ,acct_bank_ratio number(18,6) -- 账户行比例
    ,acct_bank_prft_cut_amt number(30,2) -- 账户行分润金额
    ,owe_fee_status_cd varchar2(30) -- 欠费状态代码
    ,prior_level varchar2(30) -- 优先等级
    ,fee_discnt_rat number(30,2) -- 费用折扣率
    ,revs_auth_teller_id varchar2(100) -- 冲正授权柜员编号
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
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
grant select on ${iml_schema}.evt_dep_recvbl_fee_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_dep_recvbl_fee_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_dep_recvbl_fee_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dep_recvbl_fee_dtl is '存款应收费用明细';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.recvbl_fee_seq_num is '应收费用序号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.seq_num is '序号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.acct_name is '账户名称';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_acct_id is '收费账户编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_acct_prod_id is '收费账户产品编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_cust_acct_num is '收费客户账号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_acct_curr_cd is '收费账户币种代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.last_charge_dt is '上一收费日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_revs_dt is '交易冲正日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.revs_org_id is '冲正机构编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.vouch_id is '凭证编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.vouch_sum_qtty is '凭证合计数量';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.dep_agt_id is '存款协议编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.cntpty_bus_id is '对手业务编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.discnt_fee_amt is '折扣费用金额';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.fee_type_id is '费用类型编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.fee_amt is '收费金额';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.init_fee_amt is '原始费用金额';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.next_charge_dt is '下一收费日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tax is '税金';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.init_recvbl_fee_amt is '原应收费用金额';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.fee_price is '费用单价';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_freq_cd is '收费频率代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tax_rat is '税率';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tax_category_cd is '税种代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.need_prft_cut_flg is '需要分润标志';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_bank_prft_cut_amt is '交易行分润金额';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.fee_charge_way_cd is '费用收费方式代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.grace_flg is '宽限标志';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_revd_flg is '交易已冲正标志';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.fee_discnt_type_cd is '费用折扣类型代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_bank_ratio is '交易行比例';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_curr_cd is '收费币种代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_sub_acct_num is '收费子账号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.charge_day is '收费日';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.termnt_num is '终止号码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.acct_bank_ratio is '账户行比例';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.acct_bank_prft_cut_amt is '账户行分润金额';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.owe_fee_status_cd is '欠费状态代码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.prior_level is '优先等级';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.fee_discnt_rat is '费用折扣率';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.revs_auth_teller_id is '冲正授权柜员编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.revs_teller_id is '冲正柜员编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dep_recvbl_fee_dtl.etl_timestamp is 'ETL处理时间戳';
