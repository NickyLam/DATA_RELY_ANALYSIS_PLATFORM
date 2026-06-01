/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_evt_dep_fin_tran_flow_ret1
CreateDate: 20250908
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select to_char(etl_dt,'yyyymmdd') as etl_dt from iml.evt_dep_fin_tran_flow
							where etl_dt >= date'2023-05-02'
							group by etl_dt order by etl_dt desc
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('idl')
     and table_name = upper('evt_dep_fin_tran_flow')
     and partition_name = 'P_' || tb.etl_dt;

  if v_flag <> 0 then
    execute immediate 'alter table evt_dep_fin_tran_flow drop partition p_'|| tb.etl_dt ;
  end if;

    execute immediate 'alter table evt_dep_fin_tran_flow add partition p_' || tb.etl_dt || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

end loop;
end;
/

-- 回插所有数据

insert /*+ append */ into ${idl_schema}.evt_dep_fin_tran_flow (
etl_dt -- ETL处理日期
,evt_id -- 事件编号
,lp_id -- 法人编号
,tran_flow_num -- 交易流水号
,ova_flow_num -- 全局流水号
,core_flow_num -- 核心流水号
,tran_ref_no -- 交易参考号
,acct_id -- 账户编号
,cust_acct_num -- 客户账号
,bus_prod_id -- 业务产品编号
,acct_curr_cd -- 账户币种代码
,sub_acct_num -- 子账号
,sub_acct_id -- 子账户编号
,acct_type_cd -- 账户类型代码
,acct_status_cd -- 账户状态代码
,vtual_acct_flg -- 虚户标志
,cash_tran_flg -- 现金交易标志
,acct_name -- 账户名称
,open_acct_org_id -- 开户机构编号
,evt_cate_id -- 事件类别编号
,tran_dt -- 交易日期
,tran_org_id -- 交易机构编号
,debit_crdt_flg -- 借贷标志
,tran_curr_cd -- 交易币种代码
,tran_cd -- 交易码
,tran_descb -- 交易描述
,bef_tran_bal -- 交易前余额
,tran_amt -- 交易金额
,actl_bal -- 实际余额
,tran_kind_cd -- 交易种类代码
,cntpty_tran_ref_no -- 交易对手交易参考号
,cntpty_acct_id -- 交易对手账户编号
,cntpty_cust_acct_num -- 交易对手客户账号
,cntpty_acct_curr_cd -- 交易对手账户币种代码
,cntpty_sub_acct_num -- 交易对手子账号
,cap_froz_flow_num -- 资金冻结流水号
,cntpty_acct_prod_id -- 交易对手账户产品编号
,cntpty_acct_name -- 交易对手账户名称
,cntpty_unionpay_num -- 交易对手银联号
,cntpty_bank_name -- 交易对手银行名称
,cntpty_open_acct_org_id -- 交易对手开户机构编号
,real_cntpty_fin_inst_id -- 真实交易对手金融机构编号
,real_cntpty_fin_inst_name -- 交易对手行名
,real_cntpty_acct_type_cd -- 真实交易对手账户类型代码
,real_cntpty_acct_id -- 真实交易对手账户编号
,cntpty_curr_cd -- 交易对手币种代码
,begin_curr_cd -- 起始币种代码
,cntpty_tran_flow_num -- 交易对手交易流水号
,aim_curr_cd -- 目的币种代码
,buy_amt -- 买入金额
,sell_amt -- 卖出金额
,vouch_type_cd -- 凭证类型代码
,vouch_no -- 凭证号码
,cash_proj_cd -- 现金项目代码
,amt_calc_type_cd -- 金额计算类型代码
,chn_id -- 渠道编号
,amt_type_cd -- 金额类型代码
,bal_type_cd -- 钞汇余额代码
,base_equvl_amt -- 基础等值金额
,offset_exch_rat -- 平盘汇率
,cross_exch_rat -- 交叉汇率
,buyer_exch_rat_cls_cd -- 买方汇率分类代码
,buyer_exch_rat_val -- 买方汇率值
,actl_cross_exch_rat -- 实际交叉汇率
,seller_exch_rat_cls_cd -- 卖方汇率分类代码
,seller_exch_rat_val -- 卖方汇率值
,inter_bus_type_cd -- 中间业务类型代码
,finc_type_cd -- 理财类型代码
,quot_type_cd -- 牌价类型代码
,med_flg -- 介质标志
,med_type_cd -- 介质类型代码
,bus_cls_cd -- 业务分类代码
,cntpty_cert_type_cd -- 交易对手证件类型代码
,attach_rgst_dep_flg -- 补登存标志
,main_evt_cls_cd -- 主事件分类代码
,exch_rat_type_cd -- 汇率类型代码
,avl_way_cd -- 到账方式代码
,wdraw_way_cd -- 支取方式代码
,bus_tran_batch_no -- 业务交易批次号
,bank_tran_seq_num -- 银行交易序号
,agent_tel_num -- 代理人电话号码
,cust_name -- 客户名称
,lmt_code -- 限额编码
,cntpty_fin_inst_dist_cd -- 交易对手金融机构行政区划代码
,cntpty_cert_no -- 交易对手证件号码
,real_cntpty_fin_inst_dist_cd -- 真实交易对手金融机构行政区划代码
,real_cntpty_cert_no -- 真实交易对手证件号码
,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
,tran_happ_site -- 交易发生地点
,real_tran_happ_site -- 真实交易发生地点
,cntpty_name -- 交易对手名称
,real_cntpty_name -- 真实交易对手名称
,payment_corp_name -- 交款单位名称
,prior_level -- 优先等级
,seller_quot_type_cd -- 卖方牌价类型代码
,chn_dt -- 渠道日期
,cust_id -- 客户编号
,cert_no -- 证件号码
,cert_type_cd -- 证件类型代码
,bill_num -- 票据号码
,sob_cate_cd -- 账套类别代码
,tran_postsc -- 交易附言
,bus_proc_status_cd -- 业务处理状态代码
,auto_revs_flg -- 自动冲正标志
,cntpty_equvl_amt -- 交易对手等值金额
,tran_post_bal_add_finc -- 交易后余额加理财
,free_serv_fee_flg -- 免服务费标志
,tran_public_agent_name -- 交易代办人名称
,src_module_type_cd -- 源模块类型代码
,effect_dt -- 生效日期
,revs_flow_num -- 冲正流水号
,tran_termn_id -- 交易终端编号
,follow_id -- 跟踪编号
,revs_tran_cd -- 冲正交易码
,revs_flg -- 冲正标志
,revs_dt -- 冲正日期
,clear_dt -- 清算日期
,post_flg -- 过账标志
,memo_code -- 摘要码
,tran_memo_descb -- 交易摘要描述
,check_teller_id -- 复核柜员编号
,auth_teller_id -- 授权柜员编号
,init_tran_tm -- 原交易时间
,tran_tm -- 交易时间
,tran_teller_id -- 交易柜员编号
,beps_unpasew_flg -- 小额免密标志
,bus_flow_num -- 业务流水号
,check_entry_cd -- 对账代码
,tran_id -- 交易编号
,prpery_sys_code -- 来源系统编号
,src_table_name -- 源表名称
)
select
etl_dt as etl_dt --ETL处理日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num --交易流水号
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num --全局流水号
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num --核心流水号
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num --客户账号
,replace(replace(t1.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id --业务产品编号
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd --账户币种代码
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num --子账号
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id --子账户编号
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd --账户类型代码
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd --账户状态代码
,replace(replace(t1.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg --虚户标志
,replace(replace(t1.cash_tran_flg,chr(13),''),chr(10),'') as cash_tran_flg --现金交易标志
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name --账户名称
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id --事件类别编号
,t1.tran_dt as tran_dt --交易日期
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id --交易机构编号
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg --借贷标志
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd --交易币种代码
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd --交易码
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb --交易描述
,t1.bef_tran_bal as bef_tran_bal --交易前余额
,t1.tran_amt as tran_amt --交易金额
,t1.actl_bal as actl_bal --实际余额
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd --交易种类代码
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no --交易对手交易参考号
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id --交易对手账户编号
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num --交易对手客户账号
,replace(replace(t1.cntpty_acct_curr_cd,chr(13),''),chr(10),'') as cntpty_acct_curr_cd --交易对手账户币种代码
,replace(replace(t1.cntpty_sub_acct_num,chr(13),''),chr(10),'') as cntpty_sub_acct_num --交易对手子账号
,replace(replace(t1.cap_froz_flow_num,chr(13),''),chr(10),'') as cap_froz_flow_num --资金冻结流水号
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id --交易对手账户产品编号
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name --交易对手账户名称
,replace(replace(t1.cntpty_unionpay_num,chr(13),''),chr(10),'') as cntpty_unionpay_num --交易对手银联号
,replace(replace(t1.cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name --交易对手银行名称
,replace(replace(t1.cntpty_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_open_acct_org_id --交易对手开户机构编号
,replace(replace(t1.real_cntpty_fin_inst_id,chr(13),''),chr(10),'') as real_cntpty_fin_inst_id --真实交易对手金融机构编号
,replace(replace(t1.real_cntpty_fin_inst_name,chr(13),''),chr(10),'') as real_cntpty_fin_inst_name --交易对手行名
,replace(replace(t1.real_cntpty_acct_type_cd,chr(13),''),chr(10),'') as real_cntpty_acct_type_cd --真实交易对手账户类型代码
,replace(replace(t1.real_cntpty_acct_id,chr(13),''),chr(10),'') as real_cntpty_acct_id --真实交易对手账户编号
,replace(replace(t1.cntpty_curr_cd,chr(13),''),chr(10),'') as cntpty_curr_cd --交易对手币种代码
,replace(replace(t1.begin_curr_cd,chr(13),''),chr(10),'') as begin_curr_cd --起始币种代码
,replace(replace(t1.cntpty_tran_flow_num,chr(13),''),chr(10),'') as cntpty_tran_flow_num --交易对手交易流水号
,replace(replace(t1.aim_curr_cd,chr(13),''),chr(10),'') as aim_curr_cd --目的币种代码
,t1.buy_amt as buy_amt --买入金额
,t1.sell_amt as sell_amt --卖出金额
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd --凭证类型代码
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no --凭证号码
,replace(replace(t1.cash_proj_cd,chr(13),''),chr(10),'') as cash_proj_cd --现金项目代码
,replace(replace(t1.amt_calc_type_cd,chr(13),''),chr(10),'') as amt_calc_type_cd --金额计算类型代码
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id --渠道编号
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd --金额类型代码
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd --钞汇余额代码
,t1.base_equvl_amt as base_equvl_amt --基础等值金额
,t1.offset_exch_rat as offset_exch_rat --平盘汇率
,t1.cross_exch_rat as cross_exch_rat --交叉汇率
,replace(replace(t1.buyer_exch_rat_cls_cd,chr(13),''),chr(10),'') as buyer_exch_rat_cls_cd --买方汇率分类代码
,t1.buyer_exch_rat_val as buyer_exch_rat_val --买方汇率值
,t1.actl_cross_exch_rat as actl_cross_exch_rat --实际交叉汇率
,replace(replace(t1.seller_exch_rat_cls_cd,chr(13),''),chr(10),'') as seller_exch_rat_cls_cd --卖方汇率分类代码
,t1.seller_exch_rat_val as seller_exch_rat_val --卖方汇率值
,replace(replace(t1.inter_bus_type_cd,chr(13),''),chr(10),'') as inter_bus_type_cd --中间业务类型代码
,replace(replace(t1.finc_type_cd,chr(13),''),chr(10),'') as finc_type_cd --理财类型代码
,replace(replace(t1.quot_type_cd,chr(13),''),chr(10),'') as quot_type_cd --牌价类型代码
,replace(replace(t1.med_flg,chr(13),''),chr(10),'') as med_flg --介质标志
,replace(replace(t1.med_type_cd,chr(13),''),chr(10),'') as med_type_cd --介质类型代码
,replace(replace(t1.bus_cls_cd,chr(13),''),chr(10),'') as bus_cls_cd --业务分类代码
,replace(replace(t1.cntpty_cert_type_cd,chr(13),''),chr(10),'') as cntpty_cert_type_cd --交易对手证件类型代码
,replace(replace(t1.attach_rgst_dep_flg,chr(13),''),chr(10),'') as attach_rgst_dep_flg --补登存标志
,replace(replace(t1.main_evt_cls_cd,chr(13),''),chr(10),'') as main_evt_cls_cd --主事件分类代码
,replace(replace(t1.exch_rat_type_cd,chr(13),''),chr(10),'') as exch_rat_type_cd --汇率类型代码
,replace(replace(t1.avl_way_cd,chr(13),''),chr(10),'') as avl_way_cd --到账方式代码
,replace(replace(t1.wdraw_way_cd,chr(13),''),chr(10),'') as wdraw_way_cd --支取方式代码
,replace(replace(t1.bus_tran_batch_no,chr(13),''),chr(10),'') as bus_tran_batch_no --业务交易批次号
,replace(replace(t1.bank_tran_seq_num,chr(13),''),chr(10),'') as bank_tran_seq_num --银行交易序号
,replace(replace(t1.agent_tel_num,chr(13),''),chr(10),'') as agent_tel_num --代理人电话号码
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.lmt_code,chr(13),''),chr(10),'') as lmt_code --限额编码
,replace(replace(t1.cntpty_fin_inst_dist_cd,chr(13),''),chr(10),'') as cntpty_fin_inst_dist_cd --交易对手金融机构行政区划代码
,replace(replace(t1.cntpty_cert_no,chr(13),''),chr(10),'') as cntpty_cert_no --交易对手证件号码
,replace(replace(t1.real_cntpty_fin_inst_dist_cd,chr(13),''),chr(10),'') as real_cntpty_fin_inst_dist_cd --真实交易对手金融机构行政区划代码
,replace(replace(t1.real_cntpty_cert_no,chr(13),''),chr(10),'') as real_cntpty_cert_no --真实交易对手证件号码
,replace(replace(t1.real_cntpty_cert_type_cd,chr(13),''),chr(10),'') as real_cntpty_cert_type_cd --真实交易对手证件类型代码
,replace(replace(t1.tran_happ_site,chr(13),''),chr(10),'') as tran_happ_site --交易发生地点
,replace(replace(t1.real_tran_happ_site,chr(13),''),chr(10),'') as real_tran_happ_site --真实交易发生地点
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name --交易对手名称
,replace(replace(t1.real_cntpty_name,chr(13),''),chr(10),'') as real_cntpty_name --真实交易对手名称
,replace(replace(t1.payment_corp_name,chr(13),''),chr(10),'') as payment_corp_name --交款单位名称
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level --优先等级
,replace(replace(t1.seller_quot_type_cd,chr(13),''),chr(10),'') as seller_quot_type_cd --卖方牌价类型代码
,t1.chn_dt as chn_dt --渠道日期
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no --证件号码
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd --证件类型代码
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num --票据号码
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd --账套类别代码
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc --交易附言
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd --业务处理状态代码
,replace(replace(t1.auto_revs_flg,chr(13),''),chr(10),'') as auto_revs_flg --自动冲正标志
,t1.cntpty_equvl_amt as cntpty_equvl_amt --交易对手等值金额
,t1.tran_post_bal_add_finc as tran_post_bal_add_finc --交易后余额加理财
,replace(replace(t1.free_serv_fee_flg,chr(13),''),chr(10),'') as free_serv_fee_flg --免服务费标志
,replace(replace(t1.tran_public_agent_name,chr(13),''),chr(10),'') as tran_public_agent_name --交易代办人名称
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd --源模块类型代码
,t1.effect_dt as effect_dt --生效日期
,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num --冲正流水号
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id --交易终端编号
,replace(replace(t1.follow_id,chr(13),''),chr(10),'') as follow_id --跟踪编号
,replace(replace(t1.revs_tran_cd,chr(13),''),chr(10),'') as revs_tran_cd --冲正交易码
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg --冲正标志
,t1.revs_dt as revs_dt --冲正日期
,t1.clear_dt as clear_dt --清算日期
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg --过账标志
,replace(replace(t1.memo_code,chr(13),''),chr(10),'') as memo_code --摘要码
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb --交易摘要描述
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id --复核柜员编号
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id --授权柜员编号
,t1.init_tran_tm as init_tran_tm --原交易时间
,t1.tran_tm as tran_tm --交易时间
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id --交易柜员编号
,replace(replace(t1.beps_unpasew_flg,chr(13),''),chr(10),'') as beps_unpasew_flg --小额免密标志
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num --业务流水号
,replace(replace(t1.check_entry_cd,chr(13),''),chr(10),'') as check_entry_cd --对账代码
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id --交易编号
,replace(replace(t1.prpery_sys_code,chr(13),''),chr(10),'') as prpery_sys_code --来源系统编号
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name --源表名称
from iml.evt_dep_fin_tran_flow t1
where etl_dt >= to_date('20230502', 'yyyymmdd');

commit;



