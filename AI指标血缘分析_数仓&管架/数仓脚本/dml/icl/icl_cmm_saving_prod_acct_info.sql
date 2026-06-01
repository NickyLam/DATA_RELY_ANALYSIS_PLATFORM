/*
Purpose:    共性加工层-储蓄产品账户信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_saving_prod_acct_info
Createdate: 20190808
Logs:
            20200110 翟若平 调整${iml_schema}.ref_cny_fori_exch_mdl_p_h表取数口径
            20200327 翟若平 1、增加字段[账户类型代码、计息标志、自动转存标志、转存方式代码]、增加第二组新兴储蓄产品系统的个人智能存款数据
                            2、储蓄产品系统三期需求,调整字段[科目编号、储种代码、定活标志、计息方式代码]的取数逻辑
            20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
			20201223 陈伟峰 调整表AGT_NEWLY_DEP_ACCT_RGST_INFO--->AGT_NEWLY_DEP_ACCT_RGST_H
			20211107 何桐金 【iml_ref_dep_prod_fin_dt_para、iml_agt_dep_prod_int_accr_dtl】增加job_cd过滤条件
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_saving_prod_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_saving_prod_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_04 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_saving_prod_acct_info_01
(
   acct_sign_id varchar2(60)
   ,sum_amount number(30,2)
   ,amount number(30,2)
)
nologging
compress ${option_switch} for query high
; 
-- 1.3 insert date to tmp table
insert /*+ append */ into ${icl_schema}.tmp_cmm_saving_prod_acct_info_01(
   acct_sign_id
   ,sum_amount
   ,amount
)
select acct_sign_id,
         sum(nvl(int_accr_amt, 0)) as sum_amount,
         sum(case when trunc(stl_dt) =
             (select max(p.invalid_dt)
              from ${iml_schema}.ref_dep_prod_fin_dt_para p
               where p.fin_dt_type_cd = 'LASTPOD_DATE'
                 and p.start_dt <= to_date('${batch_date}','yyyymmdd')
                 and p.end_dt > to_date('${batch_date}','yyyymmdd')
                 and p.job_cd='dpssf1') then nvl(int_accr_amt, 0)
               else 0 end) as amount
from ${iml_schema}.agt_dep_prod_int_accr_dtl
 where int_accr_type_cd = '02' 
 and create_dt <= to_date('${batch_date}','yyyymmdd')
 and job_cd = 'dpssf1'
 and id_mark <> 'D'
 group by acct_sign_id
;
commit;


create table ${icl_schema}.tmp_cmm_saving_prod_acct_info_02
(
   acct_sign_id varchar2(60)
   ,divide_amt number(30,2)
)
nologging
compress ${option_switch} for query high
;
-- 1.4 insert date to tmp table
insert /*+ append */ into ${icl_schema}.tmp_cmm_saving_prod_acct_info_02
(
   acct_sign_id
   ,divide_amt
)
select 
   acct_sign_id
   ,sum(divide_amt) as divide_amt 
from ${iml_schema}.agt_dep_prod_dtl 
	where create_dt <= to_date('${batch_date}','yyyymmdd')
	and job_cd = 'dpssf1'
	and id_mark <> 'D'
group by acct_sign_id
;
commit;

create table ${icl_schema}.tmp_cmm_saving_prod_acct_info_03
(
   fin_dt_type_cd varchar2(20)
   ,from_date date
   ,thru_date date
)
nologging
compress ${option_switch} for query high
;
-- 1.5 insert date to tmp table
insert /*+ append */ into ${icl_schema}.tmp_cmm_saving_prod_acct_info_03
(
   fin_dt_type_cd
   ,from_date
   ,thru_date
)
select 
   fin_dt_type_cd
   ,min(effect_dt) as from_date
   ,max(invalid_dt) as thru_date 
from ${iml_schema}.ref_dep_prod_fin_dt_para 
where fin_dt_type_cd ='CURRENT_DATE'
 and start_dt <= to_date('${batch_date}','yyyymmdd')
 and end_dt > to_date('${batch_date}','yyyymmdd')
 and job_cd = 'dpssf1'
 group by fin_dt_type_cd
;
commit;

