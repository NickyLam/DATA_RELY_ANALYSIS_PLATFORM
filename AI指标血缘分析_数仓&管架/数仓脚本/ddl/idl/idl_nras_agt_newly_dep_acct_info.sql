/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl nras_agt_newly_dep_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.nras_agt_newly_dep_acct_info
whenever sqlerror continue none;
drop table ${idl_schema}.nras_agt_newly_dep_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.nras_agt_newly_dep_acct_info(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,liab_acct_num varchar2(60) -- 负债账号
    ,acct_name varchar2(250) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,bus_id varchar2(60) -- 业务编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,open_acct_teller_id varchar2(60) -- 账户开户柜员编号
    ,clos_acct_teller_id varchar2(60) -- 账户销户柜员编号
    ,clos_acct_org_id varchar2(60) -- 账户销户机构编号
    ,prod_id varchar2(60) -- 产品编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,dep_term varchar2(10) -- 存期
    ,acct_exp_dt date -- 账户到期日期
    ,acct_open_acct_dt date -- 账户开户日期
    ,acct_clos_acct_dt date -- 账户销户日期
    ,acct_valid_dt date -- 账户有效日期
    ,curr_gl_bal number(30,2) -- 当前总账余额
    ,ld_gl_bal number(30,2) -- 上日总账余额
    ,init_amt number(30,2) -- 起存金额
    ,open_acct_amt number(30,2) -- 开户金额
    ,acct_retnd_max_bal number(30,2) -- 账户留存最大余额
    ,acct_retnd_min_bal number(30,2) -- 账户留存最小余额
    ,recnt_update_dt date -- 最近更新日期
    ,last_bus_dt date -- 上次业务日期
    ,last_coll_pay_dt date -- 上次代收付日期
    ,init_value_dt date -- 初始起息日期
    ,init_exp_dt date -- 初始到期日期
    ,statmt_create_dt date -- 对账单生成日期
    ,recnt_check_entry_dt date -- 最近对账日期
    ,fir_depot_dt date -- 首次存入日期
    ,recnt_acct_vrfction_dt date -- 最近账户核查日期
    ,curr_unused_seq_num number(10) -- 当前未用序号
    ,caln_name varchar2(100) -- 日历名称
    ,acct_flg_string varchar2(100) -- 账户标志字符串
    ,liab_prod_type_cd varchar2(10) -- 负债产品类型代码
    ,prod_belong_obj_cd varchar2(10) -- 产品所属对象代码
    ,acct_cls_cd_1 varchar2(10) -- 账户分类代码1
    ,acct_cls_cd_3 varchar2(10) -- 账户分类代码3
    ,depot_ctrl_way_cd varchar2(10) -- 存入控制方式代码
    ,drawdown_ctrl_way_cd varchar2(10) -- 支取控制方式代码
    ,drawdown_mpr_flg varchar2(10) -- 支取时利随本清标志
    ,redt_way_cd varchar2(10) -- 转存方式代码
    ,stdby_amt number(30,2) -- 备用金额
    ,drawdown_intrv number(10) -- 支取间隔
    ,dep_kind_cd varchar2(10) -- 存款种类代码
    ,acct_status_cd varchar2(10) -- 帐户状态代码
    ,check_entry_flg varchar2(10) -- 对账标志
    ,acct_check_entry_ped varchar2(10) -- 帐户对账周期
    ,check_entry_range varchar2(10) -- 对账范围
    ,vrfction_flg varchar2(10) -- 核查标志
    ,bal_and_gl_sync_flg varchar2(10) -- 余额与总账同步标志
    ,spec_expns_acct_flg varchar2(10) -- 指定支出账户标志
    ,cap_expns_acct varchar2(60) -- 资金支出账户
    ,spec_inco_acct_flg varchar2(10) -- 指定收入账户标志
    ,cap_inco_acct varchar2(60) -- 资金收入账户
    ,rec_status_cd varchar2(10) -- 记录状态代码
    ,acct_curr_cd varchar2(10) -- 账户币种代码
    ,ec_flg varchar2(10) -- 钞汇标志
    ,corp_curr_acct_attr_cd varchar2(10) -- 对公活期户属性代码
    ,acct_lmt_flg varchar2(10) -- 账户限制标志
    ,acct_amt_froz_flg varchar2(10) -- 账户金额冻结标志
    ,acct_close_froz_flg varchar2(10) -- 账户封闭冻结标志
    ,acct_only_out_flg varchar2(10) -- 账户只收不付标志
    ,acct_only_in_flg varchar2(10) -- 账户只付不收标志
    ,rela_circl_loan_flg varchar2(10) -- 关联循环贷款标志
    ,have_acct_prot_rela_flg varchar2(10) -- 有账户保护关系标志
    ,modal_tran_flg varchar2(10) -- 形态转移标志
    ,monit_acct_flg varchar2(10) -- 监控账户标志
    ,cap_veri_acct_flg varchar2(10) -- 验资户标志
    ,rsrv_corp_check_pwd_flg varchar2(10) -- 预留对公支票户密码标志
    ,check_acct_flg varchar2(10) -- 支票户标志
    ,allow_od_flg varchar2(10) -- 允许透支标志
    ,prep_cfm_stl_acct_flg varchar2(10) -- 待确认结算户标志
    ,fx_supv_flg varchar2(10) -- 外汇监管标志
    ,fx_vrfction_flg varchar2(10) -- 外汇核查标志
    ,nomal_acct_charge_flg varchar2(10) -- 正常户收费标志
    ,dormt_acct_charge_flg varchar2(10) -- 不动户收费标志
    ,stl_acct_flg varchar2(10) -- 结算账户标志
    ,margin_dep_flg varchar2(10) -- 保证金存款标志
    ,fin_dep_flg varchar2(10) -- 财政存款标志
    ,sign_finc_flg varchar2(10) -- 签约理财标志
    ,realtm_tran_flg varchar2(10) -- 实时划拨标志
    ,rela_od_flg varchar2(10) -- 关联透支标志
    ,bal_coll_flg varchar2(10) -- 余额归集标志
    ,onl_fee_batch_post_recv_flg varchar2(10) -- 联机费用批量后收标志
    ,batch_post_recv_fee_freq varchar2(10) -- 批量后收费频率
    ,matn_teller_id varchar2(60) -- 维护柜员编号
    ,matn_org_id varchar2(60) -- 维护机构编号
    ,matn_dt date -- 维护日期
    ,matn_tm varchar2(10) -- 维护时间
    ,seq_num number(10) -- 序号
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
grant select on ${idl_schema}.nras_agt_newly_dep_acct_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.nras_agt_newly_dep_acct_info is '新兴存款账户信息';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.etl_dt is '数据日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.agt_id is '协议编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.lp_id is '法人编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.liab_acct_num is '负债账号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_name is '账户名称';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.cust_id is '客户编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.bus_id is '业务编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.open_acct_teller_id is '账户开户柜员编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.clos_acct_teller_id is '账户销户柜员编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.clos_acct_org_id is '账户销户机构编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.prod_id is '产品编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.cust_acct_num is '客户账号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.dep_term is '存期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_exp_dt is '账户到期日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_open_acct_dt is '账户开户日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_clos_acct_dt is '账户销户日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_valid_dt is '账户有效日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.curr_gl_bal is '当前总账余额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.ld_gl_bal is '上日总账余额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.init_amt is '起存金额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.open_acct_amt is '开户金额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_retnd_max_bal is '账户留存最大余额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_retnd_min_bal is '账户留存最小余额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.recnt_update_dt is '最近更新日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.last_bus_dt is '上次业务日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.last_coll_pay_dt is '上次代收付日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.init_value_dt is '初始起息日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.init_exp_dt is '初始到期日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.statmt_create_dt is '对账单生成日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.recnt_check_entry_dt is '最近对账日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.fir_depot_dt is '首次存入日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.recnt_acct_vrfction_dt is '最近账户核查日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.curr_unused_seq_num is '当前未用序号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.caln_name is '日历名称';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_flg_string is '账户标志字符串';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.liab_prod_type_cd is '负债产品类型代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.prod_belong_obj_cd is '产品所属对象代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_cls_cd_1 is '账户分类代码1';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_cls_cd_3 is '账户分类代码3';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.depot_ctrl_way_cd is '存入控制方式代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.drawdown_ctrl_way_cd is '支取控制方式代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.drawdown_mpr_flg is '支取时利随本清标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.redt_way_cd is '转存方式代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.stdby_amt is '备用金额';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.drawdown_intrv is '支取间隔';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.dep_kind_cd is '存款种类代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_status_cd is '帐户状态代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.check_entry_flg is '对账标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_check_entry_ped is '帐户对账周期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.check_entry_range is '对账范围';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.vrfction_flg is '核查标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.bal_and_gl_sync_flg is '余额与总账同步标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.spec_expns_acct_flg is '指定支出账户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.cap_expns_acct is '资金支出账户';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.spec_inco_acct_flg is '指定收入账户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.cap_inco_acct is '资金收入账户';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.rec_status_cd is '记录状态代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_curr_cd is '账户币种代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.ec_flg is '钞汇标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.corp_curr_acct_attr_cd is '对公活期户属性代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_lmt_flg is '账户限制标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_amt_froz_flg is '账户金额冻结标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_close_froz_flg is '账户封闭冻结标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_only_out_flg is '账户只收不付标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.acct_only_in_flg is '账户只付不收标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.rela_circl_loan_flg is '关联循环贷款标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.have_acct_prot_rela_flg is '有账户保护关系标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.modal_tran_flg is '形态转移标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.monit_acct_flg is '监控账户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.cap_veri_acct_flg is '验资户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.rsrv_corp_check_pwd_flg is '预留对公支票户密码标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.check_acct_flg is '支票户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.allow_od_flg is '允许透支标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.prep_cfm_stl_acct_flg is '待确认结算户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.fx_supv_flg is '外汇监管标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.fx_vrfction_flg is '外汇核查标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.nomal_acct_charge_flg is '正常户收费标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.dormt_acct_charge_flg is '不动户收费标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.stl_acct_flg is '结算账户标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.margin_dep_flg is '保证金存款标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.fin_dep_flg is '财政存款标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.sign_finc_flg is '签约理财标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.realtm_tran_flg is '实时划拨标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.rela_od_flg is '关联透支标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.bal_coll_flg is '余额归集标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.onl_fee_batch_post_recv_flg is '联机费用批量后收标志';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.batch_post_recv_fee_freq is '批量后收费频率';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.matn_teller_id is '维护柜员编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.matn_org_id is '维护机构编号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.matn_dt is '维护日期';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.matn_tm is '维护时间';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.seq_num is '序号';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.job_cd is '任务代码';
comment on column ${idl_schema}.nras_agt_newly_dep_acct_info.etl_timestamp is '数据处理时间';
