/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_finc_prod_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_finc_prod_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_finc_prod_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_finc_prod_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,fin_prod_id varchar2(60) -- 金融产品编号
    ,sell_prod_id varchar2(60) -- 销售产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_abbr varchar2(200) -- 产品简称
    ,prod_fname varchar2(750) -- 产品全称
    ,prod_tepla_id varchar2(250) -- 产品模板编号
    ,prod_tepla_comnt varchar2(1000) -- 产品模板说明
    ,prod_cate_cd varchar2(60) -- 产品类别代码
    ,prod_sclass_cd varchar2(10) -- 产品小类代码
    ,prft_mode_cd varchar2(60) -- 收益模式代码
    ,tran_caln_cd varchar2(60) -- 交易日历代码
    ,coll_way_cd varchar2(60) -- 募集方式代码
    ,oper_mode_cd varchar2(60) -- 运作模式代码
    ,supt_buy_way_cd varchar2(10) -- 支持购买方式代码
    ,entr_way_cd varchar2(60) -- 委托方式代码
    ,csner_id varchar2(60) -- 委托人编号
    ,trustee_id varchar2(60) -- 托管人编号
    ,sell_org_id varchar2(60) -- 销售机构编号
    ,sell_dept_id varchar2(60) -- 销售部门编号
    ,coll_start_dt date -- 募集开始日期
    ,coll_end_dt date -- 募集结束日期
    ,prod_found_dt date -- 产品成立日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,actl_value_dt date -- 实际起息日期
    ,actl_exp_dt date -- 实际到期日期
    ,liqd_dt date -- 清盘日期
    ,tenor number(10) -- 期限
    ,tenor_kind_cd varchar2(60) -- 期限种类代码
    ,invest_ped_days number(10) -- 投资周期天数
    ,prod_ped_days number(10) -- 产品周期天数
    ,subtn_flg varchar2(10) -- 永续标志
    ,subtn_claus_descb varchar2(1000) -- 永续条款描述
    ,purch_cfm_tenor number(10) -- 申购确认期限
    ,redem_cfm_tenor number(10) -- 赎回确认期限
    ,inv_port_id varchar2(60) -- 投资组合编号
    ,prod_rgst_code varchar2(60) -- 产品登记编码
    ,cash_mgmt_flg varchar2(10) -- 现金管理标志
    ,ped_prod_flg varchar2(10) -- 周期型产品标志
    ,open_flg varchar2(10) -- 开放式标志
    ,consmted_flg varchar2(10) -- 可代销标志
    ,redembl_flg varchar2(10) -- 可赎回标志
    ,layered_flg varchar2(10) -- 分层标志
    ,indv_allow_buy_flg varchar2(10) -- 个人允许购买标志
    ,layered_type_cd varchar2(60) -- 分层类型代码
    ,invest_char_cd varchar2(60) -- 投资性质代码
    ,prft_type_cd varchar2(60) -- 收益类型代码
    ,issue_status_cd varchar2(60) -- 发行状态代码
    ,risk_level_cd varchar2(10) -- 风险等级代码
    ,ctrl_flg_comb varchar2(375) -- 控制标志组合
    ,sell_chn_cd_comb varchar2(2000) -- 销售渠道代码组合
    ,sell_rg_cd_comb varchar2(2000) -- 销售地区代码组合
    ,sell_cust_type_cd_comb varchar2(100) -- 销售客户类型代码组合
    ,prod_mgr_id varchar2(60) -- 产品经理编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,pric_subj_id varchar2(60) -- 本金科目编号
    ,prft_adj_subj_id varchar2(60) -- 收益调整科目编号
    ,curr_cd varchar2(10) -- 币种代码
    ,curr_pric_bal number(30,2) -- 当前本金余额
    ,currt_acru_prft number(30,2) -- 当期应计收益
    ,expe_yld_rat number(18,8) -- 预期收益率
    ,sevn_aual_yld number(18,8) -- 七日年化收益率
    ,td_cust_yld_rat number(18,8) -- 当日客户收益率
    ,sale_fee_rat number(18,8) -- 销售费率
    ,diff_price_fee_rat number(18,8) -- 差价费率
    ,prod_fee_f_unit_nv number(18,8) -- 产品费前单位净值
    ,prod_fee_post_corp_nv number(18,8) -- 产品费后单位净值
    ,prod_acm_corp_nv number(18,8) -- 产品累计单位净值
    ,prod_currt_nv number(18,8) -- 产品当期净值
    ,prod_fee_bf_ten_thous_prft number(18,8) -- 产品费前万份收益
    ,prod_fee_post_ten_thous_prft number(18,8) -- 产品费后万份收益
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
grant select on ${icl_schema}.cmm_finc_prod_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_finc_prod_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_finc_prod_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_finc_prod_basic_info is '理财产品基本信息';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.fin_prod_id is '金融产品编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sell_prod_id is '销售产品编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_abbr is '产品简称';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_fname is '产品全称';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_tepla_id is '产品模板编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_tepla_comnt is '产品模板说明';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_cate_cd is '产品类别代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_sclass_cd is '产品小类代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prft_mode_cd is '收益模式代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.tran_caln_cd is '交易日历代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.coll_way_cd is '募集方式代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.oper_mode_cd is '运作模式代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.supt_buy_way_cd is '支持购买方式代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.entr_way_cd is '委托方式代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.csner_id is '委托人编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.trustee_id is '托管人编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sell_org_id is '销售机构编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sell_dept_id is '销售部门编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.coll_start_dt is '募集开始日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.coll_end_dt is '募集结束日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_found_dt is '产品成立日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.actl_value_dt is '实际起息日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.actl_exp_dt is '实际到期日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.liqd_dt is '清盘日期';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.tenor is '期限';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.tenor_kind_cd is '期限种类代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.invest_ped_days is '投资周期天数';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_ped_days is '产品周期天数';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.subtn_flg is '永续标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.subtn_claus_descb is '永续条款描述';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.purch_cfm_tenor is '申购确认期限';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.redem_cfm_tenor is '赎回确认期限';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.inv_port_id is '投资组合编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_rgst_code is '产品登记编码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.cash_mgmt_flg is '现金管理标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.ped_prod_flg is '周期型产品标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.open_flg is '开放式标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.consmted_flg is '可代销标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.redembl_flg is '可赎回标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.layered_flg is '分层标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.indv_allow_buy_flg is '个人允许购买标志';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.layered_type_cd is '分层类型代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.invest_char_cd is '投资性质代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prft_type_cd is '收益类型代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.issue_status_cd is '发行状态代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.risk_level_cd is '风险等级代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.ctrl_flg_comb is '控制标志组合';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sell_chn_cd_comb is '销售渠道代码组合';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sell_rg_cd_comb is '销售地区代码组合';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sell_cust_type_cd_comb is '销售客户类型代码组合';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_mgr_id is '产品经理编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.pric_subj_id is '本金科目编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prft_adj_subj_id is '收益调整科目编号';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.curr_pric_bal is '当前本金余额';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.currt_acru_prft is '当期应计收益';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.expe_yld_rat is '预期收益率';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sevn_aual_yld is '七日年化收益率';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.td_cust_yld_rat is '当日客户收益率';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.sale_fee_rat is '销售费率';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.diff_price_fee_rat is '差价费率';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_fee_f_unit_nv is '产品费前单位净值';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_fee_post_corp_nv is '产品费后单位净值';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_acm_corp_nv is '产品累计单位净值';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_currt_nv is '产品当期净值';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_fee_bf_ten_thous_prft is '产品费前万份收益';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.prod_fee_post_ten_thous_prft is '产品费后万份收益';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_finc_prod_basic_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_finc_prod_basic_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_finc_prod_basic_info.etl_timestamp is 'ETL处理时间戳';
