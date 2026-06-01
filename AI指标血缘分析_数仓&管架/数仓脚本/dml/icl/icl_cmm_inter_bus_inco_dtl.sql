/*
Purpose:    共性加工层
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20290328 icl_cmm_inter_bus_inco_dtl
CreateDate: 20200519
Logs:       20210618 何桐金 新增模型
            20210802 陈伟峰 调整摊销标志为1部分的流水表的关联条件（修复客户号关联逻辑）
            20220611 陈伟峰 调整国结部分客户号取值逻辑，增加ROW_NUMBER排序
			      20220701 温旺清 1、调整取数数据源，由原核心系统调整为核算中台和新核心系统取数；
                            2、新增字段【全局流水号、业务流水号、收费单据号、税额、税后金额】
                            3、置空字段【账单流水号-ACCT_BILL_FLOW_NUM、内部账户编号-INTNAL_ACCT_ID、内部账户名称-INTNAL_ACCT_NAME、内部主账户编号-INTNAL_MAIN_ACCT_ID、余额方向代码-BAL_DIR_CD、借贷标志-DEBIT_CRDT_FLG-VARCHAR2(10)、抹账标志-ERASE_ACCT_FLG-VARCHAR2(10)、应收手续费金额-RECVBL_COMM_FEE_AMT、交易备注信息-TRAN_REMARK_INFO】
                            4、调整主键字段【数据日期、法人编号、账单流水号、交易日期、摊销流水号 -》 数据日期、法人编号、交易流水号、交易日期、摊销流水号】
            20220823 温旺清 新增字段【摊销开始日期、摊销结束日期、累计摊销金额、待摊总金额】
            20230105 翟若平 新增第三组【中间业务一次性收费交易流水】
            20230202 陈伟峰 调整tgls_ama_mdsr_acch_h关联条件，使用全局流水号关联
            20230615 陈伟峰 调整tgls_loan_busi_h表取数逻辑，增加tgls_loan_busi表数据，用于支持月批
            20230712 徐子豪 调整tgls_ama_mdsr_acch_h取值表为agt_inter_income_sub_acct_bal_dtl,M层进行数据整合。
            20231122 曹永茂 1.调整第三组和第四组和应税流水表的关联逻辑：贷款交易流水用t5.taxable_flow_num，中收用t5.sumos_seq_num关联
            								t1.serino = t5.sumos_seq_num =》 t1.serino = (case when t1.prodcd='LN' then t5.taxable_flow_num else t5.sumos_seq_num end)
            								2.调整第2组和应税流水表的关联逻辑：解决不同产品/科目的交易，但交易流水相同的场景，增加以下关联条件
                            nvl(t3.itemcd, t31.itemcd) = t7.net_price_subj_id
            20231205 徐子豪 经调研,因核算中台tgls_gla_vchr_h月末数据调账前存在当前表,M层表已对数据进行整合,故调整从M层表统计数据。
				    20231227 陈伟峰 调整glb_dept_book表中acctno的取值规则，对首位为0的数据进行判断并去除0
				    20240229 饶雅 1.新增字段【交易账户编号、收费流水号、收费方式代码、交易类型代码、收费日期】
                          3.调整取数逻辑：
                            1)第一、第二组的【业务账户编号】 NVL(T4.ATTRA1, T5.INTERNAL_KEY) -> case when t5.tran_dt < to_date('20230502','yyyymmdd') then decode(t4.bus_id,'*',' ',t4.bus_id) else t5.cntpty_cust_acct_num end --新一代迁移的数据T5.OTH_BUSINESS_NO是不准的，所以应该取T4.ATTRA1
                            2)第一、第二组的【客户编号】 T4.CUSTCD -> NVL(TRIM(T5.CLIENT_NO), T4.CUSTCD)
                          4.收费历史表的关联逻辑调整,不需要关联日期，排序后关联单据号取第一笔就可以 
                          5. 新增一组同业的中收数据
                          6. 新增一组资金本币中收数据
                          7. 新增一组资金外币中收数据
                          8. 新增一组资管系统中收数据
                          9. 第三、第四组：取数口径调整:【余额方向代码、借贷标志】
				    20240315 陈伟峰 调整evt_taxable_tran_dtl过滤sob_id ='3'  --利润预测账套
				    20240326 饶雅  调整交易类型代码和收费方式代码的逻辑
				    20240426 饶雅  新增客户名称字段、调整客户编号和客户经理编号的逻辑
				    20240509 饶雅  修改第4组中间业务一次性收费交易流水t1与t2表的关联条件，去掉账套号关联
				    20240510 饶雅  调整3-4业务账户编号的逻辑
				    20240510 曹永茂 调整第1-第4组的客户编号取数逻辑
				    20240529 饶雅  调整资金系统本币，即第6组的币种代码的取数逻辑
				    20240626 饶雅 1、调整模型中的1-4组客户编号的取数逻辑、2、修改第3-4组T1表和T3表的关联条件3、资金组及同业组的【客户编号】、【客户名称】的取数逻辑
				    20240801 陈伟峰 调整第一组 中间业务手续费摊销流水的交易金额字段取数逻辑，从M层取
				    20240830 谢宁 资金系统本币组别【客户编号】【客户名称】逻辑修改
				    20240830 谢宁 同业系统本币组别【客户编号】【客户名称】逻辑修改
				    20241126 陈伟峰 调整同业部分取数范围，去除结转流水
				    20241126 谢宁 过滤第一第二组不记账流水
				    20250101 陈伟峰 调整同业部分取数范围，去除结转流水
				    20250311 陈伟峰 新增第九组 智能报销数据
            20250527 陈伟峰 调整第三组第四组核算中台流水【客户编号、客户名称】加工逻辑，补充结售汇客户号
            20251230 陈伟峰 调整智能报销部分的交易日期加工逻辑
            20260401 陈  凭 新增第十组 结售汇损益数据

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_inter_bus_inco_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_inter_bus_inco_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_inter_bus_inco_dtl_ex purge;
drop table ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_01 purge;
drop table ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_02 purge;
drop table ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_03 purge;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_inter_bus_inco_dtl_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_inter_bus_inco_dtl where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_01 nologging
compress ${option_switch} for query high
as 
select sdp.base_prod_id,
       sdp.intnal_prod_id,
       max(decode(sd.amt_type_cd, 'FEE', sd.subj_id, '')) as itemcd,
       max(decode(sd.amt_type_cd, 'BAL', sd.subj_id, '')) as itemcd1
  from ${iml_schema}.fin_accti_subj_rela_h sd
  left join ${iml_schema}.fin_accti_prod_rela_info sdp
    on sd.accti_id = sdp.accti_id
   and sd.sob_id = sdp.sob_id
   and sdp.job_cd = 'tglsi1'
   and sdp.etl_dt = to_date('${batch_date}','yyyymmdd')
 where sd.sob_id = 2
   and sdp.base_prod_id like '5%'
   --and sdp.intnal_prod_id = 'FEE'
   and sd.job_cd = 'tglsf1'
   and sd.start_dt <= to_date('${batch_date}','yyyymmdd')
   and sd.end_dt > to_date('${batch_date}','yyyymmdd')
 group by sdp.base_prod_id, sdp.intnal_prod_id;
 commit;
 
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_02 nologging
compress ${option_switch} for query high
as 
select distinct t.sob_id as stacid,
                to_char(t.sorc_sys_dt,'yyyymmdd') as sourdt,
                t.sorc_sys_flow_num as soursq,
                t.ova_flow_num as bsnssq,
                t.src_tran_flow_seq_num as srvcsq,
                t.subj_id as itemcd,
                t.debit_crdt_dir_cd as amntcd
  from ${iml_schema}.evt_accti_midgrod_acct_ety t
  where t.tran_dt = to_date('${batch_date}','yyyymmdd')
    and substr(t.subj_id, 1, 4) in ('6021', '6051', '6061')
    and t.job_cd = 'tglsi1';
 commit;
 
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_03 nologging
compress ${option_switch} for query high
as select ac.ova_flow_num,
                    ac.tran_dt,
                    ac.cust_id,
                    ac.cntpty_cust_name,
                    ac.cntpty_cust_id,
                    ac.cust_mgr_id,
                    ac.tran_ref_no,
                    ac.tran_teller_id,
                    ac.acct_id,
                    ac.cust_acct_num,
                    ac.sub_acct_num,
                    ac.tran_revd_flg,
                    ac.discnt_fee_amt,
                    ac.acct_dmic_fee_amt,
                    ac.init_fee_amt,
                    ac.init_recvbl_fee_amt,
                    ac.charge_seq_num,
                    ac.comm_fee_coll_way_cd,
                    ac.tran_cd,
                    ac.cntpty_cust_acct_num,
                    row_number() over(partition by ac.ova_flow_num,ac.charge_seq_num order by ac.tran_dt desc) as rn
               from ${iml_schema}.evt_charge_flow ac
              where  1 = 1
                and ac.job_cd = 'ncbsi1';
commit;



  
--第一组（共九组）中间业务交易流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
      etl_dt	                             --数据日期
      ,lp_id	                             --法人编号
      ,acct_bill_flow_num                  --账单流水号
      ,tran_flow_num                       --交易流水号
      ,tran_dt                             --交易日期
      ,ova_flow_num                        --全局流水号
      ,bus_flow_num                        --业务流水号
      ,charge_doc_num                      --收费单据号
      ,charge_flow_num                     --收费流水号
      ,acct_dt                             --账务日期
      ,amort_flow_num                      --摊销流水号
      ,amort_start_dt	                     --摊销开始日期
      ,amort_end_dt	                       --摊销结束日期
      ,charge_dt	                         --收费日期
      ,subj_id                             --科目编号
      ,std_prod_id                         --标准产品编号
      ,cust_id                             --客户编号
      ,cust_name                           --客户名称
      ,bus_acct_id                         --业务账户编号
      ,intnal_acct_id                      --内部账户编号
      ,intnal_acct_name	                   --内部账户名称
      ,intnal_main_acct_id                 --内部主账户编号
      ,tran_acct_id                        --交易账户编号
      ,tran_main_acct_id                   --交易主账户编号
      ,tran_sub_acct_id                    --交易子账户编号
      ,tran_chn_cd                         --交易渠道编号
      ,bal_dir_cd                          --余额方向代码
      ,sorc_sys_cd                         --来源系统编号
      ,cust_mgr_id                         --客户经理编号
      ,charge_cd                           --收费代码
      ,charge_name                         --收费名称
      ,charge_cate_cd                      --收费类别代码
      ,charge_way_cd                       --收费方式代码
      ,tran_type_cd                        --交易类型代码
      ,amort_flg                           --摊销标志
      ,debit_crdt_flg                      --借贷标志
      ,erase_acct_flg                      --抹账标志
      ,revs_flg                            --冲正标志
      ,tran_org_id                         --交易机构编号
      ,acct_instit_id                      --账务机构编号
      ,curr_cd                             --币种代码
      ,acm_amort_amt	                     --累计摊销金额
      ,amorted_tot_amt	                   --待摊总金额   
      ,tran_amt                            --交易金额
      ,recvbl_comm_fee_amt                 --应收手续费金额
      ,tax_amt                             --税额
      ,at_amt                              --税后金额
      ,tran_remark_info                    --交易备注信息
      ,job_cd                              --任务代码
      ,etl_timestamp                       --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,''                                                                            --账单流水号
       ,t1.tran_flow_num                                                              --交易流水号
       ,t1.tran_dt                                                                    --交易日期
       ,t1.ova_flow_num                                                               --全局流水号
       ,t1.tran_flow_num                                                              --业务流水号
       ,t1.doc_id                                                                     --收费单据号
       ,t5.ova_flow_num                                                               --收费流水号
       ,t1.fin_dt                                                                     --账务日期
       ,' '                                                                           --摊销流水号
	     ,t4.amort_start_dt	                                                            --摊销开始日期
       ,t4.amort_end_dt	                                                              --摊销结束日期
       ,t5.tran_dt                                                                    --收费日期
       ,case when t2.doc_id is not null then nvl(t3.itemcd1, t31.itemcd1) else nvl(t3.itemcd, t31.itemcd) end            --科目编号
       ,t1.prod_id                                                                    --标准产品编号
       ,coalesce(trim(t5.cntpty_cust_id), trim(t5.cust_id), t4.cust_id)               --客户编号
       ,t5.cntpty_cust_name                                                           --客户名称
       ,case when t5.tran_dt < to_date('20230502','yyyymmdd') then decode(t4.bus_id,'*',' ',t4.bus_id) else t5.cntpty_cust_acct_num end  --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,t5.acct_id                                                                    --交易账户编号
       ,t5.cust_acct_num                                                              --交易主账户编号
       ,t5.sub_acct_num                                                               --交易子账户编号
       ,t1.tran_chn_id                                                                --交易渠道编号
       ,''                                                                            --余额方向代码
       ,t1.bus_sys_id                                                                 --来源系统编号
       ,nvl(trim(t5.cust_mgr_id),t5.tran_teller_id)                                   --客户经理编号
       ,t1.fee_cd                                                                     --收费代码
       ,t6.sellbl_prod_name                                                           --收费名称
       ,t6.prod_gen_id                                                                --收费类别代码
       ,t5.comm_fee_coll_way_cd                                                       --收费方式代码
       ,t5.tran_cd                                                                    --交易类型代码
       ,case when t2.doc_id is not null then '1' else '0' end                         --摊销标志
       ,''                                                                            --借贷标志
       ,''                                                                            --抹账标志
       ,t5.tran_revd_flg                                                              --冲正标志
       ,t1.tran_org_id                                                                --交易机构编号
       ,t1.fin_org_id                                                                 --账务机构编号
       ,t1.curr_cd                                                                    --币种代码
	     ,nvl(t4.acm_amort_amt,0)	                                                      --累计摊销金额
       ,nvl(t4.amorted_tot_amt,0)	                                                    --待摊总金额
       ,nvl(t1.ths_tm_amort_amt,0)                                                    --交易金额
       ,0                                                                             --应收手续费金额
       ,nvl(t7.taxbam,0)                                                              --税额
       ,nvl(t7.pricam,0)                                                              --税后金额
       ,''                                                                            --交易备注信息
       ,'1'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
from ${iml_schema}.evt_inter_income_bus_tran_dtl t1		
 left join (select sob_id, 
                   bus_sys_id, doc_id, 
  				         count(1) as cnts
              from ${iml_schema}.agt_inter_income_sub_acct_bal_dtl
			       where job_cd = 'tglsi1'
			         and fin_dt = to_date('${batch_date}','yyyymmdd')	
             group by sob_id, bus_sys_id, doc_id
 			  ) t2			
   on t1.bus_sys_id = t2.bus_sys_id 
  and t1.doc_id = t2.doc_id 
  and t1.sob_id = t2.sob_id
 left join ${iml_schema}.prd_prod_catlg_h t21
    on t21.prod_id = t1.prod_id
   and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t21.end_dt > to_date('${batch_date}','yyyymmdd')
   and t21.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_01 t3		
   on t21.prod_id = t3.base_prod_id
  and t3.intnal_prod_id = 'FEE'
  left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_01 t31		
   on t21.base_prod_id = t31.base_prod_id
  and t31.intnal_prod_id = 'FEE'
 left join ${iml_schema}.agt_inter_income_sub_acct_bal_h t4			
   on t1.sob_id = t4.sob_id 
  and t1.bus_sys_id = t4.bus_sys_id 
  and t1.doc_id = t4.doc_id		
  and t4.fin_dt = to_date('${batch_date}','yyyymmdd')
  and t4.job_cd = 'tglsf1'   
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_03 t5	
   on t1.doc_id = t5.charge_seq_num
  and t5.rn = 1  
 left join ${iml_schema}.prd_prod_catlg_h t6			
   on t1.prod_id = t6.prod_id
  and t6.job_cd = 'ncbsf1'   
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
 left join (select bus_sys_id,
                   tran_dt,
                   tran_flow_num,
                   sum(tax_amt) as taxbam,
                   sum(tax_inc_tran_amt) as tranam,
                   sum(exclude_tax_tran_amt) as pricam
              from ${iml_schema}.evt_taxable_tran_dtl
             where tran_dt = to_date('${batch_date}','yyyymmdd')
		           and job_cd = 'tglsi1'
		           and sob_id <> '3'    --过滤利润预测账套
             group by bus_sys_id, tran_dt, tran_flow_num) t7		
   on t1.tran_dt = t7.tran_dt 
  and t1.bus_sys_id = t7.bus_sys_id 
  and t1.tran_flow_num = t7.tran_flow_num
where t1.sob_id = '2' 
  and t1.fin_dt = to_date('${batch_date}','yyyymmdd')	
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'tglsi1'
  and trim(t1.new_tran_flow_num) is not null
;
commit;

--第二组（共九组）中间业务手续费摊销流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
       etl_dt	                             --数据日期
       ,lp_id	                             --法人编号
       ,acct_bill_flow_num                 --账单流水号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt	                   --摊销开始日期
       ,amort_end_dt	                     --摊销结束日期
       ,charge_dt	                         --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,intnal_acct_id                     --内部账户编号
       ,intnal_acct_name	                 --内部账户名称
       ,intnal_main_acct_id                --内部主账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道编号
       ,bal_dir_cd                         --余额方向代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_cd                          --收费代码
       ,charge_name                        --收费名称
       ,charge_cate_cd                     --收费类别代码
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt	                     --累计摊销金额
       ,amorted_tot_amt	                   --待摊总金额   
       ,tran_amt                           --交易金额
       ,recvbl_comm_fee_amt                --应收手续费金额
       ,tax_amt                            --税额
       ,at_amt                             --税后金额
       ,tran_remark_info                   --交易备注信息
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,''                                                                            --账单流水号
       ,t1.tran_flow_num                                                              --交易流水号
       ,t1.tran_dt                                                                    --交易日期
       ,t1.ova_flow_num                                                               --全局流水号
       ,t1.tran_flow_num                                                              --业务流水号
       ,t1.doc_id                                                                     --收费单据号
       ,t5.ova_flow_num                                                               --收费流水号
	     ,t1.fin_dt                             												                --账务日期
	     ,t1.tran_flow_num                                                              --摊销流水号
       ,t4.amort_start_dt	                                                            --摊销开始日期
       ,t4.amort_end_dt	                                                              --摊销结束日期
       ,t5.tran_dt                                                                    --收费日期
       ,nvl(t3.itemcd, t31.itemcd)                                                    --科目编号                                                                                   
       ,t1.prod_id                                                                    --标准产品编号
       ,coalesce(trim(t5.cntpty_cust_id), trim(t5.cust_id), t4.cust_id)               --客户编号
       ,t5.cntpty_cust_name                                                           --客户名称
       ,case when t5.tran_dt<to_date('20230502','yyyymmdd') then decode(t4.bus_id,'*',' ',t4.bus_id) else t5.cntpty_cust_acct_num end --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,t5.acct_id                                                                    --交易账户编号
       ,t5.cust_acct_num                                                              --交易主账户编号
       ,t5.sub_acct_num                                                               --交易子账户编号
       ,t1.tran_chn_id                                                                --交易渠道编号
       ,''                                                                            --余额方向代码
       ,t1.bus_sys_id                                                                 --来源系统编号
       ,nvl(trim(t5.cust_mgr_id),t5.tran_teller_id)                                   --客户经理编号
       ,t1.fee_cd                                                                     --收费代码
       ,t6.sellbl_prod_name                                                           --收费名称
       ,t6.prod_gen_id                                                                --收费类别代码
       ,t5.comm_fee_coll_way_cd                                                       --收费方式代码
       ,t5.tran_cd                                                                    --交易类型代码
       ,'1'                                                                           --摊销标志
       ,''                                                                            --借贷标志
       ,''                                                                            --抹账标志
       ,t5.tran_revd_flg                                                              --冲正标志
       ,t1.tran_org_id                                                                --交易机构编号	 
       ,t4.acct_instit_id                                                             --账务机构编号
       ,t4.curr_cd                                                                    --币种代码
	     ,nvl(t4.acm_amort_amt,0)	                                                      --累计摊销金额
       ,nvl(t4.amorted_tot_amt,0)	                                                    --待摊总金额
       ,nvl(t1.ths_tm_amort_amt,0)                                                            --交易金额
       ,null                                                                          --应收手续费金额
       ,nvl(t7.taxbam,0)                                                              --税额
       ,nvl(t7.pricam,0)                                                              --税后金额
       ,''                                                                            --交易备注信息
       ,'2'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
 from ${iml_schema}.evt_inter_income_bus_tran_dtl t1		
/* inner join ${iml_schema}.agt_inter_income_sub_acct_bal_dtl t2			
    on t1.bus_sys_id = t2.bus_sys_id 
   and t1.doc_id = t2.doc_id 
   and t1.sob_id = t2.sob_id
--   and t1.tran_flow_num = t2.transq
   and t1.ova_flow_num=t2.ova_flow_num
   and t2.fin_dt = to_date('${batch_date}','yyyymmdd')	
  */
  left join ${iml_schema}.prd_prod_catlg_h t21
    on t21.prod_id = t1.prod_id
   and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t21.end_dt > to_date('${batch_date}','yyyymmdd')
   and t21.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_01 t3		
   on t21.prod_id = t3.base_prod_id
  and t3.intnal_prod_id = 'FEE'
  left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_01 t31		
   on t21.base_prod_id = t31.base_prod_id
  and t31.intnal_prod_id = 'FEE'
 inner join ${iml_schema}.agt_inter_income_sub_acct_bal_h t4			
   on t1.sob_id = t4.sob_id 
  and t1.bus_sys_id = t4.bus_sys_id 
  and t1.doc_id = t4.doc_id		
  and t4.fin_dt = to_date('${batch_date}','yyyymmdd')
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  and t4.job_cd = 'tglsf1' 
 left join ${iol_schema}.tgls_ama_mdsr_acct_h t8
   on t1.sob_id = t8.stacid 
  and t1.bus_sys_id = t8.systid 
  and t1.doc_id = t8.loanno		
  and t8.datadt = '${batch_date}'
 left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_03 t5	
   on t1.doc_id = t5.charge_seq_num
  and t5.rn = 1
 left join ${iml_schema}.prd_prod_catlg_h t6			
   on t1.prod_id = t6.prod_id
  and t6.job_cd = 'ncbsf1'   
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
 left join (select bus_sys_id,
                   tran_dt,
                   tran_flow_num,
                   net_price_subj_id,
                   sum(tax_amt) as taxbam,
                   sum(tax_inc_tran_amt) as tranam,
                   sum(exclude_tax_tran_amt) as pricam
              from ${iml_schema}.evt_taxable_tran_dtl
             where tran_dt = to_date('${batch_date}','yyyymmdd')
		           and job_cd = 'tglsi1'
             group by bus_sys_id, tran_dt, tran_flow_num, net_price_subj_id) t7		
   on t1.tran_dt = t7.tran_dt 
  and t1.bus_sys_id = t7.bus_sys_id 
  and t1.tran_flow_num = t7.tran_flow_num	
  and nvl(t3.itemcd, t31.itemcd) = t7.net_price_subj_id		
