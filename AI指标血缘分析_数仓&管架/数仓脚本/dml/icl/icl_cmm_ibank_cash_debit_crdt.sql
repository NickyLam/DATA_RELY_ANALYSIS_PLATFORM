/*
Purpose:    共性加工层-同业现金借贷表:数据来源于同业系统（IBMS）,包括所有同业账户持有的存放同业（定期、活期）、同业借款、同业存放定期、同兴赢(定期)
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20201231 icl_cmm_ibank_cash_debit_crdt
Createdate: 20191025
Logs:
            20191220 翟若平 调整付息周期代码的取数逻辑pay_int_ped_corp_cd -> pay_int_ped_freq || pay_int_ped_corp_cd
						20200424 周沁晖 1、调整资产四分类代码 acctnt_cls_cd ——> asset_four_cls_cd
						20200724 陈伟峰 增加标准产品编号字段
						20200828 周沁晖 增加字段【交易金额、对象编号、利息科目编号、利息调整科目编号、资产三分类代码】
														调整字段【科目编号】取数口径
						20201017 陈伟峰 修改资产三分类取数源表
						20201021 陈伟峰 修改利息科目、利息调整科目取值字段
						20201027 翟若平 调整tmp_cmm_ibank_secu_post_01过滤条件
						20210122 周沁晖 增加字段【当期余额】
						20210429 陈伟峰 1、主键字段【数据日期、法人编号、外部证券账户编号、内部证券账户编号、金融工具编号、市场类型编号、业务编号】调整为【数据日期、法人编号、外部证券账户编号、内部证券账户编号、金融工具编号、资产类型编号、市场类型编号、业务编号、组合交易号、逾期状态、额外维度代码、结算日期】
                            2、新增字段【组合交易号、额外维度代码、结算日期、逾期状态、本金逾期日期、贷款贷款贷款本金逾期天数、利息逾期日期、利息逾期天数】
            20210508 何桐金 增加字段【逾期标志】
            20210527 何桐金 更改字段【期限代码】取数逻辑
            20210612 陈伟峰 增加字段【交易对手标识编码、交易对手标识编码类型代码、基准利率类型代码、利率调整频率代码、基准利率、执行利率】
                            调整T7表的关联条件（T6.PARTYID = T7.I_ID  -》NVL(T6.PARTYID, T8.PARTY_ID) = T7.I_ID ），调整脚本中把T7和T8表的关联顺序。
            20210621 陈伟峰 增加字段【账户编号、账户性质描述、账户属性描述、兑付日期、实际融资人客户编号、实际融资人名称、实际融资人集团名称】
            20210626 陈伟峰 增加字段【交易对手客户编号、质押券编号、质押券资产类型编号、质押券市场类型编号、质押券面额、质押券折价率、质押券占比】、调整字段【票面利率】的取数口径
            20210702 陈伟峰 增加字段【交易类型代码】
            20210922 陈伟峰 调整利息科目逻辑，增加表外科目
            20211020 陈伟峰 调整科目字段逻辑，当为空时取前一天科目数据
            20211130 陈伟峰 增加字段【交易序号】
            20211204 陈伟峰 调整【当期余额】加工逻辑
            20220308 陈伟峰 调整字段【基准利率、执行利率】加工逻辑 --口径提供：徐鹏程，同业报表核算余额
            20221020 温旺清 1、增加字段【应收未收利息科目编号、授信金融工具编号、资产唯一标识编号、应收利息】
                            2、调整字段【应计利息、利息科目编号】的加工口径
            20230531 陈伟峰 调整字段【付息周期代码】加工逻辑，取pay_int_ped_corp_cd，M层以做加工整合
            20230602 陈伟峰 调整【资产唯一标识编号】加工逻辑，使用intnal_vch_acct_id 拼接
            20230612 陈伟峰 调整字段【应收利息】的加工口径
            20230707 徐子豪 调整字段【应收利息】的加工口径,增加receive_ai <> 0卡值条件。
            20230816 陈伟峰 新增字段【转贷款标志】
            20230830 徐子豪 调整字段【逾期标志、本金逾期日期、贷款贷款贷款本金逾期天数、利息逾期日期、利息逾期天数】的加工口径
            20240717 陈伟峰 调整【应收利息】取数逻辑，去除应收未收利息
            20250110 谢宁 修改【执行利率】
            20260227 陈  凭 调整【应收未收应计利息、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】加工逻辑
                            增加t38的过滤条件：t38.is_si <> '1'
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_cash_debit_crdt drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_cash_debit_crdt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_cash_debit_crdt_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_02 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_cash_debit_crdt_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_cash_debit_crdt where 0=1;


--2.2 insert into tmp table
--本金科目信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_01 as 			
select acctg_obj_id as obj_id,
       max(decode(gzb_type, '1', subj_code, '')) as subj_id1,
       max(decode(gzb_type, '1', subj_code, '9', subj_code, '')) as subj_id,
       max(decode(gzb_type, '3.1', subj_code, '')) as int_subj_id,
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

--手工记账利息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_02 as 		
  select tt1.subj_code, tt1.gzb_type,sum(tt1.value) as value,tt1.core_acct_name,tt1.trade_id,tt1.typename
   from (select t1.subj_id as subj_code,
                case when t2.charge_type_cd='3.1' 
                     then case when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应收利息%' then '3.2'
                               when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应计利息%' then '3.1'
                               end
                     else t2.charge_type_cd end as gzb_type,
                case when t1.debit_crdt_dir_cd = 'D' then t1.entry_amt  --落标 借
                     when t1.debit_crdt_dir_cd = 'C' then -1 * t1.entry_amt  --贷
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
          where t.entry_status_cd = '03' --记账成功
            and t2.charge_type_cd in ('2','3.1','4.1') 
            and t.entry_type_cd<>'03' -- 仅同业系统记账
            and trim(t.tran_id) is not null
            and t.entry_dt <= to_date('${batch_date}', 'yyyymmdd')
            and t.job_cd ='ibmsi1'
      ) tt1
 group by tt1.subj_code, tt1.trade_id, tt1.gzb_type,tt1.typename,tt1.core_acct_name;
						
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_cash_debit_crdt_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,ext_secu_acct_id                      --外部证券账户编号
    ,intnal_secu_acct_id                   --内部证券账户编号
    ,acct_id                               --账户编号
    ,fin_instm_id                          --金融工具编号
    ,asset_type_id                         --资产类型编号
	  ,std_prod_id                           --标准产品编号
    ,market_type_id                        --市场类型编号
    ,bus_id                                --业务编号
    ,comb_tran_num                         --组合交易号
    ,tran_seq_num                          --交易序号
    ,obj_id                                --对象编号
    ,prod_type_cd                          --产品类型代码
    ,asset_type_name                       --资产类型名称
    ,level5_cls_cd                         --五级分类代码
    ,acct_name                             --账户名称
    ,subj_id                               --科目编号
    ,int_subj_id    											 --利息科目编号 
    ,recvbl_uncol_int_subj_id	             --应收未收利息科目编号
    ,int_adj_subj_id											 --利息调整科目编号
    ,tran_market_id                        --交易市场编号
    ,exchg_acct_id                         --交易所账户编号
    ,cntpty_cust_id                        --交易对手客户编号
    ,cntpty_id                             --交易对手编号
    ,cntpty_name                           --交易对手名称
    ,cntpty_acct_num                       --交易对手账号
    ,cntpty_acct_name                      --交易对手账户名称
    ,cntpty_open_bank_num                  --交易对手开户行号
    ,cntpty_open_bank_name                 --交易对手开户行名称
    ,cntpty_cls_descb                      --交易对手分类描述
    ,cntpty_idf_code	                     --交易对手标识编码
    ,cntpty_idf_code_type_cd	             --交易对手标识编码类型代码
    ,tran_type_cd                          --交易类型代码
    ,bank_flg                              --银行标志
    ,cty_cd                                --国家代码
    ,value_dt                              --起息日期
    ,exp_dt                                --到期日期
    ,cash_dt                               --兑付日期
    ,tenor_cd                              --期限代码
    ,int_accr_base_cd                      --计息基准代码
    ,int_rat_adj_way_cd                    --利率调整方式代码
    ,base_rat_type_cd	                     --基准利率类型代码
    ,int_rat_adj_freq_cd	                 --利率调整频率代码
    ,apv_odd_no                            --审批单号
	  ,crdt_fin_instm_id                     --授信金融工具编号
	  ,asset_uniq_idf_id                     --资产唯一标识编号
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,fac_val_int_rat                       --票面利率
    ,base_rat	                             --基准利率
    ,exec_int_rat	                         --执行利率
    ,pay_int_ped_cd                        --付息周期代码
    ,auto_redt_flg                         --自动转存标志
    ,trans_loan_flag                       --转贷款标志
    ,actl_bal                              --实际余额
    ,pric_bal                              --本金余额
    ,currt_bal                             --当期余额
    ,acru_int                              --应计利息
	  ,int_recvbl                            --应收利息
    ,recvbl_uncol_pric                     --应收未收本金
    ,recvbl_uncol_int                      --应收未收利息
    ,last_update_dt                        --上次更新日期
    ,cap_type_cd                           --资金类型代码
    ,asset_four_cls_cd                     --资产四分类代码
    ,asset_thd_cls_cd											 --资产三分类代码
    ,belong_org_id                         --所属机构编号
    ,tran_amt															 --交易金额
    ,extra_dimen_cd	                       --额外维度代码
    ,stl_dt	                               --结算日期
    ,ovdue_status	                         --逾期状态
    ,ovdue_flg                             --逾期标志
    ,pric_ovdue_dt	                       --本金逾期日期
    ,pric_ovdue_days                       --贷款贷款贷款本金逾期天数
    ,int_ovdue_dt	                         --利息逾期日期
    ,int_ovdue_days	                       --利息逾期天数
    ,acct_char_descb	                     --账户性质描述
    ,acct_attr_descb	                     --账户属性描述
    ,actl_finer_cust_id	                   --实际融资人客户编号
    ,actl_finer_name	                     --实际融资人名称
    ,actl_finer_group_name	               --实际融资人集团名称
    ,inpwn_vch_id	                         --质押券编号
    ,inpwn_vch_asset_type_id	             --质押券资产类型编号
    ,inpwn_vch_market_type_id	             --质押券市场类型编号
    ,inpwn_cert_face_lmt	                 --质押券面额
    ,inpwn_vch_discnt_rat	                 --质押券折价率
    ,inpwn_vch_pct	                       --质押券占比
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')    as etl_dt                     --数据日期
      ,'9999'                                 as lp_id                      --法人编号
      ,t1.ext_vch_acct_id                     as ext_secu_acct_id           --外部券账户编号
      ,t1.intnal_vch_acct_id                  as intnal_secu_acct_id        --内部券账户编号
      ,t14.acct_code                          as acct_id                    --账户编号
      ,t1.fin_instm_id                        as fin_instm_id               --金融工具编号
      ,t1.asset_type_id                       as asset_type_id              --资产类型编号
	  	,t1.std_prod_id                         as std_prod_id                --标准产品编号
      ,t1.market_type_id                      as market_type_id             --市场类型编号
      ,t1.tran_num                            as bus_id                     --交易号
      ,t1.comb_tran_id                        as comb_tran_num              --组合交易号
      ,t6.tran_num                            as tran_seq_num               --交易序号
      ,t1.obj_id															as obj_id 										--对象编号
      ,t4.prod_type_cd                        as prod_type_cd               --产品类型代码
      ,t4.asset_type_name                     as asset_type_name            --资产类型名称
      ,t6.level5_cls_cd                       as level5_cls_cd              --五级分类代码
      ,t3.acct_name                           as acct_name                  --账户名称
      ,nvl(t7.subj_id1,t19.subj_id)           as subj_id             				--科目编号
      /*      nvl(t7.subj_id1, (
       case when t4.prod_type_cd = '0121'  --'存放同业定期'
            then '101101020201' --存放境内银行同业一般款项
            when t4.prod_type_cd = '0125' and substr(t5.cust_cls_name,1,2) ='银行' --同业借款借出
            then '13020301' --借出银行机构
            when t4.prod_type_cd = '0125' and substr(t5.cust_cls_name,1,2) ='非银' --同业借款借出
            then '13020302' --借出非银行机构
        end))                                 as subj_id             				--科目编号  */
      ,nvl(trim(t7.int_subj_id),t19.int_subj_id) as int_subj_id    		    --利息科目编号
      ,nvl(trim(t7.un_int_subj_id),t19.int_subj_id)      as recvbl_uncol_int_subj_id	  --应收未收利息科目编号	  
      ,nvl(t7.int_adj_subj_id,t19.int_adj_subj_id) 	as int_adj_subj_id	--利息调整科目编号
      ,t3.tran_market_id                      as tran_market_id             --交易市场编号
      ,t3.exchg_acct_id                       as exchg_acct_id              --交易所账户编号
      ,t12.cust_id                            as cntpty_cust_id             --交易对手客户编号
      ,t6.cntpty_id                           as cntpty_id                  --交易对手编号
      ,t6.cntpty_name                         as cntpty_name                --交易对手名称
      ,t6.cntpty_acct_num                     as cntpty_acct_num            --交易对手账号
      ,t6.cntpty_acct_name                    as cntpty_acct_name           --交易对手账户名称
      ,t6.cntpty_open_bank_num                as cntpty_open_bank_num       --交易对手开户行号
      ,t6.cntpty_open_bank_name               as cntpty_open_bank_name      --交易对手开户行名称
      ,t5.cust_cls_name                       as cntpty_cls_descb           --客户分类名称
      ,t13.rh_code                            as cntpty_idf_code	          --交易对手标识编码
      ,t13.rh_codetype                        as cntpty_idf_code_type_cd	  --交易对手标识编码类型代码
      ,t6.tran_type_id                        as tran_type_cd               --交易类型代码
      ,case when substr(t5.cust_cls_name,1,2) = '银行' 
            then '1' else '0' end             as bank_flg                   --银行标志
      ,t4.cty_cd                              as cty_cd                     --国家代码
      ,t4.value_dt                            as value_dt                   --起息日期
      ,t4.exp_dt                              as exp_dt                     --到期日期
      ,t4.cash_dt                             as cash_dt                    --兑付日期
      --,t4.tenor                               as tenor_cd                 --期限代码
      --,t4.tenor||'D'                          as tenor_cd                   --期限代码 modify by fuxx 20191108 拼上期限单位作为期限代码
      ,t4.src_tenor_cd                        as tenor_cd                   --期限代码
      ,t4.int_accr_base_cd                    as int_accr_base_cd           --计息基准代码
      ,t4.int_rat_adj_way_cd                  as int_rat_adj_way_cd         --利率调整方式代码 1－固定利率；2－浮动利率；3－零息票利率
      ,t4.base_fin_instm_id	                  as base_rat_type_cd	          --基准利率类型代码
      ,t4.src_int_rat_adj_ped_cd              as int_rat_adj_freq_cd	      --利率调整频率代码
      ,t6.apv_odd_no                          as apv_odd_no                 --审批单号
	    ,nvl(trim(t36.approve_i_code), t1.fin_instm_id)     as crdt_fin_instm_id          --授信金融工具编号
	    ,nvl(trim(t36.approve_i_code), t1.fin_instm_id) || '_' || t1.asset_thd_cls_cd || '_' || t1.intnal_vch_acct_id    as asset_uniq_idf_id          --资产唯一标识编号
      ,t4.curr_cd                             as curr_cd                    --币种代码
      ,t4.corp_fac_val                        as fac_val_amt                --单位面值
      ,decode(t5.coupon_type_cd, '1', t5.fac_val_int_rat, '2', (t11.close_quot_price* 100) + t4.fac_val_int_rat) 
                                              as fac_val_int_rat            --票面利率
      ,decode(t5.coupon_type_cd, '2', t11.close_quot_price * 100,'0')                as base_rat	      --基准利率
      ,nvl(decode(t20.actl_int_rat,'0'，'',t20.actl_int_rat), t5.fac_val_int_rat)    as exec_int_rat	  --执行利率
      ,t4.pay_int_ped_corp_cd as pay_int_ped_cd      --付息周期代码
      ,t4.auto_redt_flg                       as auto_redt_flg              --自动转存标志
      ,t4.trans_loan_flg                      as trans_loan_flag            --转贷款标志
      ,t1.actl_bal                            as actl_bal                   --实际余额
      ,t1.net_price_cost                      as pric_bal                   --净价成本
      ,case when t4.prod_type_cd <> '0170' then t1.actl_bal + t1.recvbl_uncol_bal
             when t4.prod_type_cd = '0170' then t1.net_price_cost + t1.recvbl_uncol_net_price_cost
             when (t5.prod_type_cd = '0700' or t5.prod_cls = '债券基金') then t1.net_price_cost + t1.recvbl_uncol_net_price_cost
             when t5.prod_type_cd in ('1100', '0000') and t5.prod_cls <> '同业存单' then t1.net_price_cost + t1.recvbl_uncol_net_price_cost
             else t1.net_price_cost + t1.recvbl_uncol_net_price_cost
             end                              as currt_bal                  --当期余额 
       ,case when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
               case when t4.src_pay_int_ped_cd = '0D' then 
                      case when t31.gzb_type = '3.1' then t1.acru_int + nvl(t31.value, 0)
                           else t1.acru_int 
                       end
                    else 0 
                end
             else 0
         end as acru_int                       -- 应计利息
       ,case when t4.prod_type_cd in ('0702','0703','0704','0705') then nvl(t37.receive_ai,0)
             when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
               case when t4.src_pay_int_ped_cd <>'0D' then 
                      case when t31.gzb_type = '3.2' then t1.acru_int + nvl(t31.value, 0)
                           else t1.acru_int 
                       end
                    else 0 
                end
             else t1.acru_int  + nvl(t31.value, 0)
         end as int_recvbl                    -- 应收利息	 		 
      ,t1.recvbl_uncol_net_price_cost         as recvbl_uncol_pric          --应收未收净价成本
      ,case when t1.bal_type_cd = '1' then 0 
            else t1.recvbl_uncol_acru_int 
        end as recvbl_uncol_int           --应收未收应计利息
      ,t1.last_update_dt                      as last_update_dt             --上次更新日期
      ,t2.cap_type_cd                         as cap_type_cd                --资金类型代码 0自有资产（自营业务）、1客户资产（代客、理财）
      ,t2.asset_four_cls_cd                   as asset_four_cls_cd          --资产四分类代码 1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
      ,t1.asset_thd_cls_cd  									as asset_thd_cls_cd						--资产三分类代码
      ,t2.belong_org_id                       as belong_org_id              --所属机构编号
      ,t6.tran_amt														as tran_amt 							 		--交易金额
      ,t1.extra_dimen_cd	                    as extra_dimen_cd             --额外维度代码
      ,t1.stl_dt	                            as stl_dt                     --结算日期
      ,t1.ext_dimen_info	                    as ovdue_status               --逾期状态
      ,case when t38.is_ai_overdue = '1' or t38.is_cp_overdue = '1' then '1' else '0' end  as ovdue_flg   --逾期标志
      ,case when t38.is_cp_overdue = '1' then ${iml_schema}.dateformat_max(t38.beg_date_cp_overdue) else null end	            as pric_ovdue_dt  --本金逾期日期
      ,case when t38.is_cp_overdue = '1' then  decode(${iml_schema}.dateformat_max2(t38.beg_date_cp_overdue),to_date('29991231', 'yyyymmdd'),'0',
        to_date('${batch_date}', 'yyyymmdd') - ${iml_schema}.dateformat_max(t38.beg_date_cp_overdue))  else '0' end             as pric_ovdue_days --本金逾期天数
      ,case when t38.is_ai_overdue = '1' then ${iml_schema}.dateformat_max(t38.beg_date_ai_overdue) else null end               as int_ovdue_dt    --利息逾期日期
      ,case when t38.is_ai_overdue = '1' then decode(${iml_schema}.dateformat_max2(t38.beg_date_ai_overdue),to_date('29991231', 'yyyymmdd'),'0',
        to_date('${batch_date}', 'yyyymmdd') - ${iml_schema}.dateformat_max(t38.beg_date_ai_overdue)) else '0' end              as int_ovdue_days   --利息逾期天数
      ,t15.acct_char_descb                    as acct_char_descb            --账户性质描述
      ,t15.acct_attr_descb                    as acct_attr_descb            --账户属性描述
      ,coalesce(trim(t39.cust_id),trim(t16.actl_finer_cust_id), trim(t17.actual_financier_id), t12.cust_id) as actl_finer_cust_id --实际融资人客户编号
      ,t40.corp_name                          as actl_finer_name            --实际融资人名称
      ,substr(t12.party_cls_descb, instr(t12.party_cls_descb, '.', '-1') + 1) as actl_finer_group_name           --实际融资人集团名称
      ,t18.p_i_code                           as inpwn_vch_id	              --质押券编号
      ,t18.p_a_type                           as inpwn_vch_asset_type_id	  --质押券资产类型编号
      ,t18.p_m_type                           as inpwn_vch_market_type_id	  --质押券市场类型编号
      ,t18.amount                             as inpwn_cert_face_lmt	      --质押券面额
      ,t18.discount                           as inpwn_vch_discnt_rat	      --质押券折价率
      ,t18.rate * 100                         as inpwn_vch_pct	            --质押券占比
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
 inner join ${iml_schema}.prd_ibank_cap_ld_fin_instm t4 --同业资金借贷金融工具
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   --and t4.asset_type_name in ('同业借款借出','存放同业定期','存放同业活期')
   --and t4.asset_type_name in ('同业借款借出','存放同业定期','存放同业活期','同业存放定期','同兴赢(定期)') --t4.prod_type_cd in ('0125','0121','','0134','0135')
   and t4.prod_type_cd <> '0170'
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.id_mark <> 'D'
  left join ${iml_schema}.prd_fin_instm t5 --金融工具表
    on t1.fin_instm_id = t5.fin_instm_id
   and t1.asset_type_id = t5.asset_type_id
   and t1.market_type_id = t5.market_type_id
   and t5.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'ibmsf1'
   and t5.id_mark <> 'D'
  left join ${iml_schema}.evt_ibank_tran t6 --同业交易表
    on t1.tran_num = t6.intnal_tran_num
   --and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsi1'
  left join ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_01 t7
  	on t1.obj_id = t7.obj_id
   left join ${iml_schema}.ref_ibank_acctnt_type_cd t8
  	on t8.cls_id = t2.acctnt_cls_cd
   and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'ibmsf1'
   and t8.id_mark <> 'D'
  left join ${iml_schema}.prd_fin_instm_int_rat_makt t11   --ibms_tir_series
    on t4.base_fin_instm_id = t11.fin_instm_id 
   and t4.base_asset_type_id = t11.asset_type_id 
   and t4.base_market_type_id = t11.market_type_id 
   and t1.start_dt >= t11.effect_dt 
   and t1.start_dt < t11.invalid_dt
   and t11.job_cd='ibmsf1'
   and t11.create_dt<= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark<>'D'
  left join ${iml_schema}.pty_ibank_cntpty_info t12
    on nvl(t6.cntpty_id, t5.issue_org_id) = t12.src_party_id 
   and t12.create_dt<= to_date('${batch_date}', 'yyyymmdd')
   and t12.job_cd ='ibmsf1'
   and t12.id_mark<>'D'
  left join ${iol_schema}.ibms_ttrd_institution_ext t13
    on t12.src_party_id = t13.i_id
   and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_fixedterm_account t14	
    on t14.acct_id=t4.acct_id
   and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_ext_cap_acct t15	
   on t15.acct_id=t6.ext_cap_acct_id
  and t15.create_dt<= to_date('${batch_date}', 'yyyymmdd')
  and t15.job_cd ='ibmsf1'
  and t15.id_mark<>'D'
  left join ${iml_schema}.prd_fin_instm_mgmt_elmnt_h t16
  	on t1.fin_instm_id = t16.fin_instm_id 
 	 and t1.asset_type_id = t16.asset_type_id 
   and t1.market_type_id = t16.market_type_id
   and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t16.job_cd ='ibmsf1'
  left join ${iol_schema}.ibms_ttrd_finance_body t17	
    on t1.fin_instm_id = t17.i_code 
   and t1.asset_type_id = t17.a_type 
   and t1.market_type_id = t17.m_type
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select i_code,
                    a_type,
                    m_type,
                    p.p_i_code,
                    p.p_a_type,
                    p.p_m_type,
                    p.amount as amount,
                    p.discount,
                    disamount / sum(disamount) over(partition by p.i_code, p.a_type, p.m_type) as rate
               from ${iol_schema}.ibms_ttrd_pledgebond p
             union all
             select i_code,
                    a_type,
                    m_type,
                    u_i_code as p_i_code,
                    u_a_type as p_a_type,
                    u_m_type as p_m_type,
                    u.amount * 10000 as amount,
                    1 as discount,
                    1 as rate
               from ${iol_schema}.ibms_ttrd_outright_extend u
               where u.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and u.end_dt > to_date('${batch_date}', 'yyyymmdd')) t18
   on t1.fin_instm_id = t18.i_code 
   and t1.asset_type_id = t18.a_type 
   and t1.market_type_id = t18.m_type
  left join ${icl_schema}.cmm_ibank_cash_debit_crdt t19
    on t1.obj_id = t19.obj_id
   and t19.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join (select t20.fin_instm_id
                    ,t20.asset_type_id
                    ,t20.market_type_id
                    ,t20.actl_int_rat
                    ,row_number() over(partition by t20.fin_instm_id,t20.asset_type_id,t20.market_type_id order by t20.int_accr_end_dt desc) as rn 
              from ${iml_schema}.prd_int_accr_dtl t20 
             where t20.asset_type_id <> 'SPT_DED'
               and t20.int_accr_start_dt <= to_date('${batch_date}', 'yyyymmdd') 
               and t20.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t20.end_dt > to_date('${batch_date}', 'yyyymmdd')
               and t20.job_cd = 'ibmsf1'
            ) t20
    on t1.fin_instm_id = t20.fin_instm_id
   and t1.asset_type_id = t20.asset_type_id
   and t1.market_type_id = t20.market_type_id
   and t20.rn = 1
  left join ${iol_schema}.ibms_ttrd_credit_instrument_mapping t36 
    on t1.fin_instm_id = t36.confirm_i_code  
   and t1.asset_type_id = t36.confirm_a_type 
   and t1.market_type_id = t36.confirm_m_type
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_02 t31
    on t31.trade_id=t1.tran_num 
   and t31.typename=t8.cls_name 
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
             ) t37
    on t1.fin_instm_id = t37.inst_i_code  
   and t1.asset_type_id = t37.inst_a_type 
   and t1.market_type_id = t37.inst_m_type
  left join ${iol_schema}.ibms_ttrd_overdue_handle t38
    on t1.fin_instm_id = t38.i_code  
   and t1.asset_type_id = t38.a_type 
   and t1.market_type_id = t38.m_type
   and t38.statu = '2'
   and t38.is_si <>'1'
 	 and t38.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t38.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.pty_ibank_cntpty_info t39
    on t4.crdt_cust_id = t39.src_party_id 
   and t39.create_dt<= to_date('${batch_date}', 'yyyymmdd')
   and t39.job_cd ='ibmsf1'
   and t39.id_mark<>'D'
   and t4.prod_type_cd = '0179'
  left join ${iml_schema}.pty_corp t40
    on coalesce(trim(t39.cust_id),trim(t16.actl_finer_cust_id), trim(t17.actual_financier_id), t12.cust_id) = t40.party_id 
   and t40.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t40.end_dt > to_date('${batch_date}','yyyymmdd')
   and t40.job_cd ='eifsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
   and t5.prod_type_cd not in ('0121', '0300', '0304')
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_cash_debit_crdt exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_cash_debit_crdt_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_cash_debit_crdt_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_cash_debit_crdt_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_cash_debit_crdt', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);