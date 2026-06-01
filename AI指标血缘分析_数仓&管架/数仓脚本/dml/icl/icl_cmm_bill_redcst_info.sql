/*
Purpose:    共性加工层-票据再贴现信息
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_bill_redcst_info
Createdate: 20220505
Logs:       新票据脚本创建
            20230104 温旺清 调整临时表T6的关联条件
		        20240920 陈伟峰 新增字段【利息收入科目编号】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bill_redcst_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bill_redcst_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bill_redcst_info_ex purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_bill_redcst_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_bill_redcst_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_redcst_info_ex(
   etl_dt                --数据日期
  ,lp_id                 --法人编号
  ,bus_id                --业务编号
  ,batch_id              --批次编号
  ,std_prod_id           --标准产品编号
  ,bill_id               --票据编号
  ,bill_num              --票据号码
  ,bill_sub_intrv_id     --票据子区间号
  ,subj_id               --科目编号
  ,int_adj_subj_id       --利息调整科目编号
  ,int_income_subj_id    --利息收入科目编号
  ,batch_no_code         --批次号码
  ,ctr_nt_id             --成交单编号
  ,bill_prod_id          --票据产品编号
  ,bill_med_cd           --票据介质代码
  ,bill_kind_cd          --票据种类代码
  ,draw_dt               --出票日期
  ,exp_dt                --到期日期
  ,actl_exp_dt           --实际到期日期
  ,bus_dt                --业务日期
  ,appl_dt               --申请日期
  ,stl_dt                --结算日期
  ,repo_dt               --回购日期
  ,bag_dt				         --成交日期
  ,bag_tm				         --成交时间
  ,curr_cd               --币种代码
  ,fac_val_amt           --票面金额
  ,stl_amt               --结算金额
  ,repo_amt              --回购金额
  ,int_amt               --利息金额
  ,discnt_int_rat        --贴现利率
  ,currt_bal             --当期余额
  ,int_adj_bal           --利息调整余额
  ,td_acru_int           --当日应计利息
  ,currt_acru_int        --当期应计利息
  ,bus_type_cd           --业务类型代码
  ,cntpty_id             --交易对手编号
  ,cntpty_name           --交易对手名称
  ,cntpty_bank_no        --交易对手行号
  ,cntpty_cate_cd        --交易对手类别代码
  ,cntpty_type_cd        --交易对手类型代码
  ,hxb_acpt_flg          --我行承兑标志
  ,bill_src_cd           --票据来源代码
  ,stl_way_cd            --结算方式代码
  ,discount_bill_flg     --转贴票据标志
  ,remote_bill_flg       --异地票据标志
  ,acrd_policy_flg       --符合政策标志
  ,refuse_flg            --拒绝标志
  ,hold_days             --持票天数
  ,defer_days            --顺延天数
  ,valid_flg             --有效标志
  ,bus_status_cd         --业务状态代码
  ,entry_status_cd       --记账状态代码
  ,lmt_status_cd         --额度状态代码
  ,cust_mgr_id           --客户经理编号
  ,dept_id               --部门编号
  ,bus_org_id            --业务机构编号
  ,acct_instit_id        --账务机构编号
  ,rgst_teller_id        --登记柜员编号
  ,recver_org_id         --收款方机构编号
  ,recver_trust_acct_num --收款方托管账户编号
  ,recver_trust_acct_name--收款方托管账户名称
  ,recver_bank_no        --收款方银行行号
  ,recver_bank_name      --收款方银行名称
  ,payer_org_id          --付款方机构编号
  ,payer_trust_acct_num  --付款方托管账户编号
  ,payer_trust_acct_name --付款方托管账户名称
  ,payer_bank_no         --付款方银行行号
  ,payer_bank_name       --付款方银行名称
  ,stl_status_cd         --结算状态代码
  ,job_cd
  ,etl_timestamp         --etl处理时间戳
)
select
   to_date('${batch_date}', 'yyyymmdd')   as etl_dt          -- 数据日期
  ,t1.lp_id                        as lp_id           -- 法人编号
  ,t1.redcst_dtl_id                as bus_id          --业务编号
  ,t1.batch_id                     as batch_id        --批次编号
  ,t8.prod_id                      as std_prod_id     --标准产品编号
  ,t1.bill_id                      as bill_id         --票据编号
  ,t3.bill_num                     as bill_num        --票据号码
  ,t1.bill_sub_intrv_id            as bill_sub_intrv_id --票据子区间号
  ,t9.pric_subj_id                 as subj_id         -- 科目编号
  ,nvl(t9.recvbl_int_paybl_subj_id, t9.recvbl_int_paybl_adj_subj_id) as int_adj_subj_id -- 利息调整科目编号
  ,t9.int_bal_pay_subj_id          as int_income_subj_id    --利息收入科目编号
  ,t2.cont_id                      as batch_no_code   --批次号码
  ,t2.ctr_nt_id                    as ctr_nt_id       --成交单编号
  ,t2.prod_id                      as bill_prod_id    --票据产品编号
  ,t2.bill_med_cd                  as bill_med_cd     --票据介质代码
  ,nvl(trim(t2.bill_type_cd),'-')        as bill_kind_cd    --票据类型代码
  ,t3.draw_dt                      as draw_dt         --出票日期
  ,t1.bill_exp_dt                  as exp_dt          --到期日期
  ,t1.actl_exp_dt                  as actl_exp_dt     --实际到期日期
  ,t13.bus_dt                      as bus_dt          --业务日期
  ,t2.appl_dt                      as appl_dt         --申请日期
  ,t2.stl_dt                       as stl_dt          --结算日期
  ,t2.exp_stl_dt                   as repo_dt         --到期结算日期
  ,to_date(t11.trade_date, 'yyyymmdd')		as bag_dt					 --成交日期
  ,case when trim(t11.trade_time) is not null then
  			to_timestamp(substr(t11.trade_time, 1, 8) || ' ' || substr(t11.trade_time, 9, 2) || ':' || substr(t11.trade_time, 11, 2) || ':' || substr(t11.trade_time, 13, 2), 'yyyymmdd hh24:mi:ss')
  		  else ${iml_schema}.timeformat_min(t11.trade_time) end	as bag_tm	--成交时间
  ,'CNY'                           as curr_cd         --币种代码
  ,t1.fac_val_amt                  as fac_val_amt     --票面金额
  ,t1.stl_amt                      as stl_amt         --结算金额
  ,t1.exp_stl_amt                  as repo_amt        --到期结算金额
  ,t1.int_paybl                    as int_amt         --应付利息
  ,t2.int_rat                      as discnt_int_rat  --利率
  ,case when t6.dtl_id is not null 
        then t1.fac_val_amt 
   else 0 end                      as currt_bal --当期余额
  ,coalesce(t6.surp_int,0)         as int_adj_bal     --利息调整余额
  ,coalesce(t6.td_provi_int,0)     as td_acru_int     --当日应计利息
  ,coalesce(t6.provied_int,0)      as currt_acru_int  --当期应计利息
  ,t2.bus_type_cd                  as bus_type_cd     --业务类型代码
  ,t2.pbc_org_cd                   as cntpty_id       --客户号
  ,t2.org_cn_fname                 as cntpty_name     --客户名称
  ,t2.sys_prtcptr_bigamt_bank_no   as cntpty_bank_no  --客户所属行行号
  ,t2.org_cate_cd                  as cntpty_cate_cd  --机构类别代码
  ,t2.org_lev_cd                   as cntpty_type_cd  --机构类型代码
  ,t3.hxb_acpt_flg                 as hxb_acpt_flg    --我行承兑标志
  ,t3.bill_src_cd                  as bill_src_cd     --票据来源代码
  ,t2.stl_way_cd                   as stl_way_cd      --结算方式代码
  ,t1.discount_bill_flg            as discount_bill_flg --转贴票据标志
  ,t1.remote_bill_flg              as remote_bill_flg --异地票据标志
  ,t1.policy_std_flg               as acrd_policy_flg --政策标准标志
  ,nvl(trim(t1.refuse_flg),'0')    as refuse_flg      --拒绝标志
  ,t2.hold_tenor                   as hold_days       --持票期限
  ,t1.actl_exp_dt - t1.bill_exp_dt as defer_days      --实际到期日期 - 票据到期日期 顺延天数
  ,t1.valid_flg                    as valid_flg       --有效标志
  ,t1.proc_status_cd               as bus_status_cd   --处理状态代码
  ,t7.entry_status_cd              as entry_status_cd --记账状态代码
  ,t1.lmt_ocup_status_cd           as lmt_status_cd   --额度状态代码
  ,case when t40.emply_id is null
        then t2.cust_mgr_id
   else t40.emply_id end           as cust_mgr_id     --客户经理编号
  ,t2.dept_id                      as dept_id               --部门编号
  ,t2.org_id                       as bus_org_id            --业务机构编号
  ,t2.org_id                       as acct_instit_id        --账务机构编号
  ,t2.creator_id                   as rgst_teller_id        --登记柜员编号
  ,t12.recver_org_cd               as recver_org_id         --收款方机构编号   
  ,t12.recver_trust_acct_num       as recver_trust_acct_num --收款方托管账户编号 
  ,t12.recver_trust_acct_name      as recver_trust_acct_name--收款方托管账户名称 
  ,t12.recver_cap_acct_num         as recver_bank_no        --收款方银行行号   
  ,t12.recver_cap_acct_name        as recver_bank_name      --收款方银行名称   
  ,t12.payer_org_cd                as payer_org_id          --付款方机构编号   
  ,t12.payer_trust_acct_num        as payer_trust_acct_num  --付款方托管账户编号 
  ,t12.payer_trust_acct_name       as payer_trust_acct_name --付款方托管账户名称 
  ,t12.payer_cap_acct_num          as payer_bank_no         --付款方银行行号   
  ,t12.payer_cap_acct_name         as payer_bank_name       --付款方银行名称   
  ,t12.stl_status_cd               as stl_status_cd         --结算状态代码    
  ,t1.job_cd                       as job_cd
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_bill_redcst_dtl t1 --票据再贴现明细
 left join (select  t1.batch_id
                   ,t1.prod_id
                   ,t1.bill_med_cd
                   ,t1.bill_type_cd
                   ,t1.appl_dt
                   ,t1.stl_dt
                   ,t1.exp_stl_dt
                   ,t1.int_rat
                   ,t1.bus_type_cd
                   ,t1.stl_way_cd
                   ,t1.hold_tenor
                   ,t1.cust_mgr_id
                   ,t1.dept_id
                   ,t1.org_id
                   ,nvl(t3.cust_id,t1.pbc_org_cd) as pbc_org_cd
                   ,t1.creator_id
                   ,t1.ctr_nt_id
                   ,t2.sys_prtcptr_bigamt_bank_no --系统参与者大额行号
                   ,t2.org_cate_cd  --机构类别代码
                   ,t2.org_lev_cd   --机构级别代码
                   ,t2.org_cn_fname --机构中文全称
                   ,t1.cont_id
              from ${iml_schema}.agt_bill_redcst_batch t1 --票据再贴现批次
              left join ${iml_schema}.pty_cpes_mem t2     --票交所会员
              	on t1.pbc_org_cd = t2.mem_org_cd
               and t2.job_cd = 'bdmsf1'
               and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t2.id_mark <> 'D'
              left join ${iml_schema}.pty_cust_org_rela_h t3
                on t1.pbc_org_cd=t3.org_id
               and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
               and t3.end_dt > to_date('${batch_date}','yyyymmdd')
               and t3.job_cd ='bdmsf1'
 	           where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.job_cd = 'bdmsf1'
               and t1.id_mark <> 'D'
               ) t2
   on t1.batch_id = t2.batch_id
 left join (select t1.rgst_id
                  ,t1.draw_dt
                  ,t1.lock_flg
                  ,t1.bill_src_cd
                  ,t1.hxb_acpt_flg
                  ,t1.bill_num
                  ,t1.bill_sub_intrv_id
              from ${iml_schema}.ref_rgst_cter_bill_info_para t1 --登记中心票据信息参数
  	          where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
                and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  	            and t1.job_cd = 'bdmsf1'
  	            and t1.id_mark <> 'D'
              ) t3
   on t1.bill_id = t3.rgst_id
 left join (select t1.subj_id
                  ,t1.dtl_id --明细编号
                  ,sum(case when t1.debit_crdt_dir_cd = 'C' then t1.prtcptr_amt else t1.prtcptr_amt*(-1) end) as currt_bal
             from ${iml_schema}.evt_entry t1 --记账分录事件
            inner join ${iml_schema}.ref_bill_bus_code_subj_rela t2 --票据业务编码和科目关系
               on t1.subj_id = t2.subj_id
              and t2.job_cd = 'bdmsf1'
              and t2.amt_type_cd = '02' --金额类型代码
              and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t2.id_mark <> 'D'
            where t1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t1.job_cd = 'bdmsi1'
            group by t1.subj_id,t1.dtl_id
              ) t4
   on t1.redcst_dtl_id = t4.dtl_id
 left join (select t1.subj_id
                  ,t1.dtl_id --明细编号
             from ${iml_schema}.evt_entry t1 --记账分录事件
            inner join ${iml_schema}.ref_bill_bus_code_subj_rela t2 --票据业务编码和科目关系
               on t1.subj_id = t2.subj_id
              and t2.job_cd = 'bdmsf1'
              and t2.amt_type_cd = '06' --金额类型代码
              and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t2.id_mark <> 'D'
            where t1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t1.job_cd = 'bdmsi1'
            group by t1.subj_id,t1.dtl_id
              ) t5
   on t1.redcst_dtl_id = t5.dtl_id
 left join (select t1.dtl_id
                  ,t1.batch_id
                  ,t1.bill_id
                  ,t1.bill_num
                  ,t1.bill_sub_intrv_id
                  ,t1.provied_int --已计提利息
                  ,t1.surp_int  --剩余利息
                  ,t2.td_provi_int --当日计提利息
              from ${iml_schema}.agt_cpes_provi_h t1 --票交所计提历史
              left join ${iml_schema}.evt_cpes_provi_dtl t2 --票交所计提明细事件
                on t1.provi_mtbl_id = t2.provi_mtbl_id
               and t2.entry_sucs_flg = '1' --记账成功标志
               and t2.entry_dt = to_date('${batch_date}', 'yyyymmdd') --记账日期
               and t2.job_cd = 'bdmsi1'
             where t1.provi_dt = to_date('${batch_date}', 'yyyymmdd')
 	             and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 	             and t1.job_cd = 'bdmsf1'
 	             and t1.provi_bus_type_cd = '07'
             ) t6
    on t1.redcst_dtl_id = t6.dtl_id
   and t1.batch_id = t6.batch_id
   --and t1.bill_id = t6.bill_id
   and t3.bill_num = t6.bill_num
   and replace(t3.bill_sub_intrv_id,'-',' ') = replace(t6.bill_sub_intrv_id,'-',' ')
   left join (select t1.agt_id,t1.agt_status_cd as entry_status_cd
                from ${iml_schema}.agt_status_h t1
               where t1.agt_status_type_cd = 'CD1426'
                 and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 and t1.job_cd = 'bdmsf1'
                  ) t7
     on t1.agt_id = t7.agt_id
  left join ${iml_schema}.agt_prod_rela_h t8
    on t1.agt_id = t8.agt_id
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'bdmsf1'
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t9
    on t8.prod_id = t9.sellbl_prod_id
   and t9.bus_type_cd = 'BDMX'
   and t9.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.bdms_ces_redsct_deal t11
  	on t2.ctr_nt_id = trim(t11.dealed_no)
   and trade_date = '${batch_date}'
  left join ${iml_schema}.agt_bill_bus_stl_info t12
  	on t2.ctr_nt_id = t12.ctr_nt_id
   and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t12.job_cd = 'bdmsf1'
   and trim(t12.ctr_nt_id) is not null
   and t12.bag_dir_cd ='02'
  left join ${iml_schema}.pty_teller_info_h t40
    on t2.cust_mgr_id = t40.teller_id
   and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t40.job_cd ='ncbsf1'
  left join ${iml_schema}.evt_bill_redcst_exp_redem_batch t13
    on t13.bill_redcst_ser_num =t2.batch_id
   and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t13.job_cd = 'bdmsi1'
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 	 and t1.job_cd = 'bdmsf1'
 	 and t1.id_mark <> 'D'
;

commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_bill_redcst_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bill_redcst_info_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_bill_redcst_info_ex purge;


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bill_redcst_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