where t1.sob_id = '2' 	
 and t1.fin_dt = to_date('${batch_date}','yyyymmdd')	
 and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
 and t1.job_cd = 'tglsi1'
 and trim(t1.new_tran_flow_num) is not null
;
commit;

--第三组（共九组）中间业务一次性收费交易流水    --历史表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
      etl_dt	                            --数据日期
      ,lp_id	                            --法人编号
      ,acct_bill_flow_num                 --账单流水号
      ,tran_flow_num                      --交易流水号
      ,tran_dt                            --交易日期
      ,ova_flow_num                       --全局流水号
      ,bus_flow_num                       --业务流水号
      ,charge_doc_num                     --收费单据号
      ,charge_flow_num                    --收费流水号
      ,acct_dt                            --账务日期
      ,amort_flow_num                     --摊销流水号
      ,amort_start_dt	                    --摊销开始日期
      ,amort_end_dt	                      --摊销结束日期
      ,charge_dt	                        --收费日期
      ,subj_id                            --科目编号
      ,std_prod_id                        --标准产品编号
      ,cust_id                            --客户编号
      ,cust_name                          --客户名称
      ,bus_acct_id                        --业务账户编号
      ,intnal_acct_id                     --内部账户编号
      ,intnal_acct_name	                  --内部账户名称
      ,intnal_main_acct_id                --内部主账户编号
      ,tran_acct_id                       --交易账户编号
      ,tran_main_acct_id                  --交易主账户编号
      ,tran_sub_acct_id                   --交易子账户编号
      ,tran_chn_cd                        --交易渠道编号
      ,bal_dir_cd                         --余额方向代码
      ,sorc_sys_cd                        --来源系统编号
      ,cust_mgr_id                        --客户经理编号
      ,charge_cd                          --收费代码
      ,charge_name                        --收费名称
      ,charge_cate_cd                     --收费类别代码
      ,charge_way_cd                      --收费方式代码
      ,tran_type_cd                       --交易类型代码
      ,amort_flg                          --摊销标志
      ,debit_crdt_flg                     --借贷标志
      ,erase_acct_flg                     --抹账标志
      ,revs_flg                           --冲正标志
      ,tran_org_id                        --交易机构编号
      ,acct_instit_id                     --账务机构编号
      ,curr_cd                            --币种代码
      ,acm_amort_amt	                    --累计摊销金额
      ,amorted_tot_amt	                  --待摊总金额   
      ,tran_amt                           --交易金额
      ,recvbl_comm_fee_amt                --应收手续费金额
      ,tax_amt                            --税额
      ,at_amt                             --税后金额
      ,tran_remark_info                   --交易备注信息
      ,job_cd                             --任务代码
      ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,''                                                                            --账单流水号
       ,t1.transq                                                                     --交易流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')                                          --交易日期
       ,t1.bsnssq                                                                     --全局流水号
       ,t1.transq                                                                     --业务流水号
       ,t1.serino                                                                     --收费单据号
       ,t3.ova_flow_num                                                               --收费流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')																	        --账务日期
	     ,' '                                                                           --摊销流水号
       ,null	                                                                        --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,t3.tran_dt                                                                    --收费日期
       ,t2.itemcd                                                                     --科目编号                                                                                   
       ,t1.assis1                                                                     --标准产品编号
       ,case when t7.cust_id is not null then t7.cust_id
                 when t1.assis4='FEEIYT' then nvl(trim(t6.cntpty_cust_id), t1.custcd)           
                     else coalesce(trim(t3.cntpty_cust_id),trim(t3.cust_id),t1.custcd) end --客户编号 (先计提后收费场景,则优先取费用计提明细表信息--其他场景，如果对手客户名称为空，优先取收费历史表信息）                  
       ,case when t7.cust_id is not null then t8.party_name
                  when t1.assis4='FEEIYT' then t6.cntpty_cust_name 
                else t3.cntpty_cust_name end                                             --客户名称
       ,NVl(trim(t3.cntpty_cust_acct_num),ltrim(t1.acctno,'0'))                       --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,t3.acct_id                                                                    --交易账户编号
       ,t3.cust_acct_num                                                              --交易主账户编号
       ,t3.sub_acct_num                                                               --交易子账户编号
       ,t1.assis0                                                                     --交易渠道编号
       ,t2.amntcd                                                                     --余额方向代码
       ,t1.systid                                                                     --来源系统编号
       ,case when t1.assis4='FEEIYT' then nvl(trim(t6.cust_mgr_id),t6.tran_teller_id)  
        else nvl(trim(t3.cust_mgr_id),t3.tran_teller_id) end                          --客户经理编号
       ,t1.assis1                                                                     --收费代码
       ,t4.sellbl_prod_name                                                           --收费名称
       ,t4.prod_gen_id                                                                --收费类别代码
       ,CASE WHEN TRIM(T3.comm_fee_coll_way_cd) IS NULL THEN DECODE(T1.ASSIS4,'FEEIYT','3',' ') ELSE DECODE(TRIM(T3.comm_fee_coll_way_cd),'-','0',TRIM(T3.comm_fee_coll_way_cd)) END                                                      --收费方式代码
       ,nvl(trim(t3.tran_cd),t1.assis4)                                               --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t2.amntcd                                                                     --借贷标志
       ,''                                                                            --抹账标志
       ,t1.strkst                                                                     --冲正标志
       ,t1.tranbr                                                                     --交易机构编号	 
       ,t1.acctbr                                                                     --账务机构编号
       ,t1.crcycd                                                                     --币种代码
	     ,0	                                                                            --累计摊销金额
       ,0	                                                                            --待摊总金额
       ,t1.tranam                                                                     --交易金额
       ,null                                                                          --应收手续费金额
       ,t5.taxbam                                                                     --税额
       ,t5.pricam                                                                     --税后金额
       ,''                                                                            --交易备注信息
       ,'3'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.tgls_loan_busi_h t1
 inner join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_02 t2		
    on t2.sourdt = t1.trandt
   and t2.soursq = t1.transq
   and t2.bsnssq = t1.bsnssq
   and t2.srvcsq = t1.serino
   and t2.stacid = t1.stacid
 left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_03 t3	
   on t1.bsnssq = t3.ova_flow_num
  and substr(t1.serino,-length(t3.charge_seq_num)) = t3.charge_seq_num
  and t3.rn = 1
 left join ${iml_schema}.prd_prod_catlg_h t4			
   on t1.assis1 = t4.prod_id
  and t4.job_cd = 'ncbsf1'   
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join (select bus_sys_id,
                   to_char(tran_dt, 'yyyymmdd') as tran_dt,
                   tran_flow_num,
                   sumos_seq_num,
                   max(taxable_flow_num) as taxable_flow_num,
                   sum(tax_amt) as taxbam,
                   sum(tax_inc_tran_amt) as tranam,
                   sum(exclude_tax_tran_amt) as pricam
              from ${iml_schema}.evt_taxable_tran_dtl
             where tran_dt = to_date('${batch_date}','yyyymmdd')
		           and job_cd = 'tglsi1'
             group by bus_sys_id, tran_dt, tran_flow_num, sumos_seq_num)	 t5		
   on t1.trandt = t5.tran_dt 
  and t1.systid = t5.bus_sys_id 
  and t1.transq = t5.tran_flow_num
  and t1.serino = (case when t1.prodcd='LN' then t5.taxable_flow_num else t5.sumos_seq_num end) --贷款交易流水用t5.taxable_flow_num，中收用t5.sumos_seq_num关联
 left join ${iml_schema}.agt_fee_provi_dtl t6
  on t1.bsnssq=t6.provi_flow_num
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
  and t6.job_cd = 'ncbsf1'
 left join (select t.*
                             ,row_number() over(partition by t.tran_ref_no order by t.tran_ref_no) as rn
                   from ${iml_schema}.evt_wrt_guat_tran_flow t 
                 where t.etl_dt =to_date('${batch_date}','yyyymmdd')
                     and t.job_cd ='ncbsi1') t7
   on t7.tran_ref_no=t1.transq
 and t7.rn=1
left join ${iml_schema}.pty_indv t8
   on t7.cust_id =t8.party_id
  and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  and t8.job_cd = 'eifsf1'
where t1.stacid = 1
  and t1.trandt = '${batch_date}'
  and t1.prodcd <> 'FEE'
;
commit;

--第四组（共九组）中间业务一次性收费交易流水   --当前表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,acct_bill_flow_num                 --账单流水号
   ,tran_flow_num                      --交易流水号
   ,tran_dt                            --交易日期
   ,ova_flow_num                       --全局流水号
   ,bus_flow_num                       --业务流水号
   ,charge_doc_num                     --收费单据号
   ,charge_flow_num                    --收费流水号
   ,acct_dt                            --账务日期
   ,amort_flow_num                     --摊销流水号
   ,amort_start_dt	                   --摊销开始日期
   ,amort_end_dt	                     --摊销结束日期
   ,charge_dt	                         --收费日期
   ,subj_id                            --科目编号
   ,std_prod_id                        --标准产品编号
   ,cust_id                            --客户编号
   ,cust_name                          --客户名称
   ,bus_acct_id                        --业务账户编号
   ,intnal_acct_id                     --内部账户编号
   ,intnal_acct_name	                 --内部账户名称
   ,intnal_main_acct_id                --内部主账户编号
   ,tran_acct_id                       --交易账户编号
   ,tran_main_acct_id                  --交易主账户编号
   ,tran_sub_acct_id                   --交易子账户编号
   ,tran_chn_cd                        --交易渠道编号
   ,bal_dir_cd                         --余额方向代码
   ,sorc_sys_cd                        --来源系统编号
   ,cust_mgr_id                        --客户经理编号
   ,charge_cd                          --收费代码
   ,charge_name                        --收费名称
   ,charge_cate_cd                     --收费类别代码
   ,charge_way_cd                      --收费方式代码
   ,tran_type_cd                       --交易类型代码
   ,amort_flg                          --摊销标志
   ,debit_crdt_flg                     --借贷标志
   ,erase_acct_flg                     --抹账标志
   ,revs_flg                           --冲正标志
   ,tran_org_id                        --交易机构编号
   ,acct_instit_id                     --账务机构编号
   ,curr_cd                            --币种代码
   ,acm_amort_amt	                     --累计摊销金额
   ,amorted_tot_amt	                   --待摊总金额   
   ,tran_amt                           --交易金额
   ,recvbl_comm_fee_amt                --应收手续费金额
   ,tax_amt                            --税额
   ,at_amt                             --税后金额
   ,tran_remark_info                   --交易备注信息
   ,job_cd                             --任务代码
   ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,''                                                                            --账单流水号
       ,t1.transq                                                                     --交易流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')                                          --交易日期
       ,t1.bsnssq                                                                     --全局流水号
       ,t1.transq                                                                     --业务流水号
       ,t1.serino                                                                     --收费单据号
       ,t3.ova_flow_num                                                               --收费流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')																	        --账务日期
	     ,' '                                                                           --摊销流水号
       ,null	                                                                        --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,t3.tran_dt                                                                    --收费日期
       ,t2.itemcd                                                                     --科目编号                                                                                   
       ,t1.assis1                                                                     --标准产品编号
       ,case when t7.cust_id is not null then t7.cust_id
                 when t1.assis4='FEEIYT' then nvl(trim(t6.cntpty_cust_id), t1.custcd)           
                     else coalesce(trim(t3.cntpty_cust_id),trim(t3.cust_id),t1.custcd) end --客户编号 (先计提后收费场景,则优先取费用计提明细表信息--其他场景，如果对手客户名称为空，优先取收费历史表信息）                  
       ,case when t7.cust_id is not null then t8.party_name
                  when t1.assis4='FEEIYT' then t6.cntpty_cust_name 
                else t3.cntpty_cust_name end                                             --客户名称
       ,NVl(trim(t3.cntpty_cust_acct_num),ltrim(t1.acctno,'0'))                       --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,t3.acct_id                                                                    --交易账户编号
       ,t3.cust_acct_num                                                              --交易主账户编号
       ,t3.sub_acct_num                                                               --交易子账户编号
       ,t1.assis0                                                                     --交易渠道编号
       ,t2.amntcd                                                                     --余额方向代码
       ,t1.systid                                                                     --来源系统编号
       ,case when t1.assis4='FEEIYT' then nvl(trim(t6.cust_mgr_id),t6.tran_teller_id)  
        else nvl(trim(t3.cust_mgr_id),t3.tran_teller_id) end                          --客户经理编号
       ,t1.assis1                                                                     --收费代码
       ,t4.sellbl_prod_name                                                           --收费名称
       ,t4.prod_gen_id                                                                --收费类别代码
       ,CASE WHEN TRIM(T3.comm_fee_coll_way_cd) IS NULL THEN DECODE(T1.ASSIS4,'FEEIYT','3',' ') ELSE DECODE(TRIM(T3.comm_fee_coll_way_cd),'-','0',TRIM(T3.comm_fee_coll_way_cd)) END                                                       --收费方式代码
       ,nvl(trim(t3.tran_cd),t1.assis4)                                               --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t2.amntcd                                                                     --借贷标志
       ,''                                                                            --抹账标志
       ,t1.strkst                                                                     --冲正标志
       ,t1.tranbr                                                                     --交易机构编号	 
       ,t1.acctbr                                                                     --账务机构编号
       ,t1.crcycd                                                                     --币种代码
	     ,0	                                                                            --累计摊销金额
       ,0	                                                                            --待摊总金额
       ,nvl(t1.tranam,0)                                                              --交易金额
       ,0                                                                             --应收手续费金额
       ,nvl(t5.taxbam,0)                                                              --税额
       ,nvl(t5.pricam,0)                                                              --税后金额
       ,''                                                                            --交易备注信息
       ,'4'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.tgls_loan_busi t1
 inner join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_02 t2		
    on t2.sourdt = t1.trandt
   and t2.soursq = t1.transq
   and t2.bsnssq = t1.bsnssq
   and t2.srvcsq = t1.serino
 left join ${icl_schema}.tmp_cmm_inter_bus_inco_dtl_03 t3	
   on t1.bsnssq = t3.ova_flow_num
  and substr(t1.serino,-length(t3.charge_seq_num)) = t3.charge_seq_num
  and t3.rn = 1
 left join ${iml_schema}.prd_prod_catlg_h t4			
   on t1.assis1 = t4.prod_id
  and t4.job_cd = 'ncbsf1'   
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join (select bus_sys_id,
                   to_char(tran_dt, 'yyyymmdd') as tran_dt,
                   tran_flow_num,
                   sumos_seq_num,
                   max(taxable_flow_num) as taxable_flow_num,
                   sum(tax_amt) as taxbam,
                   sum(tax_inc_tran_amt) as tranam,
                   sum(exclude_tax_tran_amt) as pricam
              from ${iml_schema}.evt_taxable_tran_dtl
             where tran_dt = to_date('${batch_date}','yyyymmdd')
		           and job_cd = 'tglsi1'
             group by bus_sys_id, tran_dt, tran_flow_num, sumos_seq_num) t5		
   on t1.trandt = t5.tran_dt 
  and t1.systid = t5.bus_sys_id 
  and t1.transq = t5.tran_flow_num
  and t1.serino = (case when t1.prodcd='LN' then t5.taxable_flow_num else t5.sumos_seq_num end) --贷款交易流水用t5.taxable_flow_num，中收用t5.sumos_seq_num关联
  left join ${iml_schema}.agt_fee_provi_dtl t6
  on t1.bsnssq = t6.provi_flow_num
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
  and t6.job_cd = 'ncbsf1'
 left join (select t.*
                             ,row_number() over(partition by t.tran_ref_no order by t.tran_ref_no) as rn
                   from ${iml_schema}.evt_wrt_guat_tran_flow t 
                 where t.etl_dt =to_date('${batch_date}','yyyymmdd')
                     and t.job_cd ='ncbsi1') t7
   on t7.tran_ref_no=t1.transq
 and t7.rn=1
left join ${iml_schema}.pty_indv t8
   on t7.cust_id =t8.party_id
  and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  and t8.job_cd = 'eifsf1'
 where t1.stacid = 2
  and t1.trandt = '${batch_date}'
  and t1.prodcd <> 'FEE'
  and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt 
                   where tt.transq=t1.transq 
                     and tt.trandt=t1.trandt 
                     and tt.bsnssq=t1.bsnssq 
                     and tt.serino=t1.serino
                     and tt.stacid = 1
                     and tt.trandt = '${batch_date}'
                     and tt.prodcd <> 'FEE')
;
commit;


--第五组（共九组）同业系统中收
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
      etl_dt	                            --数据日期
      ,lp_id	                            --法人编号
      ,acct_bill_flow_num                 --账单流水号
      ,tran_flow_num                      --交易流水号
      ,tran_dt                            --交易日期
      ,ova_flow_num                       --全局流水号
      ,bus_flow_num                       --业务流水号
      ,charge_doc_num                     --收费单据号
      ,charge_flow_num                    --收费流水号
      ,acct_dt                            --账务日期
      ,amort_flow_num                     --摊销流水号
      ,amort_start_dt	                    --摊销开始日期
      ,amort_end_dt	                      --摊销结束日期
      ,charge_dt	                        --收费日期
      ,subj_id                            --科目编号
      ,std_prod_id                        --标准产品编号
      ,cust_id                            --客户编号
      ,cust_name                          --客户名称
      ,bus_acct_id                        --业务账户编号
      ,intnal_acct_id                     --内部账户编号
      ,intnal_acct_name	                  --内部账户名称
      ,intnal_main_acct_id                --内部主账户编号
      ,tran_acct_id                       --交易账户编号
      ,tran_main_acct_id                  --交易主账户编号
      ,tran_sub_acct_id                   --交易子账户编号
      ,tran_chn_cd                        --交易渠道编号
      ,bal_dir_cd                         --余额方向代码
      ,sorc_sys_cd                        --来源系统编号
      ,cust_mgr_id                        --客户经理编号
      ,charge_cd                          --收费代码
      ,charge_name                        --收费名称
      ,charge_cate_cd                     --收费类别代码
      ,charge_way_cd                      --收费方式代码
      ,tran_type_cd                       --交易类型代码
      ,amort_flg                          --摊销标志
      ,debit_crdt_flg                     --借贷标志
      ,erase_acct_flg                     --抹账标志
      ,revs_flg                           --冲正标志
      ,tran_org_id                        --交易机构编号
      ,acct_instit_id                     --账务机构编号
      ,curr_cd                            --币种代码
      ,acm_amort_amt	                    --累计摊销金额
      ,amorted_tot_amt	                  --待摊总金额   
      ,tran_amt                           --交易金额
      ,recvbl_comm_fee_amt                --应收手续费金额
      ,tax_amt                            --税额
      ,at_amt                             --税后金额
      ,tran_remark_info                   --交易备注信息
      ,job_cd                             --任务代码
      ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,''                                                                            --账单流水号
       ,t1.task_id||t1.vouch_id||t1.chg_id                                            --交易流水号
       ,t1.vouch_dt                                                                   --交易日期
       ,' '                                                                           --全局流水号
       ,t1.entry_flow_num                                                             --业务流水号
       ,t1.accti_obj_id                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t1.vouch_dt																	                                  --账务日期
	     ,' '                                                                           --摊销流水号
       ,null	                                                                        --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,t1.subj_id                                                                    --科目编号                                                                                   
       ,t1.prod_id                                                                    --标准产品编号
       ,case when nvl(t1.manual_vouch_flg,'-1') = '1' then t9.cust_id else t6.cust_id end --客户编号
       ,case when nvl(t1.manual_vouch_flg,'-1') = '1' then nvl(trim(t9.party_fname),t9.party_name)
        else nvl(trim(t6.party_fname),t6.party_name) end                              --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道编号
       ,t1.debit_crdt_dir_cd                                                          --余额方向代码
       ,'IBMS'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,t1.prod_id                                                                    --收费代码
       ,t2.sellbl_prod_name                                                           --收费名称
       ,t2.prod_gen_id                                                                --收费类别代码
       ,'0'                                                                           --收费方式代码
       ,'FEE1'                                                                        --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.debit_crdt_dir_cd                                                          --借贷标志
       ,t1.rbw_flg_cd                                                                 --抹账标志
       ,t1.rbw_flg_cd                                                                 --冲正标志
       ,t1.bus_org_id                                                                 --交易机构编号	 
       ,t1.entry_org_id                                                               --账务机构编号
       ,t1.curr_cd                                                                    --币种代码
	     ,0	                                                                            --累计摊销金额
       ,0	                                                                            --待摊总金额
       ,nvl(t1.entry_amt,0)+nvl(t1.tax_fee,0)                                         --交易金额
       ,0                                                                             --应收手续费金额
       ,nvl(t1.tax_fee,0)                                                             --税额
       ,nvl(t1.entry_amt,0)                                                           --税后金额
       ,''                                                                            --交易备注信息
       ,'5'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iml_schema}.evt_ibank_acct_ety_evt t1
  left join ${iml_schema}.prd_prod_catlg_h t2		
    on t1.prod_id = t2.prod_id
   and t2.job_cd = 'ncbsf1'   
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_secu_acct_accti_bal_h t3
    on t1.accti_obj_id = t3.obj_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ibmsf1'
  left join ${iml_schema}.evt_ibank_tran t4 --交易单表
    on t3.tran_num = t4.intnal_tran_num
   and t4.etl_dt =to_date('${batch_date}','yyyymmdd')
   and t4.job_cd='ibmsi1'
  left join ${iml_schema}.prd_fin_instm t5 --金融工具表
    on t3.fin_instm_id = t5.fin_instm_id
   and t3.asset_type_id = t5.asset_type_id
   and t3.market_type_id = t5.market_type_id
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.id_mark <> 'D'
   and t5.job_cd = 'ibmsf1'
  left join ${iml_schema}.pty_ibank_cntpty_info t6 --客户信息及机构表(同业交易对手信息)
    on nvl(t4.cntpty_id, t5.issue_org_id) = t6.src_party_id
   and t6.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.id_mark <> 'D'
   and t6.job_cd = 'ibmsf1'
  left join ${iml_schema}.evt_ibank_manual_entry_evt t8
    on t1.entry_flow_num = t8.entry_flow_num
   and t8.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'ibmsi1'
  left join ${iml_schema}.pty_ibank_cntpty_info t9
    on t8.cntpty_id = t9.src_party_id
   and t9.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.id_mark <> 'D'
   and t9.job_cd = 'ibmsf1'
 where t1.vouch_dt = to_date('${batch_date}','yyyymmdd')
   and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and substr(t1.subj_id,1,4) in ('6021', '6051', '6061')
   and t1.job_cd = 'ibmsi1'
   and t1.entry_type_cd <>'B'
