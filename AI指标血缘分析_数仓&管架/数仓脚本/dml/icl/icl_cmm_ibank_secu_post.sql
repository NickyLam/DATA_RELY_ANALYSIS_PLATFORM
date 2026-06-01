/*
Purpose: 共性加工层-同业证券持仓
Author: Sunline
Usage: python $ETL_HOME/script/main.py 20231231 icl_cmm_ibank_secu_post
Createdate: 20191025
Logs: fuxx add column 'issuer_id','issuer_name' 20191108
	  20200424 周沁晖 1、调整资产四分类代码 acctnt_cls_cd ——> asset_four_cls_cd
	  20200627 周沁晖 调整字段【科目编号】的取数逻辑（15032101科目）
	  20200724 陈伟峰 增加【标准产品编号】字段
	  20200828 周沁晖 增加字段【对象编号、当日净值、利息科目编号、利息调整科目编号、资产三分类代码】
	  		            调整字段【科目编号】取数口径
	  20200828 陈伟峰 增加字段【交易金额】、【首次结算日期】
	  20200925 陈伟峰 修改发行人编号增加取值来源
	  20201017 陈伟峰 修改资产三分类取数源表
	  20201021 陈伟峰 修改利息科目、利息调整科目取值字段
	  20201027 翟若平 调整tmp_cmm_ibank_secu_post_01过滤条件
	  20201209 陈伟峰 增加字段【应计利息收入科目编号、摊销利息收入科目编号、公允价值变动损益科目编号、价差损益科目编号、应收利息、公允价值变动损益、价差损益、应计利息收入、摊销利息收入】，调整字段【应计利息】取数口径,调整口径【净价成本】
    20201223 陈伟峰 增加字段【FTP点差、FTP方案类别、同业存单发行机构编号、同业存单发行机构名称】
    20210108 周沁晖 调整字段【净价成本】
    20210122 周沁晖 增加字段【当期余额】
    20210319 陈伟峰 增加字段【审批单号】
    20210429 陈伟峰 1、主键字段【数据日期、法人编号、外部证券账户编号、内部证券账户编号、金融工具编号、市场类型编号、业务编号】调整为【数据日期、法人编号、外部证券账户编号、内部证券账户编号、金融工具编号、资产类型编号、市场类型编号、业务编号、组合交易号、逾期状态、额外维度代码、结算日期】
                    2、新增字段【组合交易号、逾期状态、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】
    20210508 何桐金 增加字段【逾期标志】
    20210517 陈伟峰 增加字段【应计利息收入增值税科目编号、摊销利息收入增值税科目编号、价差损益增值税科目编号、应计利息收入应税标志、摊销利息收入应税标志、价差损益应税标志、应计利息收入税率、摊销利息收入税率、价差损益税率、应计利息收入税额、摊销利息收入税额、价差损益税额】
    20210526 陈伟峰 调整科目1503190301的判断逻辑（公允价值）
    20210619 陈伟峰 增加字段【公允价值变动科目编号】
    20210621 陈伟峰 增加字段【交易日期】
                    调整字段【当期余额】的取数口径
    20210706 何桐金 1、调整字段【FTP点差】的取数口径
                    2、增加字段【起息日期、到期日期、是否当季赎回、预期赎回日期、交易持有标识、约期存款标志、约期开始日期、约期结束日期】
    20210708 何桐金 调整T24表过滤条件，增加int_rat_flow_id = (select t.cash_accid from ttrd_acc_cash_ext_map t where t.cash_ext_accid = '3080');
    20210730 陈伟峰 调整【交易持有标识】加工逻辑
    20210804 何桐金 1、增加字段【当期应计利息】
                    2、调整字段【实际余额、当期余额】的取数口径
    20210811 何桐金 增加字段【交易成本核算方法代码】
    20210830 陈伟峰 调整字段【当期余额】的取数口径
    20210909 陈伟峰 调整【应计利息收入】字段逻辑，加入when t1.asset_type_id='SPT_NTP' then (t1.acru_int_inco + t1.at_pre_recv_int_income + t1.bs_pl)
    20210914 陈伟峰 调整【利息科目编号】字段逻辑，增加转表外科目的数据
    20211014 翟若平 调整字段【应计利息收入、摊销利息收入】的取数口径
    20211015 何桐金 增加字段【利息收入】
    20211102 陈伟峰 调整【是否当季赎回、预期赎回日期】加工逻辑，关联evt_ibank_tran表时 order by SETDATE ——>order by SETDATE desc
    20211107 何桐金 增加agt_ibank_curr_cap_acct_bal_h.job_cd过滤条件
    20211115 陈伟峰 调整【审批单号】加工逻辑
    20211119 陈伟峰 调整【五级分类代码、交易日期、交易金额】加工逻辑
    20211204 陈伟峰 增加字段【内部证券账户状态代码、交易对手账号】
    20211227 陈伟峰 调整字段【是否当季赎回、预期赎回日期】的取数口径;新增字段【本期建仓日期】
    20220111 陈伟峰 调整t21表关联条件 EXT_VCH_ACCT_ID->INTNAL_VCH_ACCT_ID
                    调整字段【利息调整科目编号、公允价值变动科目编号、应计利息收入科目编号、应计利息、应收利息、公允价值变动、利息调整金额】加工逻辑
                    调整【约期开始日期、约期结束日期】加工逻辑
                    调整【本期建仓日期】字段逻辑，去除s_combobox_01 = '交易类型'
    20220313 陈伟峰 修复逻辑小写问题
    20220322 陈伟峰 调整【交易市场编号、交易所账户编号】加工逻辑
    20220401 陈伟峰 新增字段【约期金额、参考利率】，调整字段【本期建仓日期】取数逻辑
    20220531 陈伟峰 新增字段【票面利率】 --口径提供：徐鹏程，同业报表核算余额
    20220604 陈伟峰 调整主表数据范围，增加到期数据
    20220701 陈伟峰 新增字段【跨境同存标志、跨境同存签约起息日、跨境同存签约到期日】
    20220805 陈伟峰 调整字段【参考利率】加工逻辑，增加“SPT_CEF”部分数据加工
    20220923 温旺清 临时表 T21 iol.ibms_ttrd_ftp_spread_maintenance 增加过滤条件
    20220930 翟若平 1、新增字段【应收未收利息科目编号】
                    2、调整字段【公允价值变动、价差损益】的加工口径
    20221011 温旺清 1、调整ibms_ttrd_acct_protocol_master 关联条件
                    2、调整ibms_ttrd_ftp_spread_maintenance 关联条件,增加拉链日期
    20221020 温旺清 增加字段【授信金融工具编号、资产唯一标识编号】
    20230129 调整字段【利息收入】的加工口径，当产品为0700-净值型产品时，利息收入需要加上买卖损益
    20230208 陈伟峰 调整【价差损益】加工逻辑，0700取PRFT_FEE，0703和0700以外的取PRFT_TRD，0703取T1.PRFT_TRD+ T1.PRFT_FEE -投产日前PRFT_FEE
    20230404 陈伟峰 调整ibms_ttrd_acct_protocol_master表关联条件，增加提前到期判断【early_end_date】
    20230602 陈伟峰 调整【资产唯一标识编号】加工逻辑，使用intnal_vch_acct_id 拼接
    20230612 陈伟峰 调整字段【应收利息】的加工口径
    20230702 曹永茂 增加T32主协议账户表的过滤条件：t32.usable_flag='1'
    20230707 徐子豪 调整字段【应收利息】的加工口径,增加receive_ai <> 0卡值条件。
    20230731 陈伟峰 调整字段【预期赎回日期】的加工口径，新增字段【销售机构名称组合、销售机构占比说明、归属机构名称组合、归属机构占比说明】
    20230822 陈伟峰 调整字段【同业存单发行机构编号、同业存单发行机构名称】取数逻辑
    20230830 徐子豪 调整字段【逾期标志、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】的加工口径
    20240125 饶雅   新增字段 【内部证券账户会计分类代码、内部证券账户会计分类名称】
    20240326 饶雅   调整逻辑：调整净值型项目部分的【预期赎回日期】的加工口径
    202400603 饶雅  调整逻辑：修改同业资产唯一标识编号取数逻辑
    2024621  饶雅 接入PROD_TYPE_CD=‘0304’清算账户得数据
    20240717 陈伟峰 调整【应收利息】取数逻辑，去除应收未收利息
    20241018 谢  宁 新增【本金逾期金额、利息逾期金额】
    20241122 陈伟峰 调整跨境同存标志取数逻辑，增加is_delete<>'1'
                    调整ibms_ttrd_acct_protocol_master，使用usable_flag <> '2'
    20250507 陈伟峰 调整当期余额加工逻辑，增加债券借贷类型判断
    
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_secu_post drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_secu_post add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_secu_post_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_02 purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_03 purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_04 purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_05 purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_06 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_secu_post_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_ibank_secu_post where 0=1;

/* --2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_secu_post_01(
		subj_id1 varchar2(100)
		,subj_id2 varchar2(100)
		,subj_id3 varchar2(100)
		,subj_id3 varchar2(100)
		,acctg_obj_id varchar2(100)
)
nologging
compress ${option_switch} for query high
;
insert into ${icl_schema}.tmp_cmm_ibank_secu_post_01(
		subj_id1
		,subj_id2
		,subj_id3
		,acctg_obj_id
)
select max(case when gzb_type = '1' then subj_code else null end) as subj_id1,
			 max(case when gzb_type = '2' then subj_code else null end) as subj_id2,
			 max(case when gzb_type = '3' then subj_code else null end) as subj_id3,
			 acctg_obj_id
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type
  				from iol.ibms_ttrd_bookkeeping_obj_acctg a
  				left join iol.ibms_ttrd_accounting_entry_def b
  				  on a.subj_code = b.acting_code
  				 and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  				 and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
  			 where b.gzb_type in ('1','2','3')
  			   and replace(a.beg_date, '-', '') = '${batch_date}' -- 20201027 翟若平 新增
  			)group by acctg_obj_id;
commit; */

 --2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_secu_post_01 as
