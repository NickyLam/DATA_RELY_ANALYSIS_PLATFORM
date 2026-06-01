/*
Purpose:    共性加工层
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20250313 icl_cmm_inter_bus_expns_dtl
CreateDate: 20200519
Logs:       20240327 饶雅 新增模型
            饶雅 20240509
            1、修改第3组中间业务一次性支出交易流水t1与t2表的关联条件，去掉账套号关联
            2、调整 收费方式代码、交易渠道代码、冲正标志 的默认值处理逻辑
            3、修改字段标准产品编号得取数逻辑
            20240528 饶雅 1、调整资金系统那组数据的币种代码的取数逻辑 2、新增字段【业务账户编号】3、调整客户号的取数逻辑
            20240628 陈伟峰 1、新增字段【客户名称】
                            2、调整资金组及同业组的【客户编号】的取数逻辑
                            3、修改第2组和第3组T1表和T3表的关联条
           20240801 陈伟峰 调整第一组 中间业务手续费摊销流水的交易金额字段取数逻辑，从M层取
           20240830 谢宁 资金系统本币组别【客户编号】【客户名称】逻辑修改
           20240918 谢宁 新增【客户归属条线类型代码】字段,修改1,2,4,7组【客户编号】【客户名称】字段逻辑
           20241126 陈伟峰 调整同业部分取数范围，去除结转流水
           20250101 陈伟峰 调整同业部分取数范围，去除结转流水
           20250101 谢  宁 去除智能报销结转数据
           20250227 陈伟峰 调整第九组智能报销部分的【客户编号、客户名称、业务账户编号】的取数逻辑
           20251230 陈伟峰 调整智能报销部分的交易日期加工逻辑
           20260402 陈伟峰 调整第八组【客户归属条线类型代码】默认为'-'
		                       调整第二、三组【客户归属条线类型代码、客户编号、客户名称】加工逻辑，当核心通用流水有数据时，取核心通用流水对应字段，不再使用内部户兜底
		      
     

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_inter_bus_expns_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_inter_bus_expns_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_inter_bus_expns_dtl_ex purge;
drop table ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_01 purge;
drop table ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_02 purge;
drop table ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_03 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_inter_bus_expns_dtl_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_inter_bus_expns_dtl where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_01 nologging
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
   and sdp.intnal_prod_id = 'FEE'
   and sd.job_cd = 'tglsf1'
   and sd.start_dt <= to_date('${batch_date}','yyyymmdd')
   and sd.end_dt > to_date('${batch_date}','yyyymmdd')
 group by sdp.base_prod_id,sdp.intnal_prod_id;
 commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_02 nologging
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
    and substr(t.subj_id, 1, 4) in ('6421')
    and t.etl_dt = to_date('${batch_date}','yyyymmdd')
    and t.job_cd = 'tglsi1';
 commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_03 nologging
compress ${option_switch} for query high
as select ac.ova_flow_num,
                    ac.tran_dt,
                    ac.cust_id,
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
                    ac.cntpty_cust_id,
                    ac.cntpty_cust_name,
                    ac.cntpty_type_cd,
                    row_number() over(partition by ac.ova_flow_num,ac.charge_seq_num order by ac.tran_dt desc) as rn
               from ${iml_schema}.evt_charge_flow ac
              where  1 = 1
                and ac.job_cd = 'ncbsi1';
commit;

--第一组（共十组）中间业务手续费摊销流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
       etl_dt                              --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,t1.tran_flow_num                                                              --交易流水号
       ,t1.tran_dt                                                                    --交易日期
       ,t1.ova_flow_num                                                               --全局流水号
       ,t1.tran_flow_num                                                              --业务流水号
       ,t1.doc_id                                                                     --收费单据号
       ,t5.ova_flow_num                                                               --收费流水号
       ,t1.fin_dt                                                                     --账务日期
       ,t1.tran_flow_num                                                              --摊销流水号
       ,t4.amort_start_dt                                                             --摊销开始日期
       ,t4.amort_end_dt                                                               --摊销结束日期
       ,t5.tran_dt                                                                    --收费日期
       ,nvl(t3.itemcd, t31.itemcd)                                                    --科目编号
       ,nvl(t21.prod_id,'999999999999')                                               --标准产品编号
       ,coalesce(trim(t9.cust_type_cd),t5.cntpty_type_cd)                             --客户归属条线类型代码
       ,coalesce(t6.cust_id,trim(t5.cntpty_cust_id),trim(t5.cust_id),t4.cust_id)      --客户编号
       ,nvl(trim(t7.party_name),t5.cntpty_cust_name)                                  --客户名称
       ,case when t5.tran_dt < to_date('20230502','yyyymmdd') then decode(t4.bus_id,'*',' ',t4.bus_id)
             else t5.cntpty_cust_acct_num end                                         --业务账户编号
       ,t5.acct_id                                                                    --交易账户编号
       ,t5.cust_acct_num                                                              --交易主账户编号
       ,t5.sub_acct_num                                                               --交易子账户编号
       ,t1.tran_chn_id                                                                --交易渠道代码
       ,t1.bus_sys_id                                                                 --来源系统编号
       ,t5.tran_teller_id                                                             --客户经理编号
       ,nvl(trim(t5.comm_fee_coll_way_cd),0)                                          --收费方式代码
       ,t5.tran_cd                                                                    --交易类型代码
       ,'1'                                                                           --摊销标志
       ,''                                                                            --借贷标志
       ,''                                                                            --抹账标志
       ,t5.tran_revd_flg                                                              --冲正标志
       ,t1.tran_org_id                                                                --交易机构编号
       ,t4.acct_instit_id                                                             --账务机构编号
       ,t4.curr_cd                                                                    --币种代码
       ,nvl(t4.acm_amort_amt,0)                                                       --累计摊销金额
       ,nvl(t4.amorted_tot_amt,0)                                                     --待摊总金额
       ,nvl(t1.ths_tm_amort_amt,0)                                                    --交易金额
       ,'1'                                                                           --任务代码
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
  left join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_01 t3
   on nvl(t21.prod_id,t1.prod_id) = t3.base_prod_id
  and t3.intnal_prod_id = 'FEE'
  left join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_01 t31
   on nvl(t21.base_prod_id,t1.prod_id) = t31.base_prod_id
  and t31.intnal_prod_id = 'FEE'
 inner join ${iml_schema}.agt_inter_income_sub_acct_bal_h t4
   on t1.sob_id = t4.sob_id
  and t1.bus_sys_id = t4.bus_sys_id
  and t1.doc_id = t4.doc_id
  and t4.fin_dt = to_date('${batch_date}','yyyymmdd')
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  and t4.job_cd = 'tglsf1'
 /*left join ${iol_schema}.tgls_ama_mdsr_acct_h t8
   on t1.sob_id = t8.stacid
  and t1.bus_sys_id = t8.systid
  and t1.doc_id = t8.loanno
  and t8.datadt = '${batch_date}'
  and t8.etl_dt = to_date('${batch_date}','yyyymmdd')*/
 left join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_03 t5
   on t1.doc_id = t5.charge_seq_num
  and t5.rn = 1
 left join ${iml_schema}.agt_loan_dubil_info_h t6
   on case when t5.tran_dt < to_date('20230502','yyyymmdd') then decode(t4.bus_id,'*',' ',t4.bus_id)
      else t5.cntpty_cust_acct_num end = t6.dubil_id
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
  and t6.job_cd = 'icmsf1'
 left join ${iml_schema}.pty_party t7
   on t6.cust_id = t7.party_id
  and t7.etl_dt = to_date('${batch_date}','yyyymmdd')
  and t7.job_cd = 'eifsf1'
 left join ${iml_schema}.pty_cust t9
   on coalesce(t6.cust_id,trim(t5.cntpty_cust_id),trim(t5.cust_id),t4.cust_id) = t9.cust_id
  and t9.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t9.id_mark <> 'D'
  and t9.job_cd = 'eifsf1' 