;
commit;


--第六组（共九组）资金系统中收-本币
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
      etl_dt	                            --数据日期
      ,lp_id	                            --法人编号
      ,acct_bill_flow_num                 --账单流水号
      ,tran_flow_num                      --交易流水号
      ,tran_dt                            --交易日期
      ,ova_flow_num                       --全局流水号
      ,bus_flow_num                       --业务流水号
      ,charge_doc_num                     --收费单据号
      ,charge_flow_num                    --收费流水号
      ,acct_dt                            --账务日期
      ,amort_flow_num                     --摊销流水号
      ,amort_start_dt	                    --摊销开始日期
      ,amort_end_dt	                      --摊销结束日期
      ,charge_dt	                        --收费日期
      ,subj_id                            --科目编号
      ,std_prod_id                        --标准产品编号
      ,cust_id                            --客户编号
      ,cust_name                          --客户名称
      ,bus_acct_id                        --业务账户编号
      ,intnal_acct_id                     --内部账户编号
      ,intnal_acct_name	                  --内部账户名称
      ,intnal_main_acct_id                --内部主账户编号
      ,tran_acct_id                       --交易账户编号
      ,tran_main_acct_id                  --交易主账户编号
      ,tran_sub_acct_id                   --交易子账户编号
      ,tran_chn_cd                        --交易渠道编号
      ,bal_dir_cd                         --余额方向代码
      ,sorc_sys_cd                        --来源系统编号
      ,cust_mgr_id                        --客户经理编号
      ,charge_cd                          --收费代码
      ,charge_name                        --收费名称
      ,charge_cate_cd                     --收费类别代码
      ,charge_way_cd                      --收费方式代码
      ,tran_type_cd                       --交易类型代码
      ,amort_flg                          --摊销标志
      ,debit_crdt_flg                     --借贷标志
      ,erase_acct_flg                     --抹账标志
      ,revs_flg                           --冲正标志
      ,tran_org_id                        --交易机构编号
      ,acct_instit_id                     --账务机构编号
      ,curr_cd                            --币种代码
      ,acm_amort_amt	                    --累计摊销金额
      ,amorted_tot_amt	                  --待摊总金额   
      ,tran_amt                           --交易金额
      ,recvbl_comm_fee_amt                --应收手续费金额
      ,tax_amt                            --税额
      ,at_amt                             --税后金额
      ,tran_remark_info                   --交易备注信息
      ,job_cd                             --任务代码
      ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,''                                                                            --账单流水号
       ,t1.entry_id                                                                   --交易流水号
       ,t1.stl_dt                                                                     --交易日期
       ,' '                                                                           --全局流水号
       ,t1.entry_id                                                                   --业务流水号
       ,t2.asset_bal_id                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t1.stl_dt																	                                    --账务日期
	     ,' '                                                                           --摊销流水号
       ,null	                                                                        --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,substr(t1.subj_id,2)                                                          --科目编号                                                                                   
       ,t2.std_prod_id                                                                --标准产品编号
       ,case when t1.entry_def_id = '0' then t12.cust_id
             when t13.cust_id is not null then t13.cust_id
        else nvl(trim(t9.cust_id), t11.cust_id) end                                   --客户编号
       ,case when t1.entry_def_id = '0' then nvl(t12.cntpty_fname,t1.cntpty_name)
             when t13.cust_id is not null then nvl(t13.cntpty_fname,t10.cust_key)
        else coalesce(trim(t9.cntpty_fname),trim(t8.cntpty_name),trim(t11.cntpty_fname),t10.cust_key) end --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道编号
       ,t1.debit_crdt_dir_cd                                                          --余额方向代码
       ,'CTMT'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,t2.std_prod_id                                                                --收费代码
       ,t3.sellbl_prod_name                                                           --收费名称
       ,t3.prod_gen_id                                                                --收费类别代码
       ,'0'                                                                           --收费方式代码
       ,'FEE1'                                                                        --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.debit_crdt_dir_cd                                                          --借贷标志
       ,''                                                                            --抹账标志
       ,''                                                                            --冲正标志
       ,t4.departmentid                                                               --交易机构编号	 
       ,t5.org_id                                                                     --账务机构编号
       ,nvl(t4.currency,'CNY')                                                        --币种代码
	     ,0	                                                                            --累计摊销金额
       ,0	                                                                            --待摊总金额
       ,nvl(t1.entry_amt,0)+nvl(t6.entry_amt,0)                                       --交易金额
       ,0                                                                             --应收手续费金额
       ,nvl(t6.entry_amt,0)                                                           --税额
       ,nvl(t1.entry_amt,0)                                                           --税后金额
       ,''                                                                            --交易备注信息
       ,'6'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iml_schema}.evt_cap_acct_ety t1
  left join ${iml_schema}.agt_cap_asset_bal t2		
    on t1.entry_grouping_id=t2.bal_dtl_id 
   and t1.stl_dt = t2.stl_dt
   and t2.create_dt<=to_date('${batch_date}','yyyymmdd')
   and t2.id_mark<>'D'
   and t2.job_cd = 'ctmsf1' 
  left join ${iml_schema}.prd_prod_catlg_h t3		
    on t2.std_prod_id = t3.prod_id
   and t3.job_cd = 'ncbsf1'
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')  
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t4		
    on t1.acct_b_id = t4.keepfolder_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.ref_dc_subj_map t5
    on t1.subj_id = t5.subj_id 
   and t1.dept_id=t5.dept_id 
   and t4.departmentid = t5.bus_dept_id
   and t5.job_cd = 'ctmsf1'
  left join ${iml_schema}.evt_cap_acct_ety t6
    on t1.entry_def_id = t6.entry_def_id  --事件
   and t1.stl_dt = t6.stl_dt --支付日期
   and t1.acct_b_id = t6.acct_b_id --投组id
   and t1.entry_grouping_id = t6.entry_grouping_id --代码绑定
   and substr(t6.subj_id, 2, 6) = '222102' --税额
   and t6.etl_dt = to_date('${batch_date}','yyyymmdd')  
   and t6.job_cd = 'ctmsi1'
   and t6.dc_flg='1'
  left join (select wtrade_lend_id_grand    as wtrade_lend_id_grand
                   ,max(wtrade_lend_id_max) as wtrade_lend_id_max
                   ,max(wtrade_lend_id)     as wtrade_lend_id 
               from ${iol_schema}.ctms_v_lt_wtrade_lend
              where start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
              group by wtrade_lend_id_grand
            ) t7 --债券借贷交易编号
    on to_char(t7.wtrade_lend_id_grand) = substr(t2.minor_asset_id, 4)
   and t2.asset_type_name = '债券借贷'
  left join ${iml_schema}.agt_bond_debit_crdt t8 --实际收付确认-债券借贷
    on t8.bus_id = t7.wtrade_lend_id
   and t8.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.id_mark <>'D'
   and t8.job_cd ='ctmsf1'
  left join ${iml_schema}.pty_cap_cntpty_info t9 --交易对手视图（资金交易对手信息）
    on t9.cntpty_id = t8.cntpty_id
   and t9.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.id_mark <>'D'
   and t9.job_cd ='ctmsf1'
  left join ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee t10 --实际收付确认-承分销手续费
    on to_char(t10.deal_id) = substr(t2.main_asset_id, 5)
   and to_char(t10.uw_trade_id) = substr(t2.minor_asset_id, 5)
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.pty_cap_cntpty_info t11 --交易对手视图（资金交易对手信息）
    on (t11.cntpty_abbr = t10.cust_key or t11.cntpty_fname = t10.cust_key)
   and t11.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.id_mark <>'D'
   and t11.job_cd ='ctmsf1'
  left join ${iml_schema}.pty_cap_cntpty_info t12
    on replace(t1.cntpty_name,'(营运管理部)',' ') = nvl(trim(t12.cntpty_abbr),' ')
   and t12.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.id_mark <>'D'
   and t12.job_cd ='ctmsf1'
  left join ${iml_schema}.pty_cap_cntpty_info t13
    on to_char(t10.counterparty_seq) = t13.elec_cert_id
   and t13.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.id_mark <>'D'
   and t13.job_cd ='ctmsf1'	
 where substr(t1.subj_id,2,4) in ('6021', '6051', '6061') 
   and t1.stl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ctmsi1'
   and t1.dc_flg = '1'
   and t1.entry_def_id <>'1'   --过滤结转
