/*
Purpose:    共性加工层-理财账户余额信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_finc_acct_bal_info
CreateDate: 20190808
Logs:       20200110 翟若平 调整iml.ref_cny_fori_exch_mdl_p_h表取数口径
			      20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额、收益调整科目编号、产品模板编号】
			      				        调整字段[科目编号]取数口径
			      20200724 周沁晖 增加字段【标准产品编号】
			      20200828 周沁晖 增加字段【合约编号】
			      20201203 陈伟峰 新增字段【实际起息日期、实际到期日期、市值余额、市值余额相关积数字段、产品模板说明、产品费前单位净值、当日客户收益率、产品费前万份收益、本日收益】	
                            新增主键字段【实际起息日期】，调整字段【科目编号、收益调整科目编号、本期收益、账户余额】的取数逻辑
            20201207 陈伟峰 调整字段逻辑 【认购总金额、认购总份额、赎回份额、赎回金额、当前份额、可用份额、交易冻结份额、长期冻结份额、本地冻结份额】
            20201212 翟若平 计算积数字段时，关联自身cmm_finc_acct_bal_info增加实际起息日的关联
			      20201224 陈伟峰 调整市值余额字段取数逻辑
            20210118 陈伟峰 调整产品费前净值默认值0->1
            20210119 谢  宁 增加字段【钞汇标志、个人允许购买标志、控制标志组合】
            20210204 陈伟峰 调整【实际起息日】，【实际到期日】的默认值
            20210222 陈伟峰 调整基数字段加工逻辑，1306以外的产品不按实际起息日累计
            20210302 陈伟峰 调整字段【本日收益、本期收益、市值余额、赎回金额、折本币市值余额、市值余额积数相关字段】的取数逻辑，取产品费前净值->改成产品费后净值
                            增加字段【产品费后单位净值】
            20210311 陈伟峰 增加一组对历史销户数据进行回插
            20210323 陈伟峰 M层agt_finc_acct调整算法
            20210423 翟若平 调整1306理财产品中在份额表中存在但是在份额明细表中不存在的记录。
            20210610 陈伟峰 修复年日均余额的加工口径
            20210729 何桐金 优化代码跑数时长
            20210901 陈伟峰 调整销户部分账户的【认购总金额、认购总份额】加工逻辑，置为0
            20211111 何桐金 增加字段【允许购买起始日、允许购买到期日】
            20211116 陈伟峰 新增字段【质押标志】
            20211124 陈伟峰 回调销户部分账户的【认购总金额、认购总份额】加工逻辑，取上日数据，重新追数
            20211124 陈伟峰 调整【实际起息日期、实际到息日期、本期收益】加工逻辑，增加P920产品模板判断
			20220505 翟若平	1、调整字段【本金科目编号、币种代码、折本币账户余额及相关折币积数字段、折本币市值余额及相关折币积数字段】的取数口径	
            20221011 温旺清 1、调整【实际起息日期、实际到息日期】加工逻辑，此前P920模板仅加工YSHYYX产品，调整为当产品模板为P920且产品小类为滚动型的产品都计算实际起息日和实际到期日			
			20221018 陈伟峰 1、调整【本金科目编号】加工逻辑，增加科目81240102，调整【收益调整科目编号】加工逻辑，去除科目81240102
			20240516 陈伟峰 调整开发式理财产品份额加工口径，仅取产品模板1306.
			20240528  饶雅   新增字段【销户日期】
			20240704 陈伟峰  调整【销户日期】加工逻辑，增加100002（客户解约）、100014（银行账号登记取消）
			20260121 陈伟峰  调整【销户日期】取值码值，适配财富平台改造
			20260407 何俊良 临时表创建规则调整
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_finc_acct_bal_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_finc_acct_bal_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2.1 create tmp table tmp_cmm_finc_acct_bal_info_01
drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_01 purge;
drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_02 purge;
drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_03 purge;
drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_04 purge;
drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_05 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_finc_acct_bal_info_01
nologging
compress ${option_switch} for query high
as
select
   ta_tran_acct_id
   ,max(tran_dt) as tran_dt
from ${iml_schema}.evt_finc_tran_cfm
where bus_cd in ('130','122')
 and etl_dt = to_date('${batch_date}','yyyymmdd')
 and job_cd = 'ifmsi1'
 group by ta_tran_acct_id
;
commit;

-- 创建临时表存放开发式理财产品的份额信息

create table ${icl_schema}.tmp_cmm_finc_acct_bal_info_02 
nologging
compress ${option_switch} for query high
as
select st.ta_client as ta_client,
       st.prd_code as prd_code,
       (case when iml.dateformat_max(trim(st.cfm_date)) = iml.dateformat_max('') then null
             else iml.dateformat_max(trim(st.cfm_date)) end) as actl_value_dt,

       nvl(max(tp.ped_days), 0) as ped_days,
       sum(nvl(st.tot_vol, 0)) as tot_vol,
	     sum(nvl(st.cost, 0)) as cost,
       sum(nvl(st.frozen_vol, 0)) as frozen_vol,
       sum(nvl(st.long_frozen_vol, 0)) as long_frozen_vol,
       sum(nvl(st.other_frozen, 0)) as other_frozen
  from ${iol_schema}.ifms_tbsharedetail0 st
  left join ${iml_schema}.prd_finc tp
    on st.prd_code = tp.finc_prod_id
   and tp.create_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and tp.job_cd ='ifmsf1'
 where st.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and st.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and st.ta_code ='GDHX'
   and tp.prod_tepla_id='1306'
 group by st.ta_client, st.prd_code, st.cfm_date
;
commit;
/*create table ${icl_schema}.tmp_cmm_finc_acct_bal_info_02 
(
  ta_client       varchar2(32),
  prd_code        varchar2(20),
  actl_value_dt   date,
  ped_days        number,
  tot_vol         number,
  cost            number,
  frozen_vol      number,
  long_frozen_vol number,
  other_frozen    number
)nologging
compress ${option_switch} for query high;

insert into ${icl_schema}.tmp_cmm_finc_acct_bal_info_02
select st.ta_tran_acct_id as ta_client,
                     st.prod_id as prd_code,
                     (case when iml.dateformat_max(trim(st.cfm_dt)) = iml.dateformat_max('') then null
                           else iml.dateformat_max(st.cfm_dt) end) as actl_value_dt,
                     (case when iml.dateformat_max(trim(st.cfm_dt)) = iml.dateformat_max('') then null
                           else fn_get_no_holidays(iml.dateformat_max(st.cfm_dt) + nvl(max(tp.ped_days), 0))
                           end) as actl_exp_dt,
                     sum(nvl(st.lot_tot, 0)) as tot_vol,
					  sum(nvl(st.cost, 0)) as cost,
                     sum(nvl(st.tran_froz_lot, 0)) as frozen_vol, --待M层入模
                     sum(nvl(st.lonterm_froz_lot, 0)) as long_frozen_vol, --待M层入模
                     sum(nvl(st.loc_froz_lot, 0)) as other_frozen			--待M层入模			     
                from ${iml_schema}.agt_finc_lot_dtl_h st  --iol.ifms_tbsharedetail0 st
                left join ${iml_schema}.prd_finc tp       --iol.ifms_tbproduct tp
                  on st.prod_id = tp.finc_prod_id
                 and tp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
               where st.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and st.end_dt > to_date('${batch_date}', 'yyyymmdd')
               group by st.ta_tran_acct_id, st.prod_id, st.cfm_dt
;
commit;*/

-- 创建临时表存放开发式理财产品的份额信息
create table ${icl_schema}.tmp_cmm_finc_acct_bal_info_03 
nologging
compress ${option_switch} for query high
as
select t1.*
  from ${iml_schema}.agt_finc_lot_h t1  -- 1306开放式
 inner join ${iml_schema}.prd_finc t3
    on t1.prod_id = t3.finc_prod_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd ='ifmsf1'
 where t1.ta_cd = 'GDHX'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ifmsf1'
   and t3.prod_tepla_id = '1306'
   and nvl(t1.lot_tot,0) <> 0  
 union all
select t1.*
  from ${iml_schema}.agt_finc_lot_h t1  -- 非1306开放式
 inner join ${iml_schema}.prd_finc t3
    on t1.prod_id = t3.finc_prod_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd ='ifmsf1'
 where t1.ta_cd = 'GDHX'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ifmsf1'
   and t3.prod_tepla_id <> '1306'