where t1.sob_id = '2'
  and t1.fin_dt = to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'tglsi1'
  and substr(nvl(t3.itemcd, t31.itemcd),1,4)='6421'
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

--第二组（共十组）中间业务一次性收费交易流水    --历史表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
      etl_dt                              --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,t1.transq                                                                     --交易流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')                                          --交易日期
       ,t1.bsnssq                                                                     --全局流水号
       ,t1.transq                                                                     --业务流水号
       ,t1.serino                                                                     --收费单据号
       ,nvl(trim(t4.pre_accr_no),t3.ova_flow_num)                                    --收费流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')                                          --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,t3.tran_dt                                                                    --收费日期
       ,t2.itemcd                                                                     --科目编号
       ,t1.assis1                                                                     --标准产品编号
	   ,case when trim(t5.cntpty_type_cd) is not null and trim(t5.cntpty_name) is not null then t5.cntpty_type_cd
	         else coalesce(t8.cust_type_cd,trim(t4.oth_client_type),t3.cntpty_type_cd) end --客户归属条线类型代码
       ,case when t1.assis4='FEEIYT' then nvl(trim(t6.cntpty_cust_id), t1.custcd)
	         when trim(t5.cntpty_type_cd) is not null and trim(t5.cntpty_name) is not null then t5.cntpty_cust_acct_num
             else coalesce(trim(t3.cntpty_cust_id),trim(t4.oth_client_no),trim(t3.cust_id),t1.custcd) end --客户编号 (先计提后收费场景,则优先取费用计提明细表信息--其他场景，如果对手客户名称为空，优先取收费历史表信息）
       ,case when t1.assis4='FEEIYT' then t6.cntpty_cust_name
	         when trim(t5.cntpty_type_cd) is not null and trim(t5.cntpty_name) is not null then t5.cntpty_name
             else coalesce(t3.cntpty_cust_name,t4.oth_client_name) end                --客户名称
       ,nvl(trim(t3.cntpty_cust_acct_num),decode(t1.acctno,'BLANK',' ',ltrim(t1.acctno,'0')))  --业务账户编号
       ,t3.acct_id                                                                    --交易账户编号
       ,t3.cust_acct_num                                                              --交易主账户编号
       ,t3.sub_acct_num                                                               --交易子账户编号
       ,t1.assis0                                                                     --交易渠道代码
       ,t1.systid                                                                     --来源系统编号
       ,t3.tran_teller_id                                                             --客户经理编号
       ,case when trim(t3.comm_fee_coll_way_cd) is null then decode(t1.assis4,'FEEOYT','4','0') else decode(trim(t3.comm_fee_coll_way_cd),'-','0',nvl(trim(t3.comm_fee_coll_way_cd),'0')) end                                                       --收费方式代码
       ,nvl(trim(t3.tran_cd),t1.assis4)                                               --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t2.amntcd                                                                     --借贷标志
       ,''                                                                            --抹账标志
       ,t1.strkst                                                                     --冲正标志
       ,t1.tranbr                                                                     --交易机构编号
       ,t1.acctbr                                                                     --账务机构编号
       ,t1.crcycd                                                                     --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,t1.tranam                                                                     --交易金额
       ,'2'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.tgls_loan_busi_h t1
 inner join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_02 t2
    on t2.sourdt = t1.trandt
   and t2.soursq = t1.transq
   and t2.bsnssq = t1.bsnssq
   and t2.srvcsq = t1.serino
   and t2.stacid = t1.stacid
 left join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_03 t3
   on t1.bsnssq = t3.ova_flow_num
  and substr(t1.serino,-length(t3.charge_seq_num)) = t3.charge_seq_num
  and t3.rn = 1
 left join ${iol_schema}.ncbs_rb_serv_pre_accr t4
   on t1.transq = t4.reference
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.evt_core_comn_entry_flow t5
   on t1.transq = t5.tran_ref_no
  and t1.bsnssq = t5.ova_flow_num
  and t5.etl_dt = to_date('${batch_date}','yyyymmdd')
  and substr(t1.serino,7) = t5.tran_flow_num
  and t5.job_cd = 'ncbsi1'
 left join ${iml_schema}.agt_fee_provi_dtl t6
  on t1.bsnssq = t6.provi_flow_num
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
  and t6.job_cd = 'ncbsf1'
 left join ${iml_schema}.pty_cust t8
   on case when t1.assis4='FEEIYT' then nvl(trim(t6.cntpty_cust_id), t1.custcd)
      else coalesce(trim(t3.cntpty_cust_id),trim(t4.oth_client_no),trim(t3.cust_id),t1.custcd) end = t8.cust_id
  and t8.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.id_mark <> 'D'
  and t8.job_cd = 'eifsf1' 
where t1.stacid = 1
  and t1.trandt = '${batch_date}'
  and t1.prodcd <> 'FEE'
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

--第三组（共十组）中间业务一次性收费交易流水   --当前表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
       etl_dt                              --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,t1.transq                                                                     --交易流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')                                          --交易日期
       ,t1.bsnssq                                                                     --全局流水号
       ,t1.transq                                                                     --业务流水号
       ,t1.serino                                                                     --收费单据号
       ,nvl(trim(t4.pre_accr_no),t3.ova_flow_num)                                     --收费流水号
       ,to_date(trim(t1.trandt), 'yyyymmdd')                                          --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,t3.tran_dt                                                                    --收费日期
       ,t2.itemcd                                                                     --科目编号
       ,t1.assis1                                                                     --标准产品编号
	   ,case when trim(t5.cntpty_type_cd) is not null and trim(t5.cntpty_name) is not null then t5.cntpty_type_cd
	         else coalesce(t8.cust_type_cd,trim(t4.oth_client_type),t3.cntpty_type_cd) end --客户归属条线类型代码
       ,case when t1.assis4='FEEIYT' then nvl(trim(t6.cntpty_cust_id), t1.custcd)
	         when trim(t5.cntpty_type_cd) is not null and trim(t5.cntpty_name) is not null then t5.cntpty_cust_acct_num
             else coalesce(trim(t3.cntpty_cust_id),trim(t4.oth_client_no),trim(t3.cust_id),t1.custcd) end --客户编号 (先计提后收费场景,则优先取费用计提明细表信息--其他场景，如果对手客户名称为空，优先取收费历史表信息）
       ,case when t1.assis4='FEEIYT' then t6.cntpty_cust_name
	         when trim(t5.cntpty_type_cd) is not null and trim(t5.cntpty_name) is not null then t5.cntpty_name
             else coalesce(t3.cntpty_cust_name,t4.oth_client_name) end                --客户名称
       ,nvl(trim(t3.cntpty_cust_acct_num),decode(t1.acctno,'BLANK',' ',ltrim(t1.acctno,'0'))) --业务账户编号
       ,t3.acct_id                                                                    --交易账户编号
       ,t3.cust_acct_num                                                              --交易主账户编号
       ,t3.sub_acct_num                                                               --交易子账户编号
       ,t1.assis0                                                                     --交易渠道代码
       ,t1.systid                                                                     --来源系统编号
       ,t3.tran_teller_id                                                             --客户经理编号
       ,case when trim(t3.comm_fee_coll_way_cd) is null then decode(t1.assis4,'FEEOYT','4','0') else decode(trim(t3.comm_fee_coll_way_cd),'-','0',nvl(trim(t3.comm_fee_coll_way_cd),'0')) end                                                       --收费方式代码
       ,nvl(trim(t3.tran_cd),t1.assis4)                                               --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t2.amntcd                                                                     --借贷标志
       ,''                                                                            --抹账标志
       ,t1.strkst                                                                     --冲正标志
       ,t1.tranbr                                                                     --交易机构编号
       ,t1.acctbr                                                                     --账务机构编号
       ,t1.crcycd                                                                     --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,nvl(t1.tranam,0)                                                              --交易金额
       ,'3'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.tgls_loan_busi t1
 inner join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_02 t2
    on t2.sourdt = t1.trandt
   and t2.soursq = t1.transq
   and t2.bsnssq = t1.bsnssq
   and t2.srvcsq = t1.serino
  left join ${icl_schema}.tmp_cmm_inter_bus_expns_dtl_03 t3
    on t1.bsnssq = t3.ova_flow_num
   and substr(t1.serino,-length(t3.charge_seq_num)) = t3.charge_seq_num
   and t3.rn = 1
  left join ${iol_schema}.ncbs_rb_serv_pre_accr t4
   on t1.transq = t4.reference
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.evt_core_comn_entry_flow t5
   on t1.transq = t5.tran_ref_no
  and t1.bsnssq = t5.ova_flow_num
  and t5.etl_dt = to_date('${batch_date}','yyyymmdd')
  and substr(t1.serino,7) = t5.tran_flow_num
  and t5.job_cd = 'ncbsi1'
  left join ${iml_schema}.agt_fee_provi_dtl t6
    on t1.bsnssq=t6.provi_flow_num
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'
  left join ${iml_schema}.pty_cust t8
   on case when t1.assis4 = 'FEEIYT' then nvl(trim(t6.cntpty_cust_id), t1.custcd)
                     else coalesce(trim(t3.cntpty_cust_id),trim(t4.oth_client_no),trim(t3.cust_id),t1.custcd) end = t8.cust_id
  and t8.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.id_mark <> 'D'
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
                      and tt.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                      and tt.prodcd <> 'FEE')
;
commit;


--第四组（共十组）同业系统支出
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
      etl_dt                              --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,t1.task_id||t1.vouch_id||t1.chg_id                                            --交易流水号
       ,t1.vouch_dt                                                                   --交易日期
       ,' '                                                                           --全局流水号
       ,t1.entry_flow_num                                                             --业务流水号
       ,t1.accti_obj_id                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t1.vouch_dt                                                                   --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,t1.subj_id                                                                    --科目编号
       ,t1.prod_id                                                                    --标准产品编号
       ,t10.cust_type_cd                                                              --客户归属条线类型代码
       ,case when nvl(t1.manual_vouch_flg,'-1') = '1' then t9.cust_id else t6.cust_id end --客户编号
       ,case when nvl(t1.manual_vouch_flg,'-1') = '1' then nvl(trim(t9.party_fname),t9.party_name)
        else nvl(trim(t6.party_fname),t6.party_name) end                              --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道代码
       ,'IBMS'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,'0'                                                                           --收费方式代码
       ,'FEEO1'                                                                       --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.debit_crdt_dir_cd                                                          --借贷标志
       ,t1.rbw_flg_cd                                                                 --抹账标志
       ,t1.rbw_flg_cd                                                                 --冲正标志
       ,t1.bus_org_id                                                                 --交易机构编号
       ,t1.entry_org_id                                                               --账务机构编号
       ,t1.curr_cd                                                                    --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,nvl(t1.entry_amt,0) + nvl(t1.tax_fee,0)                                       --交易金额
       ,'4'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iml_schema}.evt_ibank_acct_ety_evt t1
  left join ${iml_schema}.agt_secu_acct_accti_bal_h t3
    on t1.accti_obj_id = t3.obj_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd ='ibmsf1'
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
   and t5.job_cd ='ibmsf1'
  left join ${iml_schema}.pty_ibank_cntpty_info t6 --客户信息及机构表(同业交易对手信息)
    on nvl(t4.cntpty_id,t5.issue_org_id) = t6.src_party_id
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
  left join ${iml_schema}.pty_cust t10
   on case when nvl(t1.manual_vouch_flg,'-1') = '1' then t9.cust_id else t6.cust_id end = t10.cust_id
  and t10.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t10.id_mark <> 'D'
  and t10.job_cd = 'eifsf1'
 where t1.vouch_dt = to_date('${batch_date}','yyyymmdd')
   and substr(t1.subj_id,1,4) in ('6421')
   and t1.job_cd = 'ibmsi1'
   and t1.etl_dt  = to_date('${batch_date}','yyyymmdd')
   and t1.entry_type_cd <>'B'
