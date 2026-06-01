/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lp_od_sign_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lp_od_sign_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lp_od_sign_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lp_od_sign_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,agt_status_cd varchar2(30) -- 协议状态代码
    ,sign_agt_type_cd varchar2(30) -- 签约协议类型代码
    ,comm_fee_coll_way_cd varchar2(30) -- 手续费收取方式代码
    ,od_way_cd varchar2(30) -- 透支方式代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,curr_cd varchar2(30) -- 币种代码
    ,fee_rat number(18,8) -- 费率
    ,loan_acct_curr_cd varchar2(30) -- 贷款账户币种代码
    ,loan_num varchar2(60) -- 贷款号
    ,loan_acct_id varchar2(100) -- 贷款账户编号
    ,loan_prod_id varchar2(100) -- 贷款产品编号
    ,loan_acct_seq_num varchar2(60) -- 贷款账户序号
    ,od_lmt number(30,2) -- 透支额度
    ,od_curr_cd varchar2(30) -- 透支币种代码
    ,od_free_int_tenor number(10) -- 透支免息期限
    ,od_tenor number(10) -- 透支期限
    ,od_tenor_type_cd varchar2(30) -- 透支期限类型代码
    ,start_od_amt number(30,6) -- 起透金额
    ,charge_day varchar2(10) -- 收费日
    ,charge_freq_cd varchar2(30) -- 收费频率代码
    ,fee_coll_way_cd varchar2(30) -- 费用收取方式代码
    ,charge_ratio number(18,6) -- 收费比例
    ,file_acrs_mon_idf_cd varchar2(30) -- 靠档跨月标识代码
    ,lp_od_exp_day_calc_rule_cd varchar2(30) -- 法透到期日计算规则代码
    ,lp_od_repay_way_cd varchar2(30) -- 法透还款方式代码
    ,need_amort_flg varchar2(10) -- 需要摊销标志
    ,white_list_cust_info_remark varchar2(4000) -- 白名单客户信息备注
    ,remark varchar2(750) -- 备注
    ,fee_prod_id varchar2(100) -- 费用产品编号
    ,base_int_rat number(18,8) -- 基准利率
    ,exec_int_rat number(38,8) -- 执行利率
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,email_addr varchar2(4000) -- 邮箱地址
    ,file_int_accr_flg varchar2(10) -- 靠档计息标志
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
grant select on ${iml_schema}.agt_lp_od_sign_h to ${icl_schema};
grant select on ${iml_schema}.agt_lp_od_sign_h to ${idl_schema};
grant select on ${iml_schema}.agt_lp_od_sign_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lp_od_sign_h is '法人透支签约历史';
comment on column ${iml_schema}.agt_lp_od_sign_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_lp_od_sign_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_lp_od_sign_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.agt_status_cd is '协议状态代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.sign_agt_type_cd is '签约协议类型代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.comm_fee_coll_way_cd is '手续费收取方式代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.od_way_cd is '透支方式代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_lp_od_sign_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_lp_od_sign_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.fee_rat is '费率';
comment on column ${iml_schema}.agt_lp_od_sign_h.loan_acct_curr_cd is '贷款账户币种代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.loan_num is '贷款号';
comment on column ${iml_schema}.agt_lp_od_sign_h.loan_acct_id is '贷款账户编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.loan_acct_seq_num is '贷款账户序号';
comment on column ${iml_schema}.agt_lp_od_sign_h.od_lmt is '透支额度';
comment on column ${iml_schema}.agt_lp_od_sign_h.od_curr_cd is '透支币种代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.od_free_int_tenor is '透支免息期限';
comment on column ${iml_schema}.agt_lp_od_sign_h.od_tenor is '透支期限';
comment on column ${iml_schema}.agt_lp_od_sign_h.od_tenor_type_cd is '透支期限类型代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.start_od_amt is '起透金额';
comment on column ${iml_schema}.agt_lp_od_sign_h.charge_day is '收费日';
comment on column ${iml_schema}.agt_lp_od_sign_h.charge_freq_cd is '收费频率代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.fee_coll_way_cd is '费用收取方式代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.charge_ratio is '收费比例';
comment on column ${iml_schema}.agt_lp_od_sign_h.file_acrs_mon_idf_cd is '靠档跨月标识代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.lp_od_exp_day_calc_rule_cd is '法透到期日计算规则代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.lp_od_repay_way_cd is '法透还款方式代码';
comment on column ${iml_schema}.agt_lp_od_sign_h.need_amort_flg is '需要摊销标志';
comment on column ${iml_schema}.agt_lp_od_sign_h.white_list_cust_info_remark is '白名单客户信息备注';
comment on column ${iml_schema}.agt_lp_od_sign_h.remark is '备注';
comment on column ${iml_schema}.agt_lp_od_sign_h.fee_prod_id is '费用产品编号';
comment on column ${iml_schema}.agt_lp_od_sign_h.base_int_rat is '基准利率';
comment on column ${iml_schema}.agt_lp_od_sign_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_lp_od_sign_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_lp_od_sign_h.email_addr is '邮箱地址';
comment on column ${iml_schema}.agt_lp_od_sign_h.file_int_accr_flg is '靠档计息标志';
comment on column ${iml_schema}.agt_lp_od_sign_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lp_od_sign_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lp_od_sign_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lp_od_sign_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lp_od_sign_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lp_od_sign_h.etl_timestamp is 'ETL处理时间戳';