;


create table ${icl_schema}.tmp_cmm_finc_acct_bal_info_04 as
select bbb.src_prod_id as finprod_id,
                     bbb.src_prod_id as bookset_id,
                     bbb.subj_id as subject_no,
					 case when bbb.dc_curr_cd = '-' then 'CNY' else bbb.dc_curr_cd end as b_ccy,
                     bbb.dc_bal as b_amt
                 from ${iml_schema}.fin_am_prod_subj_bal_h bbb --iol.fams_ban_bank_bok_balance bbb 
                where bbb.subj_id in ('20140103', '20140203', '20140303', '81240101', '81240111', '81240201', '81240211', '81240301', '81240311','81240121','81240103','81240102')
                  and bbb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and bbb.end_dt > to_date('${batch_date}', 'yyyymmdd')
				  and bbb.job_cd ='famsf2'						  					  					  
               union all
               select fp.finprod_id as finprod_id,
                      bb.acct_pkg_id as bookset_id,
                      (case when bb.acct_pkg_id = 'F16_XWYEB001' then '20140203' else '20140103' end ) as subject_no,
                      nvl(trim(bb.dc_curr_cd),'CNY') as b_ccy, 
                      bb.dc_bal as b_amt
                 from ${iml_schema}.fin_am_prod_intnal_subj_bal bb
                inner join ${iol_schema}.fams_fin_product_add fp
                   on (case when bb.acct_pkg_id like 'F16_%' then bb.acct_pkg_id else 'F16_' || bb.acct_pkg_id end) = fp.finprod_id
                  and fp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and fp.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and fp.profit_flag in ('01', '02')
                where bb.subj_id = '40010101'
                  and bb.bal_dt = to_date('${batch_date}', 'yyyymmdd')
				  and bb.job_cd = 'famsi2';
 commit;
  
 create table ${icl_schema}.tmp_cmm_finc_acct_bal_info_05 as
 select bbb.src_prod_id as finprod_id,
                  bbb.src_prod_id as bookset_id,
                  bbb.subj_id as subject_no,
                  bbb.dc_curr_cd as b_ccy,
                  bbb.dc_bal as b_amt
             from ${iml_schema}.fin_am_prod_subj_bal_h bbb --iol.fams_ban_bank_bok_balance bbb
            where bbb.subj_id in ('20140104', '20140204', '20140304', '81240112', '81240202', '81240302')
              and bbb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and bbb.end_dt > to_date('${batch_date}', 'yyyymmdd')
			  and bbb.job_cd = 'famsf2'
            union all
			select fp.finprod_id as finprod_id,
                   bb.acct_pkg_id as bookset_id,
                   (case when bb.acct_pkg_id = 'F16_XWYEB001' then '20140203' else '20140103' end ) as subject_no,
                   nvl(trim(bb.dc_curr_cd),'CNY') as b_ccy, 
                   bb.dc_bal as b_amt
                 from ${iml_schema}.fin_am_prod_intnal_subj_bal bb
                inner join ${iol_schema}.fams_fin_product_add fp
                   on (case when bb.acct_pkg_id like 'F16_%' then bb.acct_pkg_id else 'F16_' || bb.acct_pkg_id end) = fp.finprod_id
                  and fp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and fp.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and fp.profit_flag in ('01', '02')
                where bb.subj_id = '22320101'
                  and bb.bal_dt = to_date('${batch_date}', 'yyyymmdd')
				  and bb.job_cd = 'famsi2'
 ;
 commit;  