;
commit; 

--第七组（共九组）资金系统中收-外币
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,acct_bill_flow_num                 --账单流水号
   ,tran_flow_num                      --交易流水号
   ,tran_dt                            --交易日期
   ,ova_flow_num                       --全局流水号
   ,bus_flow_num                       --业务流水号
   ,charge_doc_num                     --收费单据号
   ,charge_flow_num                    --收费流水号
   ,acct_dt                            --账务日期
   ,amort_flow_num                     --摊销流水号
   ,amort_start_dt	                   --摊销开始日期
   ,amort_end_dt	                     --摊销结束日期
   ,charge_dt	                         --收费日期
   ,subj_id                            --科目编号
   ,std_prod_id                        --标准产品编号
   ,cust_id                            --客户编号
   ,cust_name                          --客户名称
   ,bus_acct_id                        --业务账户编号
   ,intnal_acct_id                     --内部账户编号
   ,intnal_acct_name	                 --内部账户名称
   ,intnal_main_acct_id                --内部主账户编号
   ,tran_acct_id                       --交易账户编号
   ,tran_main_acct_id                  --交易主账户编号
   ,tran_sub_acct_id                   --交易子账户编号
   ,tran_chn_cd                        --交易渠道编号
   ,bal_dir_cd                         --余额方向代码
   ,sorc_sys_cd                        --来源系统编号
   ,cust_mgr_id                        --客户经理编号
   ,charge_cd                          --收费代码
   ,charge_name                        --收费名称
   ,charge_cate_cd                     --收费类别代码
   ,charge_way_cd                      --收费方式代码
   ,tran_type_cd                       --交易类型代码
   ,amort_flg                          --摊销标志
   ,debit_crdt_flg                     --借贷标志
   ,erase_acct_flg                     --抹账标志
   ,revs_flg                           --冲正标志
   ,tran_org_id                        --交易机构编号
   ,acct_instit_id                     --账务机构编号
   ,curr_cd                            --币种代码
   ,acm_amort_amt	                     --累计摊销金额
   ,amorted_tot_amt	                   --待摊总金额   
   ,tran_amt                           --交易金额
   ,recvbl_comm_fee_amt                --应收手续费金额
   ,tax_amt                            --税额
   ,at_amt                             --税后金额
   ,tran_remark_info                   --交易备注信息
   ,job_cd                             --任务代码
   ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,''                                                                            --账单流水号
       ,t1.entry_id                                                                   --交易流水号
       ,t1.stl_dt                                                                     --交易日期
       ,' '                                                                           --全局流水号
       ,t1.entry_id                                                                   --业务流水号
       ,t2.asset_bal_id                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t1.stl_dt																	                                    --账务日期
	     ,' '                                                                           --摊销流水号
       ,null	                                                                        --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,substr(t1.subj_id,2)                                                          --科目编号                                                                                   
       ,t2.std_prod_id                                                                --标准产品编号
       ,''                                                                            --客户编号
       ,''                                                                            --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道编号
       ,t1.debit_crdt_dir_cd                                                          --余额方向代码
       ,'CTMF'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,t2.std_prod_id                                                                --收费代码
       ,t3.sellbl_prod_name                                                           --收费名称
       ,t3.prod_gen_id                                                                --收费类别代码
       ,'0'                                                                           --收费方式代码
       ,'FEE1'                                                                        --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.debit_crdt_dir_cd                                                          --借贷标志
       ,''                                                                            --抹账标志
       ,''                                                                            --冲正标志
       ,t5.org_id                                                                     --交易机构编号	 
       ,t5.org_id                                                                     --账务机构编号
       ,t1.curr_cd                                                                    --币种代码
	     ,0	                                                                            --累计摊销金额
       ,0	                                                                            --待摊总金额
       ,nvl(t1.entry_amt,0)+nvl(t6.entry_amt,0)                                       --交易金额
       ,0                                                                             --应收手续费金额
       ,nvl(t6.entry_amt,0)                                                           --税额
       ,nvl(t1.entry_amt,0)                                                           --税后金额
       ,''                                                                            --交易备注信息
       ,'7'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iml_schema}.evt_cap_acct_ety t1
  left join ${iml_schema}.agt_fcurr_cap_asset_bal t2		
    on  t1.bal_dtl_id=t2.bal_dtl_id 
   and t1.stl_dt = t2.bus_dt
   and t2.bus_dt=to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ctmsi1' 
  left join ${iml_schema}.prd_prod_catlg_h t3		
    on t2.std_prod_id = t3.prod_id
   and t3.job_cd = 'ncbsf1'   
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')  
  left join (select subj_id as subj_id,
                    curr_cd as curr_cd,
                    core_org_id as org_id,
                    row_number() over(partition by subj_id, nvl(curr_cd,'CNY') order by subj_id, core_org_id) rn
               from ${iml_schema}.ref_fcurr_subj_map
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd='ctmsf1') t5
    on  t1.subj_id = t5.subj_id 
   and t1.curr_cd=t5.curr_cd 
   and t5.rn=1 
  left join ${iml_schema}.evt_cap_acct_ety t6
    on t1.entry_def_id = t6.entry_def_id  --事件
   and t1.stl_dt = t6.stl_dt --支付日期
   and t1.acct_b_id = t6.acct_b_id --投组id
   and t1.bal_dtl_id = t6.bal_dtl_id --资产变动id
   and substr(t6.subj_id, 2, 6) = '222102' --税额
   and t1.stl_dt = to_date('${batch_date}','yyyymmdd')
   and t6.dc_flg='0'
   and t6.job_cd='ctmsi1'
 where substr(t1.subj_id,2,4) in ('6021', '6051', '6061') 
   and t1.stl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd='ctmsi1'
   and t1.dc_flg='0'
   and t1.entry_def_id <>'1'   --过滤结转