;
commit;


--第五组（共十组）资金系统中收-本币
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
      etl_dt                              --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,t1.entry_id                                                                   --交易流水号
       ,t1.stl_dt                                                                     --交易日期
       ,' '                                                                           --全局流水号
       ,t1.entry_id                                                                   --业务流水号
       ,t2.asset_bal_id                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t1.stl_dt                                                                     --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,substr(t1.subj_id,2)                                                          --科目编号
       ,t2.std_prod_id                                                                --标准产品编号
       ,t16.cust_type_cd                                                              --客户归属条线类型代码
       ,case when t1.entry_def_id = '0' then t12.cust_id
             when t13.cust_id is not null then t13.cust_id
        else nvl(trim(t9.cust_id), t11.cust_id) end                                   --客户编号
       ,case when t1.entry_def_id = '0' then nvl(t12.cntpty_fname,t1.cntpty_name)
             when t13.cust_id is not null then nvl(t13.cntpty_fname,t10.cust_key)
        else coalesce(trim(t9.cntpty_fname),trim(t8.cntpty_name),trim(t11.cntpty_fname),t10.cust_key) end   --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道代码
       ,'CTMT'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,'0'                                                                           --收费方式代码
       ,'FEEO1'                                                                       --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.debit_crdt_dir_cd                                                          --借贷标志
       ,''                                                                            --抹账标志
       ,'-'                                                                           --冲正标志
       ,t4.departmentid                                                               --交易机构编号
       ,t5.org_id                                                                     --账务机构编号
       ,nvl(t4.currency,'CNY')                                                        --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,nvl(t1.entry_amt,0)                                                           --交易金额
       ,'5'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iml_schema}.evt_cap_acct_ety t1
  left join ${iml_schema}.agt_cap_asset_bal t2
    on  t1.entry_grouping_id=t2.bal_dtl_id
   and t1.stl_dt = t2.stl_dt
   and t2.create_dt<=to_date('${batch_date}','yyyymmdd')
   and t2.id_mark<>'D'
   and t2.job_cd = 'ctmsf1'
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t4
    on t1.acct_b_id = t4.keepfolder_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.ref_dc_subj_map t5
    on t1.subj_id = t5.subj_id
   and t1.dept_id=t5.dept_id
   and t4.departmentid = t5.bus_dept_id
   and t5.job_cd = 'ctmsf1'
  left join (select  wtrade_lend_id_grand    as wtrade_lend_id_grand
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
   left join ${iml_schema}.pty_cust t16
   on case when t1.entry_def_id = '0' then t12.cust_id
             when t13.cust_id is not null then t13.cust_id
        else nvl(trim(t9.cust_id), t11.cust_id) end = t16.cust_id
  and t16.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t16.id_mark <> 'D'
  and t16.job_cd = 'eifsf1'
 where substr(t1.subj_id,2,4) in ('6421')
   and t1.stl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ctmsi1'
   and t1.dc_flg = '1'
   and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.entry_def_id <>'1'   --过滤结转
;
commit;

--第六组（共十组）资金系统中收-外币
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
   etl_dt                                  --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,t1.entry_id                                                                   --交易流水号
       ,t1.stl_dt                                                                     --交易日期
       ,' '                                                                           --全局流水号
       ,t1.entry_id                                                                   --业务流水号
       ,t2.asset_bal_id                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t1.stl_dt                                                                     --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,substr(t1.subj_id,2)                                                          --科目编号
       ,t2.std_prod_id                                                                --标准产品编号
       ,'3'                                                                           --客户归属条线类型代码
       ,''                                                                            --客户编号
       ,''                                                                            --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道代码
       ,'CTMF'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,'0'                                                                           --收费方式代码
       ,'FEEO1'                                                                       --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.debit_crdt_dir_cd                                                          --借贷标志
       ,''                                                                            --抹账标志
       ,'-'                                                                           --冲正标志
       ,t5.org_id                                                                     --交易机构编号
       ,t5.org_id                                                                     --账务机构编号
       ,t1.curr_cd                                                                    --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,nvl(t1.entry_amt,0)                                                           --交易金额
       ,'6'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iml_schema}.evt_cap_acct_ety t1
  left join ${iml_schema}.agt_fcurr_cap_asset_bal t2
    on t1.bal_dtl_id=t2.bal_dtl_id
   and t1.stl_dt = t2.bus_dt
   and t2.bus_dt=to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ctmsi1'
  left join (select subj_id as subj_id,
                    curr_cd as curr_cd,
                    core_org_id as org_id,
                    row_number() over(partition by subj_id, nvl(curr_cd,'CNY') order by subj_id, core_org_id) rn
               from ${iml_schema}.ref_fcurr_subj_map
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'ctmsf1') t5
    on  t1.subj_id = t5.subj_id
   and t1.curr_cd=t5.curr_cd
   and t5.rn=1
 where substr(t1.subj_id,2,4) in ('6421')
   and t1.stl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd='ctmsi1'
   and t1.dc_flg='0'
   and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.entry_def_id <>'1'   --过滤结转