-- 1.3 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_finc_acct_bal_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_finc_acct_bal_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_finc_acct_bal_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_finc_acct_bal_info_ex(
   etl_dt	                               -- 数据日期
   ,lp_id	                               -- 法人编号
   ,tran_acct_id	                       -- 交易账户编号
   ,prod_id	                             -- 产品编号
   ,std_prod_id							             -- 标准产品编号
   ,prod_name	                           -- 产品名称
   ,subj_id	                             -- 科目编号
   ,prft_adj_subj_id                     -- 收益调整科目编号
   ,cust_id	                             -- 客户编号
   ,cust_type_cd	                       -- 客户类型代码
   ,finc_acct_id	                       -- 理财账户编号
   ,cont_id								               -- 合约编号
   ,open_dt	                             -- 开立日期
   ,clos_acct_dt	                       -- 销户日期
   ,last_activ_acct_dt	                 -- 上次动户日期
   ,acct_status_cd	                     -- 账户状态代码
   ,open_org_id	                         -- 开立机构编号
   ,cust_mgr_id	                         -- 客户经理编号
   ,cap_stl_acct_num	                   -- 资金结算账号
   ,seller_cd	                           -- 销售商代码
   ,bank_id	                             -- 银行编号
   ,prft_fea_cd	                         -- 收益特征代码
   ,divd_way_cd	                         -- 分红方式代码
   ,tard_way_cd	                         -- 交易方式代码
   ,prod_status_cd	                     -- 产品状态代码
   ,prod_risk_level_cd	                 -- 产品风险等级代码
   ,prft_embody_way_cd	                 -- 收益体现方式代码
   ,charge_way_cd	                       -- 收费方式代码
   ,ctrl_flg_comb												 -- 控制标志组合
   ,prod_found_dt	                       -- 产品成立日期
   ,allow_buy_begin_day                  -- 允许购买起始日	
   ,allow_buy_exp_day                    -- 允许购买到期日	
   ,prod_ped_days	                       -- 产品周期天数
   ,expe_yld_rat	                       -- 预期收益率
   ,annual_yld_rat	                     -- 年化收益率
   ,open_flg	                           -- 开放式标志
   ,ec_flg                               -- 钞汇标志
   ,indv_allow_buy_flg                   -- 个人允许购买标志
   ,inpwn_flg                            -- 质押标志
   ,prod_tepla_id						             -- 产品模板编号
   ,prod_tepla_comnt                     -- 产品模板说明
   ,brkevn_flg	                         -- 保本标志
   ,purch_dt	                           -- 申购日期
   ,exp_dt	                             -- 到期日期
   ,value_dt	                           -- 起息日期
   ,prft_exp_day	                       -- 收益到期日
   ,actl_value_dt                        -- 实际起息日期
   ,actl_exp_dt                          -- 实际到期日期
   ,curr_cd	                             -- 币种代码
   ,acct_bal	                           -- 账户余额
   ,mk_val_bal                           -- 市值余额
   ,subscr_tot_amt	                     -- 认购总金额
   ,subscr_tot_lot	                     -- 认购总份额
   ,redem_lot	                           -- 赎回份额
   ,redem_amt	                           -- 赎回金额
   ,curr_lot	                           -- 当前份额
   ,aval_lot	                           -- 可用份额
   ,tran_froz_lot	                       -- 交易冻结份额
   ,lonterm_froz_lot	                   -- 长期冻结份额
   ,loc_froz_lot	                       -- 本地冻结份额
   ,prod_fee_f_unit_nv                   -- 产品费前单位净值
   ,prod_fee_post_corp_nv                -- 产品费后单位净值
   ,td_cust_yld_rat                      -- 当日客户收益率
   ,prod_fee_bf_ten_thous_prft           -- 产品费前万份收益
   ,td_prft                              -- 本日收益
   ,invest_prft	                         -- 投资收益
   ,curr_issue_prft	                     -- 本期收益
   ,cl_curr_acct_bal	                   -- 折本币账户余额
   ,ear_d_bal	                           -- 日初余额
   ,ear_m_bal	                           -- 月初余额
   ,ear_s_bal	                           -- 季初余额
   ,ear_y_bal	                           -- 年初余额
   ,m_acm_bal	                           -- 月累计余额
   ,s_acm_bal	                           -- 季累计余额
   ,y_acm_bal	                           -- 年累计余额
   ,cl_curr_ear_d_bal	                   -- 折本币日初余额
   ,cl_curr_ear_m_bal	                   -- 折本币月初余额
   ,cl_curr_ear_s_bal	                   -- 折本币季初余额
   ,cl_curr_ear_y_bal	                   -- 折本币年初余额
   ,cl_curr_y_acm_bal	                   -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal	             -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal	             -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal	             -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal	             -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal	                   -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal	             -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal	             -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal	             -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal	                   -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal	             -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal	             -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal	             -- 折本币年初月累计余额
   ,y_avg_bal        					           -- 年日均余额
   ,q_avg_bal        					           -- 季日均余额
   ,m_avg_bal        					           -- 月日均余额
   ,cl_curr_y_avg_bal					           -- 折本币年日均余额
   ,cl_curr_q_avg_bal					           -- 折本币季日均余额
   ,cl_curr_m_avg_bal					           -- 折本币月日均余额
   ,cl_curr_mk_val_bal                   -- 折本币市值余额
   ,ear_d_mk_val_bal                     -- 日初市值余额
   ,ear_m_mk_val_bal                     -- 月初市值余额
   ,ear_s_mk_val_bal                     -- 季初市值余额
   ,ear_y_mk_val_bal                     -- 年初市值余额
   ,m_acm_mk_val_bal                     -- 月累计市值余额
   ,s_acm_mk_val_bal                     -- 季累计市值余额
   ,y_acm_mk_val_bal                     -- 年累计市值余额
   ,cl_curr_ear_d_mk_val_bal             -- 折本币日初市值余额
   ,cl_curr_ear_m_mk_val_bal             -- 折本币月初市值余额
   ,cl_curr_ear_s_mk_val_bal             -- 折本币季初市值余额
   ,cl_curr_ear_y_mk_val_bal             -- 折本币年初市值余额
   ,cl_curr_y_acm_mk_val_bal             -- 折本币年累计市值余额
   ,cl_curr_ear_d_y_acm_mk_val_bal       -- 折本币日初年累计市值余额
   ,cl_curr_ear_m_y_acm_mk_val_bal       -- 折本币月初年累计市值余额
   ,cl_curr_ear_s_y_acm_mk_val_bal       -- 折本币季初年累计市值余额
   ,cl_curr_ear_y_y_acm_mk_val_bal       -- 折本币年初年累计市值余额
   ,cl_curr_s_acm_mk_val_bal             -- 折本币季累计市值余额
   ,cl_curr_ear_d_s_acm_mk_val_bal       -- 折本币日初季累计市值余额
   ,cl_curr_ear_s_s_acm_mk_val_bal       -- 折本币季初季累计市值余额
   ,cl_curr_ear_y_s_acm_mk_val_bal       -- 折本币年初季累计市值余额
   ,cl_curr_m_acm_mk_val_bal             -- 折本币月累计市值余额
   ,cl_curr_ear_d_m_acm_mk_val_bal       -- 折本币日初月累计市值余额
   ,cl_curr_ear_m_m_acm_mk_val_bal       -- 折本币月初月累计市值余额
   ,cl_curr_ear_y_m_acm_mk_val_bal       -- 折本币年初月累计市值余额
   ,y_avg_mk_val_bal                     -- 年日均市值余额
   ,q_avg_mk_val_bal                     -- 季日均市值余额
   ,m_avg_mk_val_bal                     -- 月日均市值余额
   ,cl_curr_y_avg_mk_val_bal             -- 折本币年日均市值余额
   ,cl_curr_q_avg_mk_val_bal             -- 折本币季日均市值余额
   ,cl_curr_m_avg_mk_val_bal             -- 折本币月日均市值余额
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')   -- 数据日期
   ,t1.lp_id                             -- 法人编号
   ,t1.ta_tran_acct_id	                 -- 交易账户编号
   ,t1.prod_id	                         -- 产品编号
   ,fpt.std_prod_id											 -- 标准产品编号
   ,t3.prod_name	                       -- 产品名称
   ,case when trim(t7.subject_no) is not null then t7.subject_no
     when substr(t3.ctrl_flg, 53, 1) in('0','1') and t2.cust_type_cd = '1' then '20140103' 
     when substr(t3.ctrl_flg, 53, 1) in('0','1') and t2.cust_type_cd = '0' then '20140203' 
     when substr(t3.ctrl_flg, 53, 1) in ('2') and t2.cust_type_cd = '1' then '81240101' 
     when substr(t3.ctrl_flg, 53, 1) in ('3') and t2.cust_type_cd = '1' then '81240111' 
     when substr(t3.ctrl_flg, 53, 1) in ('2') and t2.cust_type_cd = '0' then '81240201' 
     when substr(t3.ctrl_flg, 53, 1) in ('3') and t2.cust_type_cd = '0' then '81240211'
     end   as subj_id                      -- 科目编号		  
    ,case when trim(t8.subject_no) is not null then t8.subject_no
          when substr(t3.ctrl_flg, 53, 1) in('0','1') and t2.cust_type_cd = '1' then '20140104' 
          when substr(t3.ctrl_flg, 53, 1) in('0','1') and t2.cust_type_cd = '0' then '20140204' 
          when substr(t3.ctrl_flg, 53, 1) in ('2') and t2.cust_type_cd = '1' then '81240102' 
          when substr(t3.ctrl_flg, 53, 1) in ('3') and t2.cust_type_cd = '1' then '81240112' 
          when substr(t3.ctrl_flg, 53, 1) in ('2') and t2.cust_type_cd = '0' then '81240202' 
          when substr(t3.ctrl_flg, 53, 1) in ('3') and t2.cust_type_cd = '0' then '81240212' 
           end    as prft_adj_subj_id      -- 收益调整科目编号
   ,t1.bank_cust_id	                       -- 客户编号
   ,nvl(trim(t2.cust_type_cd),'-')	       -- 客户类型代码
   ,t1.finc_acct_id	                       -- 理财账户编号
   ,t1.cont_id							               -- 合约编号
   ,t2.open_dt	                           -- 开立日期
   ,to_date(to_char(t24.occur_init_date),'yyyymmdd') -- 销户日期
   ,t1.final_tran_dt	                     -- 上次动户日期
   ,t2.acct_status_cd	                     -- 账户状态代码
   ,t2.belong_org_id	                     -- 开立机构编号
   ,t2.cust_mgr_id	                       -- 客户经理编号
   ,t1.bank_acct_id	                       -- 资金结算账号
   ,t1.seller_cd	                         -- 销售商代码
   ,t1.bank_id	                           -- 银行编号 
   ,nvl('0' || substr(t3.ctrl_flg,53,1),'00')	as prft_fea_cd      -- 收益特征代码
   ,t3.deflt_divd_way_cd	                 -- 分红方式代码
   ,t3.tard_way_cd	                       -- 交易方式代码
   ,t3.status_cd	                         -- 产品状态代码
   ,t3.risk_level_cd	                     -- 产品风险等级代码
   ,t3.prft_embody_way_cd	                 -- 收益体现方式代码
   ,t3.charge_way_cd	                     -- 收费方式代码
   ,t3.ctrl_flg														 -- 控制标志组合
   ,t3.prod_found_dt	                     -- 产品成立日期
   ,t3.coll_start_dt                       -- 允许购买起始日	
   ,t3.coll_end_dt                         -- 允许购买到期日	
   ,t3.ped_days	                           -- 产品周期天数
   ,t3.expe_yld_rat	                       -- 预期收益率
   ,0	                                     -- 年化收益率
   ,case when t3.prod_tepla_id = '1102' then '0' when t3.prod_tepla_id = '1140' then '0' else '1' end as open_flg	-- 开放式标志
   ,t1.ec_flg                              -- 钞汇标志
   ,substr(t3.ctrl_flg,3,1)                -- 个人允许购买标志
   ,case when trim(t20.in_client_no) is not null then '1' else '0' end    as inpwn_flg      -- 质押标志
   ,t3.prod_tepla_id											 -- 产品模板编号
   ,t3.ref_yld_rat_comnt                   --产品模板说明
   ,case when substr(t3.ctrl_flg, 53, 1) in ('0','1') then '1' else '0' end	  as brkevn_flg    -- 保本标志
   ,t4.tran_dt	                           -- 申购日期
   ,t3.prod_end_dt	                       -- 到期日期
   ,t3.prod_value_dt	                     -- 起息日期
   ,t3.prft_exp_dt	                       -- 收益到期日
   ,(case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' and trim(t9.actl_value_dt) is not null then t9.actl_value_dt
          when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1401' and trim(t10.value_dt) is not null then t10.value_dt
          when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('1601', '1700') and trim(t12.value_dt) is not null then t12.value_dt
          when t3.tard_way_cd = '0' and t3.prod_tepla_id = 'P920' and t23.field_value='1' and trim(t22.value_dt) is not null then t22.value_dt
          else nvl(t3.prod_value_dt,to_date('00010101','yyyymmdd')) end)       -- 实际起息日期
   ,(case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' and t9.actl_value_dt is not null then fn_get_no_holidays(t9.actl_value_dt + t9.ped_days)
          when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1401' and trim(t11.exp_dt) is not null then t11.exp_dt
          when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('1601', '1700') and trim(t13.exp_dt) is not null then t13.exp_dt
          when t3.tard_way_cd = '0' and t3.prod_tepla_id = 'P920' and t23.field_value='1' and trim(t21.exp_dt) is not null then t21.exp_dt
          else t3.prft_exp_dt end)         -- 实际到期日期
   ,case when t7.b_ccy = '-' then 'CNY' else nvl(t7.b_ccy, 'CNY') end	 as curr_cd                 -- 币种代码   	
   ,nvl(t9.tot_vol, t1.lot_tot)	           -- 账户余额
   ,nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1))         -- 市值余额
   ,nvl(t9.cost, t1.buy_cost_amt)	         -- 认购总金额
   ,nvl(t9.cost, t1.buy_cost_amt)	         -- 认购总份额
   ,nvl(t9.cost, t1.buy_cost_amt) - nvl(t9.tot_vol, t1.lot_tot)	      -- 赎回份额
   ,(nvl(t9.cost, t1.buy_cost_amt) - nvl(t9.tot_vol, t1.lot_tot)) * nvl(trim(t19.evltion), 1)	    -- 赎回金额
   ,nvl(t9.tot_vol, t1.lot_tot)            -- 当前份额
   ,nvl(t9.tot_vol, t1.lot_tot) - nvl(t9.frozen_vol, t1.froz_lot)	  -- 可用份额
   ,nvl(t9.tot_vol, t1.lot_tot) - nvl(t9.frozen_vol, t1.froz_lot)	  -- 交易冻结份额
   ,nvl(t9.long_frozen_vol, t1.lonterm_froz_lot)	                  -- 长期冻结份额
   ,nvl(t9.other_frozen,0)	               -- 本地冻结份额
   ,nvl(trim(t14.evltion), 1)              -- 产品费前单位净值
   ,nvl(trim(t19.evltion), 1)              -- 产品费后单位净值
   ,nvl(trim(t15.evltion), 1)              -- 当日客户收益率
   ,nvl(trim(t16.evltion), 1)              -- 产品费前万份收益
   ,nvl((case when t18.prft_mode_cd = '03' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1) - 1)
          when t18.prft_mode_cd = '04' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t15.evltion), 0)) / 100 / 365
          when t18.prft_mode_cd = '05' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t16.evltion), 0)) / 10000
           end),0)                         -- 本日收益
   ,nvl((case when nvl(t9.tot_vol, t1.lot_tot) = 0 then 0
          when nvl(t1.acm_inco_amt, 0) - nvl(t1.buy_cost_amt, 0) + nvl(t9.tot_vol, t1.lot_tot) > 0 
   		  then nvl(t1.acm_inco_amt, 0) - nvl(t1.buy_cost_amt, 0) + nvl(t9.tot_vol, t1.lot_tot)
   		  else nvl(t1.acm_inco_amt, 0） end),0)                       -- 投资收益
    ,nvl((case when (case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' and trim(t9.actl_value_dt) is not null then t9.actl_value_dt
                          when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1401' and trim(t10.value_dt) is not null then t10.value_dt
                          when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('1601', '1700') and trim(t12.value_dt) is not null then t12.value_dt
                          when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('P920') and trim(t22.value_dt) is not null then t22.value_dt
                          else t3.prod_value_dt end) > to_date('${batch_date}','yyyymmdd')
		           then 0                                       --当实际起息日大于跑批日期，取0
               when (case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' and trim(t9.actl_value_dt) is not null then t9.actl_value_dt
                          when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1401' and trim(t10.value_dt) is not null then t10.value_dt
                          when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('1601', '1700') and trim(t12.value_dt) is not null then t12.value_dt
                          when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('P920') and trim(t22.value_dt) is not null then t22.value_dt
                          else t3.prod_value_dt end) =to_date('${batch_date}','yyyymmdd')
		           then (case when t18.prft_mode_cd = '03' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1) - 1)
                          when t18.prft_mode_cd = '04' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t15.evltion), 0)) / 100 / 365
                          when t18.prft_mode_cd = '05' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t16.evltion), 0)) / 10000
                          end)                              -- 当实际起息日等于跑批日期，取本日收益
		           else (case when (case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' and trim(t9.actl_value_dt) is not null then t9.actl_value_dt
                                     when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1401' and trim(t10.value_dt) is not null then t10.value_dt
                                     when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('1601', '1700') and trim(t12.value_dt) is not null then t12.value_dt
                                     when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('P920') and trim(t22.value_dt) is not null then t22.value_dt
                                     else t3.prod_value_dt end) <to_date('20200101','yyyymmdd')
					                then (to_date('${batch_date}','yyyymmdd') - 
					                       (case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' and trim(t9.actl_value_dt) is not null then t9.actl_value_dt
                                       when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1401' and trim(t10.value_dt) is not null then t10.value_dt
                                       when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('1601', '1700') and trim(t12.value_dt) is not null then t12.value_dt
                                       when t3.tard_way_cd = '0' and t3.prod_tepla_id in ('P920') and trim(t22.value_dt) is not null then t22.value_dt
                                       else t3.prod_value_dt end)) * 
		  	      	                 (case when t18.prft_mode_cd = '03' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1) - 1)
                                       when t18.prft_mode_cd = '04' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t15.evltion), 0)) / 100 / 365
                                       when t18.prft_mode_cd = '05' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t16.evltion), 0)) / 10000
                                       end)                  -- 本日收益:当实际起息日小于20200101时，大于这部分日期不追数会导致上日本期收益为0，此时取起息日跟跑批日的差值+1*当日收益为本期收益，此部分数据会存在误差
					                else t6.curr_issue_prft + 
					                       (case when t18.prft_mode_cd = '03' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1) - 1)
                                       when t18.prft_mode_cd = '04' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t15.evltion), 0)) / 100 / 365
                                       when t18.prft_mode_cd = '05' then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t16.evltion), 0)) / 10000
                                       end ) 
					                end)                               -- 上日本期收益加本日收益
		           end), 0) 	as curr_issue_prft				               -- 本期收益 
				   
   ,nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1)      -- 折本币当期余额
   ,nvl(t6.acct_bal,0.0)                                     -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.acct_bal,0) else nvl(t6.ear_m_bal,0.0) end          -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.acct_bal,0) else nvl(t6.ear_s_bal,0.0) end      -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.acct_bal,0) else nvl(t6.ear_y_bal,0.0) end     -- 年初余额  
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t9.tot_vol, t1.lot_tot) else nvl(t6.m_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) end                             -- 月累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.tot_vol, t1.lot_tot) else nvl(t6.s_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) end   -- 季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.tot_vol, t1.lot_tot) else nvl(t6.y_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) end       -- 年累计余额
   ,nvl(t6.curr_issue_prft,0.0) * nvl(t5.convt_cny_exch_rat, 1)                             -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.cl_curr_acct_bal,0.0) else nvl(t6.cl_curr_ear_m_bal,0.0) end                              -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.cl_curr_acct_bal,0.0) else nvl(t6.cl_curr_ear_s_bal,0.0) end    -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_acct_bal,0.0) else nvl(t6.cl_curr_ear_y_bal,0.0) end                            -- 折本币年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_y_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) end   -- 折本币年累计余额
   ,nvl(t6.cl_curr_y_acm_bal,0.0)                                                                                                                            -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.cl_curr_y_acm_bal,0.0) else nvl(t6.cl_curr_ear_m_y_acm_bal,0.0) end                             -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.cl_curr_y_acm_bal,0.0) else nvl(t6.cl_curr_ear_s_y_acm_bal,0.0) end   -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_y_acm_bal,0.0) else nvl(t6.cl_curr_ear_y_y_acm_bal,0.0) end                           -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) 
         else nvl(t6.cl_curr_s_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) end   -- 折本币季累计余额
   ,nvl(t6.cl_curr_s_acm_bal,0.0)                                                                                                                            -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.cl_curr_s_acm_bal,0.0) else nvl(t6.cl_curr_ear_s_y_acm_bal,0.0) end   -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_s_acm_bal,0.0) else nvl(t6.cl_curr_ear_y_s_acm_bal,0.0) end                           -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_m_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) end    -- 折本币月累计余额
   ,nvl(t6.cl_curr_m_acm_bal,0.0)                                                                                                                            -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.cl_curr_m_acm_bal,0.0) else nvl(t6.cl_curr_ear_m_m_acm_bal,0.0) end                             -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_m_acm_bal,0.0) else nvl(t6.cl_curr_ear_y_m_acm_bal,0.0) end                           -- 折本币年初月累计余额
   ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t9.tot_vol, t1.lot_tot) else nvl(t6.y_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.tot_vol, t1.lot_tot) 
          else nvl(t6.s_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then nvl(t9.tot_vol, t1.lot_tot) else nvl(t6.m_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) 
          else nvl(t6.cl_curr_y_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) 
          else nvl(t6.cl_curr_s_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) 
          else nvl(t6.cl_curr_m_acm_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * nvl(t5.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额  
   ,nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1)               -- 折本币市值余额
   ,nvl(t6.mk_val_bal,0.0)                                  -- 日初市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 else nvl(t6.ear_m_mk_val_bal,0.0) end                  -- 月初市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 else nvl(t6.ear_s_mk_val_bal,0.0) end                  -- 季初市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 else nvl(t6.ear_y_mk_val_bal,0.0) end                  -- 年初市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 else nvl(t6.m_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 end                                                    -- 月累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 else nvl(t6.s_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 end                                                    -- 季累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 else nvl(t6.y_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		 end                                                    -- 年累计市值余额
   ,nvl(t6.mk_val_bal,0.0) * nvl(t5.convt_cny_exch_rat, 1)  -- 折本币日初市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
		 else nvl(t6.cl_curr_ear_m_mk_val_bal,0.0) end          -- 折本币月初市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
		 else nvl(t6.cl_curr_ear_s_mk_val_bal,0.0) end          -- 折本币季初市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
		 else nvl(t6.cl_curr_ear_y_mk_val_bal,0.0) end          -- 折本币年初市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
         else nvl(t6.cl_curr_y_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
		 end                                                    -- 折本币年累计市值余额
   ,nvl(t6.cl_curr_ear_d_y_acm_mk_val_bal,0.0)              -- 折本币日初年累计市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t6.cl_curr_y_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_m_y_acm_mk_val_bal,0.0) end    -- 折本币月初年累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t6.cl_curr_y_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_s_y_acm_mk_val_bal,0.0) end    -- 折本币季初年累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t6.cl_curr_y_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_y_y_acm_mk_val_bal,0.0) end    -- 折本币年初年累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
         else nvl(t6.cl_curr_s_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
		 end                                                    -- 折本币季累计市值余额
   ,nvl(t6.cl_curr_s_acm_mk_val_bal,0.0)                    -- 折本币日初季累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t6.cl_curr_s_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_s_y_acm_mk_val_bal,0.0) end    -- 折本币季初季累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t6.cl_curr_s_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_y_s_acm_mk_val_bal,0.0) end    -- 折本币年初季累计市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
         else nvl(t6.cl_curr_m_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
		 end                                                    -- 折本币月累计市值余额
   ,nvl(t6.cl_curr_m_acm_mk_val_bal,0.0)                    -- 折本币日初月累计市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t6.cl_curr_m_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_m_m_acm_mk_val_bal,0.0) end    -- 折本币月初月累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t6.cl_curr_m_acm_mk_val_bal,0.0) 
		 else nvl(t6.cl_curr_ear_y_m_acm_mk_val_bal,0.0) end    -- 折本币年初月累计市值余额
   ,(case when substr('${batch_date}',5,4) = '0101' 
          then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		  else nvl(t6.y_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均市值余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
          then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		  else nvl(t6.s_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均市值余额
   ,(case when substr('${batch_date}',7,2) = '01' 
          then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) 
		  else nvl(t6.m_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均市值余额
   ,(case when substr('${batch_date}',5,4) = '0101' 
          then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
          else nvl(t6.cl_curr_y_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均市值余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
          then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
          else nvl(t6.cl_curr_s_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均市值余额
   ,(case when substr('${batch_date}',7,2) = '01' 
          then nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) 
          else nvl(t6.cl_curr_m_acm_mk_val_bal,0.0) + nvl(t9.tot_vol, t1.lot_tot) * (nvl(trim(t19.evltion), 1)) * nvl(t5.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均市值余额
   ,t1.job_cd                                                    -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${icl_schema}.tmp_cmm_finc_acct_bal_info_03 t1
   left join ${iml_schema}.agt_finc_acct t2
   	on t1.finc_acct_id = t2.finc_acct_id
   --	and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   	and t2.job_cd = 'ifmsf1'
   	and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   	and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.ta_cd ='GDHX'
   left join ${iml_schema}.prd_finc t3
   	on t1.prod_id = t3.finc_prod_id
   	and t3.job_cd = 'ifmsf1'
   	and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
   	and t3.id_mark <> 'D'
   left join ${icl_schema}.tmp_cmm_finc_acct_bal_info_01 t4
   	on t1.ta_tran_acct_id = t4.ta_tran_acct_id
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5 --iol.t21
   	on t5.curr_cd = 'CNY'
   	--and t5.dt = to_date('${batch_date}','yyyymmdd')
   	and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   	and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   	and t5.job_cd = 'ncbsf1' 
   left join (select fam_prod_code,
                     ifm_prod_code,
                     row_number() over(partition by ifm_prod_code order by update_time desc, create_time desc) rn
                from ${iol_schema}.fams_fam_ifm_mapping  --t5
               where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and end_dt > to_date('${batch_date}', 'yyyymmdd')) t17
     on t1.prod_id = t17.ifm_prod_code 
    and t17.rn = 1 
   left join (select t.*,
                     row_number() over(partition by finc_prod_id order by init_create_tm desc) rn
                   from ${iml_schema}.prd_am_finc_prod t
                  where prod_cate_cd in ('F16') 
	                 and src_prod_id <> 'F16_YSHJZXNZH'
                     and create_dt<=to_date('${batch_date}', 'yyyymmdd')
	                 and job_cd ='famsf2'
                     and id_mark<>'D') t18
      on nvl(t17.fam_prod_code, t1.prod_id) = t18.finc_prod_id
    and t18.rn=1
   left join ${icl_schema}.tmp_cmm_finc_acct_bal_info_04 t7
     on t18.src_prod_id = t7.finprod_id
left join ${icl_schema}.tmp_cmm_finc_acct_bal_info_05 t8
     on t18.src_prod_id = t8.finprod_id
   left join ${icl_schema}.tmp_cmm_finc_acct_bal_info_02 t9
    on t1.ta_tran_acct_id = t9.ta_client 
   and t1.prod_id = t9.prd_code
  left join (select prd_code, to_date(max(cycle_date),'yyyymmdd') as value_dt
               from ${iol_schema}.ifms_tbcycleset
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and cycle_date <= '${batch_date}'
              group by prd_code) t10
    on t1.prod_id = t10.prd_code 
  left join (select prd_code, to_date(min(cycle_date),'yyyymmdd') as exp_dt
              from ${iol_schema}.ifms_tbcycleset
             where start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and cycle_date > '${batch_date}'
             group by prd_code) t11
    on t1.prod_id = t11.prd_code
  left join (select prd_code, to_date(max(cash_date),'yyyymmdd') as value_dt
              from ${iol_schema}.ifms_tbcashdate
             where start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and cash_date <= '${batch_date}'
             group by prd_code) t12
    on t1.prod_id = t12.prd_code
  left join (select prd_code, to_date(min(cash_date),'yyyymmdd') as exp_dt
              from ${iol_schema}.ifms_tbcashdate
             where start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and cash_date > '${batch_date}'
             group by prd_code) t13
    on t1.prod_id = t13.prd_code
  left join ${iml_schema}.fin_am_prod_evltion_h t14--fams_bok_val_table_data t14
   on t7.bookset_id = t14.sob_id
  and t14.evltion_type_cd = '09'
  and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t14.job_cd ='famsf2'
 left join ${iml_schema}.fin_am_prod_evltion_h t19--fams_bok_val_table_data 
   on t7.bookset_id = t19.sob_id
  and t19.evltion_type_cd = '10'
  and t19.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t19.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t19.job_cd ='famsf2'
 left join ${iml_schema}.fin_am_prod_evltion_h t15--fams_bok_val_table_data t15
   on t7.bookset_id = t15.sob_id
  and t15.evltion_type_cd = '48'
  and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t15.job_cd ='famsf2'
 left join ${iml_schema}.fin_am_prod_evltion_h t16--fams_bok_val_table_data t16
   on t7.bookset_id = t16.sob_id
  and t16.evltion_type_cd = '55'
  and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t16.job_cd ='famsf2'
 left join ${icl_schema}.cmm_finc_acct_bal_info t6
   on t1.ta_tran_acct_id = t6.tran_acct_id
  and t1.lp_id = t6.lp_id
  and t1.prod_id = t6.prod_id
  and t1.bank_acct_id = t6.cap_stl_acct_num
  and t1.seller_cd = t6.seller_cd
 -- and t1.bank_id = t6.bank_id
  and ((case when t3.tard_way_cd = '0' and t3.prod_tepla_id = '1306' 
              then t9.actl_value_dt
              else t6.actl_value_dt end) = t6.actl_value_dt) 
  and t6.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
 left join (select distinct in_client_no,prd_code 
               from ${iol_schema}.ifms_tbhisfrozen 
              where ${iml_schema}.dateformat_min(frozen_date) >=to_date('${batch_date}', 'yyyymmdd') 
                and ${iml_schema}.dateformat_max(unfrozen_date) <to_date('${batch_date}', 'yyyymmdd'))t20

   on t1.ta_tran_acct_id=t20.in_client_no 
  and t1.prod_id=t20.prd_code
left join (select rela_id as prd_code, min(tx_dt) as exp_dt   
             from ${iml_schema}.ref_tx_day_para
            where tx_dt > to_date('${batch_date}', 'yyyymmdd')
              and dt_type_cd = '66'
--            and rela_id like 'YSHYYX%'
              and job_cd='ifmsf1'
            group by rela_id) t21
  on t1.prod_id = t21.prd_code
left join (select rela_id as prd_code, max(tx_dt) as value_dt
             from ${iml_schema}.ref_tx_day_para
            where tx_dt <= to_date('${batch_date}', 'yyyymmdd')
              and dt_type_cd = '66'
--            and rela_id like 'YSHYYX%'
              and job_cd='ifmsf1'
            group by rela_id) t22
  on t1.prod_id = t22.prd_code
left join ${iol_schema}.ifms_tbprdparamvalue t23
  on t1.prod_id= t23.prd_code
 and t23.table_name='tbproduct' 
 and t23.field_code='prd_xlx'
 and t23.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t23.end_dt > to_date('${batch_date}', 'yyyymmdd') 
left join ${iol_schema}.fams_fin_product_type fpt
  on t18.src_prod_id = fpt.finprod_id
 and fpt.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and fpt.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join (select client_no,asset_acc,occur_init_date,row_number() over(partition by client_no,asset_acc order by occur_init_date desc) as rn
             from ${iol_schema}.ifms_tbhisaccreq
--            where trans_code in ('100101','100002','100014')
            where trans_code in ('100002','110014','110101','1B0014','1B0101','180014','180101')
              and etl_dt<=to_date('${batch_date}', 'yyyymmdd')) t24
  on t1.bank_cust_id=t24.client_no 
 and t1.finc_acct_id=t24.asset_acc 
 and t24.rn=1
where 1 = 1;
commit;


whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_finc_acct_bal_info_ex(
   etl_dt	                               -- 数据日期
   ,lp_id	                               -- 法人编号
   ,tran_acct_id	                       -- 交易账户编号
   ,prod_id	                             -- 产品编号
   ,std_prod_id							             -- 标准产品编号
   ,prod_name	                           -- 产品名称
   ,subj_id	                             -- 科目编号
   ,prft_adj_subj_id                     -- 收益调整科目编号
   ,cust_id	                             -- 客户编号
   ,cust_type_cd	                       -- 客户类型代码
   ,finc_acct_id	                       -- 理财账户编号
   ,cont_id								               -- 合约编号
   ,open_dt	                             -- 开立日期
   ,clos_acct_dt	                       -- 销户日期
   ,last_activ_acct_dt	                 -- 上次动户日期
   ,acct_status_cd	                     -- 账户状态代码
   ,open_org_id	                         -- 开立机构编号
   ,cust_mgr_id	                         -- 客户经理编号
   ,cap_stl_acct_num	                   -- 资金结算账号
   ,seller_cd	                           -- 销售商代码
   ,bank_id	                             -- 银行编号
   ,prft_fea_cd	                         -- 收益特征代码
   ,divd_way_cd	                         -- 分红方式代码
   ,tard_way_cd	                         -- 交易方式代码
   ,prod_status_cd	                     -- 产品状态代码
   ,prod_risk_level_cd	                 -- 产品风险等级代码
   ,prft_embody_way_cd	                 -- 收益体现方式代码
   ,charge_way_cd	                       -- 收费方式代码
   ,ctrl_flg_comb												 -- 控制标志组合
   ,prod_found_dt	                       -- 产品成立日期
   ,allow_buy_begin_day                  --允许购买起始日	
   ,allow_buy_exp_day                    --允许购买到期日	
   ,prod_ped_days	                       -- 产品周期天数
   ,expe_yld_rat	                       -- 预期收益率
   ,annual_yld_rat	                     -- 年化收益率
   ,open_flg	                           -- 开放式标志
   ,ec_flg                               -- 钞汇标志
   ,indv_allow_buy_flg                   -- 个人允许购买标志
   ,inpwn_flg                            -- 质押标志
   ,prod_tepla_id						             -- 产品模板编号
   ,prod_tepla_comnt                     -- 产品模板说明
   ,brkevn_flg	                         -- 保本标志
   ,purch_dt	                           -- 申购日期
   ,exp_dt	                             -- 到期日期
   ,value_dt	                           -- 起息日期
   ,prft_exp_day	                       -- 收益到期日
   ,actl_value_dt                        -- 实际起息日期
   ,actl_exp_dt                          -- 实际到期日期
   ,curr_cd	                             -- 币种代码
   ,acct_bal	                           -- 账户余额
   ,mk_val_bal                           -- 市值余额
   ,subscr_tot_amt	                     -- 认购总金额
   ,subscr_tot_lot	                     -- 认购总份额
   ,redem_lot	                           -- 赎回份额
   ,redem_amt	                           -- 赎回金额
   ,curr_lot	                           -- 当前份额
   ,aval_lot	                           -- 可用份额
   ,tran_froz_lot	                       -- 交易冻结份额
   ,lonterm_froz_lot	                   -- 长期冻结份额
   ,loc_froz_lot	                       -- 本地冻结份额
   ,prod_fee_f_unit_nv                   -- 产品费前单位净值
   ,prod_fee_post_corp_nv                -- 产品费后单位净值
   ,td_cust_yld_rat                      -- 当日客户收益率
   ,prod_fee_bf_ten_thous_prft           -- 产品费前万份收益
   ,td_prft                              -- 本日收益
   ,invest_prft	                         -- 投资收益
   ,curr_issue_prft	                     -- 本期收益
   ,cl_curr_acct_bal	                   -- 折本币账户余额
   ,ear_d_bal	                           -- 日初余额
   ,ear_m_bal	                           -- 月初余额
   ,ear_s_bal	                           -- 季初余额
   ,ear_y_bal	                           -- 年初余额
   ,m_acm_bal	                           -- 月累计余额
   ,s_acm_bal	                           -- 季累计余额
   ,y_acm_bal	                           -- 年累计余额
   ,cl_curr_ear_d_bal	                   -- 折本币日初余额
   ,cl_curr_ear_m_bal	                   -- 折本币月初余额
   ,cl_curr_ear_s_bal	                   -- 折本币季初余额
   ,cl_curr_ear_y_bal	                   -- 折本币年初余额
   ,cl_curr_y_acm_bal	                   -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal	             -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal	             -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal	             -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal	             -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal	                   -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal	             -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal	             -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal	             -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal	                   -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal	             -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal	             -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal	             -- 折本币年初月累计余额
   ,y_avg_bal        					           -- 年日均余额
   ,q_avg_bal        					           -- 季日均余额
   ,m_avg_bal        					           -- 月日均余额
   ,cl_curr_y_avg_bal					           -- 折本币年日均余额
   ,cl_curr_q_avg_bal					           -- 折本币季日均余额
   ,cl_curr_m_avg_bal					           -- 折本币月日均余额
   ,cl_curr_mk_val_bal                   -- 折本币市值余额
   ,ear_d_mk_val_bal                     -- 日初市值余额
   ,ear_m_mk_val_bal                     -- 月初市值余额
   ,ear_s_mk_val_bal                     -- 季初市值余额
   ,ear_y_mk_val_bal                     -- 年初市值余额
   ,m_acm_mk_val_bal                     -- 月累计市值余额
   ,s_acm_mk_val_bal                     -- 季累计市值余额
   ,y_acm_mk_val_bal                     -- 年累计市值余额
   ,cl_curr_ear_d_mk_val_bal             -- 折本币日初市值余额
   ,cl_curr_ear_m_mk_val_bal             -- 折本币月初市值余额
   ,cl_curr_ear_s_mk_val_bal             -- 折本币季初市值余额
   ,cl_curr_ear_y_mk_val_bal             -- 折本币年初市值余额
   ,cl_curr_y_acm_mk_val_bal             -- 折本币年累计市值余额
   ,cl_curr_ear_d_y_acm_mk_val_bal       -- 折本币日初年累计市值余额
   ,cl_curr_ear_m_y_acm_mk_val_bal       -- 折本币月初年累计市值余额
   ,cl_curr_ear_s_y_acm_mk_val_bal       -- 折本币季初年累计市值余额
   ,cl_curr_ear_y_y_acm_mk_val_bal       -- 折本币年初年累计市值余额
   ,cl_curr_s_acm_mk_val_bal             -- 折本币季累计市值余额
   ,cl_curr_ear_d_s_acm_mk_val_bal       -- 折本币日初季累计市值余额
   ,cl_curr_ear_s_s_acm_mk_val_bal       -- 折本币季初季累计市值余额
   ,cl_curr_ear_y_s_acm_mk_val_bal       -- 折本币年初季累计市值余额
   ,cl_curr_m_acm_mk_val_bal             -- 折本币月累计市值余额
   ,cl_curr_ear_d_m_acm_mk_val_bal       -- 折本币日初月累计市值余额
   ,cl_curr_ear_m_m_acm_mk_val_bal       -- 折本币月初月累计市值余额
   ,cl_curr_ear_y_m_acm_mk_val_bal       -- 折本币年初月累计市值余额
   ,y_avg_mk_val_bal                     -- 年日均市值余额
   ,q_avg_mk_val_bal                     -- 季日均市值余额
   ,m_avg_mk_val_bal                     -- 月日均市值余额
   ,cl_curr_y_avg_mk_val_bal             -- 折本币年日均市值余额
   ,cl_curr_q_avg_mk_val_bal             -- 折本币季日均市值余额
   ,cl_curr_m_avg_mk_val_bal             -- 折本币月日均市值余额
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select 
    to_date('${batch_date}','yyyymmdd')      -- 数据日期
   ,t1.lp_id	                               -- 法人编号
   ,t1.tran_acct_id	                         -- 交易账户编号
   ,t1.prod_id	                             -- 产品编号
   ,t1.std_prod_id							             -- 标准产品编号
   ,t1.prod_name	                           -- 产品名称
   ,t1.subj_id	                             -- 科目编号
   ,t1.prft_adj_subj_id                      -- 收益调整科目编号
   ,t1.cust_id	                             -- 客户编号
   ,coalesce(t1.cust_type_cd,trim(t2.cust_type_cd),'-')    -- 客户类型代码
   ,t1.finc_acct_id	                         -- 理财账户编号
   ,t1.cont_id								               -- 合约编号
   ,t1.open_dt	                             -- 开立日期
   ,t1.clos_acct_dt	                         -- 销户日期
   ,t1.last_activ_acct_dt	                   -- 上次动户日期
   ,'-'               	                     -- 账户状态代码
   ,t1.open_org_id	                         -- 开立机构编号
   ,t1.cust_mgr_id	                         -- 客户经理编号
   ,t1.cap_stl_acct_num	                     -- 资金结算账号
   ,t1.seller_cd	                           -- 销售商代码
   ,t1.bank_id	                             -- 银行编号
   ,t1.prft_fea_cd	                         -- 收益特征代码
   ,t1.divd_way_cd	                         -- 分红方式代码
   ,t1.tard_way_cd	                         -- 交易方式代码
   ,t1.prod_status_cd	                       -- 产品状态代码
   ,t1.prod_risk_level_cd	                   -- 产品风险等级代码
   ,t1.prft_embody_way_cd	                   -- 收益体现方式代码
   ,t1.charge_way_cd	                       -- 收费方式代码
   ,t1.ctrl_flg_comb												 -- 控制标志组合
   ,t1.prod_found_dt	                       -- 产品成立日期
   ,t1.allow_buy_begin_day                   -- 允许购买起始日	
   ,t1.allow_buy_exp_day                     -- 允许购买到期日	
   ,t1.prod_ped_days	                       -- 产品周期天数
   ,t1.expe_yld_rat	                         -- 预期收益率
   ,t1.annual_yld_rat	                       -- 年化收益率
   ,t1.open_flg	                             -- 开放式标志
   ,t1.ec_flg                                -- 钞汇标志
   ,t1.indv_allow_buy_flg                    -- 个人允许购买标志
   ,t1.inpwn_flg                             -- 质押标志
   ,t1.prod_tepla_id						             -- 产品模板编号
   ,t1.prod_tepla_comnt                      -- 产品模板说明
   ,t1.brkevn_flg	                           -- 保本标志
   ,t1.purch_dt	                             -- 申购日期
   ,t1.exp_dt	                               -- 到期日期
   ,t1.value_dt	                             -- 起息日期
   ,t1.prft_exp_day	                         -- 收益到期日
   ,nvl(t1.actl_value_dt,to_date('00010101','yyyymmdd'))                         -- 实际起息日期
   ,t1.actl_exp_dt                           -- 实际到期日期
   ,t1.curr_cd	                             -- 币种代码
   ,0	                                       -- 账户余额
   ,0                                        -- 市值余额
   ,t1.subscr_tot_amt	                       -- 认购总金额
   ,t1.subscr_tot_lot                        -- 认购总份额
   ,t1.redem_lot	                           -- 赎回份额
   ,t1.redem_amt	                           -- 赎回金额
   ,0	                                       -- 当前份额
   ,t1.aval_lot	                             -- 可用份额
   ,t1.tran_froz_lot	                       -- 交易冻结份额
   ,t1.lonterm_froz_lot	                     -- 长期冻结份额
   ,t1.loc_froz_lot	                         -- 本地冻结份额
   ,t1.prod_fee_f_unit_nv                    -- 产品费前单位净值
   ,t1.prod_fee_post_corp_nv                 -- 产品费后单位净值
   ,t1.td_cust_yld_rat                       -- 当日客户收益率
   ,t1.prod_fee_bf_ten_thous_prft            -- 产品费前万份收益
   ,0                                        -- 本日收益
   ,t1.invest_prft	                         -- 投资收益
   ,0	                                       -- 本期收益
   ,0	       -- 折本币账户余额
   ,0                                        -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then 0 else nvl(t1.ear_m_bal,0.0) end                                 -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else nvl(t1.ear_s_bal,0.0) end       -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then 0 else nvl(t1.ear_y_bal,0.0) end                               -- 年初余额
   ,case when substr('${batch_date}',7,2) = '01' then 0 else nvl(t1.m_acm_bal,0.0) end                                 -- 月累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else nvl(t1.s_acm_bal,0.0) end       -- 季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then 0 else nvl(t1.y_acm_bal,0.0) end                               -- 年累计余额
   ,0                                                                                                                       -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then 0 else nvl(t1.cl_curr_ear_m_bal,0.0) end                              -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else nvl(t1.cl_curr_ear_s_bal,0.0) end    -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then 0 else nvl(t1.cl_curr_ear_y_bal,0.0) end                            -- 折本币年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then 0 else nvl(t1.cl_curr_y_acm_bal,0.0) end                            -- 折本币年累计余额
   ,nvl(t1.cl_curr_y_acm_bal,0.0)                                                                                           -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.cl_curr_y_acm_bal,0.0) else nvl(t1.cl_curr_ear_m_y_acm_bal,0.0) end                             -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.cl_curr_y_acm_bal,0.0) else nvl(t1.cl_curr_ear_s_y_acm_bal,0.0) end   -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.cl_curr_y_acm_bal,0.0) else nvl(t1.cl_curr_ear_y_y_acm_bal,0.0) end                           -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else nvl(t1.cl_curr_s_acm_bal,0.0) end                                     -- 折本币季累计余额
   ,nvl(t1.cl_curr_s_acm_bal,0.0)                                                                                                                            -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.cl_curr_s_acm_bal,0.0) else nvl(t1.cl_curr_ear_s_y_acm_bal,0.0) end   -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.cl_curr_s_acm_bal,0.0) else nvl(t1.cl_curr_ear_y_s_acm_bal,0.0) end                           -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then 0 else nvl(t1.cl_curr_m_acm_bal,0.0) end                                                               -- 折本币月累计余额
   ,nvl(t1.cl_curr_m_acm_bal,0.0)                                                                                                                            -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.cl_curr_m_acm_bal,0.0) else nvl(t1.cl_curr_ear_m_m_acm_bal,0.0) end                             -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.cl_curr_m_acm_bal,0.0) else nvl(t1.cl_curr_ear_y_m_acm_bal,0.0) end                           -- 折本币年初月累计余额
   ,(case when substr('${batch_date}',5,4) = '0101' then 0 else nvl(t1.y_acm_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else nvl(t1.s_acm_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then 0 else nvl(t1.m_acm_bal,0.0) end) / to_number(substr('${batch_date}', 7, 2))             -- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then 0 else nvl(t1.cl_curr_y_acm_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else nvl(t1.cl_curr_s_acm_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then 0 else nvl(t1.cl_curr_m_acm_bal,0.0) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
   ,0                                                           -- 折本币市值余额
   ,0                                                           -- 日初市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then 0 
		 else nvl(t1.ear_m_mk_val_bal,0.0) end                      -- 月初市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then 0 
		 else nvl(t1.ear_s_mk_val_bal,0.0) end                      -- 季初市值余额
   ,case when substr('${batch_date}',5,4) = '0101'             
         then 0                                    
		 else nvl(t1.ear_y_mk_val_bal,0.0) end                      -- 年初市值余额
   ,case when substr('${batch_date}',7,2) = '01'               
         then 0                                    
		 else nvl(t1.m_acm_mk_val_bal,0.0)         
		 end                                                        -- 月累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then 0 
		 else nvl(t1.s_acm_mk_val_bal,0.0) 
		 end                                                        -- 季累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101'              
         then 0                                     
		 else nvl(t1.y_acm_mk_val_bal,0.0)          
		 end                                                        -- 年累计市值余额
   ,0                                                           -- 折本币日初市值余额
   ,case when substr('${batch_date}',7,2) = '01'                
         then 0                             
		 else nvl(t1.cl_curr_ear_m_mk_val_bal,0.0) end              -- 折本币月初市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then 0 
		 else nvl(t1.cl_curr_ear_s_mk_val_bal,0.0) end              -- 折本币季初市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then 0 
		 else nvl(t1.cl_curr_ear_y_mk_val_bal,0.0) end              -- 折本币年初市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then 0 
         else nvl(t1.cl_curr_y_acm_mk_val_bal,0.0) 
		 end                                                        -- 折本币年累计市值余额
   ,nvl(t1.cl_curr_ear_d_y_acm_mk_val_bal,0.0)                  -- 折本币日初年累计市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then nvl(t1.cl_curr_y_acm_mk_val_bal,0.0) 
		 else nvl(t1.cl_curr_ear_m_y_acm_mk_val_bal,0.0) end        -- 折本币月初年累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t1.cl_curr_y_acm_mk_val_bal,0.0) 
		 else nvl(t1.cl_curr_ear_s_y_acm_mk_val_bal,0.0) end        -- 折本币季初年累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101' 
         then nvl(t1.cl_curr_y_acm_mk_val_bal,0.0) 
		 else nvl(t1.cl_curr_ear_y_y_acm_mk_val_bal,0.0) end         -- 折本币年初年累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then 0 
         else nvl(t1.cl_curr_s_acm_mk_val_bal,0.0) 
		 end                                                         -- 折本币季累计市值余额
   ,nvl(t1.cl_curr_s_acm_mk_val_bal,0.0)                         -- 折本币日初季累计市值余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
         then nvl(t1.cl_curr_s_acm_mk_val_bal,0.0) 
		 else nvl(t1.cl_curr_ear_s_y_acm_mk_val_bal,0.0) end         -- 折本币季初季累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101'              
         then nvl(t1.cl_curr_s_acm_mk_val_bal,0.0)              
		 else nvl(t1.cl_curr_ear_y_s_acm_mk_val_bal,0.0) end         -- 折本币年初季累计市值余额
   ,case when substr('${batch_date}',7,2) = '01' 
         then 0 
         else nvl(t1.cl_curr_m_acm_mk_val_bal,0.0) 
		 end                                                         -- 折本币月累计市值余额
   ,nvl(t1.cl_curr_m_acm_mk_val_bal,0.0)                         -- 折本币日初月累计市值余额
   ,case when substr('${batch_date}',7,2) = '01'                
         then nvl(t1.cl_curr_m_acm_mk_val_bal,0.0)              
		 else nvl(t1.cl_curr_ear_m_m_acm_mk_val_bal,0.0) end         -- 折本币月初月累计市值余额
   ,case when substr('${batch_date}',5,4) = '0101'              
         then nvl(t1.cl_curr_m_acm_mk_val_bal,0.0)              
		 else nvl(t1.cl_curr_ear_y_m_acm_mk_val_bal,0.0) end         -- 折本币年初月累计市值余额
   ,(case when substr('${batch_date}',5,4) = '0101' 
          then 0 
		  else nvl(t1.y_acm_mk_val_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均市值余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
          then 0 
		  else nvl(t1.s_acm_mk_val_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均市值余额
   ,(case when substr('${batch_date}',7,2) = '01' 
          then 0 
		  else nvl(t1.m_acm_mk_val_bal,0.0) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均市值余额
   ,(case when substr('${batch_date}',5,4) = '0101' 
          then 0 
          else nvl(t1.cl_curr_y_acm_mk_val_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均市值余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') 
          then 0 
          else nvl(t1.cl_curr_s_acm_mk_val_bal,0.0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均市值余额
   ,(case when substr('${batch_date}',7,2) = '01' 
          then 0 
          else nvl(t1.cl_curr_m_acm_mk_val_bal,0.0) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均市值余额
   ,t1.job_cd                                                    -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from (
      select t1.* from ${icl_schema}.cmm_finc_acct_bal_info t1 
       where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
         and t1.tard_way_cd = '0' 
         and t1.prod_tepla_id = '1306'  -- 产品模板编号，1306开放式
         and not exists (select 1 
                           from ${icl_schema}.cmm_finc_acct_bal_info_ex t2
                          where t1.tran_acct_id = t2.tran_acct_id
                            and t1.lp_id = t2.lp_id
                            and t1.prod_id = t2.prod_id
                            and t1.cap_stl_acct_num = t2.cap_stl_acct_num
                            and t1.seller_cd = t2.seller_cd
                     --       and t1.bank_id = t2.bank_id   --因理财迁移换了银行编号，暂去掉关联
                            and t2.tard_way_cd = '0' 
                            and t2.prod_tepla_id = '1306'
                            and t1.actl_value_dt = t2.actl_value_dt
                            and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd'))
      union all
      select t1.*
        from ${icl_schema}.cmm_finc_acct_bal_info t1
       where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
         and t1.tard_way_cd || t1.prod_tepla_id <> '01306'  
         and not exists (select 1 
                           from ${icl_schema}.cmm_finc_acct_bal_info_ex t2
                          where t1.tran_acct_id = t2.tran_acct_id
                            and t1.lp_id = t2.lp_id
                            and t1.prod_id = t2.prod_id
                            and t1.cap_stl_acct_num = t2.cap_stl_acct_num
                            and t1.seller_cd = t2.seller_cd
                     --       and t1.bank_id = t2.bank_id   --因理财迁移换了银行编号，暂去掉关联
                            and t2.tard_way_cd || t2.prod_tepla_id <> '01306' 
                            and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd'))
      ) t1 
   left join ${iml_schema}.agt_finc_acct t2
   	on t1.finc_acct_id = t2.finc_acct_id
   --	and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   	and t2.job_cd = 'ifmsf1'
   	and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   	and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.ta_cd ='GDHX'
   
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_finc_acct_bal_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_finc_acct_bal_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_finc_acct_bal_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_finc_acct_bal_info_05 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_finc_acct_bal_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