;
commit; 

--第八组（共九组）资管系统中收
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,acct_bill_flow_num                 --账单流水号
   ,tran_flow_num                      --交易流水号
   ,tran_dt                            --交易日期
   ,ova_flow_num                       --全局流水号
   ,bus_flow_num                       --业务流水号
   ,charge_doc_num                     --收费单据号
   ,charge_flow_num                    --收费流水号
   ,acct_dt                            --账务日期
   ,amort_flow_num                     --摊销流水号
   ,amort_start_dt	                   --摊销开始日期
   ,amort_end_dt	                     --摊销结束日期
   ,charge_dt	                         --收费日期
   ,subj_id                            --科目编号
   ,std_prod_id                        --标准产品编号
   ,cust_id                            --客户编号
   ,cust_name                          --客户名称
   ,bus_acct_id                        --业务账户编号
   ,intnal_acct_id                     --内部账户编号
   ,intnal_acct_name	                 --内部账户名称
   ,intnal_main_acct_id                --内部主账户编号
   ,tran_acct_id                       --交易账户编号
   ,tran_main_acct_id                  --交易主账户编号
   ,tran_sub_acct_id                   --交易子账户编号
   ,tran_chn_cd                        --交易渠道编号
   ,bal_dir_cd                         --余额方向代码
   ,sorc_sys_cd                        --来源系统编号
   ,cust_mgr_id                        --客户经理编号
   ,charge_cd                          --收费代码
   ,charge_name                        --收费名称
   ,charge_cate_cd                     --收费类别代码
   ,charge_way_cd                      --收费方式代码
   ,tran_type_cd                       --交易类型代码
   ,amort_flg                          --摊销标志
   ,debit_crdt_flg                     --借贷标志
   ,erase_acct_flg                     --抹账标志
   ,revs_flg                           --冲正标志
   ,tran_org_id                        --交易机构编号
   ,acct_instit_id                     --账务机构编号
   ,curr_cd                            --币种代码
   ,acm_amort_amt	                     --累计摊销金额
   ,amorted_tot_amt	                   --待摊总金额   
   ,tran_amt                           --交易金额
   ,recvbl_comm_fee_amt                --应收手续费金额
   ,tax_amt                            --税额
   ,at_amt                             --税后金额
   ,tran_remark_info                   --交易备注信息
   ,job_cd                             --任务代码
   ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,''                                                                            --账单流水号
       ,t2.vouch_num                                                                  --交易流水号
       ,t2.happen_date                                                                --交易日期
       ,' '                                                                           --全局流水号
       ,t2.trade_id                                                                   --业务流水号
       ,t2.vouch_subnum                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t2.happen_date																	                              --账务日期
	     ,' '                                                                           --摊销流水号
       ,null	                                                                        --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,t2.subject_no                                                                 --科目编号                                                                                   
       ,t2.detail_subject_no                                                          --标准产品编号
       ,''                                                                            --客户编号
       ,''                                                                            --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --内部账户编号
       ,''                                                                            --内部账户名称
       ,''                                                                            --内部主账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道编号
       ,t2.cd_flag                                                                    --余额方向代码
       ,'FAMS'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,t2.detail_subject_no                                                          --收费代码
       ,t5.sellbl_prod_name                                                           --收费名称
       ,t5.prod_gen_id                                                                --收费类别代码
       ,'0'                                                                           --收费方式代码
       ,'FEE1'                                                                        --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t2.cd_flag                                                                    --借贷标志
       ,''                                                                            --抹账标志
       ,t1.offset_flag                                                                --冲正标志
       ,t3.entry_org_id                                                               --交易机构编号	 
       ,t3.entry_org_id                                                               --账务机构编号
       ,t2.ccy                                                                        --币种代码
	     ,0	                                                                            --累计摊销金额
       ,0	                                                                            --待摊总金额
       ,nvl(t2.happen_amt,0)+nvl(t4.happen_amt,0)                                     --交易金额
       ,0                                                                             --应收手续费金额
       ,nvl(t4.happen_amt,0)                                                          --税额
       ,nvl(t2.happen_amt,0)                                                          --税后金额
       ,t1.vouch_remark                                                               --交易备注信息
       ,'8'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.fams_ban_account_main t1
 inner join ${iol_schema}.fams_ban_account_detail t2
    on t1.vouch_num = t2.vouch_num
   and t1.book_date = t2.happen_date
   and substr(t2.subject_no,1,4) in ('6021', '6051', '6061')
   and t2.happen_amt <> 0
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')	
  left join ${iml_schema}.fin_am_subj_info t3
    on t2.subject_no = t3.subj_id
   and t3.tepla_sob_id = '00000000000000000006'
   and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.job_cd='famsf2'
   and t3.id_mark<>'D'
  left join ${iol_schema}.fams_ban_account_detail t4
    on t2.vouch_num = t4.vouch_num
   and substr(t4.subject_no,1,6) = '222102' --税额
   and t4.happen_date=to_date('${batch_date}','yyyymmdd')
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.prd_prod_catlg_h t5		
    on t2.detail_subject_no = t5.prod_id
   and t5.job_cd = 'ncbsf1'   
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.approve_status = '03'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.book_date=to_date('${batch_date}','yyyymmdd')
;
commit; 