;
commit;

--第七组（共十组）资管系统支出
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
        etl_dt                            --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,t2.vouch_num                                                                  --交易流水号
       ,t2.happen_date                                                                --交易日期
       ,' '                                                                           --全局流水号
       ,t2.trade_id                                                                   --业务流水号
       ,t2.vouch_subnum                                                               --收费单据号
       ,''                                                                            --收费流水号
       ,t2.happen_date                                                                --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,t2.subject_no                                                                 --科目编号
       ,t2.detail_subject_no                                                          --标准产品编号
       ,''                                                                            --客户归属条线类型代码
       ,''                                                                            --客户编号
       ,t1.customer_name                                                              --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道代码
       ,'FAMS'                                                                        --来源系统编号
       ,''                                                                            --客户经理编号
       ,'0'                                                                           --收费方式代码
       ,'FEEO1'                                                                       --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t2.cd_flag                                                                    --借贷标志
       ,''                                                                            --抹账标志
       ,t1.offset_flag                                                                --冲正标志
       ,t3.entry_org_id                                                               --交易机构编号
       ,t3.entry_org_id                                                               --账务机构编号
       ,t2.ccy                                                                        --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,nvl(t2.happen_amt,0)                                                          --交易金额
       ,'7'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.fams_ban_account_main t1
 inner join ${iol_schema}.fams_ban_account_detail t2
    on t1.vouch_num = t2.vouch_num
   and t1.book_date = t2.happen_date
   and substr(t2.subject_no,1,4) in ('6421')
   and t2.happen_amt<>0
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.fin_am_subj_info t3
   on  t2.subject_no = t3.subj_id
  and t3.tepla_sob_id = '00000000000000000006'
  and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.job_cd='famsf2'
  and t3.id_mark<>'D'