select acctg_obj_id                                                            as obj_id,
       max(org_id)                                                             as org_id,                      -- 机构编号
       max(decode(gzb_type, '1', subj_code, '9', subj_code, ''))               as subj_id,                     -- 科目编号
       max(decode(gzb_type, '3.1', subj_code, ''))                             as int_subj_id,                 -- 利息科目编号
       max(decode(gzb_type, 'X', subj_code, ''))                               as int_subj_id2,                -- 表外利息科目编号
       max(decode(gzb_type, '2', subj_code, ''))                               as int_adj_subj_id,             -- 利息调整科目编号
       max(decode(gzb_type, '4.1', subj_code, ''))                             as evha_val_chag_subj_id,       -- 公允价值变动科目编号
       max(decode(gzb_type, '5.1.1', subj_code, ''))                           as acru_int_inco_subj_id,       -- 应计利息收入科目编号
       max(decode(gzb_type, '5.1.2', subj_code, '5.1', subj_code, ''))         as amort_int_income_subj_id,    -- 摊销利息收入科目编号
       max(decode(gzb_type, '5.3', subj_code, ''))                             as evha_val_chag_pl_subj_id,    -- 公允价值变动损益科目编号
       max(decode(gzb_type, '5.2.1', subj_code, ''))                           as spd_pl_subj_id,              -- 价差损益科目编号
       max(decode(gzb_type, '5.1.1', '22210202', ''))                          as acru_int_inco_subj_id_1,     -- 应计利息收入增值税科目编号
       max(decode(gzb_type, '5.1.2', '22210203', ''))                          as amort_int_income_subj_id_1,  -- 摊销利息收入增值税科目编号
       max(decode(gzb_type, '5.2.1', '22210203', ''))                          as spd_pl_subj_id_1,            -- 价差损益增值税科目编号
       max(decode(gzb_type, '3.2', subj_code, ''))                             as un_int_subj_id,               -- 应收未收利息科目编号
       max(decode(gzb_type, '5.4', subj_code, ''))                             as acru_int_inco_subj_id_2               -- 应计利息收入科目编号 --特定于同业债券借贷业务，此业务的债券借入没有应计利息，只有业务支出，属于手续费，同业记账在利息科目，配置为5.4，所以需要特殊处理
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type, a.subj_org_id as org_id
          from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg a
          left join ${iol_schema}.ibms_ttrd_accounting_entry_def b
            on a.subj_code = b.acting_code
           and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
         where a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
		       and replace(a.beg_date, '-', '') = '${batch_date}')  -- 20201027 翟若平 新增
 group by acctg_obj_id;
commit;

/*create table ${icl_schema}.tmp_cmm_ibank_secu_post_02
nologging
compress ${option_switch} for query high
as
select t1.obj_id,
       t1.fin_instm_id,
       t1.asset_type_id,
       t1.market_type_id,
       t1.actl_bal,
       t1.acru_int,
       t1.recvbl_uncol_bal,
       t1.recvbl_uncol_acru_int
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
   and (t1.fin_instm_id, t1.asset_type_id, t1.market_type_id) in (select fin_instm_id, asset_type_id, market_type_id
                                                                    from ${iml_schema}.agt_secu_acct_accti_bal_h
                                                                   where ext_dimen_info like '%OverDue90%'
                                                                     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                                                                     and end_dt > to_date('${batch_date}', 'yyyymmdd')
                                                                     and job_cd = 'ibmsf1')
   and (t1.actl_bal + t1.acru_int + t1.recvbl_uncol_bal +t1.recvbl_uncol_acru_int) = 0;*/

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_secu_post_02 as
 select tt1.subj_code, tt1.gzb_type,sum(tt1.value) as value,tt1.core_acct_name,tt1.trade_id,tt1.typename
   from (select t1.subj_id as subj_code,
                case when t2.charge_type_cd='3.1'
                     then case when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应收利息%' then '3.2'
                               when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应计利息%' then '3.1'
                               end
                     else t2.charge_type_cd end as gzb_type,
                case when t1.debit_crdt_dir_cd = 'D' then t1.entry_amt
                     when t1.debit_crdt_dir_cd = 'C' then -1 * t1.entry_amt
                     end as value,
                t.tran_id as trade_id,
                t1.core_acct_name,
                case when t1.core_acct_name like '计入其他综合收益%' or t1.core_acct_name like '可供出售%' then 'FVOCI类'
                     when t1.core_acct_name like '交易性%' then 'FVTPL类'
                     when t1.core_acct_name like '以摊余成本计量%' or t1.core_acct_name like '应收款项%' then 'AC类'
                     else '' end  as typename
           from ${iml_schema}.evt_ibank_manual_entry_evt t --ttrd_manual_bk_record t
           left join ${iml_schema}.evt_ibank_acct_ety_evt t1 --ttrd_bookkeeping_entry_his t1
             on t.entry_flow_num = t1.entry_flow_num
            and t1.job_cd ='ibmsi1'
           left join ${iml_schema}.ref_ibank_accti_subj_para t2 --ttrd_accounting_entry_def t2
             on t1.subj_id=t2.accti_code
            and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
            and t2.job_cd = 'ibmsf1'
            and t2.id_mark <> 'D'
          where t.entry_status_cd = '03'
            and t2.charge_type_cd in ('2','3.1','4.1')
            and t.entry_type_cd<>'03'
            and trim(t.tran_id) is not null
            and t.entry_dt <= to_date('${batch_date}', 'yyyymmdd')
            and t.job_cd ='ibmsi1'
      ) tt1
 group by tt1.subj_code, tt1.trade_id, tt1.gzb_type,tt1.typename,tt1.core_acct_name;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_secu_post_03 as
