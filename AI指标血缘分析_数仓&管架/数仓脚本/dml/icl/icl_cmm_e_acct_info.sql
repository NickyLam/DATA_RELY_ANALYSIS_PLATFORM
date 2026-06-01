/*
Purpose:    共性加工层-电子账户信息，包括所有的电子账户信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220331 icl_cmm_e_acct_info
Createdate: 20190729
Logs:
            20200110 翟若平 修改个人电子账户中[起息日期、到期日期、当日应计利息、当期应计利息、储种代码]的取数逻辑、调整iml.ref_cny_fori_exch_mdl_p_h表取数口径
            20200110 翟若平 修改[冻结日期、解冻日期、开户时间、销户时间]的取数逻辑、调整字段[开户时间、销户时间]的数据类型DATE->TIMESTAMP(6)
            20200327 翟若平 增加字段[计息标志]
            20200424 周沁晖 增加字段[客户账户子户号、标准产品编号、存期、通知存款标志、自动转存标志、转存方式代码、计息基准代码、开户日期、销户日期、基准利率类型代码、基准利率]
            				        调整逻辑[储种代码、结息方式代码、计息方式代码、起息日期、到期日期、执行利率、当日应计利息、当期应计利息]
            				        t3表关联变更
            20200515 周沁晖 调整逻辑[计息标志]
            20200605 周沁晖 调整字段【当日应计利息、当期应计利息】的取数口径
							              增加字段【上次结息日期、下次结息日期、首次起息日期】
       	    20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
       	    20201127 周沁晖 调整字段第一组【记账标志】的取数逻辑，增加【负债账户】字段
       	    20201127 陈伟峰 增加字段【开户金额】
       	    20201128 陈伟峰 增加字段【应付利息科目编号、利息支出科目编号、当日利息支出】
            20201207 翟若平 增加字段【当期应付利息调整、当日利息支出调整、应付利息调整科目编号、利息支出调整科目编号】
			      20201223 陈伟峰 调整表AGT_NEWLY_DEP_ACCT_RGST_INFO--->AGT_NEWLY_DEP_ACCT_RGST_H
			      20201228 陈伟峰 调整字段【所属机构编号】、【止付状态代码】、【到期日期】、【睡眠户标志】、【协定存款起存金额】、【销户时间】加工逻辑
			      20201231 陈伟峰 新增字段【旧账户编号】
			      20210115 周沁晖 个人电子账户分组，调整口径【客户账户编号】
            20210121 陈伟峰 调整个人电子账户-睡眠户标志取值逻辑
            20210312 周沁晖 调整口径【账户类型代码】
            20210425 调整冻结金额取数逻辑froz_rec_type_cd = '02'->froz_rec_type_cd = '01'(旧数仓迁移)
            20210602 调整dep_kind_cd逻辑：【t31.dep_kind_cd = '01' then 'A13'】改为【t31.dep_kind_cd = '01' then 'S22'】
            20210615 何桐金 调整个人电子账户组-【销户机构编号】取数逻辑
                            调整企业电子账户组-【账户名称、计息基准代码、当日应计利息、当期应计利息、开户机构编号、销户机构编号】取数逻辑
            20210622 何桐金 调整个人电子账户组-【当期应计利息】取数逻辑	
            20210622 何桐金 调整企业电子账户组-【销户机构编号】取数逻辑改回原来逻辑			
            20210623 何桐金 调整nvl(t35.int_accr_rule_cd, '05') -》nvl(t35.int_accr_rule_cd, '04')  -- 计息基准代码
            20211107 何桐金 【iml_agt_syn_acct_med_rela_h、iml_evt_indv_e_acct_pay_dtl、iml_agt_indv_e_acct_attr_h
                             iml_prd_rela_h、iml_prd_product】增加job_cd过滤条件
            20220405 陈伟峰 新增字段【内部账户编号、电子账户介质编号、电子账户介质类型代码、绑定卡卡号、绑定卡开户行编号、绑定卡开户行名称】
            20220805 陈伟峰 优化字段【当期应计利息】取值逻辑，减小与总账差异
            

            				
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_e_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_e_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_e_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_04 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_05 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_06 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_07 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_08 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_09 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_10 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_11 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_12 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_13 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_14 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_15 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_16 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_17 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_17_1 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_18 purge;
drop table ${icl_schema}.tmp_cmm_e_acct_info_19 purge;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_01(
    agt_id varchar2(60)
    ,available_balance number(30,2)
    ,actual_balance number(30,2)
    ,yesterday_balance number(30,2)
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_01(
    agt_id
    ,available_balance
    ,actual_balance   
    ,yesterday_balance
)
select
    agt_id
    ,max(case when bal_type_cd = '001003' then bal end) as available_balance
    ,max(case when bal_type_cd = '001002' then bal end) as actual_balance
    ,max(case when bal_type_cd = '001001' then bal end) as yesterday_balance
from ${iml_schema}.agt_bal_h 
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')
	and job_cd = 'eassf1'
	group by agt_id
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_e_acct_info_02(
    prod_acct_id varchar2(60)
    ,sett_item_rate number
)
nologging
compress ${option_switch} for query high
;
-- 1.4 insert data to temp table
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_02(
    prod_acct_id
    ,sett_item_rate
)
select t5.prod_acct_id
           ,max(nvl(item.exec_int_rat, 0)) as sett_item_rate
from ${iml_schema}.agt_indv_e_acct_provi_dtl_item item,
          ${iml_schema}.agt_indv_e_acct_provi_stl_dtl t5
 where item.stl_id = t5.stl_id
   and t5.stl_type_cd = '02'
   and to_date(to_char(t5.stl_tm, 'yyyymmdd'), 'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'eassf1'
   and t5.id_mark <> 'D'
   and item.create_dt <= to_date('${batch_date}','yyyymmdd')
   and item.job_cd = 'eassf1'
   and item.id_mark <> 'D'
group by t5.prod_acct_id
;
commit;

whenever sqlerror exit sql.sqlcode;    
create table ${icl_schema}.tmp_cmm_e_acct_info_03(
    prod_acct_id  varchar2(60)
    ,frozen_dt  date
    ,unfrozen_dt  date
    ,freeze_amount  number(30,2)
)
nologging
compress ${option_switch} for query high
;
-- 1.5 insert data to temp table
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_03(
    prod_acct_id
    ,frozen_dt
    ,unfrozen_dt
    ,freeze_amount
)
select 
    prod_acct_id
    ,to_date(to_char(max(acct_froz_start_tm), 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') as frozen_dt
    ,to_date(to_char(max(acct_froz_end_tm), 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') as unfrozen_dt
    ,sum(case when init_froz_id is null then nvl(froz_amt, 0)
    	else 0 end) as freeze_amount
from ${iml_schema}.agt_indv_acct_froz_h
   where froz_rec_type_cd = '01'
   and start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
   and job_cd = 'eassf1'
   group by prod_acct_id;
commit;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_04(
    billing_account_id varchar2(20)
    ,status_id varchar2(20)
    ,bind_date timestamp(6)
    ,card_no   varchar2(60)
    ,bank_number varchar2(60)
    ,bank_name varchar2(500)
    ,rn number(10,0)
)
nologging
compress ${option_switch} for query high
;
-- 1.7 insert data to temp table
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_04(
    billing_account_id
    ,status_id
    ,bind_date
    ,card_no
    ,bank_number
    ,bank_name
    ,rn
)
select * from 
(
select 
    billing_account_id
    ,status_id
    ,bind_date
    ,card_no
    ,bank_number
    ,bank_name
    ,row_number() over(partition by billing_account_id order by bind_date asc) rn
    from ${iol_schema}.iats_card_bind_info
   where status_id <> '0'
   and start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
) where rn = 1
;
commit;

create table ${icl_schema}.tmp_cmm_e_acct_info_05(
    prod_acct_id	varchar2(60)
   ,init_froz_id	varchar2(60)
   ,froz_rec_type_cd	varchar2(20)
   ,freeze_amount	number(18,2)
)nologging
compress ${option_switch} for query high
;

insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_05(
    prod_acct_id
   ,init_froz_id
   ,froz_rec_type_cd
   ,freeze_amount
)
select prod_acct_id
			 ,init_froz_id
			 ,froz_rec_type_cd
			 ,nvl(sum(froz_amt),0) as freeze_amount
from ${iml_schema}.agt_indv_acct_froz_h 
where start_dt <= to_date('${batch_date}','yyyymmdd')
 and end_dt > to_date('${batch_date}','yyyymmdd')
 and job_cd = 'eassf1'
 group by prod_acct_id,init_froz_id,froz_rec_type_cd 
 having froz_rec_type_cd = '01' and trim(init_froz_id) is null
;
commit;

-- 20200110 翟若平 新增个人智能存款从新兴储蓄产品系统获取的信息
create table ${icl_schema}.tmp_cmm_e_acct_info_10(
    prod_acct_id	 varchar2(60) -- 产品账户编号
   ,value_dt	     date         -- 起息日期
   ,exp_dt	       date         -- 到期日期
   ,td_acru_int	   number(30,8) -- 当日应计利息
   ,currt_acru_int number(30,8) -- 当期应计利息
   ,std_prod_id    varchar2(60) -- 标准产品编号
)nologging
compress ${option_switch} for query high
;

insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_10(
    prod_acct_id
   ,value_dt
   ,exp_dt
   ,td_acru_int
   ,currt_acru_int
   ,std_prod_id
)
select b.prod_acct_num as prod_acct_id,
       min(c.init_value_dt) as value_dt,
       min(c.init_exp_dt) as exp_dt,
       sum(nvl(d.ld_provi_int, 0)) as today_accrued_int,
       sum(nvl(d.provi_int, 0)) as currt_acru_int,
       max(e.prod_id) as std_prod_id
  from ${iml_schema}.agt_newly_dep_acct_rgst_h b
  left join ${iml_schema}.agt_newly_dep_acct_info c
    on b.liab_acct_num = c.liab_acct_num
   and b.lp_id = c.lp_id
   and c.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and c.id_mark <> 'D'
   and c.job_cd = 'dpssf1'
  left join ${iml_schema}.agt_prod_rela_h e
  	on c.agt_id = e.agt_id
   and e.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	 and e.end_dt > to_date('${batch_date}', 'yyyymmdd')
 	 --and e.id_mark <> 'D'
 	 and e.job_cd = 'dpssf2'
  left join ${iml_schema}.agt_newly_dep_provi_info d
    on c.liab_acct_num = d.liab_acct_num
   and c.lp_id = d.lp_id
   and d.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	 and d.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and d.int_code_name = 'INTERT'
   and d.job_cd = 'dpssf1'
 where b.start_dt <= to_date('${batch_date}','yyyymmdd')
   and b.end_dt > to_date('${batch_date}','yyyymmdd')
   and b.job_cd = 'dpssf1'
 group by b.prod_acct_num
;
commit;


-- 创建临时表tmp_cmm_e_acct_info_11存放个人电子账户的推荐人信息
create table ${icl_schema}.tmp_cmm_e_acct_info_11(
  billing_account_id varchar2(60)  -- E账户编号     
  ,camp_activ_id     varchar2(60)  -- 营销活动编号    
  ,referrer_type_cd  varchar2(10)  -- 推荐人类型代码   
  ,referrer_num      varchar2(30)  -- 推荐人号码     
)nologging
compress ${option_switch} for query high
;

-- 插入个人电子账户的推荐人信息
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_11(
  billing_account_id -- E账户编号     
  ,camp_activ_id     -- 营销活动编号    
  ,referrer_type_cd  -- 推荐人类型代码   
  ,referrer_num      -- 推荐人号码    
)
select t10.billing_account_id,                                -- E账户编号
       t11.attr_value as camp_activ_id,                       -- 营销活动编号
       nvl(trim(t12.attr_value), '0')  as referrer_type_cd,   -- 推荐人类型代码
       t13.attr_value as referrer_num                         -- 推荐人号码
  from ${iol_schema}.iats_billing_account_term t10 
   left join ${iol_schema}.iats_billing_account_term_attr t11 
    on t10.billing_account_term_id = t11.billing_account_term_id
    and t11.attr_name = 'marketingActivityNo'
    and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
 	  and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.iats_billing_account_term_attr t12 
    on t10.billing_account_term_id = t12.billing_account_term_id
    and t12.attr_name = 'recommendTypeId'
    and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
 	  and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.iats_billing_account_term_attr t13 
    on t10.billing_account_term_id = t13.billing_account_term_id
    and t13.attr_name = 'recommendNo'
    and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
 	  and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	where t10.start_dt <= to_date('${batch_date}','yyyymmdd')
 	  and t10.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

create table ${icl_schema}.tmp_cmm_e_acct_info_15(
	liab_acct_num  varchar2(60) --负债账号
	,acct_id 			 varchar2(60) --账户编号
	,prod_acct_num varchar2(60) --产品账号
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_15(
	liab_acct_num
	,acct_id
	,prod_acct_num
)
select liab_acct_num,
			 acct_id,
			 prod_acct_num 
  from ${iml_schema}.agt_newly_dep_acct_rgst_h 
 where job_cd = 'dpssf1'
   and start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
 union all
select liab_acct_num,
			 prod_acct_num as acct_id,
			 '000001' as prod_acct_num 
  from ${iml_schema}.agt_newly_dep_acct_rgst_h 
 where job_cd = 'dpssf1'
   and start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
;	
commit;

-- 创建临时表tmp_cmm_e_acct_info_12存放账户利息相关信息
create table ${icl_schema}.tmp_cmm_e_acct_info_12(
	acct_id						varchar2(60) -- 主账号
	,prod_acct_num		varchar2(60) -- 子户号
  ,dep_term         varchar2(10) -- 存期
  ,advise_dep_flg   varchar2(10) -- 通知存款标志
  ,auto_redt_flg    varchar2(10) -- 自动转存标志
  ,redt_way_cd      varchar2(10) -- 转存方式代码
  ,int_accr_base_cd varchar2(10) -- 计息基准代码
  ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
  ,base_rat         number(18,8) -- 基准利率
  ,dep_kind_cd      varchar2(10) -- 储种代码
  ,int_set_way_cd   varchar2(10) -- 结息方式代码
  ,int_accr_way_cd  varchar2(10) -- 计息方式代码
  ,open_acct_dt     date         -- 开户日期
  ,value_dt         date         -- 起息日期
  ,exp_dt           date         -- 到期日期
  ,exec_int_rat     number(18,8) -- 执行利率
  ,td_acru_int      number(30,8) -- 当日应计利息
  ,currt_acru_int   number(30,8) -- 当期应计利息
  ,liab_acct_num		varchar2(60) -- 负债账号
  ,int_accr_flg     varchar2(10) -- 计息标志
  ,last_int_set_dt  date				 -- 上次结息日期
  ,next_int_set_dt  date				 -- 下次结息日期
  ,ld_provi_int     number(30,8) -- 上日计提利息
  ,provi_int			  number(30,8) -- 计提利息
  ,init_value_dt    date				 -- 初始起息日期
  ,std_prod_id      varchar2(60) -- 标准产品编号
  ,open_acct_amt    number(30,2) -- 开户金额
)
nologging
compress ${option_switch} for query high
;

-- 将账户利息相关信息插入至临时表tmp_cmm_e_acct_info_12
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_12(
  acct_id           -- 主账号
  ,prod_acct_num    -- 子户号
  ,dep_term         -- 存期
  ,advise_dep_flg   -- 通知存款标志
  ,auto_redt_flg    -- 自动转存标志
  ,redt_way_cd      -- 转存方式代码
  ,int_accr_base_cd -- 计息基准代码
  ,base_rat_type_cd -- 基准利率类型代码
  ,base_rat         -- 基准利率
  ,dep_kind_cd      -- 储种代码
  ,int_set_way_cd   -- 结息方式代码
  ,int_accr_way_cd  -- 计息方式代码
  ,open_acct_dt     -- 开户日期
  ,value_dt         -- 起息日期
  ,exp_dt           -- 到期日期
  ,exec_int_rat     -- 执行利率
  ,td_acru_int      -- 当日应计利息
  ,currt_acru_int   -- 当期应计利息
  ,liab_acct_num		-- 负债账号
  ,int_accr_flg     -- 计息标志
  ,last_int_set_dt  -- 上次结息日期
  ,next_int_set_dt  -- 下次结息日期
  ,ld_provi_int			-- 上日计提利息
  ,provi_int				-- 计提利息
  ,init_value_dt    -- 初始起息日期
  ,std_prod_id      -- 标准产品编号
  ,open_acct_amt    -- 开户金额
)
select t31.acct_id
       ,t31.prod_acct_num
       ,nvl(t32.dep_term, '000') as dep_term         -- 存期
       ,(case when t32.dep_kind_cd = '05' then '1' else '0' end) as advise_dep_flg   -- 通知存款标志
       ,nvl(t34.redt_flg, '0') as auto_redt_flg -- 自动转存标志
       ,nvl(t32.redt_way_cd, '0') as redt_way_cd -- 转存方式代码
    --   ,nvl(t35.int_accr_rule_cd, '05') as int_accr_base_cd  -- 计息基准代码
       ,nvl(t35.int_accr_rule_cd, '04') as int_accr_base_cd  -- 计息基准代码
       ,t35.base_provi_int_rat_id as base_rat_type_cd -- 基准利率类型代码
       ,t35.base_rat as base_rat -- 基准利率
       ,t32.dep_kind_cd -- 储种代码
       ,'B3' as int_set_way_cd  -- 结息方式代码
       ,(case when t32.dep_kind_cd in ('01', '05') then '01' 
              when t32.dep_kind_cd in ('26', '27', '28', '29') then '02'
              else '01'
              end) as int_accr_way_cd -- 计息方式代码
	     ,t32.acct_open_acct_dt         -- 开户日期
       ,t32.init_value_dt as value_dt -- 起息日期
       ,t32.init_exp_dt as exp_dt -- 到期日期
       ,nvl(t35.curr_exec_int_rat, t33.last_provi_int_rat) as exec_int_rat -- 执行利率
       ,t33.ld_provi_int as td_acru_int -- 当日应计利息
       ,nvl(t36.curr_accrued_int,0) as currt_acru_int -- 当期应计利息
       ,t32.liab_acct_num 	 -- 负债账号
       ,t33.int_accr_flg 		 -- 计息标志
       ,t33.last_int_set_dt  -- 上次结息日期
       ,t33.next_int_set_dt  -- 下次结息日期
       ,t33.ld_provi_int		 -- 上日计提利息
       ,t33.provi_int				 -- 计提利息
       ,t32.init_value_dt		 -- 初始起息日期
       ,e.prod_id as std_prod_id -- 标准产品编号 
       ,t32.open_acct_amt	     -- 开户金额  
  from ${icl_schema}.tmp_cmm_e_acct_info_15 t31
  left join ${iml_schema}.agt_newly_dep_acct_info t32
    on t31.liab_acct_num = t32.liab_acct_num
   and t32.dep_kind_cd not in ('26', '27')
   and t32.job_cd = 'dpssf1'
   and t32.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t32.id_mark <> 'D'
  left join ${iml_schema}.agt_newly_dep_provi_info t33
    on t32.liab_acct_num = t33.liab_acct_num
   and t33.int_code_name = 'INTERT'
   and t33.job_cd = 'dpssf1'
   and t33.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t33.end_dt > to_date('${batch_date}','yyyymmdd')
   --and t33.id_mark <> 'D'
  left join ${iml_schema}.prd_liab_prod_info t34
    on t32.prod_id = t34.prod_id
   and t32.lp_id = t34.lp_id
   and t34.job_cd = 'dpssf1'
   and t34.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t34.id_mark <> 'D'
  left join (select dp.liab_acct_num,
        						dp.int_accr_rule_cd,
        						dp.base_provi_int_rat_id,
        						dp.base_rat,
        						dp.curr_exec_int_rat,
        						row_number() over(partition by dp.liab_acct_num order by dp.tran_dt asc, dp.tran_tm) rn
  					 from ${iml_schema}.agt_newly_dep_int_set_dtl dp
 						where dp.intnal_tran_code in ('dp116','dpa20')
   						and dp.rec_status_cd not in ('03', '04')
   						and dp.job_cd = 'dpssf1'
   						and dp.create_dt <= to_date('${batch_date}','yyyymmdd')
   						and dp.id_mark <> 'D') t35
   	on t32.liab_acct_num = t35.liab_acct_num
   and t35.rn = 1
  left join ${iml_schema}.agt_prod_rela_h e
  	on t32.agt_id = e.agt_id
   and e.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	 and e.end_dt > to_date('${batch_date}', 'yyyymmdd')
 	 --and e.id_mark <> 'D'
 	 and e.job_cd = 'dpssf2'
  left join (select a.dpact_no,
                    sum(round(a.int_occuramt - a.ld_provi_int + round(a.ld_provi_int, 2),nvl(t8.min_cur_unit, 2))) as curr_accrued_int
               from (select t1.dpact_no,t4.acct_curr_cd,
                            sum(t1.int_occuramt) int_occuramt,
                            t2.ld_provi_int
                       from ${iol_schema}.dpss_dpr_actintjnl t1
                       left join ${iml_schema}.agt_newly_dep_provi_info t2 --iol.dpss_dpa_acrudef t2
                         on t1.dpact_no = t2.liab_acct_num
                        and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
                        and t2.end_dt > to_date('${batch_date}','yyyymmdd')
            	  	      and t2.job_cd ='dpssf1'
            	  	     left join ${iml_schema}.agt_newly_dep_acct_info t4
            	  	       on t4.liab_acct_num=t1.dpact_no
            	  	      and t4.create_dt <=to_date('${batch_date}','yyyymmdd')
            	  	      and t4.job_cd ='dpssf1'
            	  	      and t4.id_mark<>'D'
                      inner join ${iml_schema}.agt_status_h t5 --iol.dpss_dpa_acctinf t5
                         on t5.agt_id = t4.agt_id
            	  	      and t5.agt_status_type_cd='CD1107'
            	  	      and t5.agt_status_cd	 = '01'
                        and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
                        and t5.end_dt > to_date('${batch_date}','yyyymmdd')
                        and t5.job_cd ='dpssf1'
                      where (t1.int_adj_flg = '1' or
                            (t1.int_adj_flg = '2' and t1.int_opera_cod = 'ADJUSTMENT'))
                        and ((${iml_schema}.dateformat_min(t1.last_intdate) >= t2.last_int_set_dt and t4.dep_kind_cd not in ('04', '06', '07')) 
                         or (${iml_schema}.dateformat_min(t1.last_intdate) >= t2.value_dt and t4.dep_kind_cd in ('04', '06', '07')))
                        and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
                        and t1.end_dt > to_date('${batch_date}','yyyymmdd')
                      group by t1.dpact_no, t2.ld_provi_int,t4.acct_curr_cd) a
               left join ${iol_schema}.dpss_pmp_curr t8
                 on t8.curr_code = a.acct_curr_cd
                and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
                and t8.end_dt > to_date('${batch_date}','yyyymmdd')
                group by a.dpact_no) t36
    on t36.dpact_no=t32.liab_acct_num
;
commit;

create table ${icl_schema}.tmp_cmm_e_acct_info_13(
	status_id 			varchar2(20) -- 状态
	,billing_account_id	varchar2(20) -- E账户编号
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_13(
	status_id
	,billing_account_id
)
select distinct c.status_id,c.billing_account_id
	from ${iol_schema}.iats_card_bind_info c
 where c.status_id='0'
	 and c.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and c.end_dt > to_date('${batch_date}', 'yyyymmdd')
;	
commit;

create table ${icl_schema}.tmp_cmm_e_acct_info_14(
	int_rat number(18,8) -- 利率
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_14(
	int_rat
)
select int_rat 
  from  iml.ref_indv_e_acct_int_rat_para
 where effect_dt in (select max(effect_dt) as effect_dt 
                       from iml.ref_indv_e_acct_int_rat_para 
                      where int_rat_id = 'HQLV'
                      	and create_dt <= to_date('${batch_date}','yyyymmdd')
                      	and job_cd = 'eassf1'
                      	and id_mark <> 'D')
   and int_rat_id = 'HQLV'
   and create_dt <= to_date('${batch_date}','yyyymmdd') 
   and job_cd = 'eassf1'
   and id_mark <> 'D'
;	
commit;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_16 
nologging
compress ${option_switch} for query high
as 
select pcm.product_category_id,
       pcm.product_id,
       apa.prod_type_code,
       apa.prod_type_name,
       ajr.debt_account,
       ajr.assets_account,
       ajr.currency_uom_id 
  from ${iol_schema}.fdms_account_journal_rule ajr
  left join ${iol_schema}.fdms_product_category_member pcm 
    on ajr.accounting_type = pcm.product_id
   and pcm.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and pcm.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.fdms_accounting_prod_adapter apa 
    on ajr.accounting_service = apa.account_service_code
   and apa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and apa.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where (ajr.debt_account like '6411%' or ajr.debt_account like '2231%')
   and ajr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ajr.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

whenever sqlerror exit sql.sqlcode;  
create table ${icl_schema}.tmp_cmm_e_acct_info_17_1
nologging
compress ${option_switch} for query high
as 
select t1.agt_id as agt_id,    
           t1.prd_id as prd_id,
           t1.txn_num as txn_num,
           t1.txn_amt as txn_amt,
		   'DPSS' as sys_code
from ${iol_schema}.dpss_dps_txn_dtl_dsnaps t1
where  to_date('${batch_date}', 'yyyymmdd')>=to_date('20201127', 'yyyymmdd')
   and t1.posting_dt=to_date('${batch_date}', 'yyyymmdd') 
union all  
select t2.agt_id as agt_id,    
           t2.prd_id as prd_id,
           t2.txn_num as txn_num,
           t2.txn_amt as txn_amt,
		   'EASS' as sys_code
from ${iol_schema}.eass_txn_evt_dtl_dsnaps t2
where  to_date('${batch_date}', 'yyyymmdd')>=to_date('20201127', 'yyyymmdd')
   and t2.posting_dt=to_date('${batch_date}', 'yyyymmdd') 
union all  
select  t3.account_number as agt_id,    
           t3.product_category_id as prd_id,
           t3.transaction_id as txn_num,
           t3.amount as txn_amt,
		   'EEAS' as sys_code
from ${iol_schema}.eeas_txn_evt_dtl_dsnaps t3
where  to_date('${batch_date}', 'yyyymmdd')>=to_date('20201127', 'yyyymmdd')
   and t3.posting_date=to_date('${batch_date}', 'yyyymmdd') 
union all  
select t4.account_number as  agt_id,
           t4.product_category_id as prd_id,
           t4.transaction_id as txn_num,
           t4.amount as txn_amt,
           t4.origin_sys_id as sys_code
from msl.fdm_trans_info_backup t4
where to_date('${batch_date}', 'yyyymmdd')<to_date('20201127', 'yyyymmdd')
and t4.posting_date =to_date('${batch_date}', 'yyyymmdd')
and t4.origin_sys_id  in ('DPSS','EASS','EEAS')
;
commit;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_17 
nologging
compress ${option_switch} for query high
as 
select txn.agt_id,
       max(case when (subj.debt_account like '6411%' and subj.debt_account not like '64110151%' and
                      subj.debt_account not in ('64110199', '64110299')) then
                  subj.debt_account
                else '' end) as int_expns_subj_id,
       max(case when (subj.debt_account like '64110151%' or subj.debt_account in ('64110199', '64110299')) then
                  subj.debt_account
                else '' end) as int_expns_adj_subj_id,
       max(case when (subj.debt_account like '2231%' and subj.debt_account not like '223151%' and
                      subj.debt_account not in ('223198', '22319801', '223199')) then
                  subj.debt_account
                else '' end) as int_paybl_subj_id,
       max(case when (subj.debt_account like '223151%' or subj.debt_account in ('223198', '22319801', '223199')) then
                  subj.debt_account
                else '' end) as int_paybl_adj_subj_id,
       sum(case when (subj.debt_account like '6411%' and subj.debt_account not like '64110151%' and
                      subj.debt_account not in ('64110199', '64110299')) then
                  txn_amt
                else 0 end) as td_int_expns,
       sum(case when (subj.debt_account like '64110151%' or subj.debt_account in ('64110199', '64110299')) then
                  txn_amt
                else 0 end) as td_int_expns_adj,
       sum(case when (subj.debt_account like '2231%' and subj.debt_account not like '223151%' and
                      subj.debt_account not in ('223198', '22319801', '223199')) then
                  txn_amt
                else 0 end) as currt_acru_int,
       sum(case when (subj.debt_account like '223151%' or subj.debt_account in ('223198', '22319801', '223199')) then
                  txn_amt
                else 0 end) as currt_int_paybl_adj
  from (select agt_id, prd_id, txn_num, sum(txn_amt) as txn_amt
          from (select agt_id, prd_id, txn_num, sum(txn_amt) as txn_amt
                  from ${icl_schema}.tmp_cmm_e_acct_info_17_1
                 where sys_code ='EASS'
                 group by agt_id, prd_id, txn_num
                 union all 
                select agt_id, prd_id, txn_num, sum(txn_amt) as txn_amt
                  from ${icl_schema}.tmp_cmm_e_acct_info_17_1
                 where sys_code ='DPSS'
                 group by agt_id, prd_id, txn_num
               )
         group by agt_id, prd_id, txn_num) txn
 inner join ${icl_schema}.tmp_cmm_e_acct_info_16 subj
    on subj.product_category_id = txn.prd_id
   and subj.prod_type_code = txn.txn_num
 where 1 = 1
 group by txn.agt_id
;
commit;


-- 新旧数仓账号映射
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_e_acct_info_19 
nologging
compress ${option_switch} for query high
as 
select t1.dpact_no as cds_liab_acct_num,
      (case when trim(t9.contract_id) is not null then(case when length(t9.contract_id) >= 10 then t9.contract_id
                                                            else 'D' || lpad(t9.contract_id, '9', 0)
                                                            end)
            else (case when t1.dep_kind in ('26', '27') then t7.rsv_adfld
                       when t1.dep_kind = '30' then (case when trim(t7.contract_cod) is not null then 'T' || substr(t7.contract_cod, -9)
                                                          else t2.cust_acctno end)
                       else t2.cust_acctno end)
            end) as odw_acct_id,
       coalesce(t13.acctid, t12.fin_account_id, t7.rsv_adfld) as ndw_acct_id
 from ${iol_schema}.dpss_dpa_acctinf t1
  left join ${iol_schema}.dpss_dpa_custacctref t2
    on t1.dpact_no = t2.sys_acctno
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.dpss_dpa_cdcont t7
    on t1.dpact_no = t7.dpact_no
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.dpss_dps_dpactnodef t9
    on t9.dpact_no = t1.dpact_no
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.dpss_dpa_acctinf_add t10
    on t1.dpact_no = t10.dpact_no
   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select liab_acct,prd_acct ,sub_num,row_number() over(partition by  liab_acct order by cretificate_id desc) rn
               from ${iol_schema}.dpss_dps_cretificate
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and issue_crecates = 'Y') t11
    on t1.dpact_no = t11.liab_acct
   and t11.rn=1
  left join ${iol_schema}.eass_bill_fin_acc_assoc t12
    on t12.billing_account_id = nvl(t11.prd_acct, t10.rsv_acfld)
   and t12.account_sequence = nvl(t11.sub_num, t10.rsv_adfld)
   and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.cbss_kna_accs t13
    on t13.acctno = nvl(t11.prd_acct, t10.rsv_acfld)
   and t13.subsac = nvl(t11.sub_num, t10.rsv_adfld)
   and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.acct_opec_date <= '${batch_date}'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;


-- 1.2 create table for exchage and add partition

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_e_acct_info_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_e_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_e_acct_info where 0=1
;      
commit;

-- 第一组（个人电子账户)
whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into ${icl_schema}.cmm_e_acct_info_ex(
   etl_dt                                  -- 数据日期
   ,lp_id                                  -- 法人编号
   ,acct_id                                -- 账户编号
   ,acct_name                              -- 账户名称
   ,cust_acct_id                           -- 客户账户编号
   ,cust_sub_acct_num 					           -- 客户账户子户号
   ,liab_acct_id                           -- 负债账户编号
   ,old_acct_id                            -- 旧账户编号
   ,intnal_acct_id                         -- 内部账户编号
   ,e_acct_med_id                          -- 电子账户介质编号
   ,e_acct_med_type_cd                     -- 电子账户介质类型代码
   ,bd_card_card_no                        -- 绑定卡卡号
   ,bd_card_open_bank_id                   -- 绑定卡开户行编号
   ,bd_card_open_bank_name                 -- 绑定卡开户行名称
   ,cust_id                                -- 客户编号
   ,subj_id                                -- 科目编号
   ,int_paybl_subj_id                      -- 应付利息科目编号
   ,int_paybl_adj_subj_id                  -- 应付利息调整科目编号
   ,int_expns_subj_id                      -- 利息支出科目编号
   ,int_expns_adj_subj_id                  -- 利息支出调整科目编号
   ,prod_id                                -- 产品编号
   ,std_prod_id							               -- 标准产品编号
   ,dep_term							                 -- 存期
   ,dep_kind_cd                            -- 储种代码
   ,acct_cls_cd                            -- 账户分类代码
   ,acct_type_cd                           -- 账户类型代码
   ,e_acct_type_cd                         -- 电子账户类型代码
   ,dep_acct_status_cd                     -- 存款账户状态代码
   ,corp_acct_flg                          -- 对公账户标志
   ,rc_flg                                 -- 定活标志
   ,web_dep_flg							               -- 网络存款标志
   ,general_exch_flg                       -- 通兑标志
   ,margin_flg                             -- 保证金标志
   ,advise_dep_flg						             -- 通知存款标志
   ,ec_flg                                 -- 钞汇标志
   ,privavy_acct_flg                       -- 隐私账户标志
   ,legal_acct_flg                         -- 涉案账户标志
   ,sleep_acct_flg                         -- 睡眠户标志
   ,froz_flg                               -- 冻结标志
   ,bind_acct_flg                          -- 绑定账户标志
   ,int_accr_flg                           -- 计息标志
   ,auto_redt_flg	   	        		         -- 自动转存标志
   ,redt_way_cd				        	           -- 转存方式代码 
   ,int_accr_base_cd          			       -- 计息基准代码
   ,int_set_way_cd                         -- 结息方式代码
   ,int_accr_way_cd                        -- 计息方式代码
   ,curr_cd                                -- 币种代码
   ,open_acct_chn_type_cd                  -- 开户渠道类型代码
   ,tran_chn_status_cd                     -- 交易渠道状态代码
   ,open_acct_dt                 		       -- 开户日期
   ,open_acct_tm                           -- 开户时间
   ,clos_acct_dt  						             -- 销户日期
   ,clos_acct_tm                           -- 销户时间
   ,actv_dt                                -- 激活日期
   ,value_dt                               -- 起息日期
   ,exp_dt                                 -- 到期日期
   ,final_activ_acct_dt                    -- 最后动户日期
   ,froz_dt                                -- 冻结日期
   ,unfrz_dt                               -- 解冻日期
   ,last_int_set_dt                        -- 上次结息日期
   ,next_int_set_dt                        -- 下次结息日期
   ,fir_value_dt                           -- 首次起息日期
   ,base_rat_type_cd					             -- 基准利率类型代码
   ,base_rat 							                 -- 基准利率
   ,exec_int_rat                           -- 执行利率
   ,td_acru_int                            -- 当日应计利息
   ,currt_acru_int                         -- 当期应计利息
   ,currt_int_paybl_adj                    -- 当期应付利息调整
   ,td_int_expns                           -- 当日利息支出
   ,td_int_expns_adj                       -- 当日利息支出调整
   ,open_acct_teller_id                    -- 开户柜员编号
   ,clos_acct_teller_id                    -- 销户柜员编号
   ,open_acct_org_id                       -- 开户机构编号
   ,close_acct_org_id                      -- 销户机构编号
   ,belong_org_id                          -- 所属机构编号
   ,camp_activ_id                          -- 营销活动编号
   ,referrer_type_cd                       -- 推荐人类型代码
   ,referrer_num                           -- 推荐人号码
   ,vtual_acct_flg                         -- 虚拟账户标志
   ,mercht_id                              -- 商户编号
   ,open_amt                               -- 开户金额
   ,currt_bal                              -- 当期余额
   ,aval_bal                               -- 可用余额
   ,froz_amt                               -- 冻结金额
   ,cl_curr_currt_bal                      -- 折本币当期余额
   ,ear_d_bal	                             -- 日初余额
   ,ear_m_bal	                             -- 月初余额
   ,ear_s_bal	                             -- 季初余额
   ,ear_y_bal	                             -- 年初余额
   ,y_acm_bal	                             -- 年累计余额
   ,s_acm_bal	                             -- 季累计余额
   ,m_acm_bal	                             -- 月累计余额
   ,cl_curr_ear_d_bal	                     -- 折本币日初余额
   ,cl_curr_ear_m_bal	                     -- 折本币月初余额
   ,cl_curr_ear_s_bal	                     -- 折本币季初余额
   ,cl_curr_ear_y_bal	                     -- 折本币年初余额
   ,cl_curr_y_acm_bal	                     -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal	               -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal	               -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal	               -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal	               -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal	                     -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal	               -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal	               -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal	               -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal	                     -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal	               -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal	               -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal	               -- 折本币年初月累计余额
   ,entry_flg                              -- 记账标志
   ,y_avg_bal        					             -- 年日均余额
   ,q_avg_bal        					             -- 季日均余额
   ,m_avg_bal        					             -- 月日均余额
   ,cl_curr_y_avg_bal					             -- 折本币年日均余额
   ,cl_curr_q_avg_bal					             -- 折本币季日均余额
   ,cl_curr_m_avg_bal					             -- 折本币月日均余额
   ,job_cd                                 -- 任务代码
   ,etl_timestamp                          -- etl处理时间戳
)
select 
   to_date('${batch_date}','yyyymmdd')           -- 数据日期
   ,t1.lp_id                                     -- 法人编号
   ,t1.prod_acct_id                              -- 账户编号
   ,t1.acct_name                                 -- 账户名称
   ,t2.e_acct_id                                 -- 客户账户编号
   ,t2.acct_sub_seq_num						            	 -- 客户账户子户号
   ,t31.liab_acct_num                            -- 负债账户编号
   ,t39.odw_acct_id                              -- 旧账户编号
   ,t3.external_account_id                       -- 内部账户编号
   ,t2.e_acct_id                                 -- 电子账户介质编号
   ,t2.med_type_cd                               -- 电子账户介质类型代码
   ,t19.card_no                                  -- 绑定卡卡号
   ,t19.bank_number                              -- 绑定卡开户行编号
   ,t19.bank_name                                -- 绑定卡开户行名称
   ,nvl(trim(t3.party_id),trim(t2.party_id))     -- 客户编号
   ,t4.subj_id                                   -- 科目编号
   ,t38.int_paybl_subj_id                        -- 应付利息科目编号
   ,t38.int_paybl_adj_subj_id                    -- 应付利息调整科目编号
   ,t38.int_expns_subj_id                        -- 利息支出科目编号
   ,t38.int_expns_adj_subj_id                    -- 利息支出调整科目编号
   ,t2.prod_id                                   -- 产品编号
   ,nvl(trim(t31.std_prod_id),t30.prod_id)       -- 标准产品编号
   ,nvl(t31.dep_term, '000')					           -- 存期
   ,case when t31.dep_kind_cd = '05' then 'S07' 
     		 --	 when t31.dep_kind_cd = '01' then 'A13' 
     	   when t31.dep_kind_cd = '01' then 'S22'
         when t31.dep_kind_cd = '26' then 'S21' 
         when t31.dep_kind_cd = '27' then 'A18'
         when t31.dep_kind_cd = '28' then 'S02'
         when t31.dep_kind_cd = '29' then 'S02'
         when t2.prod_id = '0900100200207' then 'A15'
         when t2.prod_id in ('0900500100206','0900500100205') then 'A01'
         when t2.prod_id = '0900200100203' then 'S18'
         when t2.prod_id = '0900200100204' then 'S02'
         when t2.prod_id in ('0900100100201','0900100100203','0900500100204') then 'S09'
         when t2.prod_id = '0900100200208' then 'S07'
         when t2.prod_id in ('0900100200205','0900100200210') then 'S17'
				 else '000'
		end as dep_kind_cd              		                                      -- 储种代码
   ,t1.fin_acct_type_cd                                                       -- 账户分类代码
   ,case 
     when t3.account_category_level = 'FIRST-ACCT' then '1'
     when t3.account_category_level = 'SECOND-ACCT' then '2'
     when t3.account_category_level = 'THIRD-ACCT' then '3'
     when t3.account_category_level = 'TEMP-ACCT' then '6'
     else '0'
   end                                                                        -- 账户类型代码
   ,nvl(trim(t3.account_type),'EAFE')                                         -- 电子账户类型代码
   ,nvl(trim(t28.agt_status_cd),'02')                                         -- 存款账户状态代码
   ,decode(t2.prod_id, '0900500100206', '1', '0900500100205', '1', '0')       -- 对公账户标志
   ,decode(t2.prod_id, '0900100200208', '1', '0900100200210', '1', '0900200100204', '1', '0900100200205', '1','0900200100203', '1', '0900100200212', '1', '0')   -- 定活标志
   ,case when t37.prod_id is not null then '1' else '0' end		                -- 网络存款标志
   ,nvl(trim(t3.cash_saving_withdw_id),'00')                                  -- 通兑标志
   ,case when t2.prod_id = '0900100200207' then '1' else '0' end              -- 保证金标志
   ,nvl(t31.advise_dep_flg, '0')				                                      -- 通知存款标志
   ,(case when trim(t3.cash_or_remit_id) = 'x' then '9' 
   				when trim(t3.cash_or_remit_id) is null then '9' else t3.cash_or_remit_id end) -- 钞汇标志
   ,nvl(trim(t3.private_acct_id),'0')                                         -- 隐私账户标志
   ,nvl(trim(t3.account_flag),'0')                                            -- 涉案账户标志
   ,case when t1.fin_acct_type_cd='12' 
         then nvl(trim(t3.sleep_account_status), '0') 
         else t40.agt_status_cd	end	                                          -- 睡眠户标志
   ,decode(t3.status_id, '2', '1', '5', '1', '0')                             -- 冻结标志
   ,case t22.status_id                                                        
     when  '0' then '1'                                                       
     else '0' end                                                             -- 绑定账户标志
   ,case when t31.liab_acct_num is not null 
		     then t31.int_accr_flg
		 		 else decode(t29.fea_val,'Y','1','0') end                             -- 计息标志
   ,nvl(t31.auto_redt_flg, '0')										                            -- 自动转存标志
   ,nvl(t31.redt_way_cd, '0')										                              -- 转存方式代码
  -- ,nvl(t31.int_accr_base_cd, '05')									                          -- 计息基准代码
    ,nvl(t31.int_accr_base_cd, '04')									                          -- 计息基准代码
   ,case when t31.liab_acct_num is not null then t31.int_set_way_cd
     		 when t2.prod_id = '0900100200205' then 'C0'
     		 else 'B2'
     	 end									               				                            -- 结息方式代码
   ,case when t31.acct_id is not null then t31.int_accr_way_cd
     		 when t2.prod_id = '0900100200205' then '02'
     		 else '01'
			 end           													                                -- 计息方式代码
   ,t1.curr_cd                                                                -- 币种代码
   ,nvl(trim(t3.channel),'XXXX')                                              -- 开户渠道类型代码
   ,nvl(trim(t3.channel_status),'0')                                          -- 交易渠道状态代码
   ,(case when t31.acct_id is not null and trim(t31.open_acct_dt) is not null 
          then t31.open_acct_dt else trunc(t1.agt_effect_tm) end )		        -- 开户日期
    ,(case when t31.acct_id is not null and trim(t31.open_acct_dt) is not null 
          then t31.open_acct_dt else t1.agt_effect_tm  end )                  -- 开户时间 
   ,case when (t1.agt_invalid_tm <> to_date('20991231','yyyymmdd') and trunc(t1.last_activ_acct_tm) > trunc(t1.agt_invalid_tm))
   			 then trunc(t1.last_activ_acct_tm)
     		 else trunc(t1.agt_invalid_tm)
 			 end															                                       -- 销户日期   --20201225修改
   ,case when (t1.agt_invalid_tm is not null and t1.last_activ_acct_tm > t1.agt_invalid_tm) then t1.last_activ_acct_tm
       else t1.agt_invalid_tm
     end as colse_dt                                                           -- 销户时间
   ,${iml_schema}.dateformat_min(t19.bind_date)                                -- 激活日期
   ,(case when t31.acct_id is not null then t31.value_dt
      		--when t2.prod_id = '0900100200210' then t27.value_dt 
      	  when (to_date(to_char(t1.agt_effect_tm, 'yyyymmdd'), 'yyyymmdd')) is not null then  (to_date(to_char(t1.agt_effect_tm, 'yyyymmdd'), 'yyyymmdd'))
		  else (case when t31.acct_id is not null and trim(t31.open_acct_dt) is not null 
                     then t31.open_acct_dt else trunc(t1.agt_effect_tm) end )
 		  end)                                                                     -- 起息日期   --20201225修改
   ,(case when t31.acct_id is not null then t31.exp_dt
      		--when t2.prod_id = '0900100200210' then t27.exp_dt 
      		else to_date('20991231','yyyymmdd')
				end)                                                                   -- 到期日期
   ,case when (to_date(to_char(t1.last_activ_acct_tm, 'yyyymmdd'), 'yyyymmdd') <> ${iml_schema}.dateformat_max('')) 
   																					then  to_date(to_char(t1.last_activ_acct_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss')
                                      when (to_date(to_char(t1.agt_invalid_tm, 'yyyymmdd'), 'yyyymmdd') <> ${iml_schema}.dateformat_max('')) 
        																		then to_date(to_char(t1.agt_invalid_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss')
        else to_date(to_char(t1.agt_effect_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') end                 -- 最后动户日期   --20201225修改
   ,${iml_schema}.dateformat_max(case when t28.agt_status_cd in ('02', '03') then t18.frozen_dt else null end)     -- 冻结日期  
   ,${iml_schema}.dateformat_max(case when t28.agt_status_cd in ('02', '03') then t18.unfrozen_dt else null end)   -- 解冻日期
   ,nvl(t31.last_int_set_dt,to_date(t32.attr_val, 'yyyymmdd'))                 -- 上次结息日期
   ,nvl(t31.next_int_set_dt,add_months(to_date(t32.attr_val, 'yyyymmdd'), 3))  -- 下次结息日期
   ,case when t31.liab_acct_num is not null then t31.init_value_dt
    	   else trunc(t1.agt_effect_tm)
		 end                       											                           -- 首次起息日期
   ,nvl(t31.base_rat_type_cd, '-')											                       -- 基准利率类型代码
   ,nvl(t31.base_rat, 0)													                             -- 基准利率       
   ,case when t31.acct_id is not null then t31.exec_int_rat
     		 when t2.prod_id = '0900100200205' then
       			(case when trunc(t1.acct_tm) < to_date('${batch_date}','yyyymmdd') + 1 then
               (case when nvl(t1.actl_bal, 0) = 0 then 0
                     else nvl(t6.sett_item_rate, 0) 
                 end)
             else
               (case when nvl(t20.yesterday_balance, 0) = 0 then 0
                     else nvl(t6.sett_item_rate, 0) 
                 end)
      			 end)
				 else nvl(t7.int_rat, 0) 
				 end                           						                              -- 执行利率
   ,(case when t31.liab_acct_num is not null then t31.ld_provi_int
      		else nvl(t33.td_acru_int, 0) 
 			end) 																                                      -- 当日应计利息
   /*,(case when t31.liab_acct_num is not null then t31.provi_int
      		else coalesce(t33.currt_acru_int, t38.currt_acru_int, 0)
 			end)																                                      -- 当期应计利息
 			*/
 	 ,case when t31.liab_acct_num is not null then t31.currt_acru_int
      	 else nvl(t42.currt_acru_int,0) end			 					                      -- 当期应计利息   -- modify htj 20210622
 	 ,nvl(t38.currt_int_paybl_adj, 0)                                             -- 当期应付利息调整
   ,nvl(t38.td_int_expns, 0)                                                    -- 当日利息支出
   ,nvl(t38.td_int_expns_adj, 0)                                                -- 当日利息支出调整
   ,'M0001'                                                                     -- 开户柜员编号
   ,'M0001'                                                                     -- 销户柜员编号
   ,t1.open_acct_org_id                                                         -- 开户机构编号
  -- ,t1.open_acct_org_id                                                       -- 销户机构编号
   ,''                                                                          -- 销户机构编号
   ,nvl(trim(t3.account_branch_id),t1.open_acct_org_id)                         -- 所属机构编号
   ,t10.camp_activ_id                                                           -- 营销活动编号
   ,t10.referrer_type_cd                                                        -- 推荐人类型代码
   ,t10.referrer_num                                                            -- 推荐人号码
   ,case when t3.account_type in ('DZHT', 'ILCE', 'BSVA', 'XZSP', 'XZSE') then '1' else '0' end -- 虚拟账户标志
   ,t2.mercht_id                                                                -- 商户编号
   ,nvl(t31.open_acct_amt,0)                                                    -- 开户金额
   ,coalesce(t25.acct_bal,t20.actual_balance,0)                                 -- 当期余额
   ,decode(t28.agt_status_cd, '02', 0, '03', 0, nvl(t20.available_balance, 0))  -- 可用余额
   ,case when t28.agt_status_cd in ( '01','04','05') then nvl(t21.freeze_amount,0)
        when t28.agt_status_cd = '02'  then nvl(t20.actual_balance, 0)
        when t28.agt_status_cd = '03' then nvl(t20.actual_balance, 0)
   else 0 end                                                                   -- 冻结金额
   ,coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat,1) -- 折本币当期余额
   ,nvl(t24.currt_bal,0.0)                                                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.ear_m_bal,0.0) end                                                                            -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.ear_s_bal,0.0) end                                                  -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.ear_y_bal,0.0) end                                                                          -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.y_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) end                                                                    -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.s_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) end                                            -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.m_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) end                                                                     -- 月累计余额
   ,nvl(coalesce(t25.acct_bal,t20.actual_balance,0),0.0) * nvl(t15.convt_cny_exch_rat,1)                                                                                                                                                          -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t24.cl_curr_currt_bal,0.0) else nvl(t24.cl_curr_ear_m_bal,0.0) end                                                              -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t24.cl_curr_currt_bal,0.0) else nvl(t24.cl_curr_ear_s_bal,0.0) end                                    -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t24.cl_curr_currt_bal,0.0) else nvl(t24.cl_curr_ear_y_bal,0.0) end                                                            -- 折本币年初余额    
   ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) else nvl(t24.cl_curr_y_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) end                           -- 折本币年累计余额
   ,nvl(t24.cl_curr_y_acm_bal,0.0)                                                                                                                                                    -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t24.cl_curr_y_acm_bal,0.0) else nvl(t24.cl_curr_ear_m_y_acm_bal,0.0) end                                             -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t24.cl_curr_y_acm_bal,0.0) else nvl(t24.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t24.cl_curr_y_acm_bal,0.0) else nvl(t24.cl_curr_ear_y_y_acm_bal,0.0) end                                           -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) else nvl(t24.cl_curr_s_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) end   -- 折本币季累计余额
   ,nvl(t24.cl_curr_s_acm_bal,0.0)                                                                                                                                                    -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t24.cl_curr_s_acm_bal,0.0) else nvl(t24.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t24.cl_curr_s_acm_bal,0.0) else nvl(t24.cl_curr_ear_y_s_acm_bal,0.0) end                                           -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) else nvl(t24.cl_curr_m_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) end                            -- 折本币月累计余额
   ,nvl(t24.cl_curr_m_acm_bal,0.0)                                                                                                                                                   -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t24.cl_curr_m_acm_bal,0.0) else nvl(t24.cl_curr_ear_m_m_acm_bal,0.0) end                                           -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t24.cl_curr_m_acm_bal,0.0) else nvl(t24.cl_curr_ear_y_m_acm_bal,0.0) end                                         -- 折本币年初月累计余额
   ,case when t2.prod_id = '0900500100205' then '0' else decode(t34.supply_acctnt_egin_flg, 'Y', '1', '0') end    -- 记账标志
   ,(case when substr('${batch_date}',5,4) = '0101' then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.y_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)      						 					 -- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.s_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)        						 					 -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then coalesce(t25.acct_bal,t20.actual_balance,0) else nvl(t24.m_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) end) / to_number(substr('${batch_date}', 7, 2))      						 					 -- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) else nvl(t24.cl_curr_y_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) end)	/	(to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)				 					 -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) else nvl(t24.cl_curr_s_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
	 ,(case when substr('${batch_date}',7,2) = '01' then coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) else nvl(t24.cl_curr_m_acm_bal,0.0) + coalesce(t25.acct_bal,t20.actual_balance,0) * nvl(t15.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
from ${iml_schema}.agt_indv_e_acct t1
 inner join ${iml_schema}.agt_indv_e_prod_acct_rela_h t2
 	 	on t1.prod_acct_id = t2.prod_acct_id
 	 	and nvl(t2.fea_name_cd,'XX') <> 'UPDATE_MEDIUM_NO' 
 	 	and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 	  and t2.job_cd = 'eassf1'
 	 left join ${iml_schema}.agt_status_h t28
 	 	on t1.agt_id = t28.agt_id
 	 	and t28.agt_status_type_cd = 'CD1246'
 	 	and t28.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	  and t28.end_dt > to_date('${batch_date}', 'yyyymmdd')
 	  and t28.job_cd = 'eassf1' 
 	 left join (select med_id,acct_id
 	 						 from ${iml_schema}.agt_syn_acct_med_rela_h
 	 						 where start_dt <= to_date('${batch_date}','yyyymmdd')
 	  						 and end_dt > to_date('${batch_date}','yyyymmdd')
 	  						 and job_cd='iatsf1'
 	 						 group by med_id,acct_id) t36
 	   on t36.med_id = t2.e_acct_id
   left join ${iol_schema}.iats_billing_account t3 
     on t36.acct_id = t3.external_account_id
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
 	  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.ref_prod_appl_info t4 
    on t2.prod_id = t4.prod_id
    and t4.sys_src_abbr = 'EASS'
    and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
 	  and t4.job_cd = 'fdmsf1'
   left join ${icl_schema}.tmp_cmm_e_acct_info_02 t6 
    on t1.prod_acct_id = t6.prod_acct_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_14 t7
	  on 1 = 1
   left join ${iml_schema}.agt_indv_e_acct_attr_h t8 
    on t1.prod_acct_id = t8.agt_id
    and t8.attr_cd = '04'
    and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t8.job_cd = 'eassi1'
   left join ${iml_schema}.agt_indv_e_acct_provi_stl_dtl t9 
    on t1.prod_acct_id = t9.prod_acct_id
    and t9.stl_type_cd = '02'
    and to_date(to_char(t9.stl_tm, 'yyyymmdd'), 'yyyymmdd') = to_date('${batch_date}', 'yyyymmdd')
    and t9.create_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t9.job_cd = 'eassf1'
    and t9.id_mark <> 'D'
   left join ${icl_schema}.tmp_cmm_e_acct_info_11 t10 
    on t3.billing_account_id = t10.billing_account_id
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t15
     on t1.curr_cd = t15.curr_sym_cd
    --and t15.dt = to_date('${batch_date}', 'yyyymmdd')
    and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
    --and t15.id_mark <> 'D'
    and t15.job_cd = 'cbssf1'
   left join ${icl_schema}.tmp_cmm_e_acct_info_03 t18 
    on t1.prod_acct_id = t18.prod_acct_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_04 t19 
    on t3.billing_account_id = t19.billing_account_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_01 t20
    on t20.agt_id = t1.agt_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_05 t21
    on t21.prod_acct_id=t1.prod_acct_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_13 t22
     on t22.billing_account_id = t3.billing_account_id
  left join ${iml_schema}.ref_indv_e_acct_sn_cfg_para t26
  	 on t2.prod_id = t26.prod_id
  	and t26.start_dt <= to_date('${batch_date}','yyyymmdd') 
  	and t26.end_dt > to_date('${batch_date}','yyyymmdd')
  	and t26.job_cd = 'eassf1'
  left join ${iml_schema}.agt_prod_bal_dtl_h t25
  	on t1.prod_acct_id = t25.acct_num
   and t25.sys_src_abbr = 'EASS' 
   and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t25.end_dt > to_date('${batch_date}','yyyymmdd')
   and t25.job_cd = 'fdmsf1'
  /*left join ${icl_schema}.tmp_cmm_e_acct_info_10 t27
    on t1.prod_acct_id=t27.prod_acct_id*/
  left join ${icl_schema}.cmm_e_acct_info t24
    on t24.acct_id = t1.prod_acct_id
   and t24.lp_id = t1.lp_id
   and t24.etl_dt = to_date('${batch_date}','yyyymmdd') - 1 
  left join (select prod_id,
                    fea_val,
                    row_number() over(partition by prod_id order by valid_tm desc) as rn
               from ${iml_schema}.ref_indv_e_acct_prod_fea_para
              where start_dt <= to_date('${batch_date}','yyyymmdd') 
  	            and end_dt > to_date('${batch_date}','yyyymmdd')
  	            and job_cd = 'eassf1'
  	            and en_name = 'interestFlag') t29
    on t2.prod_id = t29.prod_id 
   and t29.rn = 1
  left join ${iml_schema}.agt_prod_rela_h t30
    on t1.agt_id = t30.agt_id
   and t1.lp_id = t30.lp_id
   and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t30.end_dt > to_date('${batch_date}','yyyymmdd')
   --and t30.id_mark <> 'D'
   and t30.job_cd in ('eassf2', 'eassf1')
  left join ${icl_schema}.tmp_cmm_e_acct_info_12 t31
    on t2.e_acct_id = t31.acct_id
   and t2.acct_sub_seq_num = t31.prod_acct_num
  left join ${iml_schema}.agt_indv_e_acct_attr_h t32
  	on t1.prod_acct_id = t32.agt_id
   and t32.attr_cd = '05'
   and t32.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t32.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t32.job_cd = 'eassi1'
  left join (select pay.from_mem_cd,
				       			sum(case when trunc(pay.acct_tm) = to_date('${batch_date}', 'yyyymmdd') then nvl(pay.tran_amt, 0) else 0 end) as td_acru_int,
				       			sum(case when trunc(pay.acct_tm) <> to_date('${batch_date}', 'yyyymmdd') then nvl(pay.tran_amt, 0) else 0 end) as currt_acru_int
				 		   from ${iml_schema}.evt_indv_e_acct_pay_dtl pay
				 		   left join ${iml_schema}.agt_indv_e_acct_attr_h faa
				 		     on pay.from_mem_cd = faa.agt_id
				 		    and faa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
				 		    and faa.end_dt > to_date('${batch_date}', 'yyyymmdd')
				 		    and faa.attr_cd = '05'
				 		    and faa.job_cd='eassi1'
				 		  where pay.pay_type_cd = '002'
				 		    and trunc(pay.acct_tm) <= to_date('${batch_date}', 'yyyymmdd')
				 		    and trunc(pay.acct_tm) >= to_date(faa.attr_val, 'yyyymmdd')
				 		    and pay.etl_dt = to_date('${batch_date}', 'yyyymmdd')
				 		    and pay.job_cd='eassi1'
				 		  group by pay.from_mem_cd) t33
		on t1.prod_acct_id = t33.from_mem_cd
  left join ${iml_schema}.ref_indv_e_acct_sn_cfg_para t34
    on t34.prod_id = t2.prod_id
   and t34.job_cd = 'eassf1'
   and t34.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t34.end_dt > to_date('${batch_date}','yyyymmdd')
	left join (select *
 							 from ${iml_schema}.prd_rela_h a
 							start with prod_id = (select prod_id
                    from ${iml_schema}.prd_product
                   where prod_name = '个人平台存款')
							connect by prior prod_id = rela_prod_id) t37
		on nvl(trim(t31.std_prod_id),t30.prod_id) = t37.prod_id
	 and t30.lp_id = t37.lp_id
	 and t37.prod_rela_type_cd = '01'
	 and t37.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t37.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_e_acct_info_17 t38
    on nvl(t31.liab_acct_num, t1.prod_acct_id) = t38.agt_id
  left join ${icl_schema}.tmp_cmm_e_acct_info_19 t39
    on t39.ndw_acct_id =t1.prod_acct_id
	left join ${iml_schema}.agt_status_h t40
    on t1.agt_id=t40.agt_id
   and t40.agt_status_type_cd='CD1756'
	 and t40.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t40.end_dt > to_date('${batch_date}','yyyymmdd')
	 and t40.job_cd = 'eassf1'
	left join(                                                                                 -- add htj 20210622
           select  t4.prod_acct_id,sum(to_number(nvl(t4.attr_val, 0))) as currt_acru_int
             from  ${iml_schema}.agt_indv_e_acct_attr_h t4
        left join   ${iml_schema}.ref_pub_cd_map r1
               on t4.attr_cd = r1.target_cd_val
              and r1.sorc_sys_cd= 'EASS'
              and r1.src_tab_en_name= 'EASS_FIN_ACCOUNT_ATTRIBUTE'
              and r1.src_field_en_name= 'ATTR_NAME'
              and r1.target_tab_en_name= 'AGT_INDV_E_ACCT_ATTR_H'
              and r1.target_tab_field_en_name= 'ATTR_CD'
            where R1.src_code_val = 'lastCountInterestAmount'
              and t4.job_cd='eassf1'
              and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
              and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
         group by  t4.prod_acct_id
          )T42 
   on t1.prod_acct_id = t42.prod_acct_id	
where /*t2.prod_id not in ('0900200100204', '0900200100203')
    and*/ (t26.supply_h_dw_flg = 'Y' or t26.supply_acctnt_egin_flg = 'Y')
    and to_date(to_char(t2.effect_tm, 'yyyymmdd'), 'yyyymmdd') < to_date('${batch_date}','yyyymmdd') + 1
    and length(t1.prod_acct_id) <> 6
    and t1.job_cd = 'eassf1'
    and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.id_mark <> 'D'
;
commit;


whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_06(
   prod_acct_id  varchar2(60)
   ,teller_id  varchar2(60)
   ,org_id  varchar2(60)
)
nologging                               
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_06(
   prod_acct_id
   ,teller_id
   ,org_id
)
select prod_acct_id
			,teller_id
			,org_id
    from ${iml_schema}.agt_corp_e_acct_status_h fasi
   where fasi.start_dt =
         (select max(start_dt)
            from ${iml_schema}.agt_corp_e_acct_status_h
           where acct_status_cd = '01'
             and prod_acct_id = fasi.prod_acct_id
             and start_dt <= to_date('${batch_date}','yyyymmdd')
             and end_dt > to_date('${batch_date}','yyyymmdd')
             and job_cd = 'eeasf1')
     and acct_status_cd = '01'
     and end_dt > to_date('${batch_date}','yyyymmdd')
     and job_cd = 'eeasf1'
;
commit; 

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_07(
   prod_acct_id  varchar2(60)
   ,teller_id  varchar2(60)
   ,org_id  varchar2(60)
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_07(
   prod_acct_id
   ,teller_id
   ,org_id
)
select prod_acct_id
			 ,teller_id
			 ,org_id
    from ${iml_schema}.agt_corp_e_acct_status_h fasi
   where fasi.start_dt =
         (select max(start_dt)
            from ${iml_schema}.agt_corp_e_acct_status_h
           where acct_status_cd = '04'
             and prod_acct_id = fasi.prod_acct_id
             and start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and end_dt > to_date('${batch_date}', 'yyyymmdd')
             and job_cd = 'eeasf1' )
     and acct_status_cd = '04'
     and end_dt > to_date('${batch_date}', 'yyyymmdd')
     and job_cd = 'eeasf1'
;   
commit;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_08(
   prod_acct_id	varchar2(60)
   ,frozen_dt	date
   ,unfrozen_dt	date
   ,amount	number(30,2)
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into tmp_cmm_e_acct_info_08(
   prod_acct_id
  ,frozen_dt
  ,unfrozen_dt
  ,amount
)
select 
   prod_acct_id
   ,to_date(to_char(max(acct_froz_start_tm), 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') as frozen_dt
   ,to_date(to_char(max(acct_froz_end_tm), 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') as unfrozen_dt
  ,sum(case when init_auth_id is null then nvl(froz_amt, 0)
      else 0 end) as amount
from ${iml_schema}.agt_corp_e_acct_froz_h
  where froz_rec_type_cd = '02'
     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and end_dt > to_date('${batch_date}', 'yyyymmdd')
     and job_cd = 'eeasf1'
  group by prod_acct_id
;
commit;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_09(
   agt_id varchar2(60)
   ,available_balance number(30,2)
   ,actual_balance number(30,2)
   ,yesterday_balance number(30,2)
)
nologging
compress ${option_switch} for query high
;
insert /*+ append */ into ${icl_schema}.tmp_cmm_e_acct_info_09(
	 agt_id
	 ,available_balance
	 ,actual_balance
	 ,yesterday_balance
)
select
    agt_id
    ,max(case when bal_type_cd = '002003' then bal end) as available_balance
    ,max(case when bal_type_cd = '002002' then bal end) as actual_balance
    ,max(case when bal_type_cd = '002001' then bal end) as yesterday_balance
from ${iml_schema}.agt_bal_h 
 where start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and end_dt > to_date('${batch_date}', 'yyyymmdd')
  and job_cd = 'eeasf1'
 group by agt_id
;
commit;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_e_acct_info_18 
nologging
compress ${option_switch} for query high
as 
select txn.agt_id,
       max(case when (subj.debt_account like '6411%' and subj.debt_account not like '64110151%' and
                      subj.debt_account not in ('64110199', '64110299')) then
                  subj.debt_account
                else '' end) as int_expns_subj_id,
       max(case when (subj.debt_account like '64110151%' or subj.debt_account in ('64110199', '64110299')) then
                  subj.debt_account
                else '' end) as int_expns_adj_subj_id,
       max(case when (subj.debt_account like '2231%' and subj.debt_account not like '223151%' and
                      subj.debt_account not in ('223198', '22319801', '223199')) then
                  subj.debt_account
                else '' end) as int_paybl_subj_id,
       max(case when (subj.debt_account like '223151%' or subj.debt_account in ('223198', '22319801', '223199')) then
                  subj.debt_account
                else '' end) as int_paybl_adj_subj_id,
       sum(case when (subj.debt_account like '6411%' and subj.debt_account not like '64110151%' and
                      subj.debt_account not in ('64110199', '64110299')) then
                  txn_amt
                else 0 end) as td_int_expns,
       sum(case when (subj.debt_account like '64110151%' or subj.debt_account in ('64110199', '64110299')) then
                  txn_amt
                else 0 end) as td_int_expns_adj,
       sum(case when (subj.debt_account like '2231%' and subj.debt_account not like '223151%' and
                      subj.debt_account not in ('223198', '22319801', '223199')) then
                  txn_amt
                else 0 end) as currt_acru_int,
       sum(case when (subj.debt_account like '223151%' or subj.debt_account in ('223198', '22319801', '223199')) then
                  txn_amt
                else 0 end) as currt_int_paybl_adj
  from (select  agt_id,prd_id,txn_num,sum(txn_amt) as txn_amt
              from ${icl_schema}.tmp_cmm_e_acct_info_17_1
			  where sys_code ='EEAS'
            group by agt_id,prd_id,txn_num
            ) txn
 inner join ${icl_schema}.tmp_cmm_e_acct_info_16 subj
    on subj.product_category_id = txn.prd_id
   and subj.prod_type_code = txn.txn_num
 where 1 = 1
 group by txn.agt_id
;
commit;

-- 第二组（企业电子账户)
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_e_acct_info_ex(
   etl_dt	                                -- 数据日期
   ,lp_id	                                -- 法人编号
   ,acct_id	                              -- 账户编号
   ,acct_name	                            -- 账户名称
   ,cust_acct_id	                        -- 客户账户编号
   ,cust_sub_acct_num						          -- 客户账户子户号
   ,liab_acct_id                          -- 负债账户编号
   ,old_acct_id                           -- 旧账户编号
   ,intnal_acct_id                        -- 内部账户编号
   ,e_acct_med_id                         -- 电子账户介质编号
   ,e_acct_med_type_cd                    -- 电子账户介质类型代码
   ,bd_card_card_no                       -- 绑定卡卡号
   ,bd_card_open_bank_id                  -- 绑定卡开户行编号
   ,bd_card_open_bank_name                -- 绑定卡开户行名称
   ,cust_id	                              -- 客户编号
   ,subj_id	                              -- 科目编号
   ,int_paybl_subj_id                     -- 应付利息科目编号
   ,int_paybl_adj_subj_id                 -- 应付利息调整科目编号
   ,int_expns_subj_id                     -- 利息支出科目编号
   ,int_expns_adj_subj_id                 -- 利息支出调整科目编号
   ,prod_id	                              -- 产品编号
   ,std_prod_id								            -- 标准产品编号
   ,dep_term   								            -- 存期
   ,dep_kind_cd	                          -- 储种代码
   ,acct_cls_cd	                          -- 账户分类代码
   ,acct_type_cd	                        -- 账户类型代码
   ,e_acct_type_cd	                      -- 电子账户类型代码
   ,dep_acct_status_cd	                  -- 存款账户状态代码
   ,corp_acct_flg	                        -- 对公账户标志
   ,rc_flg	                              -- 定活标志
   ,web_dep_flg							              -- 网络存款标志
   ,general_exch_flg	                    -- 通兑标志
   ,margin_flg	                          -- 保证金标志
   ,advise_dep_flg						            -- 通知存款标志
   ,ec_flg	                              -- 钞汇标志
   ,privavy_acct_flg	                    -- 隐私账户标志
   ,legal_acct_flg	                      -- 涉案账户标志
   ,sleep_acct_flg	                      -- 睡眠户标志
   ,froz_flg	                            -- 冻结标志
   ,bind_acct_flg	                        -- 绑定账户标志
   ,int_accr_flg                          -- 计息标志
   ,auto_redt_flg    						          -- 自动转存标志
   ,redt_way_cd      						          -- 转存方式代码
   ,int_accr_base_cd 						          -- 计息基准代码
   ,int_set_way_cd	                      -- 结息方式代码
   ,int_accr_way_cd	                      -- 计息方式代码
   ,curr_cd	                              -- 币种代码
   ,open_acct_chn_type_cd	                -- 开户渠道类型代码
   ,tran_chn_status_cd	                  -- 交易渠道状态代码
   ,open_acct_dt 							            -- 开户日期
   ,open_acct_tm	                        -- 开户时间
   ,clos_acct_dt 							            -- 销户日期
   ,clos_acct_tm	                        -- 销户时间
   ,actv_dt	                              -- 激活日期
   ,value_dt	                            -- 起息日期
   ,exp_dt	                              -- 到期日期
   ,final_activ_acct_dt	                  -- 最后动户日期
   ,froz_dt	                              -- 冻结日期
   ,unfrz_dt	                            -- 解冻日期
   ,last_int_set_dt                       -- 上次结息日期
   ,next_int_set_dt                       -- 下次结息日期
   ,fir_value_dt                          -- 首次起息日期
   ,base_rat_type_cd  					         	-- 基准利率类型代码
   ,base_rat								              -- 基准利率
   ,exec_int_rat	                        -- 执行利率
   ,td_acru_int	                          -- 当日应计利息
   ,currt_acru_int	                      -- 当期应计利息
   ,currt_int_paybl_adj                   -- 当期应付利息调整
   ,td_int_expns                          -- 当日利息支出
   ,td_int_expns_adj                      -- 当日利息支出调整
   ,open_acct_teller_id	                  -- 开户柜员编号
   ,clos_acct_teller_id	                  -- 销户柜员编号
   ,open_acct_org_id	                    -- 开户机构编号
   ,close_acct_org_id	                    -- 销户机构编号
   ,belong_org_id	                        -- 所属机构编号
   ,camp_activ_id	                        -- 营销活动编号
   ,referrer_type_cd	                    -- 推荐人类型代码
   ,referrer_num	                        -- 推荐人号码
   ,vtual_acct_flg	                      -- 虚拟账户标志
   ,mercht_id	                            -- 商户编号
   ,open_amt                              -- 开户金额
   ,currt_bal	                            -- 当期余额
   ,aval_bal	                            -- 可用余额
   ,froz_amt	                            -- 冻结金额
   ,cl_curr_currt_bal	                    -- 折本币当期余额
   ,ear_d_bal	                            -- 日初余额
   ,ear_m_bal	                            -- 月初余额
   ,ear_s_bal	                            -- 季初余额
   ,ear_y_bal	                            -- 年初余额
   ,y_acm_bal	                            -- 年累计余额
   ,s_acm_bal	                            -- 季累计余额
   ,m_acm_bal	                            -- 月累计余额
   ,cl_curr_ear_d_bal	                    -- 折本币日初余额
   ,cl_curr_ear_m_bal	                    -- 折本币月初余额
   ,cl_curr_ear_s_bal	                    -- 折本币季初余额
   ,cl_curr_ear_y_bal	                    -- 折本币年初余额
   ,cl_curr_y_acm_bal	                    -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal	              -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal	              -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal	              -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal	              -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal	                    -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal	              -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal	              -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal	              -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal	                    -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal	              -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal	              -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal	              -- 折本币年初月累计余额
   ,entry_flg                             -- 记账标志
   ,y_avg_bal        						          -- 年日均余额
   ,q_avg_bal        						          -- 季日均余额
   ,m_avg_bal        						          -- 月日均余额
   ,cl_curr_y_avg_bal						          -- 折本币年日均余额
   ,cl_curr_q_avg_bal						          -- 折本币季日均余额
   ,cl_curr_m_avg_bal						          -- 折本币月日均余额
   ,job_cd                                -- 任务代码
   ,etl_timestamp                         -- etl处理时间戳
)     
select
   to_date('${batch_date}','yyyymmdd')      -- 数据日期
   ,t1.lp_id                                -- 法人编号
   ,t1.prod_acct_id                         -- 账户编号
  -- ,t1.acct_name                            -- 账户名称
   ,nvl(t3.billing_account_name,t1.acct_name)          -- 账户名称
   ,t2.acct_id                              -- 客户账户编号
   ,nvl(trim(t2.acct_sub_seq_num),'000001')  -- 客户账户子户号
   ,''                                      -- 负债账户编号
   ,t39.odw_acct_id                         -- 旧账户编号
   ,t3.external_account_id                  -- 内部账户编号
   ,t2.e_acct_id                            -- 电子账户介质编号
   ,'-'                                      -- 电子账户介质类型代码
   ,t18.card_no                             -- 绑定卡卡号
   ,t18.bank_number                         -- 绑定卡开户行编号
   ,t18.bank_name                           -- 绑定卡开户行名称
   ,nvl(trim(t3.party_id),trim(t2.cust_id)) -- 客户编号
   ,t15.subj_id                             -- 科目编号
   ,t38.int_paybl_subj_id                   -- 应付利息科目编号
   ,t38.int_paybl_adj_subj_id               -- 应付利息调整科目编号
   ,t38.int_expns_subj_id                   -- 利息支出科目编号
   ,t38.int_expns_adj_subj_id               -- 利息支出调整科目编号
   ,t2.prod_id                              -- 产品编号
   ,t27.prod_id								              -- 标准产品编号
   ,'000'									                  -- 存期
   ,case when t1.fin_acct_type_cd in ('12', '28') then 'P01' else '000' end             -- 储种代码
   ,t1.fin_acct_type_cd                     -- 账户分类代码
   ,case 
     when t3.account_category_level = 'FIRST-ACCT' then '1'
     when t3.account_category_level = 'SECOND-ACCT'then '2'
     when t3.account_category_level = 'THIRD-ACCT' then '3'
     when t3.account_category_level = 'TEMP-ACCT' then '6'
     else '0'
     end                                                        -- 账户类型代码
   ,nvl(trim(t3.account_type),'HXYJ')                           -- 电子账户类型代码
   ,nvl(trim(t24.agt_status_cd),'02')                           -- 存款账户状态代码
   ,decode(t3.account_type, 'ILCE', '1', '0')                   -- 对公账户标志
   ,'0'                                                         -- 定活标志
   ,case when t37.prod_id is not null then '1' else '0' end	    -- 网络存款标志
   ,nvl(trim(t3.cash_saving_withdw_id),'00')                    -- 通兑标志
   ,'0'                                                         -- 保证金标志
   ,'0'															                            -- 通知存款标志
   ,nvl(trim(t3.cash_or_remit_id), '1')                         -- 钞汇标志
   ,nvl(trim(t3.private_acct_id),'0')                           -- 隐私账户标志
   ,nvl(trim(t3.account_flag),'0')                              -- 涉案账户标志
   ,nvl(trim(t3.sleep_account_status),'0')                      -- 睡眠户标志
   ,decode(t3.status_id, '2', '1', '5', '1', '0')               -- 冻结标志
   ,'1'  --case t20.status_id when  '0' then '1' else '0' End   -- 绑定账户标志
   ,decode(t25.fea_val, 'Y', '1', '0')                          -- 计息标志
   ,'0'   														                          -- 自动转存标志
   ,'0'   														                          -- 转存方式代码
  -- ,'05'  														                          -- 计息基准代码
   ,'04'  														                          -- 计息基准代码
   ,'B2'                                                        -- 结息方式代码
   ,'01'                                                        -- 计息方式代码
   ,t1.curr_cd                                                  -- 币种代码
   ,nvl(t3.channel,'XXXX')                                      -- 开户渠道类型代码
   ,nvl(t3.channel_status,'0')                                  -- 交易渠道状态代码
   ,trunc(t1.agt_effect_tm)										                  -- 开户日期
   ,t1.agt_effect_tm                                            -- 开户时间
   ,case when (t1.agt_invalid_tm is not null and trunc(t1.last_activ_acct_tm) > trunc(t1.agt_invalid_tm))
   			 then trunc(t1.last_activ_acct_tm)
    		 else trunc(t1.agt_invalid_tm)
				end												                              -- 销户日期
   ,case when (to_date(to_char(t1.agt_invalid_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') <> ${iml_schema}.dateformat_max('')
              and t1.last_activ_acct_tm > t1.agt_invalid_tm) then
              t1.last_activ_acct_tm
             else
              t1.agt_invalid_tm
           end as colse_dt                                      -- 销户时间
   ,${iml_schema}.dateformat_min(t18.bind_date)                 -- 激活日期
   ,${iml_schema}.dateformat_min(decode(t2.prod_id,'1000100100201',to_date(t4.attr_val,'yyyy-mm-dd') + 1))             -- 起息日期
   ,${iml_schema}.dateformat_max('')                                                                                   -- 到期日期
   ,${iml_schema}.dateformat_max(case when to_date(to_char(t1.last_activ_acct_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') <> ${iml_schema}.dateformat_max('')
                                      then to_date(to_char(t1.last_activ_acct_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss')
                                      when to_date(to_char(t1.agt_invalid_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss') <> ${iml_schema}.dateformat_max('')
                                      then to_date(to_char(t1.agt_invalid_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss')
                                      else to_date(to_char(t1.agt_effect_tm, 'yyyymmdd hh24:mi:ss'), 'yyyymmdd hh24:mi:ss')
                                       end)                                                                            -- 最后动户日期
   ,${iml_schema}.dateformat_max((case when t24.agt_status_cd in ('02', '03') then t14.frozen_dt else null end))       -- 冻结日期
   ,${iml_schema}.dateformat_max((case when t24.agt_status_cd in ('02', '03') then t14.unfrozen_dt else null end))     -- 解冻日期
   ,to_date(t4.attr_val, 'yyyymmdd')                  																   -- 上次结息日期
   ,add_months(to_date(t4.attr_val,'yyyymmdd'),3)     																   -- 下次结息日期
   ,trunc(t1.agt_effect_tm)                           																   -- 首次起息日期
   ,'000'																											                           -- 基准利率类型代码
   ,'0.00'																											                         -- 基准利率
   ,nvl(to_number(t5.int_rat),0)                                                         -- 执行利率
  -- ,nvl(t26.td_acru_int,0)                                                               -- 当日应计利息
   ,nvl(t7.provi_amt, 0)+nvl(t7.should_add_decrs_int,0)                                  -- 当日应计利息
--   ,coalesce(t26.currt_acru_int, t38.currt_acru_int, 0)                   			      	 -- 当期应计利息
   ,nvl(t36.currt_acru_int, 0)                                                           -- 当期应计利息
   ,nvl(t38.currt_int_paybl_adj, 0)                                                      -- 当期应付利息调整
   ,nvl(t38.td_int_expns, 0)                                                             -- 当日利息支出
   ,nvl(t38.td_int_expns_adj, 0)                                                         -- 当日利息支出调整
   ,nvl(t8.teller_id, 'M0001')                                                           -- 开户柜员编号
   ,t17.teller_id                                                                        -- 销户柜员编号
  -- ,nvl(t8.org_id, '802011')                                                             -- 开户机构编号
   ,t1.sign_org_id                                                                       -- 开户机构编号
   ,t17.org_id                                                                           -- 销户机构编号
   ,coalesce(trim(t3.account_branch_id),t8.org_id, '802011')                             -- 所属机构编号
   ,t11.attr_value                                                                       -- 营销活动编号
   ,nvl(t12.attr_value,'0')                                                              -- 推荐人类型代码
   ,t13.attr_value                                                                       -- 推荐人号码
   ,case when t3.account_type in ('DZHT', 'ILCE', 'BSVA', 'XZSP', 'XZSE') then '1' else '0' end  -- 虚拟账户标志
   ,t2.mercht_id                                                                         -- 商户编号
   ,0                                                                                    -- 开户金额
   ,coalesce(t22.acct_bal,t19.actual_balance,0)                                          -- 当期余额
   ,decode(t24.agt_status_cd, '02', 0, '03', 0, nvl(t19.available_balance, 0))           -- 可用余额        
   ,case when t24.agt_status_cd = '01' then nvl(t14.amount, 0)
            when t24.agt_status_cd = '02'  then nvl(t19.actual_balance, 0)
            when t24.agt_status_cd = '03' then nvl(t19.actual_balance, 0)
          else 0 end                                                                     -- 冻结金额
   ,coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1)         -- 折本币当期余额
   ,nvl(t21.currt_bal,0.0)                                                               -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.ear_m_bal,0.0) end                                                                            -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.ear_s_bal,0.0) end                                                  -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.ear_y_bal,0.0) end                                                                          -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.y_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) end                                                                    -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.s_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) end                                            -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.m_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) end                                                                     -- 月累计余额
   ,coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1)                                                                                                                                                         -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t21.cl_curr_currt_bal,0.0) else nvl(t21.cl_curr_ear_m_bal,0.0) end                                                              -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t21.cl_curr_currt_bal,0.0) else nvl(t21.cl_curr_ear_s_bal,0.0) end                                    -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t21.cl_curr_currt_bal,0.0) else nvl(t21.cl_curr_ear_y_bal,0.0) end                                                            -- 折本币年初余额    
   ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t21.cl_curr_y_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) end                           -- 折本币年累计余额
   ,nvl(t21.cl_curr_y_acm_bal,0.0)                                                                                                                                             -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t21.cl_curr_y_acm_bal,0.0) else nvl(t21.cl_curr_ear_m_y_acm_bal,0.0) end                                             -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t21.cl_curr_y_acm_bal,0.0) else nvl(t21.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t21.cl_curr_y_acm_bal,0.0) else nvl(t21.cl_curr_ear_y_y_acm_bal,0.0) end                                           -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t21.cl_curr_s_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) end   -- 折本币季累计余额
   ,nvl(t21.cl_curr_s_acm_bal,0.0)                                                                                                                                             -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t21.cl_curr_s_acm_bal,0.0) else nvl(t21.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t21.cl_curr_s_acm_bal,0.0) else nvl(t21.cl_curr_ear_y_s_acm_bal,0.0) end                                           -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t21.cl_curr_m_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) end                            -- 折本币月累计余额
   ,nvl(t21.cl_curr_m_acm_bal,0.0)                                                                                                                                             -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t21.cl_curr_m_acm_bal,0.0) else nvl(t21.cl_curr_ear_m_m_acm_bal,0.0) end                                             -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t21.cl_curr_m_acm_bal,0.0) else nvl(t21.cl_curr_ear_y_m_acm_bal,0.0) end                                           -- 折本币年初月累计余额
   ,case when t2.prod_id in ('1000100100201', '1000200100202') then '1' else decode(t23.supply_acctnt_egin_flg, 'Y', '1', '0') end                                             -- 记账标志
   ,(case when substr('${batch_date}',5,4) = '0101' then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.y_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.s_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then coalesce(t22.acct_bal,t19.actual_balance,0) else nvl(t21.m_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t21.cl_curr_y_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t21.cl_curr_s_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t21.cl_curr_m_acm_bal,0.0) + coalesce(t22.acct_bal,t19.actual_balance,0) * nvl(t16.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
   ,t1.job_cd                -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
from ${iml_schema}.agt_corp_e_acct t1
   inner join ${iml_schema}.agt_corp_e_prod_acct_rela_h t2 
    on t1.prod_acct_id = t2.prod_acct_id
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'eeasf1'
   left join ${iml_schema}.agt_status_h t24
   	on t24.agt_id = t1.agt_id
   	and t24.agt_status_type_cd = 'CD1246'
   	and t24.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t24.end_dt > to_date('${batch_date}','yyyymmdd')
    and t24.job_cd = 'eeasf1'
   left join ${iol_schema}.iats_billing_account t3 
    on t2.acct_id = t3.external_account_id
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.agt_corp_e_acct_attr_h t4 
    on t1.prod_acct_id = t4.prod_acct_id
    and t4.attr_cd = '05'
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
    and t4.job_cd = 'eeasf1'
   left join ${iml_schema}.agt_corp_e_acct_attr_h t6 
     on t1.prod_acct_id = t6.prod_acct_id
     and t6.attr_cd = '04'
     and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t6.end_dt > to_date('${batch_date}','yyyymmdd')
     and t6.job_cd = 'eeasf1'
   left join ${iml_schema}.agt_corp_e_acct_int_set_dtl t7 
     on t1.prod_acct_id = t7.prod_acct_id
     and t7.stl_type_cd ='02'
     and to_date(to_char(t7.stl_tm, 'yyyymmdd'), 'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
     and t7.create_dt <= to_date('${batch_date}','yyyymmdd')
     and t7.job_cd = 'eeasf1'
     and t7.id_mark <> 'D'
   left join ${icl_schema}.tmp_cmm_e_acct_info_06 t8 
     on t1.prod_acct_id = t8.prod_acct_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_07 t17 
     on t1.prod_acct_id = t17.prod_acct_id
   left join ${iol_schema}.iats_billing_account_term t10 
     on t3.billing_account_id = t10.billing_account_id
     and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.iats_billing_account_term_attr t11 
     on t10.billing_account_term_id = t11.billing_account_term_id
     and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.iats_billing_account_term_attr t12 
     on t10.billing_account_term_id = t12.billing_account_term_id
     and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.iats_billing_account_term_attr t13 
     on t10.billing_account_term_id = t13.billing_account_term_id
     and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${icl_schema}.tmp_cmm_e_acct_info_08 t14 
     on t1.prod_acct_id = t14.prod_acct_id
   left join ${iml_schema}.ref_prod_appl_info t15 
     on t2.prod_id = t15.prod_id
     and t15.sys_src_abbr = 'EEAS'
     and t15.create_dt <= to_date('${batch_date}','yyyymmdd')
     and t15.job_cd = 'fdmsf1'
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t16 
     on t1.curr_cd = t16.curr_sym_cd
     --and t16.dt = to_date('${batch_date}', 'yyyymmdd')
     and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t16.end_dt > to_date('${batch_date}','yyyymmdd')
     --and t16.id_mark <> 'D'
     and t16.job_cd = 'cbssf1'
   left join ${icl_schema}.tmp_cmm_e_acct_info_04 t18
     on t2.agt_id = t18.billing_account_id
   left join ${icl_schema}.tmp_cmm_e_acct_info_09 t19
     on t1.agt_id = t19.agt_id
   left join (
               select int_rat 
	               from  ${iml_schema}.ref_corp_e_acct_int_rat_para
                where effect_dt in (select max(effect_dt) as effect_dt 
                                      from ${iml_schema}.ref_corp_e_acct_int_rat_para 
                                     where int_rat_id = 'HQLV' and create_dt <= to_date('${batch_date}','yyyymmdd') and job_cd = 'eeasf1' and id_mark <> 'D')
                  and int_rat_id = 'HQLV'
                  and create_dt <= to_date('${batch_date}','yyyymmdd')
                  and job_cd = 'eeasf1'
                  and id_mark <> 'D'
	            ) t5
     on 1 = 1
   left join ${iml_schema}.ref_corp_e_acct_sn_cfg_para t23
     on t23.prod_id = t2.prod_id
     and t23.job_cd = 'eeasf1'
     and t23.start_dt <= to_date('${batch_date}','yyyymmdd') 
  	 and t23.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.agt_prod_bal_dtl_h t22
      on t1.prod_acct_id = t22.acct_num
     and t22.sys_src_abbr = 'EEAS' 
     and t22.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t22.end_dt > to_date('${batch_date}','yyyymmdd')
     and t22.job_cd = 'fdmsf1'
   left join ${icl_schema}.cmm_e_acct_info t21
   	  on t21.acct_id = t1.prod_acct_id
   	 and t21.lp_id = t1.lp_id
   	 and t21.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
   left join (select prod_id,
                     fea_val,
                     row_number() over(partition by prod_id order by valid_tm desc) rn
                from ${iml_schema}.ref_corp_e_acct_prod_fea_para
               where start_dt <= to_date('${batch_date}','yyyymmdd') 
  	             and end_dt > to_date('${batch_date}','yyyymmdd')
  	             and job_cd = 'eeasf1'
  	             and en_name = 'interestFlag') t25
     on t2.prod_id = t25.prod_id 
    and t25.rn = 1
   left join (select pay.from_mem_cd,
							       sum(case when trunc(pay.acct_tm) = to_date('${batch_date}', 'yyyymmdd') then nvl(pay.tran_amt, 0) else 0 end) as td_acru_int,
							       sum(case when trunc(pay.acct_tm) <> to_date('${batch_date}', 'yyyymmdd') then nvl(pay.tran_amt, 0) else 0 end) as currt_acru_int
							  FROM ${iml_schema}.evt_corp_e_acct_pay_dtl pay
							  left join ${iml_schema}.agt_corp_e_acct_attr_h faa
							    on pay.from_mem_cd = faa.prod_acct_id
							   and faa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
							   and faa.end_dt > to_date('${batch_date}', 'yyyymmdd')
							   and faa.attr_cd = '05'
							   and faa.job_cd ='eeasi1'
							 where pay.from_mem_cd = '000000152435'
							   and pay.pay_type_cd = '002'
							   and pay.job_cd ='eeasi1'
							   and trunc(pay.acct_tm) <= to_date('${batch_date}', 'yyyymmdd')
							   and trunc(pay.acct_tm) >= to_date(faa.attr_val, 'yyyymmdd')
							 group by pay.from_mem_cd) t26
   	 on t1.prod_acct_id = t26.from_mem_cd
   left join ${iml_schema}.agt_prod_rela_h t27
   	 on t1.agt_id = t27.agt_id
    and t1.lp_id = t27.lp_id
    and t27.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t27.end_dt > to_date('${batch_date}','yyyymmdd')
    --and t27.id_mark <> 'D'
    and t27.job_cd = 'eeasf1'
   left join                                                                            -- add htj 20210622
           (select faa.prod_acct_id,
                   sum(to_number(nvl(faa.attr_val, 0)))  as currt_acru_int
             from ${iml_schema}.agt_corp_e_acct_attr_h faa
        left join ${iml_schema}.ref_pub_cd_map r1
               on faa.attr_cd = r1.target_cd_val
              and r1.sorc_sys_cd= 'EEAS'
              and r1.src_tab_en_name= 'EEAS_FIN_ACCOUNT_ATTRIBUTE'
              and r1.src_field_en_name= 'ATTR_NAME'
              and r1.target_tab_en_name= 'AGT_CORP_E_ACCT_ATTR_H'
              and r1.target_tab_field_en_name= 'ATTR_CD'
            where r1.src_code_val = 'lastCountInterestAmount'
             -- and trunc(faa.last_updated_stamp) = to_date('${batch_date}', 'yyyymmdd')
              and faa.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
              and faa.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and faa.job_cd = 'eeasf1'
            group by faa.prod_acct_id
          ) t36
         on t1.prod_acct_id = t36.prod_acct_id		
   left join (select *
 							 from ${iml_schema}.prd_rela_h a
 							start with prod_id = (select prod_id
                    from ${iml_schema}.prd_product
                   where prod_name = '个人平台存款')
							connect by prior prod_id = rela_prod_id) t37
		on t27.prod_id = t37.prod_id
	 and t27.lp_id = t37.lp_id
	 and t37.prod_rela_type_cd = '01'
	 and t37.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t37.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${icl_schema}.tmp_cmm_e_acct_info_18 t38
    on t1.prod_acct_id = t38.agt_id
  left join ${icl_schema}.tmp_cmm_e_acct_info_19 t39
    on t39.ndw_acct_id =t1.prod_acct_id
  where to_date(to_char(t2.effect_tm, 'yyyymmdd'), 'yyyymmdd') < to_date('${batch_date}','yyyymmdd') + 1
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.job_cd = 'eeasf1'
    and t1.fin_acct_type_cd <> '17'
    and (t23.supply_h_dw_flg = 'Y' or t23.supply_acctnt_egin_flg = 'Y')
    and t1.id_mark <> 'D'
;                                                                                  
commit;
 
-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_e_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_e_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_e_acct_info_ex purge;

--3.2 drop temp table

--drop table ${icl_schema}.tmp_cmm_e_acct_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_05 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_06 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_07 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_08 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_09 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_10 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_11 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_12 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_13 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_14 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_15 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_16 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_17 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_17_1 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_18 purge;
--drop table ${icl_schema}.tmp_cmm_e_acct_info_19 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_e_acct_info',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);
 