create table ${icl_schema}.tmp_cmm_saving_prod_acct_info_04
(
   agt_id varchar2(60)
   ,divide_amount number(30,2)
   ,amount  number(30,2)
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_saving_prod_acct_info_04
(
	 agt_id
	 ,divide_amount
	 ,amount
)
select 
	 agt_id
	 ,max(case when bal_type_cd = '004002' then bal end) as divide_amount   --储蓄产品协议余额
	 ,max(case when bal_type_cd = '004001' then bal end) as amount          --储蓄产品账户余额
from ${iml_schema}.agt_bal_h
where start_dt <= to_date('${batch_date}','yyyymmdd')
and end_dt > to_date('${batch_date}','yyyymmdd')
and job_cd = 'dpssf1'
group by agt_id
;
commit;

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_saving_prod_acct_info_ex purge;
drop table ${icl_schema}.cmm_saving_prod_acct_info_ex_02 purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_saving_prod_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_saving_prod_acct_info where 0=1;

-- 第一组（储蓄产品系统-兴安利得/财富宝）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_saving_prod_acct_info_ex(
    etl_dt                            -- 数据日期
    ,lp_id                            -- 法人编号
    ,acct_id                          -- 账户编号
    ,acct_name                        -- 账户名称
    ,cust_acct_id                     -- 客户账户编号
    ,prod_acct_id                     -- 产品账户编号
    ,cust_id                          -- 客户编号
    ,subj_id                          -- 科目编号
    ,std_prod_id                      -- 标准产品编号
    ,prod_id                          -- 产品编号
    ,dep_term                         -- 存期
    ,dep_kind_cd                      -- 储种代码
    ,acct_cls_cd                      -- 账户分类	代码
    ,acct_type_cd                     -- 账户类型代码
    ,dep_acct_status_cd               -- 存款账户状态代码
    ,stop_pay_status_cd               -- 止付状态代码
    ,rc_flg                           -- 定活标志
    ,general_exch_flg                 -- 通兑标志
    ,advise_dep_flg                   -- 通知存款标志
    ,ec_flg                           -- 钞汇标志
    ,sleep_acct_flg                   -- 睡眠户标志
    ,froz_flg                         -- 冻结标志
    ,int_accr_flg                     -- 计息标志
    ,auto_redt_flg                    -- 自动转存标志
    ,redt_way_cd                      -- 转存方式代码
    ,int_accr_base_cd                 -- 计息基准代码
    ,int_set_way_cd                   -- 结息方式代码
    ,int_accr_way_cd                  -- 计息方式代码
    ,curr_cd                          -- 币种代码
    ,open_acct_dt                     -- 开户日期
    ,open_acct_tm                     -- 开户时间
    ,clos_acct_dt                     -- 销户日期
    ,value_dt                         -- 起息日期
    ,exp_dt                           -- 到期日期
    ,final_activ_acct_dt              -- 最后动户日期
    ,froz_dt                          -- 冻结日期
    ,unfrz_dt                         -- 解冻日期
    ,base_rat_type_cd                 -- 基准利率类型代码
    ,base_rat                         -- 基准利率
    ,exec_int_rat                     -- 执行利率
    ,td_acru_int                      -- 当日应计利息
    ,currt_acru_int                   -- 当期应计利息
    ,open_acct_teller_id              -- 开户柜员编号
    ,clos_acct_teller_id              -- 销户柜员编号
    ,open_acct_org_id                 -- 开户机构编号
    ,close_acct_org_id                -- 销户机构编号
    ,currt_bal                        -- 当期余额
    ,aval_bal                         -- 可用余额
    ,stop_pay_amt                     -- 止付金额
    ,cl_curr_currt_bal                -- 折本币当期余额
    ,job_cd                           -- 任务代码
    ,etl_timestamp                    -- etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') --数据日期
    ,t1.lp_id                           --法人编号
    ,case when length(t1.acct_sign_id) > 10 then 'D' || substr(t1.acct_sign_id, -10) else 'D' || lpad(t1.acct_sign_id, 9, '0') end  --账户编号
    ,nvl(trim(t2.acct_name), '未知')                                                                     --账户名称
    ,t1.acct_id                                                                                          --客户账户编号
    ,t1.prod_acct_id                                                                                     --产品账户编号
    ,t1.cust_id                                                                                          --客户编号
    ,decode(t1.sav_type_cd, 'S07', '20110302', '20110202')                                               --科目编号
    ,t11.prod_id                                                                                         --标准产品编号
    ,decode(t1.base_prod_id, 'CFB', '01004002', 'XALD', '01004001', t1.base_prod_id)                     --产品编号
    ,t1.dep_term                                                                                         --存期
    ,t1.sav_type_cd                                                                                      --储种代码
    ,t1.dep_sub_acct_type_cd                                                                             --账户分类代码
    ,t1.acct_type_cd                                                                                     --账户类型代码
    ,t8.agt_status_cd                                                                                    --存款账户状态代码
    ,case
      when trim(t8.agt_status_cd) = '02' and (t1.froz_exp_dt > t6.from_date) then '2'
    else '0' end                                                                                         --止付标志
    ,'1'                                                                                                 --定活标志
    ,'02'                                                                                                --通兑标志
    ,decode(t1.sav_type_cd, 'S07', '1', '0')                                                             --通知存款标志
    ,'9'                                                                                                 --钞汇标志
    ,'0'                                                                                                 --睡眠户标志
    ,decode(t1.froz_status_cd, '01', '1','0')                                                            --冻结标志
    ,'1'                                                                                                 --计息标志
    ,''                                                                                                  --自动转存标志
    ,''                                                                                                  --转存方式代码
    ,decode(t1.sav_type_cd, 'S07', '04', '01')                                                           --计息基准代码
    ,'A0'                                                                                                --结息方式代码
    ,'02'                                                                                                --计息方式代码
    ,t2.curr_cd                                                                                          --币种代码                                                                                  
    ,${iml_schema}.dateformat_min(t2.open_acct_dt)                                                       --开户日期
    ,t2.open_acct_tm                                                                                     --开户时间
    ,t1.revo_dt                                                                                          --销户日期
    ,t1.value_dt                                                                                         --起息日期
    ,${iml_schema}.dateformat_max(case when t1.sav_type_cd = 'S07' then null 
         when t1.base_prod_id = 'CFB' then trunc(nvl(t3.intrdu_dt, t3.int_set_dt))
         else t1.agt_end_dt end)                                                                         --到期日期
    ,t1.last_activ_acct_dt                                                                               --最后动户日期
    ,t1.froz_dt                                                                                          --冻结日期
    ,t1.froz_exp_dt                                                                                      --解冻日期
    ,decode(t1.sav_type_cd, 'S07', '222', '220')                                                         --基准利率类型代码
    ,case when t1.base_prod_id = 'CFB' then nvl(to_number(t4.stl_grouping_id), 0) else to_number(nvl(t1.exec_int_rat,0)) end -- 基准利率
    ,case when t1.base_prod_id = 'CFB' then nvl(to_number(t4.stl_grouping_id), 0) else to_number(nvl(t1.exec_int_rat,0)) end -- 执行利率
    ,case when t8.agt_status_cd = '03' then 0 else nvl(t5.amount, 0) end                                 --当日应计利息
    ,case when t8.agt_status_cd = '03' then 0 else nvl(t5.sum_amount, 0) end                             --当期应计利息
    ,'M0001'                                                                                             --开户柜员编号
    ,decode(t8.agt_status_cd, '03', 'M0001')                                                             --销户柜员编号
    ,t1.acct_instit_id                                                                                   --开户机构编号
    ,decode(t8.agt_status_cd, '03', t1.acct_instit_id)                                                   --销户机构编号
    ,case when t1.base_prod_id = 'CFB' and t8.agt_status_cd = '02' then nvl(t10.amount,0)
            when t1.base_prod_id = 'XALD' and t8.agt_status_cd = '02' then
              nvl(t10.divide_amount,0)
       else 0 end as currt_bal                                                                            --当期余额
    ,case when t1.base_prod_id = 'CFB' and t8.agt_status_cd = '02' then nvl(t10.amount,0)
         when t1.base_prod_id = 'XALD' and t8.agt_status_cd = '02' and (t1.froz_exp_dt <= t6.from_date) then
            nvl(t10.divide_amount,0)
    else 0 end                                                                                            --可用余额
    ,case when t1.base_prod_id = 'XALD' and t8.agt_status_cd = '02' and (t1.froz_exp_dt > t6.from_date) then
            nvl(t10.divide_amount,0)
    else 0 end                                                                                            --止付金额
    ,(case when t1.base_prod_id = 'CFB' and t8.agt_status_cd = '02' then nvl(t10.amount,0)
         when t1.base_prod_id = 'XALD' and t8.agt_status_cd = '02' then
            nvl(t10.divide_amount,0)
    else 0 end) * nvl(t7.convt_cny_exch_rat, 1)                                                          --折本币当期余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                      --etl处理时间戳
from ${iml_schema}.agt_dep_prod t1
    inner join ${iml_schema}.agt_saving_prod_acct t2 
       on t1.prod_acct_id = t2.prod_acct_id
      and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t1.job_cd = 'dpssf1'
      and t2.id_mark <> 'D'
    left join ${iml_schema}.agt_status_h t8
    	 on t8.agt_id = t1.agt_id
    	and t8.agt_status_type_cd = 'CD1247'
    	and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    	and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
    	and t8.job_cd = 'dpssf1'
    left join ${iml_schema}.prd_dep_prod_info t3 
       on t3.prod_id = t1.camp_prod_id
      and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t3.job_cd = 'dpssf1'
    left join ${iml_schema}.agt_dep_prod_int_accr_dtl t4 
      on t4.acct_sign_id = t1.acct_sign_id
     and t4.int_accr_type_cd='02' 
     and (t4.final_modif_tm,t4.acct_sign_id) in (select max(final_modif_tm),acct_sign_id from ${iml_schema}.agt_dep_prod_int_accr_dtl 
     																							where int_accr_type_cd = '02' and create_dt <= to_date('${batch_date}', 'yyyymmdd') 
     																							and id_mark <> 'D' 
     																							and job_cd='dpssf1' group by acct_sign_id)
     and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t4.job_cd = 'dpssf1'
     and t4.id_mark <> 'D'
    left join ${icl_schema}.tmp_cmm_saving_prod_acct_info_01 t5
      on t5.acct_sign_id = t1.acct_sign_id
    left join ${icl_schema}.tmp_cmm_saving_prod_acct_info_03 t6 
      on t6.fin_dt_type_cd ='CURRENT_DATE'
    left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t7
      on t2.curr_cd = t7.curr_sym_cd
     --and t7.dt = to_date('${batch_date}', 'yyyymmdd')
     and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t7.id_mark <> 'D'
     and t7.job_cd = 'cbssf1'
    left join ${icl_schema}.tmp_cmm_saving_prod_acct_info_02 t9
      on t9.acct_sign_id = t1.acct_sign_id
    left join ${icl_schema}.tmp_cmm_saving_prod_acct_info_04 t10
    	on t1.agt_id = t10.agt_id
    left join ${iml_schema}.agt_prod_rela_h t11
      on t1.agt_id = t11.agt_id
     and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t11.job_cd = 'dpssf1'
where t8.agt_status_cd in ('02','03') 
		and t1.sign_type_cd = '02'
    and t2.open_acct_dt < t6.thru_date
    and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'dpssf1'
    and t1.id_mark <> 'D'
; 
commit;

-- 第二组（新兴储蓄产品系统-个人智能存款）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_saving_prod_acct_info_ex(
    etl_dt                            -- 数据日期
    ,lp_id                            -- 法人编号
    ,acct_id                          -- 账户编号
    ,acct_name                        -- 账户名称
    ,cust_acct_id                     -- 客户账户编号
    ,prod_acct_id                     -- 产品账户编号
    ,cust_id                          -- 客户编号
    ,subj_id                          -- 科目编号
    ,std_prod_id                      -- 标准产品编号
    ,prod_id                          -- 产品编号
    ,dep_term                         -- 存期
    ,dep_kind_cd                      -- 储种代码
    ,acct_cls_cd                      -- 账户分类代码
    ,acct_type_cd                     -- 账户类型代码
    ,dep_acct_status_cd               -- 存款账户状态代码
    ,stop_pay_status_cd               -- 止付状态代码
    ,rc_flg                           -- 定活标志
    ,general_exch_flg                 -- 通兑标志
    ,advise_dep_flg                   -- 通知存款标志
    ,ec_flg                           -- 钞汇标志
    ,sleep_acct_flg                   -- 睡眠户标志
    ,froz_flg                         -- 冻结标志
    ,int_accr_flg                     -- 计息标志
    ,auto_redt_flg                    -- 自动转存标志
    ,redt_way_cd                      -- 转存方式代码
    ,int_accr_base_cd                 -- 计息基准代码
    ,int_set_way_cd                   -- 结息方式代码
    ,int_accr_way_cd                  -- 计息方式代码
    ,curr_cd                          -- 币种代码
    ,open_acct_dt                     -- 开户日期
    ,open_acct_tm                     -- 开户时间
    ,clos_acct_dt                     -- 销户日期
    ,value_dt                         -- 起息日期
    ,exp_dt                           -- 到期日期
    ,final_activ_acct_dt              -- 最后动户日期
    ,froz_dt                          -- 冻结日期
    ,unfrz_dt                         -- 解冻日期
    ,base_rat_type_cd                 -- 基准利率类型代码
    ,base_rat                         -- 基准利率
    ,exec_int_rat                     -- 执行利率
    ,td_acru_int                      -- 当日应计利息
    ,currt_acru_int                   -- 当期应计利息
    ,open_acct_teller_id              -- 开户柜员编号
    ,clos_acct_teller_id              -- 销户柜员编号
    ,open_acct_org_id                 -- 开户机构编号
    ,close_acct_org_id                -- 销户机构编号
    ,currt_bal                        -- 当期余额
    ,aval_bal                         -- 可用余额
    ,stop_pay_amt                     -- 止付金额
    ,cl_curr_currt_bal                -- 折本币当期余额
    ,job_cd                           -- 任务代码
    ,etl_timestamp                    -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd') -- 数据日期                                      
       ,t1.lp_id                                                                          -- 法人编号    
       ,t1.liab_acct_num                                                                  -- 账户编号    
       ,t1.acct_name                                                                      -- 账户名称    
       ,t1.cust_acct_num                                                                  -- 客户账户编号  
       ,t2.prod_acct_num                                                                  -- 产品账户编号  
       ,t1.cust_id                                                                        -- 客户编号    
       ,(case when t1.dep_kind_cd = '01' then '20110204'
              when t1.dep_kind_cd in ('28', '29') then '20110202'             
              else '20110302'
         end)                                                                             -- 科目编号    
       ,t3.prod_id                                                                        -- 标准产品编号  
       ,t1.prod_id                                                                        -- 产品编号    
       ,t1.dep_term                                                                       -- 存期      
       ,(case when t1.dep_kind_cd = '05' then 'S07'
              when t1.dep_kind_cd = '01' then 'A13'
              when t1.dep_kind_cd = '26' then 'S21'
              when t1.dep_kind_cd = '27' then 'A18'
              when t1.dep_kind_cd = '28' then 'S02'
              when t1.dep_kind_cd = '29' then 'S02'
              else '000'
         end)                                                                             -- 储种代码    
       ,(case when t1.dep_kind_cd = '01' then 'A02' else 'C29' end)                       -- 账户分类代码  
       ,t1.acct_cls_cd_3                                                                  -- 账户类型代码  
       ,t8.agt_status_cd                                                                  -- 存款账户状态代码
       ,'0'                                                                               -- 止付状态代码  
       ,(case when t1.dep_kind_cd in ('05', '01', '26', '27', '28', '29') then '1' 
              else '0' 
         end)                                                                             -- 定活标志    
       ,'1'                                                                               -- 通兑标志    
       ,case when t1.dep_kind_cd = '05' then '1' else '0' end                             -- 通知存款标志  
       ,t1.ec_flg                                                                         -- 钞汇标志    
       ,'0'                                                                               -- 睡眠户标志   
       ,nvl(trim(t1.acct_amt_froz_flg), '0')                                              -- 冻结标志    
       ,t4.int_accr_flg                                                                   -- 计息标志    
       ,t7.redt_flg                                                                       -- 自动转存标志  
       ,t1.redt_way_cd                                                                    -- 转存方式代码  
       ,nvl(t5.int_accr_rule_cd, '05')                                                    -- 计息基准代码  
       ,t4.int_set_way_cd                                                                 -- 结息方式代码  
       ,(case when t1.dep_kind_cd in ('010', '05') then '01' 
              when t1.dep_kind_cd in ('26', '27', '28', '29') then '02' 
              else '00' 
         end)                                                                             -- 计息方式代码    
       ,t1.acct_curr_cd                                                                   -- 币种代码      
       ,t1.acct_open_acct_dt                                                              -- 开户日期      
       ,to_date(to_char(t1.matn_dt, 'yyyymmdd') || ' ' ||   
                     substr(lpad(trim(t1.matn_tm), 6, 0), 1, 2) || ':' ||  
                     substr(lpad(trim(t1.matn_tm), 6, 0), 3, 2) || ':' ||   
                     substr(lpad(trim(t1.matn_tm), 6, 0), 5, 2),'yyyymmdd hh24:mi:ss')    -- 开户时间      
       ,t1.acct_clos_acct_dt                                                              -- 销户日期      
       ,t1.init_value_dt                                                                  -- 起息日期      
       ,t1.init_exp_dt                                                                    -- 到期日期      
       ,t9.imp_dt                                                                         -- 最后动户日期    
       ,''                                                                                -- 冻结日期      
       ,''                                                                                -- 解冻日期      
       ,t5.base_provi_int_rat_id                                                          -- 基准利率类型代码  
       ,t5.base_rat                                                                       -- 基准利率      
       ,nvl(t5.curr_exec_int_rat, t4.last_provi_int_rat)                                  -- 执行利率      
       ,t4.ld_provi_int                                                                   -- 当日应计利息    
       ,t4.provi_int                                                                      -- 当期应计利息    
       ,t1.open_acct_teller_id                                                            -- 开户柜员编号    
       ,t1.clos_acct_teller_id                                                            -- 销户柜员编号    
       ,t1.open_acct_org_id                                                               -- 开户机构编号    
       ,t1.clos_acct_org_id                                                               -- 销户机构编号    
       ,t10.bal                                                                           -- 当期余额      
       ,t10.bal                                                                           -- 可用余额     
       ,0                                                                                 -- 止付金额     
       ,t10.bal * nvl(t6.convt_cny_exch_rat, 1)                                           -- 折本币当期余额  
       ,t1.job_cd                                                                         -- 任务编码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                   -- etl处理时间戳
  from ${iml_schema}.agt_newly_dep_acct_info t1
  left join ${iml_schema}.agt_newly_dep_acct_rgst_h t2	
    on t1.liab_acct_num = t2.liab_acct_num
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd') 
   and t2.job_cd = 'dpssf1'
  left join ${iml_schema}.agt_prod_rela_h t3
    on t1.agt_id = t3.agt_id 
   and t1.lp_id = t3.lp_id
   and t3.agt_prod_rela_type_cd = '02' 
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd') 
   and t3.job_cd = 'dpssf1'
  left join ${iml_schema}.agt_newly_dep_provi_info t4
    on t1.liab_acct_num = t4.liab_acct_num
   and t4.int_code_name = 'INTERT'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	 and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'dpssf1'
   and t4.id_mark <> 'D'
  left join (select dp.liab_acct_num,
                    dp.int_accr_rule_cd,
                    dp.base_provi_int_rat_id,
                    dp.base_rat,
                    dp.curr_exec_int_rat,
                    row_number() over(partition by dp.liab_acct_num order by dp.tran_dt asc, dp.tran_tm) rn
               from ${iml_schema}.agt_newly_dep_int_set_dtl dp
              where dp.intnal_tran_code in ('dp116','dpa20')
                and dp.rec_status_cd not in ('03', '04')
                and dp.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and dp.job_cd = 'dpssf1'
                and dp.id_mark <> 'D'
            ) t5
    on t1.liab_acct_num = t5.liab_acct_num
   and rn = 1
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t6
    on t1.acct_curr_cd = t6.curr_cd 
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd') 
   and t6.job_cd = 'cbssf1'
  left join ${iml_schema}.prd_liab_prod_info t7
    on t1.prod_id = t7.prod_id 
   and t1.lp_id = t7.lp_id
   and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'dpssf1'
   and t7.id_mark <> 'D'
  left join ${iml_schema}.agt_status_h t8
    on t1.agt_id = t8.agt_id 
   and t1.lp_id = t8.lp_id
   and t8.agt_status_type_cd = 'CD1437' 
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd') 
   and t8.job_cd = 'dpssf1' 
  left join ${iml_schema}.agt_imp_dt_h t9	
    on t1.agt_id = t9.agt_id 
   and t1.lp_id = t9.lp_id
   and t9.dt_type_cd = '25' 
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd') 
   and t9.job_cd = 'dpssf1'
  left join ${iml_schema}.agt_bal_h t10	
    on t1.agt_id = t10.agt_id 
   and t1.lp_id = t10.lp_id
   and t10.bal_type_cd = '004003' 
   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd') 
   and t10.job_cd = 'dpssf1'
 where t1.dep_kind_cd not in ('26', '27')
   and t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'dpssf1'
   and t1.id_mark <> 'D'
; 
commit;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_saving_prod_acct_info_ex_02
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_saving_prod_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_saving_prod_acct_info_ex_02(
    etl_dt                            -- 数据日期
    ,lp_id                            -- 法人编号
    ,acct_id                          -- 账户编号
    ,acct_name                        -- 账户名称
    ,cust_acct_id                     -- 客户账户编号
    ,prod_acct_id                     -- 产品账户编号
    ,cust_id                          -- 客户编号
    ,subj_id                          -- 科目编号
    ,std_prod_id                      -- 标准产品编号
    ,prod_id                          -- 产品编号
    ,dep_term                         -- 存期
    ,dep_kind_cd                      -- 储种代码
    ,acct_cls_cd                      -- 账户分类代码
    ,acct_type_cd                     -- 账户类型代码
    ,dep_acct_status_cd               -- 存款账户状态代码
    ,stop_pay_status_cd               -- 止付状态代码
    ,rc_flg                           -- 定活标志
    ,general_exch_flg                 -- 通兑标志
    ,advise_dep_flg                   -- 通知存款标志
    ,ec_flg                           -- 钞汇标志
    ,sleep_acct_flg                   -- 睡眠户标志
    ,froz_flg                         -- 冻结标志
    ,INT_ACCR_FLG                     -- 计息标志
    ,AUTO_REDT_FLG                    -- 自动转存标志
    ,REDT_WAY_CD                      -- 转存方式代码 
    ,int_accr_base_cd                 -- 计息基准代码
    ,int_set_way_cd                   -- 结息方式代码
    ,int_accr_way_cd                  -- 计息方式代码
    ,curr_cd                          -- 币种代码
    ,open_acct_dt                     -- 开户日期
    ,open_acct_tm                     -- 开户时间
    ,clos_acct_dt                     -- 销户日期
    ,value_dt                         -- 起息日期
    ,exp_dt                           -- 到期日期
    ,final_activ_acct_dt              -- 最后动户日期
    ,froz_dt                          -- 冻结日期
    ,unfrz_dt                         -- 解冻日期
    ,base_rat_type_cd                 -- 基准利率类型代码
    ,base_rat                         -- 基准利率
    ,exec_int_rat                     -- 执行利率
    ,td_acru_int                      -- 当日应计利息
    ,currt_acru_int                   -- 当期应计利息
    ,open_acct_teller_id              -- 开户柜员编号
    ,clos_acct_teller_id              -- 销户柜员编号
    ,open_acct_org_id                 -- 开户机构编号
    ,close_acct_org_id                -- 销户机构编号
    ,currt_bal                        -- 当期余额
    ,aval_bal                         -- 可用余额
    ,stop_pay_amt                     -- 止付金额
    ,cl_curr_currt_bal                -- 折本币当期余额
    ,ear_d_bal	                      -- 日初余额
    ,ear_m_bal	                      -- 月初余额
    ,ear_s_bal	                      -- 季初余额
    ,ear_y_bal	                      -- 年初余额
    ,y_acm_bal	                      -- 年累计余额
    ,s_acm_bal	                      -- 季累计余额
    ,m_acm_bal	                      -- 月累计余额
    ,cl_curr_ear_d_bal	              -- 折本币日初余额
    ,cl_curr_ear_m_bal	              -- 折本币月初余额
    ,cl_curr_ear_s_bal	              -- 折本币季初余额
    ,cl_curr_ear_y_bal	              -- 折本币年初余额
    ,cl_curr_y_acm_bal	              -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal	        -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal	        -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal	        -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal	        -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal	              -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal	        -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal	        -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal	        -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal	              -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal	        -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal	        -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal	        -- 折本币年初月累计余额
    ,y_avg_bal        						 		-- 年日均余额
    ,q_avg_bal        						 		-- 季日均余额
    ,m_avg_bal        								-- 月日均余额
    ,cl_curr_y_avg_bal								-- 折本币年日均余额
    ,cl_curr_q_avg_bal							  -- 折本币季日均余额
    ,cl_curr_m_avg_bal							  -- 折本币月日均余额
    ,job_cd                           -- 任务代码
    ,etl_timestamp                    -- etl处理时间戳
)
select 
    t1.etl_dt                            -- 数据日期
    ,t1.lp_id                            -- 法人编号
    ,t1.acct_id                          -- 账户编号
    ,t1.acct_name                        -- 账户名称
    ,t1.cust_acct_id                     -- 客户账户编号
    ,t1.prod_acct_id                     -- 产品账户编号
    ,t1.cust_id                          -- 客户编号
    ,t1.subj_id                          -- 科目编号
    ,t1.std_prod_id                      -- 标准产品编号
    ,t1.prod_id                          -- 产品编号
    ,t1.dep_term                         -- 存期
    ,t1.dep_kind_cd                      -- 储种代码
    ,t1.acct_cls_cd                      -- 账户分类代码
    ,t1.acct_type_cd                     -- 账户类型代码
    ,t1.dep_acct_status_cd               -- 存款账户状态代码
    ,t1.stop_pay_status_cd               -- 止付状态代码
    ,t1.rc_flg                           -- 定活标志
    ,t1.general_exch_flg                 -- 通兑标志
    ,t1.advise_dep_flg                   -- 通知存款标志
    ,t1.ec_flg                           -- 钞汇标志
    ,t1.sleep_acct_flg                   -- 睡眠户标志
    ,t1.froz_flg                         -- 冻结标志
    ,t1.INT_ACCR_FLG                     -- 计息标志
    ,t1.AUTO_REDT_FLG                    -- 自动转存标志
    ,t1.REDT_WAY_CD                      -- 转存方式代码
    ,t1.int_accr_base_cd                 -- 计息基准代码
    ,t1.int_set_way_cd                   -- 结息方式代码
    ,t1.int_accr_way_cd                  -- 计息方式代码
    ,t1.curr_cd                          -- 币种代码
    ,t1.open_acct_dt                     -- 开户日期
    ,t1.open_acct_tm                     -- 开户时间
    ,t1.clos_acct_dt                     -- 销户日期
    ,t1.value_dt                         -- 起息日期
    ,t1.exp_dt                           -- 到期日期
    ,t1.final_activ_acct_dt              -- 最后动户日期
    ,t1.froz_dt                          -- 冻结日期
    ,t1.unfrz_dt                         -- 解冻日期
    ,t1.base_rat_type_cd                 -- 基准利率类型代码
    ,t1.base_rat                         -- 基准利率
    ,t1.exec_int_rat                     -- 执行利率
    ,t1.td_acru_int                      -- 当日应计利息
    ,t1.currt_acru_int                   -- 当期应计利息
    ,t1.open_acct_teller_id              -- 开户柜员编号
    ,t1.clos_acct_teller_id              -- 销户柜员编号
    ,t1.open_acct_org_id                 -- 开户机构编号
    ,t1.close_acct_org_id                -- 销户机构编号
    ,t1.currt_bal                        -- 当期余额
    ,t1.aval_bal                         -- 可用余额
    ,t1.stop_pay_amt                     -- 止付金额
    ,t1.cl_curr_currt_bal                -- 折本币当期余额
	  ,nvl(t2.ear_d_bal,0.0)                   -- 日初余额
    ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else nvl(t2.ear_m_bal,0.0) end                                                                            -- 月初余额
    ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else nvl(t2.ear_s_bal,0.0) end                                                  -- 季初余额
    ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else nvl(t2.ear_y_bal,0.0) end                                                                          -- 年初余额
    ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else nvl(t2.y_acm_bal,0.0) + t1.currt_bal end                                                                    -- 年累计余额
    ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else nvl(t2.s_acm_bal,0.0) + t1.currt_bal end                                            -- 季累计余额
    ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else nvl(t2.m_acm_bal,0.0) + t1.currt_bal end                                                                     -- 月累计余额
    ,nvl(t2.ear_d_bal,0.0) * nvl(t3.convt_cny_exch_rat, 1)                                                                                                                                                          -- 折本币日初余额
    ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_currt_bal,0.0) else nvl(t2.cl_curr_ear_m_bal,0.0) end                                                              -- 折本币月初余额
    ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_currt_bal,0.0) else nvl(t2.cl_curr_ear_s_bal,0.0) end                                    -- 折本币季初余额
    ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_currt_bal,0.0) else nvl(t2.cl_curr_ear_y_bal,0.0) end                                                            -- 折本币年初余额    
    ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end                           -- 折本币年累计余额
    ,nvl(t2.cl_curr_y_acm_bal,0.0)                                                                                                                                                    -- 折本币日初年累计余额
    ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_y_acm_bal,0.0) else nvl(t2.cl_curr_ear_m_y_acm_bal,0.0) end                                             -- 折本币月初年累计余额
    ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_y_acm_bal,0.0) else nvl(t2.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初年累计余额
    ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_y_acm_bal,0.0) else nvl(t2.cl_curr_ear_y_y_acm_bal,0.0) end                                           -- 折本币年初年累计余额
    ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end   -- 折本币季累计余额
    ,nvl(t2.cl_curr_s_acm_bal,0.0)                                                                                                                                                    -- 折本币日初季累计余额
    ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_s_acm_bal,0.0) else nvl(t2.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初季累计余额
    ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_s_acm_bal,0.0) else nvl(t2.cl_curr_ear_y_s_acm_bal,0.0) end                                           -- 折本币年初季累计余额
    ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end                            -- 折本币月累计余额
    ,nvl(t2.cl_curr_m_acm_bal,0.0)                                                                                                                                                   -- 折本币日初月累计余额
    ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_m_acm_bal,0.0) else nvl(t2.cl_curr_ear_m_m_acm_bal,0.0) end                                           -- 折本币月初月累计余额
    ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_m_acm_bal,0.0) else nvl(t2.cl_curr_ear_y_m_acm_bal,0.0) end                                         -- 折本币年初月累计余额
    ,(case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else nvl(t2.y_acm_bal,0.0) + t1.currt_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
    ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else nvl(t2.s_acm_bal,0.0) + t1.currt_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
    ,(case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else nvl(t2.m_acm_bal,0.0) + t1.currt_bal end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
    ,(case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
    ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
    ,(case when substr('${batch_date}',7,2) = '01' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
from ${icl_schema}.cmm_saving_prod_acct_info_ex t1
    left join ${icl_schema}.cmm_saving_prod_acct_info t2
    	on t2.acct_id = t1.acct_id
    	and t2.lp_id = t1.lp_id
    	and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
    left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3
      on t1.curr_cd = t3.curr_sym_cd
      --and t3.dt = to_date('${batch_date}', 'yyyymmdd')
    	and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t3.id_mark <> 'D'
      and t3.job_cd = 'cbssf1'
;
commit;
-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_saving_prod_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_saving_prod_acct_info_ex_02
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_saving_prod_acct_info_ex purge;
drop table ${icl_schema}.cmm_saving_prod_acct_info_ex_02 purge;

-- 3.2 drop temp table
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_saving_prod_acct_info_04 purge;
-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_saving_prod_acct_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
