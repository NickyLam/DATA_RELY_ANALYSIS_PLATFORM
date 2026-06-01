/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_agent_consmt_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_agent_consmt_prod_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_agent_consmt_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_agent_consmt_prod_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_name varchar2(375) -- 产品名称
    ,prod_fname varchar2(375) -- 产品全称
    ,prod_tepla_id varchar2(250) -- 产品模板编号
    ,prod_tepla_comnt varchar2(1000) -- 产品模板说明
    ,ta_cd varchar2(10) -- TA代码
    ,consmt_bus_type_cd varchar2(10) -- 代销业务类型代码
    ,prod_type_cd varchar2(10) -- 产品类型代码
    ,prod_sclass_cd varchar2(10) -- 产品小类代码
    ,issuer_id varchar2(60) -- 发行人编号
    ,issuer_name varchar2(375) -- 发行人名称
    ,trustee_id varchar2(60) -- 托管人编号
    ,trustee_name varchar2(250) -- 托管人名称
    ,mger_id varchar2(60) -- 管理人编号
    ,mger_name varchar2(375) -- 管理人名称
    ,fund_mgr varchar2(3000) -- 基金经理
    ,dept_id varchar2(60) -- 部门编号
    ,org_id varchar2(60) -- 机构编号
    ,coll_start_dt date -- 募集开始日期
    ,coll_end_dt date -- 募集结束日期
    ,found_dt date -- 成立日期
    ,end_dt date -- 结束日期
    ,value_dt date -- 起息日期
    ,int_closing_dt date -- 利息截止日期
    ,next_open_start_dt date -- 下一开放开始日期
    ,next_open_end_dt date -- 下一开放结束日期
    ,prft_exp_dt date -- 收益到期日期
    ,actl_found_dt date -- 实际成立日期
    ,sp_acct_id varchar2(60) -- 认申购账户编号
    ,redem_acct_id varchar2(60) -- 赎回账户编号
    ,comm_fee_assign_acct_id varchar2(60) -- 手续费分配账户编号
    ,mgmt_fee_assign_acct_id varchar2(60) -- 管理费分配账户编号
    ,allow_chn_group_id varchar2(60) -- 允许渠道组编号
    ,allow_cust_group_id varchar2(60) -- 允许客户组编号
    ,sell_rg_ctrl_flg varchar2(10) -- 销售区域控制标志
    ,lmt_ctrl_flg varchar2(10) -- 额度控制标志
    ,ped_open_flg varchar2(10) -- 周期开放型标志
    ,provi_for_aged_target_fund_flg varchar2(10) -- 养老目标基金标志
    ,allow_divd_way_cd varchar2(10) -- 允许分红方式代码
    ,deflt_divd_way_cd varchar2(10) -- 默认分红方式代码
    ,prft_embody_way_cd varchar2(10) -- 收益体现方式代码
    ,prft_type_cd varchar2(10) -- 收益类型代码
    ,charge_type_cd varchar2(10) -- 收费类型代码
    ,prod_attr_cd varchar2(10) -- 产品属性代码
    ,risk_level_cd varchar2(10) -- 风险等级代码
    ,estim_level_cd varchar2(10) -- 评估等级代码
    ,prod_status_cd varchar2(10) -- 产品状态代码
    ,tran_flg_cd varchar2(10) -- 转换标志代码
    ,tard_way_cd varchar2(10) -- 交易方式代码
    ,ec_flg_cd varchar2(10) -- 钞汇标志代码
    ,prft_curr_cd varchar2(10) -- 收益币种代码
    ,curr_cd varchar2(10) -- 币种代码
    ,supt_buy_way_cd varchar2(30) -- 支持购买方式代码
    ,ctrl_flg_info varchar2(250) -- 控制标志信息
    ,bta_ctrl_flg_info varchar2(250) -- BTA控制标志信息
    ,issue_price number(18,8) -- 发行价格
    ,expe_yld_rat number(18,8) -- 预期收益率
    ,lowt_coll_amt number(30,2) -- 最低募集金额
    ,higt_coll_amt number(30,2) -- 最高募集金额
    ,lowt_coll_lot number(30,2) -- 最低募集份额
    ,higt_coll_lot number(30,2) -- 最高募集份额
    ,actl_coll_amt number(30,2) -- 实际募集金额
    ,curr_coll_size number(30,2) -- 当前募集规模
    ,indv_fir_lowt_invest_amt number(30,2) -- 个人首次最低投资金额
    ,acvmnt_base number(30,2) -- 业绩基准
    ,ped_days number(10,0) -- 周期天数
    ,nv_days number(10,0) -- 净值天数
    ,curr_tot_lot number(30,2) -- 当前总份额
    ,curr_acm_nv number(38,8) -- 当前累计净值
    ,nv number(18,8) -- 净值
    ,nv_dt date -- 净值日期
    ,fac_val number(18,8) -- 面值
    ,sale_fee_rat number(18,8) -- 销售费率
    ,diff_price_fee_rat number(18,8) -- 差价费率
    ,insure_prod_proj_type_cd varchar2(10) -- 保险产品项目类型代码
    ,dir_insure_cd varchar2(60) -- 定向保险代码
    ,insure_return_days number(10,0) -- 保险返回天数
    ,redem_cap_avl_days number(22) -- 赎回资金到账天数
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_agent_consmt_prod_info to ${idl_schema};
grant select on ${icl_schema}.cmm_agent_consmt_prod_info to ${iel_schema};
grant select on ${icl_schema}.cmm_agent_consmt_prod_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_agent_consmt_prod_info is '代理代销产品信息';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_fname is '产品全称';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_tepla_id is '产品模板编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_tepla_comnt is '产品模板说明';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.ta_cd is 'TA代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.consmt_bus_type_cd is '代销业务类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_sclass_cd is '产品小类代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.issuer_id is '发行人编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.trustee_id is '托管人编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.trustee_name is '托管人名称';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.mger_id is '管理人编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.mger_name is '管理人名称';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.fund_mgr is '基金经理';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.org_id is '机构编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.coll_start_dt is '募集开始日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.coll_end_dt is '募集结束日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.found_dt is '成立日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.end_dt is '结束日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.int_closing_dt is '利息截止日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.next_open_start_dt is '下一开放开始日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.next_open_end_dt is '下一开放结束日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prft_exp_dt is '收益到期日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.actl_found_dt is '实际成立日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.sp_acct_id is '认申购账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.redem_acct_id is '赎回账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.comm_fee_assign_acct_id is '手续费分配账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.mgmt_fee_assign_acct_id is '管理费分配账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.allow_chn_group_id is '允许渠道组编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.allow_cust_group_id is '允许客户组编号';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.sell_rg_ctrl_flg is '销售区域控制标志';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.lmt_ctrl_flg is '额度控制标志';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.ped_open_flg is '周期开放型标志';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.provi_for_aged_target_fund_flg is '养老目标基金标志';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.allow_divd_way_cd is '允许分红方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prft_embody_way_cd is '收益体现方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prft_type_cd is '收益类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.charge_type_cd is '收费类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_attr_cd is '产品属性代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.risk_level_cd is '风险等级代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.estim_level_cd is '评估等级代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prod_status_cd is '产品状态代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.tran_flg_cd is '转换标志代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.tard_way_cd is '交易方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.ec_flg_cd is '钞汇标志代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.prft_curr_cd is '收益币种代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.supt_buy_way_cd is '支持购买方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.ctrl_flg_info is '控制标志信息';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.bta_ctrl_flg_info is 'BTA控制标志信息';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.issue_price is '发行价格';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.expe_yld_rat is '预期收益率';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.lowt_coll_amt is '最低募集金额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.higt_coll_amt is '最高募集金额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.lowt_coll_lot is '最低募集份额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.higt_coll_lot is '最高募集份额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.actl_coll_amt is '实际募集金额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.curr_coll_size is '当前募集规模';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.indv_fir_lowt_invest_amt is '个人首次最低投资金额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.acvmnt_base is '业绩基准';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.ped_days is '周期天数';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.nv_days is '净值天数';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.curr_tot_lot is '当前总份额';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.curr_acm_nv is '当前累计净值';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.nv is '净值';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.nv_dt is '净值日期';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.fac_val is '面值';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.sale_fee_rat is '销售费率';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.diff_price_fee_rat is '差价费率';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.insure_prod_proj_type_cd is '保险产品项目类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.dir_insure_cd is '定向保险代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.insure_return_days is '保险返回天数';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.redem_cap_avl_days is '赎回资金到账天数';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_agent_consmt_prod_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_agent_consmt_prod_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_agent_consmt_prod_info.etl_timestamp is 'ETL处理时间戳';