where t1.approve_status = '03'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.book_date=to_date('${batch_date}','yyyymmdd')
;
commit;

--第八组（共十组）联合存、联合贷支出

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
        etl_dt                            --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,t1.soursq                                                                     --交易流水号
       ,t1.sourdt                                                                     --交易日期
       ,t1.bsnssq                                                                     --全局流水号
       ,t1.soursq                                                                     --业务流水号
       ,t1.vchrsq                                                                     --收费单据号
       ,' '                                                                           --收费流水号
       ,t1.sourdt                                                                     --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,t1.itemcd                                                                     --科目编号
       ,t1.prducd                                                                     --标准产品编号
       ,'-'                                                                           --客户归属条线类型代码
       ,''                                                                            --客户编号
       ,''                                                                            --客户名称
       ,''                                                                            --业务账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,t1.assis0                                                                     --交易渠道代码
       ,'ICMS'                                                                        --来源系统编号
       ,' '                                                                           --客户经理编号
       ,'0'                                                                           --收费方式代码
       ,'FEEO1'                                                                       --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.amntcd                                                                     --借贷标志
       ,''                                                                            --抹账标志
       ,t1.chrex4                                                                     --冲正标志
       ,t1.tranbr                                                                     --交易机构编号
       ,t1.acctbr                                                                     --账务机构编号
       ,t1.crcycd                                                                     --币种代码
       ,0                                                                             --累计摊销金额
       ,0                                                                             --待摊总金额
       ,nvl(t1.tranam,0)                                                              --交易金额
       ,'8'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp  --数据处理时间
  from ${iol_schema}.icms_lhd_accounting_hsfile t1
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and to_date(t1.sourdt,'yyyymmdd')=to_date('${batch_date}','yyyymmdd')
   and SUBSTR(t1.itemcd,1,4)='6421'