select agt_id,lp_id,obj_id,task_id,ext_vch_acct_id,intnal_vch_acct_id,fin_instm_id,asset_type_id,market_type_id,tran_num,extra_dimen_cd,actl_qtty,actl_bal,net_price_cost,acru_int,int_cost,evha_val_chag,recvbl_uncol_bal,recvbl_uncol_net_price_cost,recvbl_uncol_acru_int,td_amort_bus_cnt,amort_dt,int_adj_amt,fair_val_pl,bs_pl,int_income,acru_int_inco,amort_int_income,curr_post_acru_int_int_income,curr_post_amort_int_income,reclafy_fair_val_pl,impam_prep,impam_loss,futures_margin,open_dt,last_update_dt,fee,paybl_fee,fee_cost,amort_net_price_cost,amort_int_cost,actl_int_rat,invest_yld_rat,open_yld_rat,pre_recv_int,non_amort_net_price_cost,non_amort_evha_val_chag,non_amort_fair_val_pl,non_amort_bs_pl,provi_amort_closing_dt,impam_status_cd,cost_impam_loss,int_impam_loss,cost_impam_prep,wrtn_off_cost,wrtn_off_acru_int,wrtn_off_recvbl_uncol_int,off_bs_acru_int,off_bs_recvbl_uncol_int,acru_int_amt,acru_vat,paybl_vat,curr_cd,bal_type_cd,stl_dt,rlizd_evha_val_chag_pl,curr_post_int_tax,open_int_cost,open_ex_yld_rat,pre_recv_int_income,provi_int_income,int_recvbl_inco,actl_recv_int_income,provi_int_income_pre_recv_tax,amort_int_income_paybl_vat,offset_dlvy_dt,std_prod_id,asset_thd_cls_cd,at_pre_recv_int_income,ext_dimen_info,comb_tran_id,job_cd
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
 union all
select agt_id,lp_id,obj_id,task_id,ext_vch_acct_id,intnal_vch_acct_id,fin_instm_id,asset_type_id,market_type_id,tran_num,extra_dimen_cd,actl_qtty,actl_bal,net_price_cost,acru_int,int_cost,evha_val_chag,recvbl_uncol_bal,recvbl_uncol_net_price_cost,recvbl_uncol_acru_int,td_amort_bus_cnt,amort_dt,int_adj_amt,fair_val_pl,bs_pl,int_income,acru_int_inco,amort_int_income,curr_post_acru_int_int_income,curr_post_amort_int_income,reclafy_fair_val_pl,impam_prep,impam_loss,futures_margin,open_dt,last_update_dt,fee,paybl_fee,fee_cost,amort_net_price_cost,amort_int_cost,actl_int_rat,invest_yld_rat,open_yld_rat,pre_recv_int,non_amort_net_price_cost,non_amort_evha_val_chag,non_amort_fair_val_pl,non_amort_bs_pl,provi_amort_closing_dt,impam_status_cd,cost_impam_loss,int_impam_loss,cost_impam_prep,wrtn_off_cost,wrtn_off_acru_int,wrtn_off_recvbl_uncol_int,off_bs_acru_int,off_bs_recvbl_uncol_int,acru_int_amt,acru_vat,paybl_vat,curr_cd,bal_type_cd,stl_dt,rlizd_evha_val_chag_pl,curr_post_int_tax,open_int_cost,open_ex_yld_rat,pre_recv_int_income,provi_int_income,int_recvbl_inco,actl_recv_int_income,provi_int_income_pre_recv_tax,amort_int_income_paybl_vat,offset_dlvy_dt,std_prod_id,asset_thd_cls_cd,at_pre_recv_int_income,ext_dimen_info,comb_tran_id,job_cd
  from ${iml_schema}.agt_secu_acct_accti_bal_exp_h t2
 where t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and not exists (select 1 from ${iml_schema}.agt_secu_acct_accti_bal_h t3
                    where t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                      and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
                      and t3.job_cd = 'ibmsf1'
                      and t3.obj_id =t2.obj_id);