--第九组（共九组）智能报销中收
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,acct_bill_flow_num                 --账单流水号
   ,tran_flow_num                      --交易流水号
   ,tran_dt                            --交易日期
   ,ova_flow_num                       --全局流水号
   ,bus_flow_num                       --业务流水号
   ,charge_doc_num                     --收费单据号
   ,charge_flow_num                    --收费流水号
   ,acct_dt                            --账务日期
   ,amort_flow_num                     --摊销流水号
   ,amort_start_dt	                   --摊销开始日期
   ,amort_end_dt	                     --摊销结束日期
   ,charge_dt	                         --收费日期
   ,subj_id                            --科目编号
   ,std_prod_id                        --标准产品编号
   ,cust_id                            --客户编号
   ,cust_name                          --客户名称
   ,bus_acct_id                        --业务账户编号
   ,intnal_acct_id                     --内部账户编号
   ,intnal_acct_name	                 --内部账户名称
   ,intnal_main_acct_id                --内部主账户编号
   ,tran_acct_id                       --交易账户编号
   ,tran_main_acct_id                  --交易主账户编号
   ,tran_sub_acct_id                   --交易子账户编号
   ,tran_chn_cd                        --交易渠道编号
   ,bal_dir_cd                         --余额方向代码
   ,sorc_sys_cd                        --来源系统编号
   ,cust_mgr_id                        --客户经理编号
   ,charge_cd                          --收费代码
   ,charge_name                        --收费名称
   ,charge_cate_cd                     --收费类别代码
   ,charge_way_cd                      --收费方式代码
   ,tran_type_cd                       --交易类型代码
   ,amort_flg                          --摊销标志
   ,debit_crdt_flg                     --借贷标志
   ,erase_acct_flg                     --抹账标志
   ,revs_flg                           --冲正标志
   ,tran_org_id                        --交易机构编号
   ,acct_instit_id                     --账务机构编号
   ,curr_cd                            --币种代码
   ,acm_amort_amt	                     --累计摊销金额
   ,amorted_tot_amt	                   --待摊总金额   
   ,tran_amt                           --交易金额
   ,recvbl_comm_fee_amt                --应收手续费金额
   ,tax_amt                            --税额
   ,at_amt                             --税后金额
   ,tran_remark_info                   --交易备注信息
   ,job_cd                             --任务代码
   ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期										
       ,'9999' as lp_id                                                               --法人编号										
       ,''                                                                                   --账单流水号									
       ,to_char(t1.nov)||to_char(t1.detailindex)                                      --交易流水号										
       ,to_date(substr(t2.tallydate, 1, 10),'yyyy-mm-dd')                                      --交易日期										
       ,t1.free8                                                                      --全局流水号										
       ,to_char(t1.nov)||to_char(t1.detailindex)                                      --业务流水号										
       ,to_char(t1.nov)                                                               --收费单据号										
       ,' '                                                                           --收费流水号										
       ,substr(t2.tallydate,1,10)										                    --账务日期
	     ,' '                                                                           --摊销流水号									
       ,null	                                                                        --摊销开始日期									
       ,null                                                                          --摊销结束日期										
       ,null                                                                          --收费日期										
       ,t1.accountcode                                                                --科目编号										
       ,'999999999999'                                                                --标准产品编号										
       ,t8.cust_id                                                                      --客户编号										
       ,t7.freevalue7                                                                        --客户名称										
       ,t7.freevalue4                                                                       --业务账户编号										
       ,''                                                                            --内部账户编号										
       ,''                                                                            --内部账户名称										
       ,''                                                                            --内部主账户编号										
       ,''                                                                            --交易账户编号										
       ,''                                                                            --交易主账户编号										
       ,''                                                                            --交易子账户编号										
       ,'901001'                                                                      --交易渠道编号										
       ,''                                                                                --余额方向代码										
       ,'IERS'                                                                        --来源系统编号										
       ,' '                                                                           --客户经理编号										
       ,''                                                                              --收费代码										
       ,''                                                                              --收费名称										
       ,''                                                                              --收费类别代码										
       ,'0'                                                                           --收费方式代码										
       ,'FEEO1'                                                                       --交易类型代码										
       ,'0'                                                                           --摊销标志										
       ,t1.direction                                                                  --借贷标志										
       ,' '                                                                           --抹账标志										
       ,'-'                                                                           --冲正标志										
       ,t6.code                                                                       --交易机构编号										
       ,t4.code                                                                       --账务机构编号										
       ,t3.code                                                                       --币种代码										
	     ,0	                                                                            --累计摊销金额								
       ,0	                                                                            --待摊总金额									
       ,(case when t1.direction='D' then nvl(t1.localdebitamount,0)-nvl(t1.localcreditamount,0) else nvl(t1.localcreditamount,0)-nvl(t1.localdebitamount,0) end)  --交易金额										
       ,''                                                                              --应收手续费金额										
       ,''                                                                              --税额										
       ,''                                                                              --税后金额										
       ,''                                                                              --交易备注信息										
       ,'9'                                                                           --任务代码										
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间		
 from ${iol_schema}.iers_gl_detail t1
