/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_finc_sign_agt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_finc_sign_agt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_finc_sign_agt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_sign_agt_h(
    agt_id varchar2(250) -- 协议编号
    ,dep_agt_id varchar2(100) -- 存款协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,sign_agt_type_cd varchar2(30) -- 签约协议类型代码
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,finc_prod_type_descb varchar2(500) -- 理财产品类型描述
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,finc_amt number(30,2) -- 理财金额
    ,agt_retnd_amt number(30,2) -- 协议留存金额
    ,auto_delay_flg varchar2(10) -- 自动延期标志
    ,sign_agt_status_cd varchar2(30) -- 签约协议状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,final_modif_dt date -- 最后修改日期
    ,min_init_amt number(30,2) -- 最小起存金额
    ,finc_fix_amt number(30,2) -- 理财固定金额
    ,dep_tenor varchar2(30) -- 存款期限
    ,dep_tenor_type_cd varchar2(30) -- 存款期限类型代码
    ,auto_redt_way_type_cd varchar2(30) -- 自动转存方式类型代码
    ,conti_redt_fail_cnt number(10) -- 连续转存失败次数
    ,conti_redt_sucs_cnt number(10) -- 连续转存成功次数
    ,redt_fail_tot_cnt number(10) -- 转存失败总次数
    ,redt_sucs_tot_cnt number(10) -- 转存成功总次数
    ,last_redt_flow_id varchar2(100) -- 上一转存流水编号
    ,tran_freq number(10) -- 划转频率
    ,tran_freq_cd varchar2(30) -- 划转频率代码
    ,last_tran_dt date -- 上次划转日期
    ,next_tran_dt date -- 下次划转日期
    ,sign_org_id varchar2(100) -- 签约机构编号
    ,sign_teller_id varchar2(100) -- 签约柜员编号
    ,sign_flow_id varchar2(100) -- 签约流水编号
    ,rels_org_id varchar2(100) -- 解约机构编号
    ,rels_teller_id varchar2(100) -- 解约柜员编号
    ,rels_flow_id varchar2(100) -- 解约流水编号
    ,a_try_redt_dt date -- 重新尝试转存日期
    ,lmt_ped varchar2(10) -- 限额周期
    ,max_lmt number(30,2) -- 最大限额
    ,occu_lmt number(30,2) -- 已占用额度
    ,next_calc_dt date -- 下一计算日期
    ,curr_mon_acm_end_day_bal number(30,2) -- 当月累计日终余额
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,reg_acct_curr_cd varchar2(30) -- 定期账户币种代码
    ,reg_acct_prod_id varchar2(100) -- 定期账户产品编号
    ,reg_acct_sub_acct varchar2(60) -- 定期账户子账号
    ,reg_acct_id varchar2(60) -- 定期账户编号
    ,tran_day number(10) -- 划转日
    ,redt_begin_dt date -- 转存起始日期
    ,redt_termnt_dt date -- 转存终止日期
    ,auto_payoff_flg varchar2(10) -- 自动结清标志
    ,core_dep_char_cd varchar2(30) -- 核心存款性质代码
    ,fail_rs_descb varchar2(2000) -- 失败原因描述
    ,rels_dt date -- 解约日期
    ,stl_sub_acct_acm_bal_dt date -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg varchar2(10) -- 自动续签标志
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
grant select on ${iml_schema}.agt_finc_sign_agt_h to ${icl_schema};
grant select on ${iml_schema}.agt_finc_sign_agt_h to ${idl_schema};
grant select on ${iml_schema}.agt_finc_sign_agt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_finc_sign_agt_h is '理财签约协议历史';
comment on column ${iml_schema}.agt_finc_sign_agt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.dep_agt_id is '存款协议编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.sign_agt_type_cd is '签约协议类型代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.finc_prod_type_descb is '理财产品类型描述';
comment on column ${iml_schema}.agt_finc_sign_agt_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.finc_amt is '理财金额';
comment on column ${iml_schema}.agt_finc_sign_agt_h.agt_retnd_amt is '协议留存金额';
comment on column ${iml_schema}.agt_finc_sign_agt_h.auto_delay_flg is '自动延期标志';
comment on column ${iml_schema}.agt_finc_sign_agt_h.sign_agt_status_cd is '签约协议状态代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.min_init_amt is '最小起存金额';
comment on column ${iml_schema}.agt_finc_sign_agt_h.finc_fix_amt is '理财固定金额';
comment on column ${iml_schema}.agt_finc_sign_agt_h.dep_tenor is '存款期限';
comment on column ${iml_schema}.agt_finc_sign_agt_h.dep_tenor_type_cd is '存款期限类型代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.auto_redt_way_type_cd is '自动转存方式类型代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.conti_redt_fail_cnt is '连续转存失败次数';
comment on column ${iml_schema}.agt_finc_sign_agt_h.conti_redt_sucs_cnt is '连续转存成功次数';
comment on column ${iml_schema}.agt_finc_sign_agt_h.redt_fail_tot_cnt is '转存失败总次数';
comment on column ${iml_schema}.agt_finc_sign_agt_h.redt_sucs_tot_cnt is '转存成功总次数';
comment on column ${iml_schema}.agt_finc_sign_agt_h.last_redt_flow_id is '上一转存流水编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.tran_freq is '划转频率';
comment on column ${iml_schema}.agt_finc_sign_agt_h.tran_freq_cd is '划转频率代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.last_tran_dt is '上次划转日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.next_tran_dt is '下次划转日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.sign_flow_id is '签约流水编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.rels_org_id is '解约机构编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.rels_teller_id is '解约柜员编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.rels_flow_id is '解约流水编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.a_try_redt_dt is '重新尝试转存日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.lmt_ped is '限额周期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.max_lmt is '最大限额';
comment on column ${iml_schema}.agt_finc_sign_agt_h.occu_lmt is '已占用额度';
comment on column ${iml_schema}.agt_finc_sign_agt_h.next_calc_dt is '下一计算日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.curr_mon_acm_end_day_bal is '当月累计日终余额';
comment on column ${iml_schema}.agt_finc_sign_agt_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.reg_acct_curr_cd is '定期账户币种代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.reg_acct_prod_id is '定期账户产品编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.reg_acct_sub_acct is '定期账户子账号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.reg_acct_id is '定期账户编号';
comment on column ${iml_schema}.agt_finc_sign_agt_h.tran_day is '划转日';
comment on column ${iml_schema}.agt_finc_sign_agt_h.redt_begin_dt is '转存起始日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.redt_termnt_dt is '转存终止日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.auto_payoff_flg is '自动结清标志';
comment on column ${iml_schema}.agt_finc_sign_agt_h.core_dep_char_cd is '核心存款性质代码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.fail_rs_descb is '失败原因描述';
comment on column ${iml_schema}.agt_finc_sign_agt_h.rels_dt is '解约日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.stl_sub_acct_acm_bal_dt is '结算盈子户累计余额日期';
comment on column ${iml_schema}.agt_finc_sign_agt_h.auto_scd_sign_flg is '自动续签标志';
comment on column ${iml_schema}.agt_finc_sign_agt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_finc_sign_agt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_finc_sign_agt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_finc_sign_agt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_finc_sign_agt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_finc_sign_agt_h.etl_timestamp is 'ETL处理时间戳';
