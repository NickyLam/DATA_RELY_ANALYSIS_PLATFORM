/*
Purpose:    共性加工层-同业净值型产品投资:包括所有同业系统净值型产品和债券基金的投资持仓信息、金融工具基础信息、底层资产信息等；数据来源于同业系统IBMS。
备注：TTRD_CASHLB还存在P_TYEP IN（‘0121’，‘0125’，'0134'，'0135'，‘0176’），可以通过审批单号关联对公贷款合同信息的合同编号获取信贷合同信息。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_ibank_nv_type_prod_invest
Createdate: 20191025
Logs:       20210813 陈伟峰 删除字段【五级分类代码level5_cls_cd、交易对手编号cntpty_id、交易对手名称cntpty_name、交易对手客户编号cntpty_cust_id、审批单号apv_odd_no、交易金额tran_amt】
            20210830 何桐金 调整PRD_IBANK_BOND_EVLTION算法，从全量快照，改成全量流水
            20210914 何桐金 调整PRD_IBANK_BOND_EVLTION算法，从全量流水，改成增量流水，C层同步更改
            20210922 陈伟峰 调整利息科目逻辑，增加表外科目
            20211020 陈伟峰 调整科目字段逻辑，当为空时取前一天科目数据
            20211206 陈伟峰 新增字段【认购日期】
            20211227 陈伟峰 新增字段【表内外标志代码、本金逾期标志、利息逾期标志】
                            调整字段【逾期标志、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】的取数口径
                            调整字段【底层实际融资人名称】的取数口径
            20221021 温旺清 1、增加字段【应收未收利息科目编号、授信金融工具编号、同业唯一标识编号】
                            2、调整字段【应计利息、应收利息、利息科目编号、公允价值变动】的加工口径
            20230602 陈伟峰 调整【资产唯一标识编号】加工逻辑，使用intnal_vch_acct_id 拼接
            20230612 陈伟峰 调整字段【应收利息】的加工口径
            20230707 徐子豪 调整字段【应收利息】的加工口径,增加receive_ai <> 0卡值条件。
            20231101 徐子豪 新增字段【管理人编号、管理人名称、托管人编号、托管人名称】
            20240717 陈伟峰 调整【应收利息】取数逻辑，去除应收未收利息
            20260227 陈  凭 调整【应收未收应计利息、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】加工逻辑
                            增加t23的过滤条件：t23.is_si <> '1'
			20260407 何俊良 临时表创建规则调整
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_nv_type_prod_invest drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_nv_type_prod_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_nv_type_prod_invest_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_02 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_03 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_04 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_05 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_06 purge;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_nv_type_prod_invest_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_nv_type_prod_invest where 0=1;

--2.2 insert into tmp table

create table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_01 as
select acctg_obj_id as obj_id,
       max(decode(gzb_type, '1', subj_code, '')) as subj_id1,
       max(decode(gzb_type, '1', subj_code, '9', subj_code, '')) as subj_id,
       max(decode(gzb_type, '3.1', subj_code, '')) as int_subj_id,
       max(decode(gzb_type, 'X', subj_code, '')) as int_subj_id2,
       max(decode(gzb_type, '2', subj_code, '')) as int_adj_subj_id,
       max(decode(gzb_type, '4.1', subj_code, '')) as evha_val_chag_subj_id,
       max(decode(gzb_type, '5.1.1', subj_code, '')) as acru_int_inco_subj_id,
       max(decode(gzb_type, '5.1.2', subj_code, '')) as amort_int_income_subj_id,
       max(decode(gzb_type, '5.3', subj_code, '')) as evha_val_chag_pl_subj_id,
       max(decode(gzb_type, '5.2.1', subj_code, '')) as spd_pl_subj_id,
       max(decode(gzb_type, '5.1.1', '22210202', '')) as acru_int_inco_subj_id_1,
       max(decode(gzb_type, '5.1.2', '22210203', '')) as amort_int_income_subj_id_1,
       max(decode(gzb_type, '5.2.1', '22210203', '')) as spd_pl_subj_id_1,
       max(decode(gzb_type, '3.2', subj_code, '')) as un_int_subj_id
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type
          from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg a
          left join ${iol_schema}.ibms_ttrd_accounting_entry_def b
            on a.subj_code = b.acting_code
           and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
         where a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
           and replace(a.beg_date, '-', '') = '${batch_date}') -- 20201027 翟若平 新增
 group by acctg_obj_id;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_04
nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by t.fin_instm_id, t.asset_type_id, t.market_type_id order by effect_dt desc) rn
          from iml.prd_ibank_bond_evltion t
         where effect_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
           and t.job_cd = 'ibmsi1'
       )
 where rn = 1
;
commit;

create table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_02
nologging
compress ${option_switch} for query high
as
select t9.i_code,
       t9.a_type,
       t9.m_type,
       substr(t9.u_i_code,1,instr(t9.u_i_code||'.','.')-1) as u_i_code,
       t9.u_i_name,
       t9.a_class,
       t9.amount,
       t9.parent_id,
       (case when substr(t9.u_i_code,instr(t9.u_i_code||'.','.')+1)= 'SZ' then 'XSHE' else 'XSHG' end) as u_m_type,
       t10.full_price_amt,
       t10.net_price_amt,
       t10.estim_coret_duran,
       t10.estim_cvty,
       t9.grade
  from ${iol_schema}.ibms_ttrd_und_asset t9
  left join ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_04 t10
  	on t10.fin_instm_id = substr(t9.u_i_code, 1, instr(t9.u_i_code || '.', '.') - 1)
   and (substr(t9.u_i_code, instr(t9.u_i_code || '.', '.') + 1) is null
    or decode(t10.market_type_id,'XSHG','SH','XSHE','SZ','X_CNBD','IB', t10.market_type_id) = substr(t9.u_i_code, instr(t9.u_i_code || '.', '.') + 1))
 where t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t9.und_status = '1' ;

commit;



create table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_03
nologging
compress ${option_switch} for query high
as
select i_code,
       a_type,
       m_type,
       sum(volume) as cp
  from (select a1.secu_acct_id,
             a1.i_code,
             a1.a_type,
             a1.m_type,
             a1.volume,
             a1.trade_grp_id
        from iol.ibms_ttrd_blc_secu_obj a1
        left join iol.ibms_ttrd_blc_secu_obj b
          on a1.p_obj_id = b.obj_id
         and replace(b.beg_date,'-','') = '${batch_date}'
        left join iol.ibms_ttrd_instrument c
          on b.i_code = c.i_code
         and b.a_type = c.a_type
         and b.m_type = c.m_type
         and c.start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and c.end_dt > to_date('${batch_date}', 'yyyymmdd')
       where a1.set_date = '1900-01-01'
         and a1.blc_type not in ('231', '232', '241', '242')
         and (c.p_type is null or c.p_type <> '2000')
         and replace(a1.beg_date,'-','') <= '${batch_date}') a
         group by a.i_code, a.a_type, a.m_type;
commit;

--手工记账利息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_05 as
 select tt1.subj_code, tt1.gzb_type,sum(tt1.value) as value,tt1.core_acct_name,tt1.trade_id,tt1.typename
   from (select t1.subj_id as subj_code,
                case when t2.charge_type_cd='3.1'  --3利息，3.1应计利息
                     then case when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应收利息%' then '3.2'
                               when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应计利息%' then '3.1'
                               end
                     else t2.charge_type_cd
                      end as gzb_type,
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
commit;



--公允价值变动核算差额
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_06 as
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


-- 第一组：同业非标投资（净值型产品）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_nv_type_prod_invest_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,ext_secu_acct_id                      --外部证券账户编号
    ,intnal_secu_acct_id                   --内部证券账户编号
    ,fin_instm_id                          --金融工具编号
    ,asset_type_id                         --资产类型编号
	  ,std_prod_id                           --标准产品编号
    ,market_type_id                        --市场类型编号
    ,bus_id                                --业务编号
    ,comb_tran_num                         --组合交易号
    ,obj_id								                 --对象编号
	  ,crdt_fin_instm_id                     --授信金融工具编号
	  ,asset_uniq_idf_id                     --资产唯一标识编号
    ,prod_type_cd                          --产品类型代码
    ,asset_type_name                       --资产类型名称
    ,class_crdt_flg                        --类信贷标志
    ,abs_flg                               --ABS标志
    ,acct_name                             --账户名称
    ,subj_id                               --科目编号
    ,int_subj_id					 	               --利息科目编号
	  ,recvbl_uncol_int_subj_id              --应收未收利息科目编号
    ,int_adj_subj_id			 		             --利息调整科目编号
    ,tran_market_id                        --交易市场编号
    ,exchg_acct_id                         --交易所账户编号
    ,cntpty_cls_descb                      --交易对手分类描述
    ,bank_flg                              --银行标志
    ,cty_cd                                --国家代码
    ,mger_id                               --管理人编号
    ,mger_name                             --管理人名称
    ,trustee_id                            --托管人编号
    ,trustee_name                          --托管人名称
    ,value_dt                              --起息日期
    ,exp_dt                                --到期日期
    ,subscr_dt                             --认购日期
    ,tenor_cd                              --期限代码
    ,int_accr_base_cd                      --计息基准代码
    ,int_rat_adj_way_cd                    --利率调整方式代码
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,fac_val_int_rat                       --票面利率
    ,pay_int_ped_cd                        --付息周期代码
    ,auto_redt_flg                         --自动转存标志
    ,actl_qtty							               --实际数量
    ,actl_bal                              --实际余额
    ,pric_bal                              --本金余额
    ,currt_bal                             --当期余额
    ,acru_int                              --应计利息
	  ,int_recvbl                            --应收利息
    ,recvbl_uncol_pric                     --应收未收本金
    ,recvbl_uncol_int                      --应收未收利息
    ,int_adj_amt						               --利息调整金额
    ,evha_val_chag						             --公允价值变动
    ,nv_prod_flg  						             --净值产品标志
    ,base_rat     						             --基准利率
    ,spd          						             --利差
    ,base_rat_mult						             --基准利率倍数
    ,td_nv        						             --当日净值
    ,book_bal     						             --账面余额
    ,curr_bal                              --当前余额
    ,last_update_dt                        --上次更新日期
    ,cap_type_cd                           --资金类型代码
    ,asset_four_cls_cd                     --资产四分类代码
    ,asset_thd_cls_cd					             --资产三分类代码
    ,belong_org_id                         --所属机构编号
    ,uder_asset_dir_indus_categy_cd        --底层资产投向行业门类代码
    ,uder_bond_cd               		       --底层债券代码
    ,uder_bond_name             		       --底层债券名称
    ,uder_bond_flg						             --底层债券标志
    ,uder_asset_type_id                    --底层资产类型编号
    ,uder_bond_rating                      --底层债券评级结果代码
    ,uder_actl_finer_name       		       --底层实际融资人名称
    ,uder_post_denom            		       --底层持仓面额
    ,uder_actl_finer_cust_id    		       --底层实际融资人客户编号
    ,uder_actl_finer_belong_group		 		   --底层实际融资人所属集团
    ,uder_actl_finer_cust_char   		       --底层实际融资人客户性质
	  ,uder_coll_way_cd                      --底层募集方式代码
    ,uder_cbond_estim_full_price		       --底层中债估价全价
    ,uder_cbond_estim_net_price 		       --底层中债估价净价
    ,uder_csecu_full_price_evltion         --底层中证全价估值
    ,uder_csecu_net_price_evltion          --底层中证净价估值
    ,uder_csecu_coret_duran                --底层中证修正久期
    ,uder_csecu_bp_val                     --底层中证基点价值
    ,uder_csecu_estim_cvty                 --底层中证估价凸性
    ,uder_estim_coret_duran                --底层估价修正久期
    ,uder_bp_val                           --底层基点价值
    ,uder_estim_cvty                       --底层估价凸性
    ,final_dir_type_cd	                   --最终投向类型代码
    ,final_dir_indus_gen	                 --最终投向行业_大类
    ,final_dir_indus_subclass	             --最终投向行业_细类
    ,dir_ind_fund_part	                   --投向产业基金的部分
    ,dir_debt_eqty_part	                   --投向债转股的部分
    ,dir_pe_part	                         --投向私募股权投资基金的部分
    ,dir_pam_prod_part	                   --投向私募资产管理产品的部分
    ,extra_dimen_cd	                       --额外维度代码
    ,stl_dt	                               --结算日期
    ,ovdue_status	                         --逾期状态
    ,in_out_tab_flg_cd                     --表内外标志代码
    ,ovdue_flg                             --逾期标志
    ,pric_ovdue_flg                        --本金逾期标志
    ,pric_ovdue_dt	                       --本金逾期日期
    ,pric_ovdue_days                       --本金逾期天数
    ,int_ovdue_flg                         --利息逾期标志
    ,int_ovdue_dt	                         --利息逾期日期
    ,int_ovdue_days	                       --利息逾期天数
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')    as etl_dt                    --数据日期
      ,'9999'                                 as lp_id                     --法人编号
      ,t1.ext_vch_acct_id                     as ext_secu_acct_id          --外部券账户编号
      ,t1.intnal_vch_acct_id                  as intnal_secu_acct_id       --内部券账户编号
      ,t1.fin_instm_id                        as fin_instm_id              --金融工具编号
      ,t1.asset_type_id                       as asset_type_id             --资产类型编号
	    ,t1.std_prod_id                         as std_prod_id               --标准产品编号
      ,t1.market_type_id                      as market_type_id            --市场类型编号
      ,t1.tran_num                            as bus_id                    --交易号
      ,t1.comb_tran_id                        as comb_tran_num             --组合交易号
      ,t1.obj_id							                as obj_id		                 --对象编号
      ,nvl(trim(t36.approve_i_code), t1.fin_instm_id)     as crdt_fin_instm_id          --授信金融工具编号
	    ,nvl(trim(t36.approve_i_code), t1.fin_instm_id) || '_' || t1.asset_thd_cls_cd || '_' || t1.intnal_vch_acct_id    as asset_uniq_idf_id          --资产唯一标识编号
      ,t4.prod_type_cd                        as prod_type_cd              --产品类型代码
      ,t4.prod_cls                            as asset_type_name           --资产类型名称
      ,(case when t4.prod_cls like '%类信贷%'
	           then '1' else '0' end)           as class_crdt_flg            --类信贷标志
      ,decode(t13.is_asset_base_securities, '1', '1', '0')  as abs_flg     --ABS标志
      ,t2.acct_name                           as acct_name                 --账户名称
      ,case when t4.prod_type_cd in ('0170') and t4.prod_cls = '票据资管计划（非保本）' and '${batch_date}' <= '20201231' then '15032201'
            when t14.subj_id1 is not null then t14.subj_id1
            else t21.subj_id end              as subj_id             		            --科目编号
      ,coalesce(trim(t14.int_subj_id),t14.int_subj_id2, t21.int_subj_id)     as int_subj_id  --利息科目编号
      ,nvl(trim(t14.un_int_subj_id),t21.int_subj_id)  as recvbl_uncol_int_subj_id       --应收未收利息科目编号
      ,nvl(trim(t14.int_subj_id),t21.int_adj_subj_id) as int_adj_subj_id  			        --利息调整科目编号
      ,t3.tran_market_id                      as tran_market_id             --交易市场编号
      ,t3.exchg_acct_id                       as exchg_acct_id              --交易所账户编号
      ,t4.cust_cls_name                       as cntpty_cls_descb           --客户分类名称
      ,case when substr(t4.cust_cls_name,1,2）= '银行'
	          then '1' else '0' end             as bank_flg                   --银行标志
      ,''                                     as cty_cd                     --国家代码
      ,t22.manager_id                         as mger_id                    --管理人编号
      ,t22.manager_value                      as mger_name                  --管理人名称
      ,t22.trustee_id                         as trustee_id                 --托管人编号
      ,t22.trustee                            as trustee_name               --托管人名称
      ,t4.value_dt                            as value_dt                   --起息日期
      ,t4.exp_dt                              as exp_dt                     --到期日期
      ,${iml_schema}.dateformat_min(t22.list_date)      as subscr_dt            --认购日期
      --,t4.tenor                               as tenor_cd                 --期限代码
      ,t4.src_tenor_cd                        as tenor_cd                   --期限代码 modify by fuxx 20191108 拼上期限单位作为期限代码
      ,t4.int_accr_base_cd                    as int_accr_base_cd           --计息基准代码
      ,t4.coupon_type_cd                      as int_rat_adj_way_cd         --利率调整方式代码 1－固定利率；2－浮动利率；3－零息票利率
      ,t4.curr_cd                             as curr_cd                    --币种代码
      ,t4.issue_denom                         as fac_val_amt                --单位面值
      ,t4.fac_val_int_rat                     as fac_val_int_rat            --票面利率
      ,t4.pay_int_ped_freq || t4.pay_int_ped_corp_cd  as pay_int_ped_cd     --付息周期代码
      ,''                                     as auto_redt_flg              --自动转存标志
      ,t1.actl_qtty 						              as actl_qtty					        --实际数量
      ,t1.actl_bal                            as actl_bal                   --实际余额
      ,t1.net_price_cost                      as pric_bal                   --净价成本
      ,t1.net_price_cost                      as currt_bal                  --当期余额

      ,case when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
                   case when t4.src_pay_int_ped_cd = '0D' then
                          case when t25.gzb_type = '3.1' then t1.acru_int + nvl(t25.value, 0)
                               else t1.acru_int
                           end
                        else 0
                    end
                 else 0
             end as acru_int                       -- 应计利息
       ,case when t4.prod_type_cd in ('0702','0703','0704','0705') then nvl(t27.receive_ai,0)
             when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
               case when t4.src_pay_int_ped_cd <>'0D' then
                      case when t25.gzb_type = '3.2' then t1.acru_int + nvl(t25.value, 0)
                           else t1.acru_int
                       end
                    else 0
                end
             else t1.acru_int  + nvl(t25.value, 0)
         end as int_recvbl                    -- 应收利息
      ,t1.recvbl_uncol_net_price_cost         as recvbl_uncol_pric          --应收未收净价成本
      ,case when t1.bal_type_cd ='1' then 0 
            else t1.recvbl_uncol_acru_int 
        end as recvbl_uncol_int              -- 应收未收应计利息
      ,t1.int_adj_amt						              as int_adj_amt				        --利息调整金额
      ,case when t25.gzb_type='4.1' then t1.evha_val_chag+t25.value+nvl(t26.chg_fv,0)
            else t1.evha_val_chag+nvl(t26.chg_fv,0) end         as evha_val_chag	            --公允价值变动
      ,'1'    								                as nv_prod_flg				        --净值产品标志
      ,t12.ad_fixingrate 					            as base_rat     			        --基准利率
      ,t12.ad_spread     					            as spd          			        --利差
      ,t12.ad_multiplier 					            as base_rat_mult			        --基准利率倍数
      ,t7.unit_nav							              as td_nv						          --当日净值
      ,t1.net_price_cost + t1.recvbl_uncol_net_price_cost + t1.int_adj_amt + decode(t4.src_pay_int_ped_cd, '0D', t1.recvbl_uncol_acru_int + t1.acru_int,0) + t1.evha_val_chag as book_bal --账面余额
	    ,t17.cp                                 as curr_bal                   --当前余额
      ,t1.last_update_dt                      as last_update_dt             --上次更新日期
      ,t2.cap_type_cd                         as cap_type_cd                --资金类型代码 0自有资产（自营业务）、1客户资产（代客、理财）
      ,t2.asset_four_cls_cd                   as asset_four_cls_cd          --资产四分类代码 1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
      ,t1.asset_thd_cls_cd  				          as asset_thd_cls_cd			      --资产三分类代码
      ,t2.belong_org_id                       as belong_org_id              --所属机构编号
      ,case when t13.business_category = '0' then '21'
            when t13.business_category = '1' then '6'
            when t13.business_category = '2' then '9'
            when t13.business_category = '3' then '7'
            when t13.business_category = '4' then '19'
            when t13.business_category = '5' then '1'
            when t13.business_category = '6' then '3'
            when t13.business_category = '7' then '17'
            when t13.business_category = '8' then '20'
            when t13.business_category = '9' then '15'
            when t13.business_category = '10' then '5'
            when t13.business_category = '11' then '11'
            when t13.business_category = '12' then '8'
            when t13.business_category = '13' then '16'
            when t13.business_category = '14' then '18'
            when t13.business_category = '15' then '14'
            when t13.business_category = '16' then '4'
            when t13.business_category = '17' then '13'
            when t13.business_category = '18' then '12'
            when t13.business_category = '19' then '2'
            when t13.business_category = '20' then '10'
            when t13.business_category = '21' then '-'
       else '-' end                           as uder_asset_dir_indus_categy_cd  --底层资产投向行业门类代码
      ,t9.u_i_code							              as uder_bond_cd  				           --底层债券代码
      ,t9.u_i_name						                as uder_bond_name				           --底层债券名称
      ,decode(t9.a_class, '3', '1', '6', '1', '0') as uder_bond_flg		           --底层债券标志
      ,t9.a_class as uder_asset_type_id                                          --底层资产类型编号
      ,t9.grade                               as uder_bond_rating                --底层债券评级结果代码
      ,coalesce(trim(t24.party_fname),t13.final_use_comp)      as uder_actl_finer_name 		       --底层实际融资人名称
      ,t9.amount							                as uder_post_denom			           --底层持仓面额
      ,t13.actual_financier_id				        as uder_actl_finer_cust_id	       --底层实际融资人客户编号
      ,t13.parent_group    					          as uder_actl_finer_belong_group 	 --底层实际融资人所属集团
      ,t13.financier_nature					          as uder_actl_finer_cust_char       --底层实际融资人客户性质
	    ,trim(t13.raise_way)                    as uder_coll_way_cd                --底层募集方式代码
      ,t9.full_price_amt 				              as uder_cbond_estim_full_price     --底层中债估价全价
      ,t9.net_price_amt  				              as uder_cbond_estim_net_price      --底层中债估价净价
      ,''                                     as uder_csecu_full_price_evltion   --底层中证全价估值
      ,''                                     as uder_csecu_net_price_evltion    --底层中证净价估值
      ,''                                     as uder_csecu_coret_duran          --底层中证修正久期
      ,''                                     as uder_csecu_bp_val               --底层中证基点价值
      ,''                                     as uder_csecu_estim_cvty           --底层中证估价凸性
      ,t9.estim_coret_duran                   as uder_estim_coret_duran          --底层估价修正久期
      ,t9.full_price_amt*t9.amount/100*t9.estim_coret_duran/10000 as uder_bp_val --底层基点价值
      ,t9.estim_cvty                          as uder_estim_cvty                 --底层估价凸性
      ,t13.investment_type                    as final_dir_type_cd	             --最终投向类型代码
      ,t13.business_category                  as final_dir_indus_gen	           --最终投向行业_大类
      ,t13.business_category_min              as final_dir_indus_subclass	       --最终投向行业_细类
      ,t13.invest_fund_part                   as dir_ind_fund_part	             --投向产业基金的部分
      ,t13.invest_market_part                 as dir_debt_eqty_part	             --投向债转股的部分
      ,t13.invest_finance_forcapitalpart      as dir_pe_part	                   --投向私募股权投资基金的部分
      ,t13.invest_finance_formanagepart       as dir_pam_prod_part	             --投向私募资产管理产品的部分
      ,t1.extra_dimen_cd	                    as extra_dimen_cd                  --额外维度代码
      ,t1.stl_dt	                            as stl_dt                          --结算日期
      ,t1.ext_dimen_info	                    as ovdue_status                    --逾期状态
      ,t23.transfer_table_type                as in_out_tab_flg_cd               --表内外标志代码
      ,case when (t23.is_ai_overdue = '1' or  t23.is_cp_overdue = '1')
            then '1' else '0' end             as ovdue_flg                       --逾期标志
      ,t23.is_cp_overdue                      as pric_ovdue_flg                  --本金逾期标志
      ,case when t23.is_cp_overdue = '1' then ${iml_schema}.dateformat_max(t23.beg_date_cp_overdue) else null end as pric_ovdue_dt   --本金逾期日期
      ,case when t23.is_cp_overdue = '1' then decode(${iml_schema}.dateformat_max2(t23.beg_date_cp_overdue),to_date('29991231', 'yyyymmdd'),'0',
                 to_date('${batch_date}', 'yyyymmdd')-${iml_schema}.dateformat_max(t23.beg_date_cp_overdue))
       else '0' end as pric_ovdue_days --本金逾期天数
      ,t23.is_ai_overdue                      as int_ovdue_flg                   --利息逾期标志
      ,case when t23.is_ai_overdue = '1' then ${iml_schema}.dateformat_max(t23.beg_date_ai_overdue)  else null end as int_ovdue_dt    --利息逾期日期
      ,case when t23.is_ai_overdue = '1' then decode(${iml_schema}.dateformat_max2(t23.beg_date_ai_overdue),to_date('29991231', 'yyyymmdd'),'0',
               to_date('${batch_date}', 'yyyymmdd')-${iml_schema}.dateformat_max(t23.beg_date_ai_overdue))
       else '0' end as int_ovdue_days  --利息逾期天数
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1  --证券账户核算余额历史
  left join ${iml_schema}.agt_intnal_secu_acct t2 --内部证券账户
    on t1.intnal_vch_acct_id = t2.acct_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_ext_secu_acct t3 --外部证券账户
    on t1.ext_vch_acct_id = t3.acct_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
 inner join ${iml_schema}.prd_fin_instm t4 --金融工具表
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.id_mark <> 'D'
  left join ${iml_schema}.evt_ibank_tran t6 --同业交易表
    on t1.tran_num = t6.intnal_tran_num
   --and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsi1'
  left join (select en.i_code, en.a_type, en.m_type, en.beg_date, en.end_date, en.unit_nav
 						   from ${iol_schema}.ibms_ttrd_equity_nav en
 						  where to_date(en.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
 						    and to_date(en.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
 						    and en.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 						    and en.end_dt > to_date('${batch_date}', 'yyyymmdd')
						 	union
 						 select tn.i_code, tn.a_type, tn.m_type, tn.beg_date, tn.end_date, tn.f_unitnav as unit_nav
 						   from ${iol_schema}.ibms_tfnd_nav tn
 						  where to_date(tn.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
 						    and to_date(tn.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
 						    and tn.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 						    and tn.end_dt > to_date('${batch_date}', 'yyyymmdd')) t7
 		on t1.fin_instm_id   = t7.i_code
 	 and t1.asset_type_id  = t7.a_type
 	 and t1.market_type_id = t7.m_type
 	left join ${iml_schema}.ref_ibank_acctnt_type_cd t8
 		on t8.cls_id = t2.acctnt_cls_cd
 	 and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'ibmsf1'
   and t8.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_02 t9
  	on t1.fin_instm_id   = t9.i_code
   and t1.asset_type_id  = t9.a_type
   and t1.market_type_id = t9.m_type
  left join ${iml_schema}.pty_ibank_cntpty_info t11
  	on t11.src_party_id = t9.parent_id
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.job_cd = 'ibmsf1'
   and t11.id_mark <> 'D'
  left join (select a.i_code,a.a_type,a.m_type,a.ad_fixingrate,a.ad_spread,a.ad_multiplier
               from ${iol_schema}.ibms_tbsi_accrualdetail a
               left join  ${iol_schema}.ibms_ttrd_acc_cash_ext_map t
            	   on a.stream_id = t.cash_accid
              where t.cash_ext_accid = '3080'
                and to_char(to_date(a.ad_startdate,'yyyy-mm-dd'),'yyyymmdd') <= '${batch_date}'
                and to_char(to_date(a.ad_enddate,'yyyy-mm-dd'),'yyyymmdd') > '${batch_date}'
                and a.start_dt <= to_date('${batch_date}','yyyymmdd')
 	              and a.end_dt > to_date('${batch_date}','yyyymmdd')
             ) t12
  	on t1.fin_instm_id   = t12.i_code
   and t1.asset_type_id  = t12.a_type
   and t1.market_type_id = t12.m_type
 	left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele t13
 	  on t1.fin_instm_id   = t13.i_code
 	 and t1.asset_type_id  = t13.a_type
 	 and t1.market_type_id = t13.m_type
 	 and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	left join ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_01 t14
 	  on t1.obj_id = t14.obj_id
	left join ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_03 t17
	  on t1.fin_instm_id   = t17.i_code
	 and t1.asset_type_id  = t17.a_type
	 and t1.market_type_id = t17.m_type
  left join ${icl_schema}.cmm_ibank_nv_type_prod_invest t21
    on t1.obj_id = t21.obj_id
   and t21.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join ${iol_schema}.ibms_ttrd_equity t22
	  on t1.fin_instm_id   = t22.i_code
	 and t1.asset_type_id  = t22.a_type
	 and t1.market_type_id = t22.m_type
	 and t22.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t22.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_overdue_handle t23
    on t1.fin_instm_id = t23.i_code
   and t1.asset_type_id = t23.a_type
   and t1.market_type_id = t23.m_type
   and t23.statu = '2'
   AND t23.is_si <> '1'
 	 and t23.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t23.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.pty_ibank_cntpty_info t24  --${iol_schema}.ibms_ttrd_institution t24
    on t13.final_use_comp = t24.src_party_id
   and t24.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t24.job_cd = 'ibmsf1'
   and t24.id_mark<>'D'
  left join ${iol_schema}.ibms_ttrd_credit_instrument_mapping t36
    on t1.fin_instm_id = t36.confirm_i_code
   and t1.asset_type_id = t36.confirm_a_type
   and t1.market_type_id = t36.confirm_m_type
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_05 t25
    on t25.trade_id=t1.tran_num
   and t25.typename=t8.cls_name
  left join ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_06 t26
    on t1.obj_id =t26.accti_obj_id
  left join (select inst_i_code,inst_a_type,inst_m_type,receive_ai
               from ${iol_schema}.ibms_ttrd_accounting_due_obj
              where start_dt <=to_date('${batch_date}', 'yyyymmdd')
                and end_dt >to_date('${batch_date}', 'yyyymmdd')
                and to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and receive_ai <> 0
              union all
             select inst_i_code,inst_a_type,inst_m_type,receive_ai
               from ${iol_schema}.ibms_ttrd_accounting_due_obj_his
              where to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and receive_ai <> 0
             ) t27
    on t1.fin_instm_id = t27.inst_i_code
   and t1.asset_type_id = t27.inst_a_type
   and t1.market_type_id = t27.inst_m_type
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
   and (t4.prod_type_cd = '0700' or t4.prod_cls = '债券基金')
   and to_date('${batch_date}', 'yyyymmdd') >=to_date('20210910', 'yyyymmdd')   --限制投产前后数据出入
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_nv_type_prod_invest exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_nv_type_prod_invest_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_nv_type_prod_invest_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_02 purge;
drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_03 purge;
--drop table ${icl_schema}.tmp_cmm_ibank_nv_type_prod_invest_06 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_nv_type_prod_invest', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);