inner join ${iol_schema}.iers_gl_voucher t2
   on  t1.pk_voucher = t2.pk_voucher --凭证主键
  and t2.dr = 0 --删除标志
  and substr(t2.tallydate, 1, 10) = to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd')  --记账日期
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.iers_bd_currtype t3
   on t1.pk_currtype = t3.pk_currtype
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.iers_org_orgs t4
   on t1.pk_unit = t4.pk_org
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.iers_gl_freevalue t5
   on t1.assid = t5.freevalueid
  and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.iers_org_dept t6
   on substr(t5.typevalue1, 21, 41) = t6.pk_dept
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.iers_gl_dtlfreevalue t7
     on t1.pk_detail  = t7.pk_detail
  and t7.etl_dt = to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_loan_dubil_info_h t8
   on t7.freevalue4=t8.dubil_id
 and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t8.end_dt > to_date('${batch_date}','yyyymmdd')
 and t8.job_cd = 'icmsf1'
 left join ${iml_schema}.pty_cust t9
   on t9.party_id=t8.cust_id
  and t9.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t9.id_mark <> 'D'
  and t9.job_cd = 'eifsf1' 
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.dr = 0 --删除标志
  and substr(t1.accountcode, 1, 4) in ('6021','6051','6061')
--  and substr(t1.ts, 1, 10) = to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd') --交易日期
  and t2.pk_vouchertype <> '1001A1100000000K5NZZ'