--获取投产日前的PRFT_FEE余额,用于0703产品计算价差损益
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_secu_post_04 as
select obj_id,sum(fee)as fee from (
select obj_id,fee
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1
 where t1.start_dt <= to_date('20230502', 'yyyymmdd')   --投产日期，写死
   and t1.end_dt > to_date('20230502', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
 union all
select obj_id,fee
  from ${iml_schema}.agt_secu_acct_accti_bal_exp_h t2
 where t2.start_dt <= to_date('20230502', 'yyyymmdd')
   and t2.end_dt > to_date('20230502', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and not exists (select 1 from ${iml_schema}.agt_secu_acct_accti_bal_h t3
                    where t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                      and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
                      and t3.job_cd = 'ibmsf1'
                      and t3.obj_id =t2.obj_id))
 group by obj_id;

--公允价值变动核算差额
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_secu_post_05 as
select secu_chg.accti_obj_id,
       sum(-secu_chg.evha_val_chag) as chg_fv
  from ${iml_schema}.agt_secu_acct_accti_bal_chg_h secu_chg
 inner join ${iml_schema}.evt_ibank_tran_vch_instr_dtl inst_secu
    on inst_secu.secu_instr_seq_num = secu_chg.instr_id
   and inst_secu.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and inst_secu.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and inst_secu.job_cd='ibmsi1'
 inner join ${iml_schema}.evt_ibank_tran_main_instr_dtl inst
    on inst.main_instr_seq_num = inst_secu.main_instr_seq_num
   and inst.instr_status_cd = '04'
   and inst.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and inst.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and inst.job_cd ='ibmsi1'
 where secu_chg.revo_rela_chg_id = '-1'
   and (secu_chg.evha_val_chag <> 0 or secu_chg.fair_val_pl <> 0 or secu_chg.bs_pl <> 0)
   and secu_chg.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and secu_chg.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and secu_chg.job_cd='ibmsf1'
 group by secu_chg.accti_obj_id;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_secu_post_06 
as
select tran_num,
       fin_instm_id,
       asset_type_id,
       tran_market_id,
       entr_dt,
       row_number() over(partition by fin_instm_id,asset_type_id,tran_market_id order by entr_dt desc) as rn 
  from ${iml_schema}.evt_ibank_tran  --同业交易表
 where stl_status_cd=999
   and tran_type_id='0700080'  
   and entr_dt <= to_date('${batch_date}', 'yyyymmdd')
   and job_cd='ibmsi1'

;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_secu_post_ex(
  etl_dt                 				        -- 数据日期
  ,lp_id                 				        -- 法人编号
  ,ext_secu_acct_id      				        -- 外部证券账户编号
  ,intnal_secu_acct_id   				        -- 内部证券账户编号
  ,intnal_secu_acct_status_cd           -- 内部证券账户状态代码
  ,intnal_secu_acct_acctnt_cls_cd       -- 内部证券账户会计分类代码
  ,intnal_secu_acct_acctnt_cls_name     -- 内部证券账户会计分类名称
  ,fin_instm_id          				        -- 金融工具编号
  ,asset_type_id         				        -- 资产类型编号
  ,std_prod_id           				        -- 标准产品编号
  ,market_type_id        				        -- 市场类型编号
  ,bus_id                				        -- 业务编号
  ,comb_tran_num                        -- 组合交易号
  ,cntpty_acct_id                       -- 交易对手账号
  ,obj_id							                  -- 对象编号
  ,apv_form_num                         -- 审批单号
  ,crdt_fin_instm_id                    -- 授信金融工具编号
  ,asset_uniq_idf_id                    -- 资产唯一标识编号
  ,prod_type_cd          				        -- 产品类型代码
  ,asset_type_name       				        -- 资产类型名称
  ,level5_cls_cd         				        -- 五级分类代码
  ,subj_id               				        -- 科目编号
  ,int_subj_id    		   				        -- 利息科目编号
  ,recvbl_uncol_int_subj_id             -- 应收未收利息科目编号
  ,int_adj_subj_id		   				        -- 利息调整科目编号
  ,evha_val_chag_subj_id                -- 公允价值变动科目编号
  ,acru_int_inco_subj_id                -- 应计利息收入科目编号
  ,amort_int_income_subj_id             -- 摊销利息收入科目编号
  ,evha_val_chag_pl_subj_id             -- 公允价值变动损益科目编号
  ,spd_pl_subj_id                       -- 价差损益科目编号
  ,acru_int_inco_vat_subj_id            -- 应计利息收入增值税科目编号
  ,amort_int_income_vat_subj_id         -- 摊销利息收入增值税科目编号
  ,spd_pl_vat_subj_id                   -- 价差损益增值税科目编号
  ,acct_name             				        -- 账户名称
  ,tran_market_id        				        -- 交易市场编号
  ,exchg_acct_id         				        -- 交易所账户编号
  ,issuer_id             				        -- 发行人编号
  ,issuer_name           				        -- 发行人名称
  ,stl_site_id           				        -- 结算场所编号
  ,stl_site_name         				        -- 结算场所名称
  ,tran_num              				        -- 交易号
  ,extra_dimen_cd        				        -- 额外维度代码
  ,curr_cd               				        -- 币种代码
  ,bal_type_cd                          -- 余额类型代码
  ,actl_qtty             				        -- 实际数量
  ,actl_bal              				        -- 实际余额
  ,currt_bal                            -- 当期余额
  ,net_price_cost        				        -- 净价成本
  ,currt_acru_int                       -- 当期应计利息
  ,acru_int              				        -- 应计利息
  ,int_recvbl                           -- 应收利息
  ,int_cost              				        -- 利息成本
  ,evha_val_chag         				        -- 公允价值变动
  ,recvbl_uncol_bal      				        -- 应收未收余额
  ,recvbl_uncol_net_price_cost          -- 应收未收净价成本
  ,recvbl_uncol_acru_int                -- 应收未收应计利息
  ,int_adj_amt                          -- 利息调整金额
  ,ref_int_rat                          -- 参考利率
  ,actl_int_rat                         -- 实际利率
  ,fac_val_int_rat                      -- 票面利率
  ,invest_yld_rat                       -- 投资收益率
  ,open_yld_rat                         -- 开仓收益率
  ,td_nv					                      -- 当日净值
  ,amort_dt                             -- 摊销日期
  ,fir_stl_dt                           -- 首次结算日期
  ,tran_dt                              -- 交易日期
  ,stl_dt                               -- 结算日期
  ,open_dt                              -- 开仓日期
  ,value_dt                             -- 起息日期
  ,exp_dt                               -- 到期日期
  ,last_update_dt                       -- 上次更新日期
  ,cap_type_cd                          -- 资金类型代码
  ,asset_four_cls_cd                    -- 资产四分类代码
  ,asset_thd_cls_cd			                -- 资产三分类代码
  ,belong_org_id                        -- 所属机构编号
  ,tran_amt                             -- 交易金额
  ,evha_val_chag_pl                     -- 公允价值变动损益
  ,spd_pl                               -- 价差损益
  ,int_income                           -- 利息收入
  ,acru_int_inco                        -- 应计利息收入
  ,amort_int_inco                       -- 摊销利息收入
  ,acru_int_inco_should_tax_flg         -- 应计利息收入应税标志
  ,amort_int_income_should_tax_flg      -- 摊销利息收入应税标志
  ,spd_pl_should_tax_flg                -- 价差损益应税标志
  ,acru_int_inco_tax_rat                -- 应计利息收入税率
  ,amort_int_income_tax_rat             -- 摊销利息收入税率
  ,spd_pl_tax_rat                       -- 价差损益税率
  ,acru_int_inco_tax_lmt                -- 应计利息收入税额
  ,amort_int_income_tax_lmt             -- 摊销利息收入税额
  ,spd_pl_tax_lmt                       -- 价差损益税额
  ,ftp_prop_cate                        -- ftp方案类别
  ,ftp_spread                           -- ftp点差
  ,ncds_issue_org_id                    -- 同业存单发行机构编号
  ,ncds_issue_org_name                  -- 同业存单发行机构名称
  ,sell_org_name_comb                   -- 销售机构名称组合
  ,sell_org_pct_comnt                   -- 销售机构占比说明
  ,belong_org_name_comb                 -- 归属机构名称组合
  ,belong_org_pct_comnt                 -- 归属机构占比说明
  ,ovdue_status	                        -- 逾期状态
  ,ovdue_flg                            -- 逾期标志
  ,pric_ovdue_dt	                      -- 本金逾期日期
  ,pric_ovdue_days                      -- 本金逾期天数
  ,int_ovdue_dt	                        -- 利息逾期日期
  ,int_ovdue_days	                      -- 利息逾期天数
  ,pric_ovdue_amt                       -- 本金逾期金额
  ,int_ovdue_amt                        -- 利息逾期金额
  ,is_th_ssn_redem                      -- 是否当季赎回
  ,curr_issue_build_up_pos_dt           -- 本期建仓日期
  ,expe_redem_dt                        -- 预期赎回日期
  ,tran_hold_idf                        -- 交易持有标识
  ,apot_tenor_dep_flg                   -- 约期存款标志
  ,apot_tenor_start_dt                  -- 约期开始日期
  ,apot_tenor_end_dt                    -- 约期结束日期
  ,apot_tenor_amt                       -- 约期金额
  ,tran_cost_accti_method_cd            -- 交易成本核算方法代码
  ,cross_bor_depo_takof_inter_flg       -- 跨境同存标志
  ,cross_bor_depo_takof_inter_sign_value_dt   -- 跨境同存签约起息日期
  ,cross_bor_depo_takof_inter_sign_exp_dt   -- 跨境同存签约到期日期
  ,job_cd
  ,etl_timestamp                        -- etl处理时间戳
)
select
  to_date('${batch_date}', 'yyyymmdd')  -- 数据日期
  ,t1.lp_id                             -- 法人编号
  ,t1.ext_vch_acct_id                   -- 外部证券账户编号
  ,t1.intnal_vch_acct_id                -- 内部证券账户编号
  ,t3.acct_status_cd                    -- 内部证券账户状态代码
  ,t7.cls_id                            -- 内部证券账户会计分类代码
  ,t7.cls_name                          -- 内部证券账户会计分类名称
  ,t1.fin_instm_id                      -- 金融工具编号
  ,t1.asset_type_id                     -- 资产类型编号
  ,t1.std_prod_id                       -- 标准产品编号
  ,t1.market_type_id                    -- 市场类型编号
  ,t1.tran_num                          -- 业务编号
  ,t1.comb_tran_id                      -- 组合交易号
  ,t52.cntpty_acct_num                  -- 交易对手账号
  ,t1.obj_id			                      -- 对象编号
  ,t52.apv_odd_no                       -- 审批单号
  ,nvl(trim(t38.approve_i_code), t1.fin_instm_id)   -- 授信金融工具编号
  ,nvl(trim(t38.approve_i_code), t1.fin_instm_id) || case when t1.asset_type_id IN ('SPT_BD', 'SPT_ABS') AND t1.market_type_id = 'XSHG' THEN 'SH' WHEN t1.asset_type_id IN ('SPT_BD', 'SPT_ABS') AND t1.market_type_id = 'XSHE' THEN 'SZ' else '' END|| '_' || t1.asset_thd_cls_cd || '_' || t1.intnal_vch_acct_id -- 资产唯一标识编号
  ,t4.prod_type_cd                      -- 产品类型代码
  ,t4.prod_cls                          -- 资产类型名称
  ,nvl(trim(t52.level5_cls_cd),'99')    -- 五级分类代码
  ,case when t4.prod_type_cd in ('0170') and t4.prod_cls = '票据资管计划（非保本）' and '${batch_date}' <= '20201231' then '15032201'
        when t9.subj_id is not null then t9.subj_id
        else isp.subj_id
        end                 			      -- 科目编号
  ,coalesce(t9.int_subj_id, t9.int_subj_id2, isp.int_subj_id)         -- 利息科目编号
  ,t9.un_int_subj_id                    -- 应收未收利息科目编号
  ,coalesce(t9.int_adj_subj_id,decode(t31.gzb_type,'2',t31.subj_code,''),isp.int_adj_subj_id)	        		          -- 利息调整科目编号
  ,coalesce(t9.evha_val_chag_subj_id,decode(t31.gzb_type,'4.1',t31.subj_code,''),isp.evha_val_chag_subj_id)      -- 公允价值变动科目编号
  ,case when T4.src_pay_int_ped_cd='0D'
        then case when t5.tran_type_id in ('2000100','2000101') then  coalesce(t9.acru_int_inco_subj_id,t9.acru_int_inco_subj_id_2,decode(t31.gzb_type,'3.1',t31.subj_code,''))
                             else coalesce(t9.acru_int_inco_subj_id,decode(t31.gzb_type,'3.1',t31.subj_code,'')) end 
        when T4.src_pay_int_ped_cd<>'0D'
        then case when t5.tran_type_id in ('2000100','2000101') then coalesce(t9.acru_int_inco_subj_id,t9.acru_int_inco_subj_id_2,decode(t31.gzb_type,'3.2',t31.subj_code,''))
                             else coalesce(t9.acru_int_inco_subj_id,decode(t31.gzb_type,'3.2',t31.subj_code,'')) end
        else isp.acru_int_inco_subj_id end            -- 应计利息收入科目编号
  ,nvl(t9.amort_int_income_subj_id, isp.amort_int_income_subj_id)     -- 摊销利息收入科目编号
  ,nvl(t9.evha_val_chag_pl_subj_id, isp.evha_val_chag_pl_subj_id)     -- 公允价值变动损益科目编号
  ,nvl(t9.spd_pl_subj_id, isp.spd_pl_subj_id)                         -- 价差损益科目编号
  ,nvl(t9.acru_int_inco_subj_id_1, isp.acru_int_inco_vat_subj_id)       -- 应计利息收入增值税科目编号
  ,nvl(t9.amort_int_income_subj_id_1, isp.amort_int_income_vat_subj_id) -- 摊销利息收入增值税科目编号
  ,nvl(t9.spd_pl_subj_id_1, isp.spd_pl_vat_subj_id)                     -- 价差损益增值税科目编号
  --,t3.acct_name                        -- 账户名称 --modify by fuxx 20191122 账户名称需要从内部证券账户取
  ,t2.acct_name                          -- 账户名称
  ,nvl(trim(t3.tran_market_id),t22.tran_market_id)                 -- 交易市场编号
  ,nvl(trim(t3.exchg_acct_id),t22.exchg_acct_id)                   -- 交易所账户编号
  ,nvl(t6.issuer_id,t4.issuer_id)        -- 发行人编号
  ,t6.issuer_name                        -- 发行人名称
  ,t3.stl_site_id                        -- 结算场所编号
  ,t3.stl_site_name                      -- 结算场所名称
  ,t1.tran_num                           -- 交易号
  ,t1.extra_dimen_cd                     -- 额外维度代码
  ,t1.curr_cd                            -- 币种代码
  ,t1.bal_type_cd                        -- 余额类型代码
  ,t1.actl_qtty                          -- 实际数量
  ,(case when t1.asset_type_id = 'SPT_DED' then t28.acct_bal else t1.actl_bal end) -- 实际余额
  ,(case when t1.asset_type_id  = 'SPT_DED' then t28.acct_bal
              when t5.tran_type_id in ('2000100','2000101') then t1.actl_bal
         when t20.fin_instm_id is not null and t20.prod_type_cd <> '0170' then t1.actl_bal + t1.recvbl_uncol_bal
         when t20.fin_instm_id is not null and t20.prod_type_cd = '0170' then t1.net_price_cost + t1.recvbl_uncol_net_price_cost
         when (t4.prod_type_cd = '0700' or t4.prod_cls = '债券基金') then t1.net_price_cost + t1.recvbl_uncol_net_price_cost
         when t4.prod_type_cd in ('1100', '0000') and t4.prod_cls <> '同业存单' then t1.net_price_cost + t1.recvbl_uncol_net_price_cost
         else t1.net_price_cost + t1.recvbl_uncol_net_price_cost
    end)                                     -- 当期余额
  ,nvl(t1.net_price_cost,0)+nvl(t1.recvbl_uncol_net_price_cost,0)       -- 净价成本
  ,t1.acru_int                          -- 当期应计利息
  ,case when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
          case when t4.src_pay_int_ped_cd = '0D' then
                 case when t31.gzb_type = '3.1' then t1.acru_int + nvl(t31.value, 0)
                      else t1.acru_int
                  end
               else 0
           end
        else 0
    end as acru_int                       -- 应计利息
  ,case when t4.prod_type_cd in ('0702','0703','0704','0705') then nvl(t41.receive_ai,0)
        when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
          case when t4.src_pay_int_ped_cd <>'0D' then
                 case when t31.gzb_type = '3.2' then t1.acru_int + nvl(t31.value, 0)
                      else t1.acru_int
                  end
               else 0
           end
        else t1.acru_int  + nvl(t31.value, 0)
    end as int_recvbl                    -- 应收利息
  ,t1.int_cost                           -- 利息成本
  ,case when t31.gzb_type='4' then t1.evha_val_chag + nvl(t31.value, 0)+nvl(t40.chg_fv,0)
        else t1.evha_val_chag+nvl(t40.chg_fv,0) end        -- 公允价值变动
  ,t1.recvbl_uncol_bal                   -- 应收未收余额
  ,t1.recvbl_uncol_net_price_cost        -- 应收未收净价成本
  ,case when t1.bal_type_cd = '1' then 0 
        else t1.recvbl_uncol_acru_int end                  -- 应收未收应计利息
  ,case when t31.gzb_type='2' then t1.int_adj_amt + nvl(t31.value, 0)
        else t1.int_adj_amt end          -- 利息调整金额
  ,case when t1.asset_type_id='SPT_NTP' then nvl(trim(t33.rx_bnd_ytm),'0')
        when t1.asset_type_id='SPT_MMF' then nvl(trim(t34.h_rate_07_f4),'0')
        when t1.asset_type_id='SPT_CEF' then nvl(trim(t37.ref_int_rat),'0')
        else '0' end                     -- 参考利率
  ,t1.actl_int_rat                       -- 实际利率
  ,nvl(t35.actl_int_rat,0)               -- 票面利率
  ,t1.invest_yld_rat                     -- 投资收益率
  ,t1.open_yld_rat                       -- 开仓收益率
  ,t8.f_unitnav						               -- 当日净值
  ,t1.amort_dt                           -- 摊销日期
  ,t5.stl_dt                             -- 首次结算日期
  ,t52.entr_dt                           -- 交易日期
  ,t1.stl_dt                             -- 结算日期
  ,t1.open_dt                            -- 开仓日期
  ,case when t1.asset_type_id = 'SPT_DED' then t23.vp_start_dt
        when t4.prod_type_cd = '0706' then null
        else t4.value_dt
        end as value_dt                  -- 起息日期
  ,case when t1.asset_type_id = 'SPT_DED' then t23.vp_end_dt
        when t4.prod_type_cd = '0706' then null
        else t4.exp_dt
        end as exp_dt                    -- 到期日期
  ,t1.last_update_dt                     -- 上次更新日期
  ,t2.cap_type_cd                        -- 资金类型代码
  ,t2.asset_four_cls_cd    		           -- 资产四分类代码
  ,t1.asset_thd_cls_cd  				         -- 资产三分类
  ,nvl(t2.belong_org_id, t9.org_id)      -- 所属机构编号
  ,t52.tran_amt                          -- 交易金额
  ,t1.fair_val_pl                        -- 公允价值变动损益
  ,case when t4.prod_type_cd = '0700' then t1.fee
        when t4.prod_type_cd ='0703' then t1.bs_pl + t1.fee - nvl(t39.fee,0)  --新一代切换后需加上费用发生额t1.fee - nvl(t39.fee,0)
        else t1.bs_pl
        end as spd_pl                    -- 价差损益
  ,case when t4.prod_type_cd = '0700' then t1.bs_pl+t1.int_income
        else t1.int_income
        end as int_income                -- 利息收入
  ,(case when t1.ext_dimen_info like '%OverDue90%' then 0
         when ${batch_date} <= '20201231' then t1.int_income - t1.amort_int_income
         when t1.asset_type_id='SPT_NTP' then (t1.acru_int_inco + t1.at_pre_recv_int_income + t1.bs_pl)
         else (t1.acru_int_inco + t1.at_pre_recv_int_income)
         end)                            -- 应计利息收入
  ,(case when t1.ext_dimen_info like '%OverDue90%' then 0
         else t1.amort_int_income end)   -- 摊销利息收入
  ,t18.acru_int_inco_tax_flag            -- 应计利息收入应税标志
  ,t18.amort_int_inco_tax_flag           -- 摊销利息收入应税标志
  ,t18.spd_pl_tax_flag                   -- 价差损益应税标志
  ,nvl(t18.acru_int_inco_tax_rate,0)     -- 应计利息收入税率
  ,nvl(t18.amort_int_inco_tax_rate,0)    -- 摊销利息收入税率
  ,nvl(t18.spd_pl_tax_rate,0)            -- 价差损益税率
  ,nvl(t19.tax_due_ai + t19.tax_ai + t19.tax_fut_ai,0)      -- 应计利息收入税额
  ,nvl(t19.tax_due_amrt,0)               -- 摊销利息收入税额
  ,nvl(t19.tax_due_trd,0)                -- 价差损益税额
  ,t14.type                              -- ftp方案类别
  ,t21.new_spread                        -- ftp点差
  ,t15.src_party_id                      -- 同业存单发行机构编号
  ,t15.party_fname                       -- 同业存单发行机构名称
  ,t44.sell_org_name_comb                -- 销售机构名称组合
  ,t44.sell_org_pct_comnt                -- 销售机构占比说明
  ,t44.belong_org_name_comb              -- 归属机构名称组合
  ,t44.belong_org_pct_comnt              -- 归属机构占比说明
  ,t1.ext_dimen_info	                   -- 逾期状态
  ,case when (t45.is_ai_overdue = '1' or  t45.is_cp_overdue = '1') then '1' 
        else '0' end  as ovdue_flg       --逾期标志 
  ,case when t45.is_cp_overdue = '1' then ${iml_schema}.dateformat_max(t45.beg_date_cp_overdue) else null end as pric_ovdue_dt -- 本金逾期日期
  ,case when t45.is_cp_overdue = '1' then decode(${iml_schema}.dateformat_max2(t45.beg_date_cp_overdue),to_date('29991231', 'yyyymmdd'),'0',
        to_date('${batch_date}', 'yyyymmdd') - ${iml_schema}.dateformat_max(t45.beg_date_cp_overdue)) else '0' end   as pric_ovdue_days    -- 本金逾期天数
  ,case when t45.is_ai_overdue = '1' then ${iml_schema}.dateformat_max(t45.beg_date_ai_overdue) else null end as int_ovdue_dt -- 利息逾期日期
  ,case when t45.is_ai_overdue = '1' then decode(${iml_schema}.dateformat_max2(t45.beg_date_ai_overdue),to_date('29991231', 'yyyymmdd'),'0',
        to_date('${batch_date}', 'yyyymmdd') - ${iml_schema}.dateformat_max(t45.beg_date_ai_overdue)) else '0' end   as int_ovdue_days     -- 利息逾期天数
  ,case when t45.is_cp_overdue = '1' then nvl(t45.amount_cp_overdue,0) else 0 end                                    as pric_ovdue_amt     -- 本金逾期金额
  ,case when t45.is_ai_overdue = '1' then nvl(t45.amount_ai_overdue,0) else 0 end                                    as int_ovdue_amt      -- 利息逾期金额
  ,case when trim(t25.is_quarter_redeem) is not null
        then t25.is_quarter_redeem
        else decode(t27.s_combobox_01,'交易类型','1','0')
        end                              -- 是否当季赎回
  ,case when t1.asset_type_id = 'SPT_DED' then t23.vp_start_dt
        --when t4.prod_type_cd = '0706' then null
        when t4.prod_type_cd = '0700'  then ${iml_schema}.dateformat_min(t30.beg_date)   -- 净值型开放类型固定期限，取首次建仓日
        when t4.prod_type_cd in ('0000','1100','1200') and t1.extra_dimen_cd = 'L'  then ${iml_schema}.dateformat_min(t30.beg_date) -- 债券交易持有标志为交易类型，取首次建仓日
        when t4.prod_type_cd in ('0703','0704','0705','0706') then ${iml_schema}.dateformat_min(t30.beg_date)-- 债基取首次建仓日
        else t4.value_dt                        -- 非标、非交易类型债券等取产品起息日
        end                              -- 本期建仓日期
  ,case when t1.asset_type_id = 'SPT_DED' then t23.vp_end_dt
        when t4.prod_type_cd = '0706' then null
        when t4.prod_type_cd = '0700' and t29.open_type = '2' then ${iml_schema}.dateformat_max(t29.closing_end_date)
        when t4.prod_type_cd = '0700' and t29.open_type <> '2' then to_date(decode(t47.redem_datefield,' ','',${iml_schema}.dateformat_max(t47.redem_datefield))) --净值型开放类型非固定期限，取录入计划赎回日期
        when t4.prod_type_cd in ('0000','1100','1200') and t1.extra_dimen_cd = 'L' and t27.s_combobox_01 = '交易类型' then ${iml_schema}.dateformat_max(t27.redem_datefield)
        when t4.prod_type_cd in ('0703','0704','0705') then ${iml_schema}.dateformat_max(t25.redeem_date)  -- 债基取交易单计划赎回日
        else t4.exp_dt -- 非标、非交易类型债券等取产品到期日
        end                              -- 预期赎回日期
  ,t27.s_combobox_01                     -- 交易持有标识
  ,t26.is_appoint_time                   -- 约期存款标志
  ,t32.start_date                        -- 约期开始日期
  ,t32.expire_date                       -- 约期结束日期
  ,t32.amount                            -- 约期金额
  ,t7.tran_cost_accti_method_cd          -- 交易成本核算方法代码
  ,case when t36.accid is not null then '1' else '0' end  -- 跨境同存标志
  ,to_date(trim(t36.start_date),'yyyy-mm-dd')             -- 跨境同存签约起息日期
  ,to_date(trim(t36.mtr_date),'yyyy-mm-dd')               -- 跨境同存签约到期日期
  ,t1.job_cd
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${icl_schema}.tmp_cmm_ibank_secu_post_03 t1 -- 证券账户核算余额历史
  left join ${iml_schema}.agt_intnal_secu_acct t2 -- 内部证券账户
    on t1.intnal_vch_acct_id = t2.acct_id
   and t2.job_cd = 'ibmsf1'
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.id_mark <> 'D'
  left join ${iml_schema}.pty_ibank_cntpty_info t42
    on t2.belong_org_id  =t42.org_id
   and t42.job_cd = 'ibmsf1'
   and t42.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t42.id_mark <> 'D'
  left join ${iml_schema}.agt_ext_secu_acct t3 --外部证券账户
    on t1.ext_vch_acct_id = t3.acct_id
   and t3.job_cd = 'ibmsf1'
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.id_mark <> 'D'
  left join ${iml_schema}.prd_fin_instm t4 --金融工具表
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   and t4.job_cd = 'ibmsf1'
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.id_mark <> 'D'
  left join ${iml_schema}.evt_ibank_tran t52 --同业交易表
    on t1.tran_num = t52.intnal_tran_num
   and t52.job_cd = 'ibmsi1'
left join ${iml_schema}.evt_ncds_issue_rest_tot t44 -- 同业存单发行结果汇总表
    on t52.tran_num = t44.sub_tran_odd_no
   and t52.quote_tran_num = t44.tran_odd_no
   and t44.job_cd = 'ibmsf1'
   left join (select tran_num
                     ,fin_instm_id
                     ,asset_type_id
                     ,tran_market_id
                     ,level5_cls_cd
                     ,stl_dt
					           ,tran_amt
					           ,ftp_id
                     ,apv_odd_no
                     ,entr_dt
                     ,tran_type_id
                     ,row_number() over(partition by fin_instm_id,asset_type_id,tran_market_id order by stl_dt) as rn
                from ${iml_schema}.evt_ibank_tran
               where job_cd = 'ibmsi1'
                ) t5
    on t1.fin_instm_id = t5.fin_instm_id
   and t1.asset_type_id = t5.asset_type_id
   and t1.market_type_id = t5.tran_market_id
   and t5.rn = 1
  left join ${iml_schema}.prd_ibank_bond t6 --同业债券 modify by fuxx 20191108
    on t1.fin_instm_id = t6.fin_instm_id
   and t1.asset_type_id = t6.asset_type_id
   and t1.market_type_id = t6.market_type_id
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsf1'
   and t6.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_acctnt_type_cd t7
  	on t7.cls_id = t2.acctnt_cls_cd
   and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'ibmsf1'
   and t7.id_mark <> 'D'
  left join ${iol_schema}.ibms_tfnd_nav t8
  	on t1.fin_instm_id = t8.i_code
   and t1.asset_type_id = t8.a_type
   and t1.market_type_id = t8.m_type
   and replace(t8.beg_date, '-', '') <= '${batch_date}'
   and replace(t8.end_date, '-', '') > '${batch_date}'
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ibank_secu_post_01 t9
  	on t1.obj_id = t9.obj_id
  left join ${iol_schema}.ibms_ttrd_ftp_register t14
	  on t5.ftp_id = t14.ftp_code
   and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.end_dt > to_date('${batch_date}','yyyymmdd')
  left join (select a.obj_id,
                    dm.src_party_id,
                    dm.party_fname,
                    row_number() over(partition by obj_id order by register_date desc) as fk
               from ${iol_schema}.ibms_ttrd_position_asset_register a
               left join ${iml_schema}.pty_ibank_cntpty_info dm
                 on dm.src_party_id = a.secu_acct_id
                and dm.create_dt <=to_date('${batch_date}', 'yyyymmdd')
                and dm.id_mark <>'D'
                and dm.job_cd ='ibmsf1'
              where a.register_type = '3'
                and a.register_date <= '${batch_date}'
				        and trim(a.obj_id) is not null ) t15
    on t1.obj_id = t15.obj_id
   and t15.fk =1
  left join (select a.p_type,
                    a.p_class,
                    max(case when a.tax_rate_field in ('11', '12') then decode(a.tax_type_rate, '0', '1', '0') else '0' end) as acru_int_inco_tax_flag,
                    max(case when a.tax_rate_field in ('14') then decode(a.tax_type_rate, '0', '1', '0') else '0' end) as amort_int_inco_tax_flag,
                    max(case when a.tax_rate_field in ('16') then decode(a.tax_type_rate, '0', '1', '0') else '0' end) as spd_pl_tax_flag,
                    max(case when a.tax_rate_field in ('11', '12') then a.tax_rate else 0 end) as acru_int_inco_tax_rate,
                    max(case when a.tax_rate_field in ('14') then a.tax_rate else 0 end) as amort_int_inco_tax_rate,
                    max(case when a.tax_rate_field in ('16') then a.tax_rate else 0 end) as spd_pl_tax_rate
               from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate a
              where a.tax_rate_field in ('11','12','14','16','20')
                and a.status = '1'
                and to_date(a.beg_date, 'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
                and to_date(a.end_date, 'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
                and a.start_dt <= to_date('${batch_date}','yyyymmdd')
                and a.end_dt > to_date('${batch_date}','yyyymmdd')
              group by a.p_class, a.p_type) t18
    on t4.prod_cls = t18.p_class
   and t4.prod_type_cd = t18.p_type
  left join (select acctg_obj_id,
                    sum(tax_due_ai) as tax_due_ai,
                    sum(tax_ai) as tax_ai,
                    sum(tax_fut_ai) as tax_fut_ai,
                    sum(tax_due_amrt) tax_due_amrt,
                    sum(tax_due_trd) tax_due_trd
               from ${iol_schema}.ibms_ttrd_accounting_secu_chg_his
              where to_date(chg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
              group by acctg_obj_id) t19
   on t1.obj_id = t19.acctg_obj_id
  left join ${iml_schema}.prd_ibank_cap_ld_fin_instm T20
  	on t1.fin_instm_id = t20.fin_instm_id
   and t1.asset_type_id = t20.asset_type_id
   and t1.market_type_id = t20.market_type_id
   and t20.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t20.job_cd = 'ibmsf1'
   and t20.id_mark <> 'D'
  left join ${iol_schema}.ibms_ttrd_ftp_spread_maintenance t21
    on t1.fin_instm_id = t21.i_code
   and t1.asset_type_id = t21.a_type
   and t1.market_type_id = t21.m_type
   and t1.intnal_vch_acct_id = t21.accid
   and t1.tran_num = t21.trade_id
   and t21.status = '1'   --是否有效  modify by wwq 2022/9/23 15:50
   and t21.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t21.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_ext_cap_acct t22
    on t1.ext_vch_acct_id = t22.acct_id
   and t22.create_dt<=to_date('${batch_date}', 'yyyymmdd')
   and t22.job_cd= 'ibmsf1'
   and t22.id_mark <> 'D'
  left join ${iml_schema}.ref_curr_fin_instm_int_rat t23
    on t22.int_rat_def_id = t23.int_rat_def_id
   and t23.create_dt<=to_date('${batch_date}', 'yyyymmdd')
   and t23.job_cd= 'ibmsf1'
   and t23.id_mark <> 'D'
   and t23.vp_start_dt <=  to_date('${batch_date}', 'yyyymmdd')
   and t23.vp_end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t.intnal_secu_acct_id,s.fin_instm_id,s.asset_type_id,s.market_type_id,
                    t.th_ssn_redem_flg as is_quarter_redeem
                    ,t.plan_redem_dt as redeem_date
                    ,row_number() over(partition by t.intnal_secu_acct_id,s.fin_instm_id,s.asset_type_id,s.market_type_id order by t.entr_dt desc) rn
               from  ${iml_schema}.evt_ibank_tran t --iol.ibms_ttrd_otc_trade t
               left join ${iml_schema}.prd_fin_instm  s --iol.ibms_ttrd_instrument s
                 on t.fin_instm_id = s.fin_instm_id
                and t.asset_type_id = s.asset_type_id
                and t.tran_market_id = s.market_type_id
                and s.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and s.job_cd ='ibmsf1'
                and s.id_mark<>'D'
               where t.tran_status_cd = '4'
	       and t.stl_status_cd = '999'
               and t.tran_type_id in ('0702080', '0702150')
               and t.plan_redem_dt <> to_date('20991231', 'yyyymmdd')   --新增字段 plan_redem_dt使用的是iml.dateformat_max('')函数
               and t.stl_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t.job_cd ='ibmsi1') t25
   on t25.intnal_secu_acct_id = t1.intnal_vch_acct_id
   and t25.fin_instm_id = t1.fin_instm_id
   and t25.asset_type_id = t1.asset_type_id
   and t25.market_type_id = t1.market_type_id
   and t25.rn=1
  left join(select t.cntpty_zzd_acct_id as party_zzdacccode,
                   t.is_term as is_appoint_time,
                   t.term_start_day as appoint_start_date,
                   t.term_end_day as appoint_end_date,
                   row_number() over(partition by t.cntpty_zzd_acct_id order by t.dlvy_dt) rn
              from ${iml_schema}.evt_ibank_tran t
             where t.tran_type_id in ('0303010','0303011')
               and t.tran_status_cd = '4' and t.stl_status_cd = '999'
               and trim(t.is_term) is not null
               and t.job_cd='ibmsi1'
           ) t26
    on t22.acct_id = t26.party_zzdacccode
   and t26.rn=1
  left join (select t.intnal_secu_acct_id
                   ,coalesce(tb.fin_instm_id,s.fin_instm_id) as i_code
                   ,coalesce(tb.asset_type_id,s.asset_type_id) as a_type
                   ,coalesce(tb.market_type_id,s.market_type_id) as m_type
                   ,te.s_combobox_01
                   ,t.plan_redem_dt as redeem_date
                   ,t.th_ssn_redem_flg as is_quarter_redeem
                   ,te.redem_datefield
                   ,row_number() over(partition by t.intnal_secu_acct_id,coalesce(tb.fin_instm_id,s.fin_instm_id),coalesce(tb.asset_type_id,s.asset_type_id),coalesce(tb.market_type_id,s.market_type_id) order by t.entr_dt desc) rn
               from ${iml_schema}.evt_ibank_tran t --ttrd_otc_trade t
               left join ${iol_schema}.ibms_ttrd_otc_trade_ext te
                 on te.sysordid = t.tran_num
               left join ${iml_schema}.prd_fin_instm s --ttrd_instrument s
                 on t.fin_instm_id = s.fin_instm_id
                and t.asset_type_id = s.asset_type_id
                and t.tran_market_id = s.market_type_id
                and s.create_dt<=to_date('${batch_date}','yyyymmdd')
                and s.id_mark <>'D'
                and s.job_cd ='ibmsf1'
               left join ${iml_schema}.prd_ibank_bond tb--tbnd tb
                 on tb.fin_instm_id = s.underly_fin_instm_id
                and tb.asset_type_id = s.un_asset_type_id
                and tb.market_type_id = s.underly_market_type_id
                and tb.create_dt<=to_date('${batch_date}','yyyymmdd')
                and tb.id_mark <>'D'
                and tb.job_cd ='ibmsf1'
              where t.tran_status_cd='4'
                and t.stl_status_cd = '999'
                and t.tran_type_id in ('0000000','0000001','0201100','0202100','0202101')
                and trim(te.s_combobox_01) is not null
                and t.stl_dt <= to_date('${batch_date}','yyyymmdd')
                and t.job_cd ='ibmsi1') t27
    on t27.intnal_secu_acct_id = t1.intnal_vch_acct_id
   and t27.i_code = t1.fin_instm_id
   and t27.a_type = t1.asset_type_id
   and t27.m_type = t1.market_type_id
   and t27.rn=1
  left join ${iml_schema}.agt_ibank_curr_cap_acct_bal_h t28
    on t1.intnal_vch_acct_id = t28.intnal_cap_acct_id
   and t1.ext_vch_acct_id = t28.ext_cap_acct_id
   and t28.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t28.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t28.job_cd = 'ibmsf1'
  left join ${iol_schema}.ibms_ttrd_equity t29
    on t1.fin_instm_id = t29.i_code
   and t1.asset_type_id = t29.a_type
   and t1.market_type_id = t29.m_type
   and t29.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t29.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_trpt_fund_position_record t30
    on t1.obj_id = t30.obj_id
   and to_date(t30.beg_date, 'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
   and to_date(t30.end_date, 'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
   and t30.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t30.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.cmm_ibank_secu_post isp
    on t1.obj_id = isp.obj_id
   and isp.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join ${icl_schema}.tmp_cmm_ibank_secu_post_02 t31
    on t31.trade_id=t1.tran_num
   and t31.typename=t7.cls_name
  left join ${iol_schema}.ibms_ttrd_acct_protocol_master t32  --新接表
    on t1.ext_vch_acct_id=t32.accid
    and replace(t32.start_date,'-','')<='${batch_date}'
    and replace(t32.expire_date,'-','')>'${batch_date}'
--	  and decode(t32.early_end_date,' ','20991231',replace(t32.early_end_date,'-',''))>'${batch_date}'
	  and t32.usable_flag <> '2'                                    -- 只取有效的数据
    and t32.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t32.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join (select t2.rx_bnd_ytm,a.i_code,a.a_type,a.m_type,a.secu_accid,
                     row_number() over(partition by a.i_code, a.a_type, a.m_type, a.secu_accid order by a.orddate desc) rm
               from ${iol_schema}.ibms_ttrd_otc_trade a
               left join ${iol_schema}.ibms_ttrd_otc_trade_ext t2
                 on a.sysordid = t2.sysordid
              where a.ordstatus = '-4'
                and a.trdtype = '0700080') t33
     on t33.secu_accid = t1.intnal_vch_acct_id
    and t33.i_code = t1.fin_instm_id
    and t33.a_type = t1.asset_type_id
    and t33.m_type = t1.market_type_id
    and t33.rm = 1
   left join(select t2.h_rate_07_f4,a.i_code,a.a_type,a.m_type,a.secu_accid,
                    row_number() over(partition by a.i_code, a.a_type, a.m_type, a.secu_accid order by a.orddate desc) rm
               from ${iol_schema}.ibms_ttrd_otc_trade a
               left join ${iol_schema}.ibms_ttrd_otc_trade_ext t2
                 on a.sysordid = t2.sysordid
              where a.ordstatus = '-4'
                and a.trdtype = '0706080') t34
     on t34.secu_accid = t1.intnal_vch_acct_id
    and t34.i_code = t1.fin_instm_id
    and t34.a_type = t1.asset_type_id
    and t34.m_type = t1.market_type_id
    and t34.rm = 1
  left join ${iml_schema}.prd_int_accr_dtl t35
    on t1.fin_instm_id = t35.fin_instm_id
   and t1.asset_type_id = t35.asset_type_id
   and t1.market_type_id = t35.market_type_id
   and t35.asset_type_id <> 'SPT_DED'
   and t35.int_accr_start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t35.int_accr_end_dt>to_date('${batch_date}', 'yyyymmdd')
   and t35.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t35.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t35.job_cd = 'ibmsf1'
  left join ${iol_schema}.ibms_ttrd_cross_border_rmb t36
    on t36.accid = t22.acct_id
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
--   and decode(t36.early_end_date,' ','20991231',replace(t36.early_end_date,'-',''))>'${batch_date}'
   and replace(t36.start_date,'-','')<='${batch_date}'
   and replace(t36.mtr_date,'-','')>'${batch_date}'
   and t36.is_delete<>'1'
  left join(select decode(a.trdtype,'0702150',t2.rx_bnd_ytm,'0702080',t2.h_rate_01) as ref_int_rat,a.i_code,a.a_type,a.m_type,a.secu_accid,
                    row_number() over(partition by a.i_code, a.a_type, a.m_type, a.secu_accid order by a.orddate desc) rm
               from ${iol_schema}.ibms_ttrd_otc_trade a
               left join ${iol_schema}.ibms_ttrd_otc_trade_ext t2
                 on a.sysordid = t2.sysordid
              where a.ordstatus = '-4'
                and a.trdtype in ('0702150','0702080')) t37
    on t37.secu_accid = t1.intnal_vch_acct_id
   and t37.i_code = t1.fin_instm_id
   and t37.a_type = t1.asset_type_id
   and t37.m_type = t1.market_type_id
   and t37.rm = 1
  left join ${iol_schema}.ibms_ttrd_credit_instrument_mapping t38
    on t1.fin_instm_id = t38.confirm_i_code
   and t1.asset_type_id = t38.confirm_a_type
   and t1.market_type_id = t38.confirm_m_type
   and t38.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t38.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ibank_secu_post_04 t39
    on t1.obj_id=t39.obj_id
  left join ${icl_schema}.tmp_cmm_ibank_secu_post_05 t40
    on t1.obj_id=t40.accti_obj_id
  left join (select inst_i_code,inst_a_type,inst_m_type,receive_ai
               from ${iol_schema}.ibms_ttrd_accounting_due_obj
              where start_dt <=to_date('${batch_date}', 'yyyymmdd')
                and end_dt >to_date('${batch_date}', 'yyyymmdd')
                and	to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and receive_ai <> 0
              union all
             select inst_i_code,inst_a_type,inst_m_type,receive_ai
               from ${iol_schema}.ibms_ttrd_accounting_due_obj_his
              where to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and receive_ai <> 0
             ) t41
    on t1.fin_instm_id = t41.inst_i_code
   and t1.asset_type_id = t41.inst_a_type
   and t1.market_type_id = t41.inst_m_type
  left join ${iol_schema}.ibms_ttrd_overdue_handle t45
    on t1.fin_instm_id = t45.i_code  
   and t1.asset_type_id = t45.a_type 
   and t1.market_type_id = t45.m_type
   and t45.statu = '2'
   and t45.is_si <> '1' 
 	 and t45.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t45.end_dt > to_date('${batch_date}','yyyymmdd')
 	left join ${icl_schema}.tmp_cmm_ibank_secu_post_06 t46
    on t1.fin_instm_id = t46.fin_instm_id  
   and t1.asset_type_id = t46.asset_type_id 
   and t1.market_type_id = t46.tran_market_id
   and t46.rn=1
  left join ${iol_schema}.ibms_ttrd_otc_trade_ext t47
  on t46.tran_num = t47.sysordid
 where 1=1
   and t4.prod_type_cd not in ('0121', '0300')
/*   and not exists (select 1
                     from ${icl_schema}.tmp_cmm_ibank_secu_post_02 tt
                    where t1.obj_id=tt.obj_id)*/
;

commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_secu_post exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_secu_post_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_secu_post_ex purge;
--drop table ${icl_schema}.tmp_cmm_ibank_secu_post_01 purge;
--drop table ${icl_schema}.tmp_cmm_ibank_secu_post_03 purge;
--drop table ${icl_schema}.tmp_cmm_ibank_secu_post_04 purge;
--drop table ${icl_schema}.tmp_cmm_ibank_secu_post_05 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_ibank_secu_post',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