;
commit;


--第九组（共十组）来自自智能报销系统

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_inter_bus_expns_dtl_ex(
        etl_dt                            --数据日期
       ,lp_id                              --法人编号
       ,tran_flow_num                      --交易流水号
       ,tran_dt                            --交易日期
       ,ova_flow_num                       --全局流水号
       ,bus_flow_num                       --业务流水号
       ,charge_doc_num                     --收费单据号
       ,charge_flow_num                    --收费流水号
       ,acct_dt                            --账务日期
       ,amort_flow_num                     --摊销流水号
       ,amort_start_dt                     --摊销开始日期
       ,amort_end_dt                       --摊销结束日期
       ,charge_dt                          --收费日期
       ,subj_id                            --科目编号
       ,std_prod_id                        --标准产品编号
       ,cust_belong_bus_type_cd            --客户归属条线类型代码
       ,cust_id                            --客户编号
       ,cust_name                          --客户名称
       ,bus_acct_id                        --业务账户编号
       ,tran_acct_id                       --交易账户编号
       ,tran_main_acct_id                  --交易主账户编号
       ,tran_sub_acct_id                   --交易子账户编号
       ,tran_chn_cd                        --交易渠道代码
       ,sorc_sys_cd                        --来源系统编号
       ,cust_mgr_id                        --客户经理编号
       ,charge_way_cd                      --收费方式代码
       ,tran_type_cd                       --交易类型代码
       ,amort_flg                          --摊销标志
       ,debit_crdt_flg                     --借贷标志
       ,erase_acct_flg                     --抹账标志
       ,revs_flg                           --冲正标志
       ,tran_org_id                        --交易机构编号
       ,acct_instit_id                     --账务机构编号
       ,curr_cd                            --币种代码
       ,acm_amort_amt                      --累计摊销金额
       ,amorted_tot_amt                    --待摊总金额
       ,tran_amt                           --交易金额
       ,job_cd                             --任务代码
       ,etl_timestamp                      --数据处理时间
)
select
       to_date('${batch_date}', 'yyyymmdd')                                           --数据日期
       ,'9999' as lp_id                                                               --法人编号
       ,to_char(t1.nov)||to_char(t1.detailindex)                                      --交易流水号
       ,to_date(substr(t2.tallydate, 1, 10),'yyyy-mm-dd')                             --交易日期
       ,t1.free8                                                                      --全局流水号
       ,to_char(t1.nov)||to_char(t1.detailindex)                                      --业务流水号
       ,to_char(t1.nov)                                                               --收费单据号
       ,' '                                                                           --收费流水号
       ,substr(t2.tallydate,1,10)                                                     --账务日期
       ,' '                                                                           --摊销流水号
       ,null                                                                          --摊销开始日期
       ,null                                                                          --摊销结束日期
       ,null                                                                          --收费日期
       ,t1.accountcode                                                                --科目编号
       ,'999999999999'                                                                --标准产品编号
       ,t9.cust_type_cd                                                               --客户归属条线类型代码
       ,t8.cust_id                                                                    --客户编号
       ,t7.freevalue7                                                                 --客户名称
       ,t7.freevalue4                                                                 --业务账户编号
       ,''                                                                            --交易账户编号
       ,''                                                                            --交易主账户编号
       ,''                                                                            --交易子账户编号
       ,'901001'                                                                      --交易渠道代码
       ,'IERS'                                                                        --来源系统编号
       ,' '                                                                           --客户经理编号
       ,'0'                                                                           --收费方式代码
       ,'FEEO1'                                                                       --交易类型代码
       ,'0'                                                                           --摊销标志
       ,t1.direction                                                                  --借贷标志
       ,' '                                                                           --抹账标志
       ,'-'                                                                           --冲正标志
       ,t6.code                                                                       --交易机构编号
       ,t4.code                                                                       --账务机构编号
       ,t3.code                                                                       --币种代码
      ,0                                                                              --累计摊销金额
       ,0                                                                             --待摊总金额
       ,(case when t1.direction='D' then nvl(t1.localdebitamount,0)-nvl(t1.localcreditamount,0) else nvl(t1.localcreditamount,0)-nvl(t1.localdebitamount,0) end)  --交易金额
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
  and substr(t1.accountcode, 1, 4) = '6421'
--  and substr(t1.ts, 1, 10) = to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd') --交易日期
  and t2.pk_vouchertype <> '1001A1100000000K5NZZ'
;
commit;



-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_inter_bus_expns_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_inter_bus_expns_dtl_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_inter_bus_expns_dtl_01 purge;
--drop table ${icl_schema}.cmm_inter_bus_expns_dtl_02 purge;
--drop table ${icl_schema}.cmm_inter_bus_expns_dtl_03 purge;
-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_inter_bus_expns_dtl',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