;
commit; 

--第十组（共十组）结售汇损益数据
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_inco_dtl_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,acct_bill_flow_num                 --账单流水号
   ,tran_flow_num                      --交易流水号
   ,tran_dt                            --交易日期
   ,ova_flow_num                       --全局流水号
   ,bus_flow_num                       --业务流水号
   ,charge_doc_num                     --收费单据号
   ,charge_flow_num                    --收费流水号
   ,acct_dt                            --账务日期
   ,amort_flow_num                     --摊销流水号
   ,amort_start_dt	                   --摊销开始日期
   ,amort_end_dt	                     --摊销结束日期
   ,charge_dt	                         --收费日期
   ,subj_id                            --科目编号
   ,std_prod_id                        --标准产品编号
   ,cust_id                            --客户编号
   ,cust_name                          --客户名称
   ,bus_acct_id                        --业务账户编号
   ,intnal_acct_id                     --内部账户编号
   ,intnal_acct_name	                 --内部账户名称
   ,intnal_main_acct_id                --内部主账户编号
   ,tran_acct_id                       --交易账户编号
   ,tran_main_acct_id                  --交易主账户编号
   ,tran_sub_acct_id                   --交易子账户编号
   ,tran_chn_cd                        --交易渠道编号
   ,bal_dir_cd                         --余额方向代码
   ,sorc_sys_cd                        --来源系统编号
   ,cust_mgr_id                        --客户经理编号
   ,charge_cd                          --收费代码
   ,charge_name                        --收费名称
   ,charge_cate_cd                     --收费类别代码
   ,charge_way_cd                      --收费方式代码
   ,tran_type_cd                       --交易类型代码
   ,amort_flg                          --摊销标志
   ,debit_crdt_flg                     --借贷标志
   ,erase_acct_flg                     --抹账标志
   ,revs_flg                           --冲正标志
   ,tran_org_id                        --交易机构编号
   ,acct_instit_id                     --账务机构编号
   ,curr_cd                            --币种代码
   ,acm_amort_amt	                     --累计摊销金额
   ,amorted_tot_amt	                   --待摊总金额   
   ,tran_amt                           --交易金额
   ,recvbl_comm_fee_amt                --应收手续费金额
   ,tax_amt                            --税额
   ,at_amt                             --税后金额
   ,tran_remark_info                   --交易备注信息
   ,job_cd                             --任务代码
   ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd') -- 数据日期										
       ,'9999' as lp_id                     -- 法人编号	
       ,''                                  -- 账单流水号
       ,t1.sorc_sys_flow_num                -- 交易流水号
       ,t1.tran_dt                          -- 交易日期
       ,t1.ova_flow_num                     -- 全局流水号
       ,t1.sorc_sys_flow_num                -- 业务流水号
       ,t1.tran_flow_num||t1.sumos_seq_num  -- 收费单据号
       ,'-'                                 -- 收费流水号
       ,t1.tran_dt                          -- 账务日期
       ,'-'                                 -- 摊销流水号
       ,null                                -- 摊销开始日期
       ,null                                -- 摊销结束日期
       ,null                                -- 收费日期
       ,t1.subj_id                          -- 科目编号
       ,t1.sellbl_prod_id                   -- 标准产品编号
       ,''                                  -- 客户编号
       ,''                                  -- 客户名称
       ,t1.acct_id                          -- 业务账户编号
       ,''                                  -- 内部账户编号
       ,''                                  -- 内部账户名称
       ,''                                  -- 内部主账户编号
       ,''                                  -- 交易账户编号
       ,''                                  -- 交易主账户编号
       ,''                                  -- 交易子账户编号
       ,t1.chn_id                           -- 交易渠道编号
       ,t1.debit_crdt_dir_cd                -- 余额方向代码
       ,t1.bus_sys_id                       -- 来源系统编号
       ,''                                  -- 客户经理编号
       ,''                                  -- 收费代码
       ,t1.memo_descb                       -- 收费名称
       ,''                                  -- 收费类别代码
       ,''                                  -- 收费方式代码
       ,''                                  -- 交易类型代码
       ,'0'                                 -- 摊销标志
       ,t1.debit_crdt_dir_cd                -- 借贷标志
       ,''                                  -- 抹账标志
       ,''                                  -- 冲正标志
       ,t1.tran_org_id                      -- 交易机构编号
       ,t1.fin_org_id                       -- 账务机构编号
       ,t1.curr_cd                          -- 币种代码
       ,0                                   -- 累计摊销金额
       ,0                                   -- 待摊总金额
       ,t1.tran_amt                         -- 交易金额
       ,0                                   -- 应收手续费金额
       ,0                                   -- 税额
       ,case when t1.debit_crdt_dir_cd = 'C' then t1.tran_amt
             when t1.debit_crdt_dir_cd = 'D' then -1 * t1.tran_amt
          end -- 税后金额
       ,t1.memo_descb                       -- 交易备注信息
       ,'10'                                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  -- 数据处理时间
 from ${iml_schema}.evt_accti_midgrod_acct_ety t1
where t1.sob_id = '1' 
  and t1.memo_descb = '结售汇兑损益' 
  and substr(t1.subj_id,1,4) in (6021, 6051, 6061) 
  and t1.bus_sys_id = 'TGLS' 
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  ;
commit;  


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_inter_bus_inco_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_inter_bus_inco_dtl_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_inter_bus_inco_dtl_01 purge;
--drop table ${icl_schema}.cmm_inter_bus_inco_dtl_02 purge;
--drop table ${icl_schema}.cmm_inter_bus_inco_dtl_03 purge;
-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_inter_bus_inco_dtl',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
