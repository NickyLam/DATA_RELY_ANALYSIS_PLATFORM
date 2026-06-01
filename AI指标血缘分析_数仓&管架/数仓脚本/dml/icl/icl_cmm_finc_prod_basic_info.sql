/*
Purpose:    共性加工层-理财产品基本信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_finc_prod_basic_info
CreateDate: 20200627
Logs:       20200724  翟若平 调整T1表过滤条件【增加 AND T1.FINPROD_ID <> 'F16_YSHJZXNZH'】、增加字段【开放式标志】
						20200828  周沁晖 增加字段【可代销标志、可赎回标志、销售渠道代码组合、销售地区代码组合、销售客户类型代码组合】
						20201106  陈伟峰 1、增加字段【销售产品编号、产品模板编号、实际起息日期、产品周期天数、当日客户收益率、产品费前单位净值、产品费后单位净值、产品累计单位净值、产品当期净值、募集开始日期、募集结束日期、产品成立日期、产品模板说明、销售机构编号】
                                         2、调整字段【实际到期日期】的取数逻辑，调整当前本金余额、当期应计收益取数逻辑
			      20201028  翟若平 1、调整过滤条件【T1.FINPROD_TYPE2 in ('F16', 'F24', 'F26') --》 T1.FINPROD_TYPE2 in ('F16')】
                             2、增加字段【产品模板.ref_tx_day_para td --iol.ifms_tbtransday td说明、销售机构编号】
            20201126 翟若平 调整字段【销售产品编号的取数】的取数口径
			      20201203 陈伟峰 调整字段【产品当期净值】取数口径，增加字段【产品费前万份收益、产品费后万份收益】
			      20201208 陈伟峰 调整科目范围，加入（'81240121','81240122'）
			      20201212 翟若平 ifms_tbprddaily调整IOL层的算法，由全量快照改为全量流水，需要增加ETL_DT字段的关联
			      20210112 谢  宁 【控制标志组合、个人允许购买标志】
            20210224 陈伟峰 调整募集开始日期、募集结束日期加工逻辑（直取改为实际起息日-7天、实际起息日-1天）
            20210302 陈伟峰 调整【当期应计收益】口径，使用产品费前净值->产品费后净值
            20210303 谢  宁 调整【控制标志组合、个人允许购买标志】
            20210416 翟若平 调整字段【募集开始日期、募集结束日期】的取数口径
            20210603 陈伟峰 调整当前本金余额、当期应计收益取数逻辑
            20211115 陈伟峰 增加字段【支持购买方式代码】
            20211124 陈伟峰 调整【起息日期、到期日期、实际起息日期、实际到息日期、募集开始日期、募集结束日期】加工逻辑，增加P920产品模板判断
            20211216 陈伟峰 调整【支持购买方式代码】码值，统一引用CD1582-产品属性代码
            20211224 陈伟峰 调整【起息日期、到期日期、实际起息日期、实际到息日期】加工逻辑，当取不到理财数据时，取资管
            20220428 朱觉军 新增字段【产品小类代码、销售费率、差价费率】
            20220505 翟若平 调整字段【本金科目编号、币种代码】的取数口径
			      20220915 陈伟峰 调整【实际起息日期、实际到息日期、募集开始日期、募集结束日期】加工逻辑，此前P920模板仅加工YSHYYX产品，调整为当产品模板为P920且产品小类为滚动型的产品都计算实际起息日、实际到期日、募集开始日期、募集结束日期
			      20221018 陈伟峰 1、调整【本金科目编号】加工逻辑，增加科目81240102，调整【收益调整科目编号】加工逻辑，去除科目81240102
			      20221128 陈伟峰 置空【收益调整科目编号】,调整【当期应计收益】加工逻辑
			      20231113 陈伟峰 调整【实际起息日期、实际到息日期】加工逻辑，为空时取产品表的
            20251224 陈伟峰 调整代销理财的费率表加工逻辑，按照生效日期排序取大者
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_finc_prod_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_finc_prod_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_finc_prod_basic_info_ex purge;
drop table ${icl_schema}.cmm_finc_prod_basic_info_01 purge;
drop table ${icl_schema}.cmm_finc_prod_basic_info_02 purge;
drop table ${icl_schema}.cmm_finc_prod_basic_info_03 purge;
drop table ${icl_schema}.cmm_finc_prod_basic_info_04 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_finc_prod_basic_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_finc_prod_basic_info where 0=1;

create table ${icl_schema}.cmm_finc_prod_basic_info_01
nologging
compress ${option_switch} for query high
as
select nvl(t16.fam_prod_code, t17.prd_code) as fam_prod_code,
       t17.prd_code as sell_prod_id,
       t17.reserve1 as prod_tepla_id,
       t17.model_comment as prod_tepla_comnt,
       t17.branch_no as sell_org_id,
       to_date(t17.ipo_start_date, 'yyyymmdd') as coll_start_dt,
       to_date(t17.ipo_end_date, 'yyyymmdd') as coll_end_dt,
       to_date(t17.estab_date, 'yyyymmdd') as prod_found_dt,
       t17.trans_way,
       t17.reserve1,
       to_date(t19.value_dt, 'yyyymmdd') as actl_value_dt_1,
       to_date(t21.value_dt, 'yyyymmdd') as actl_value_dt_2,
       t24.value_dt as actl_value_dt_3,
       to_date(t20.exp_dt, 'yyyymmdd') as actl_exp_dt_1,
       to_date(t22.exp_dt, 'yyyymmdd') as actl_exp_dt_2,
       t23.exp_dt as actl_exp_dt_3,
       t17.cycle_days as prod_ped_days,
       t17.control_flag as control_flag,
       row_number() over(partition by nvl(t16.fam_prod_code, t17.prd_code) order by update_time desc) rn
  from ${iol_schema}.ifms_tbproduct t17
  left join ${iol_schema}.fams_fam_ifm_mapping t16
    on t16.ifm_prod_code = t17.prd_code
   and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select prd_code, max(cycle_date) as value_dt
               from ${iol_schema}.ifms_tbcycleset
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and cycle_date <= '${batch_date}'
              group by prd_code) t19
    on t17.prd_code = t19.prd_code
  left join (select prd_code, min(cycle_date) as exp_dt
               from ${iol_schema}.ifms_tbcycleset
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and cycle_date > '${batch_date}'
              group by prd_code) t20
    on t17.prd_code = t20.prd_code
  left join (select prd_code, max(cash_date) as value_dt
               from ${iol_schema}.ifms_tbcashdate
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and cash_date <= '${batch_date}'
              group by prd_code) t21
    on t17.prd_code = t21.prd_code
  left join (select prd_code, min(cash_date) as exp_dt
               from ${iol_schema}.ifms_tbcashdate
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and cash_date > '${batch_date}'
              group by prd_code) t22
    on t17.prd_code = t22.prd_code
  left join (select rela_id as prd_code, min(tx_dt) as exp_dt   
               from ${iml_schema}.ref_tx_day_para
              where tx_dt > to_date('${batch_date}', 'yyyymmdd')
                and dt_type_cd = '66'
               -- and rela_id like 'YSHYYX%'
                and job_cd='ifmsf1'
              group by rela_id) t23
    on t17.prd_code = t23.prd_code
  left join (select rela_id as prd_code, max(tx_dt) as value_dt
               from ${iml_schema}.ref_tx_day_para
              where tx_dt <= to_date('${batch_date}', 'yyyymmdd')
                and dt_type_cd = '66'
                --and rela_id like 'YSHYYX%'
                and job_cd='ifmsf1'
              group by rela_id) t24
    on t17.prd_code = t24.prd_code
 where t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and (t17.reserve1 <> '1306' or t17.reserve1 is null)
;


-- 创建临时表存放开发式理财产品的份额信息
create table ${icl_schema}.cmm_finc_prod_basic_info_02
nologging
compress ${option_switch} for query high
as
select st.prod_id as prd_code,
       st.cfm_dt as actl_value_dt,
       fn_get_no_holidays(st.cfm_dt + nvl(max(tp.ped_days), 0)) as actl_exp_dt,
       nvl(lag(st.cfm_dt, 1) over(partition by st.prod_id order by st.cfm_dt asc), tp.prod_value_dt) as coll_start_dt,    --募集开始日期
       nvl(lag(st.cfm_dt, 0) over(partition by st.prod_id order by st.cfm_dt asc), tp.prod_value_dt)-1 as coll_end_dt,    --募集结束日期
       sum(nvl(st.lot_tot, 0)) as tot_vol
  from ${iml_schema}.agt_finc_lot_dtl_h st --${iol_schema}.ifms_tbsharedetail0 st
  inner join ${iml_schema}.prd_finc tp
    on st.prod_id = tp.finc_prod_id
   and tp.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and tp.job_cd ='ifmsf1'
   and tp.tard_way_cd = '0'
   and tp.prod_tepla_id = '1306'
 where st.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and st.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and st.job_cd='ifmsf1'
 group by st.prod_id, st.cfm_dt,tp.prod_value_dt
;

create table ${icl_schema}.cmm_finc_prod_basic_info_03
nologging
compress ${option_switch} for query high
as
select decode(t.rn1, 1, to_date(t.ipo_start_date, 'yyyymmdd'), to_date(t.last_value_dt, 'yyyymmdd') + 1) as coll_start_dt,
       (to_date(t.value_dt, 'yyyymmdd') - 1) as coll_end_dt,
       t.*
  from (select tb.prd_code,
               tb.ipo_start_date,
               tb.ipo_end_date,
               tb.cycle_date,
               nvl(lag(tb.cycle_date, 0) over(partition by tb.prd_code order by tb.cycle_date asc), tb.income_date) as value_dt,
               nvl(lag(tb.cycle_date, 1) over(partition by tb.prd_code order by tb.cycle_date asc), tb.income_date) as last_value_dt,
               row_number() over(partition by tb.prd_code order by cycle_date asc) rn1,
               row_number() over(partition by tb.prd_code order by cycle_date desc) rn
          from (select td.cycle_date, tb.*
                  from ${iol_schema}.ifms_tbcycleset td
                 inner join ${iol_schema}.ifms_tbproduct tb
                    on tb.prd_code = td.prd_code
                   and tb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and tb.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 where td.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and td.end_dt > to_date('${batch_date}', 'yyyymmdd')
                   and td.cycle_date <= '${batch_date}'
                union all
                select tb.income_date as cycle_date, tb.*
                  from ${iol_schema}.ifms_tbproduct tb
                 where tb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and tb.end_dt > to_date('${batch_date}', 'yyyymmdd')
                   and tb.income_date <> '0'
               ) tb
         where 1 = 1) t
 where 1 = 1
;

-- 创建临时表存放P920产品模板的募集日期信息
create table ${icl_schema}.cmm_finc_prod_basic_info_04
nologging
compress ${option_switch} for query high
as
select decode(t.rn1, 1, t.ipo_start_date, t.last_value_dt + 1) as coll_start_dt,
       (t.value_dt - 1) as coll_end_dt,
       t.*
  from (select tb.finc_prod_id as prd_code,
               tb.coll_start_dt as ipo_start_date,
               tb.coll_end_dt as ipo_end_date,
               tb.cycle_date,
               nvl(lag(tb.cycle_date, 0) over(partition by tb.finc_prod_id order by tb.cycle_date asc), tb.prod_value_dt) as value_dt,
               nvl(lag(tb.cycle_date, 1) over(partition by tb.finc_prod_id order by tb.cycle_date asc), tb.prod_value_dt) as last_value_dt,
               row_number() over(partition by tb.finc_prod_id order by tb.cycle_date asc) rn1,
               row_number() over(partition by tb.finc_prod_id order by tb.cycle_date desc) rn
          from (select td.tx_dt as cycle_date, tb.*
                  from ${iml_schema}.ref_tx_day_para td --iol.ifms_tbtransday td
                 inner join ${iml_schema}.prd_finc  tb --iol.ifms_tbproduct tb
                    on tb.finc_prod_id = td.rela_id
                   and tb.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and tb.id_mark <>'D'
		   and tb.job_cd = 'ifmsf1'
                   and tb.prod_tepla_id='P920'
                 where td.tx_dt <= to_date('${batch_date}', 'yyyymmdd')
                   -- and td.rela_id = 'YSHYYX001'
                   and td.dt_type_cd = '66'
                   and td.job_cd='ifmsf1'
                union all
                select tb.prod_value_dt as cycle_date, tb.*
                  from ${iml_schema}.prd_finc  tb --iol.ifms_tbproduct tb
                 where tb.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and tb.id_mark <>'D'
		   and tb.job_cd = 'ifmsf1'
                   and tb.prod_tepla_id='P920'
                   -- and tb.finc_prod_id = 'YSHYYX001'
               ) tb
         where 1 = 1) t
 where 1 = 1
 ;



whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_finc_prod_basic_info_ex(
    etl_dt                        -- 数据日期
    ,lp_id                        -- 法人编号
    ,prod_id                      -- 产品编号
    ,fin_prod_id                  -- 金融产品编号
    ,sell_prod_id                 -- 销售产品编号
    ,std_prod_id                  -- 标准产品编号
    ,prod_abbr                    -- 产品简称
    ,prod_fname                   -- 产品全称
    ,prod_tepla_id                -- 产品模板编号
    ,prod_tepla_comnt             -- 产品模板说明
    ,prod_cate_cd                 -- 产品类别代码
    ,prod_sclass_cd               -- 产品小类代码
    ,prft_mode_cd                 -- 收益模式代码
    ,tran_caln_cd                 -- 交易日历代码
    ,coll_way_cd                  -- 募集方式代码
    ,oper_mode_cd                 -- 运作模式代码
    ,supt_buy_way_cd              -- 支持购买方式代码
    ,entr_way_cd                  -- 委托方式代码
    ,csner_id                     -- 委托人编号
    ,trustee_id                   -- 托管人编号
    ,sell_dept_id                 -- 销售部门编号
    ,sell_org_id                  -- 销售机构编号
    ,coll_start_dt	              -- 募集开始日期
    ,coll_end_dt                  -- 募集结束日期
    ,prod_found_dt                -- 产品成立日期
    ,value_dt                     -- 起息日期
    ,exp_dt                       -- 到期日期
    ,actl_value_dt	              -- 实际起息日期
    ,actl_exp_dt                  -- 实际到期日期
    ,liqd_dt                      -- 清盘日期
    ,tenor                        -- 期限
    ,tenor_kind_cd                -- 期限种类代码
    ,invest_ped_days              -- 投资周期天数
    ,prod_ped_days                -- 产品周期天数
    ,subtn_flg                    -- 永续标志
    ,subtn_claus_descb            -- 永续条款描述
    ,purch_cfm_tenor              -- 申购确认期限
    ,redem_cfm_tenor              -- 赎回确认期限
    ,inv_port_id                  -- 投资组合编号
    ,prod_rgst_code               -- 产品登记编码
    ,cash_mgmt_flg                -- 现金管理标志
    ,ped_prod_flg                 -- 周期型产品标志
    ,open_flg                     -- 开放式标志
    ,consmted_flg		              -- 可代销标志
    ,redembl_flg		              -- 可赎回标志
    ,layered_flg                  -- 分层标志
    ,indv_allow_buy_flg           -- 个人允许购买标志
    ,layered_type_cd              -- 分层类型代码
    ,invest_char_cd               -- 投资性质代码
    ,prft_type_cd                 -- 收益类型代码
    ,issue_status_cd              -- 发行状态代码
    ,risk_level_cd                -- 风险等级代码
    ,ctrl_flg_comb                -- 控制标志组合
    ,sell_chn_cd_comb	            -- 销售渠道代码组合
    ,sell_rg_cd_comb	            -- 销售地区代码组合
    ,sell_cust_type_cd_comb	      -- 销售客户类型代码组合
    ,prod_mgr_id                  -- 产品经理编号
    ,acct_instit_id               -- 账务机构编号
    ,pric_subj_id                 -- 本金科目编号
    ,prft_adj_subj_id             -- 收益调整科目编号
    ,curr_cd                      -- 币种代码
    ,curr_pric_bal                -- 当前本金余额
    ,currt_acru_prft              -- 当期应计收益
    ,expe_yld_rat                 -- 预期收益率
    ,sevn_aual_yld                -- 七日年化收益率
    ,td_cust_yld_rat              -- 当日客户收益率
    ,sale_fee_rat                 -- 销售费率
    ,diff_price_fee_rat           -- 差价费率
    ,prod_fee_f_unit_nv           -- 产品费前单位净值
    ,prod_fee_post_corp_nv        -- 产品费后单位净值
    ,prod_acm_corp_nv             -- 产品累计单位净值
    ,prod_currt_nv                -- 产品当期净值
	  ,prod_fee_bf_ten_thous_prft   -- 产品费前万份收益
    ,prod_fee_post_ten_thous_prft -- 产品费后万份收益
    ,job_cd                       -- 任务代码
    ,etl_timestamp                -- 数据处理时间
)
select  to_date('${batch_date}','yyyymmdd')                        as  etl_dt                    -- 数据日期
       ,t1.lp_id                                                   as  lp_id                     -- 法人编号
       ,t1.src_prod_id                                             as  prod_id                   -- 产品编号
       ,t1.finc_prod_id                                            as  fin_prod_id               -- 金融产品编号
	     ,nvl(t17.prd_code, tp.sell_prod_id)                         as  sell_prod_id              -- 销售产品编号
	     ,fpt.std_prod_id                                            as  std_pord_id               -- 标准产品编号
       ,t1.prod_abbr                                               as  prod_abbr                 -- 产品简称
       ,nvl(t2.prod_name, t1.prod_abbr)                            as  prod_fname                -- 产品全称
	     ,nvl(t17.reserve1,tp.prod_tepla_id)                         as  prod_tepla_id             -- 产品模板编号
	     ,nvl(t17.model_comment, tp.prod_tepla_comnt)                as  prod_tepla_comnt          -- 产品模板说明
       ,t1.prod_cate_cd                                            as  prod_cate_cd              -- 产品类别代码
       ,nvl(trim(t26.field_value),'-')                             as  prod_sclass_cd            -- 产品小类代码
       ,t1.prft_mode_cd                                            as  prft_mode_cd              -- 收益模式代码
       ,t1.tran_caln_cd                                            as  tran_caln_cd              -- 交易日历代码
       ,t1.coll_way_cd                                             as  coll_way_cd               -- 募集方式代码
       ,t1.oper_mode_cd                                            as  oper_mode_cd              -- 运作模式代码
       ,decode(t25.field_value,'0','1','1','2','2','3','-')        as  supt_buy_way_cd           -- 支持购买方式代码
       ,t1.entr_way_cd                                             as  entr_way_cd               -- 委托方式代码
       ,t1.csner_id                                                as  csner_id                  -- 委托人编号
       ,t1.trustee_id                                              as  trustee_id                -- 托管人编号
       ,t1.sell_dept_id                                            as  sell_dept_id              -- 销售部门编号
       ,nvl(t17.branch_no, tp.sell_org_id)                         as  sell_org_id               -- 销售机构编号
       ,(case when t17.trans_way = '0' and t17.reserve1 = '1306' then t18.coll_start_dt
              when tp.trans_way = '0'  and tp.reserve1 = '1401'  then t19.coll_start_dt
              when tp.trans_way = '0'  and tp.reserve1 = 'P920'  and t26.field_value='1' then t21.coll_start_dt
              when tp.trans_way = '0'  and tp.reserve1 in ('1601', '1700', '1307') then (to_date('${batch_date}', 'yyyymmdd') - 1)
              else (nvl(to_date(t17.ipo_start_date, 'yyyymmdd'), tp.coll_start_dt))
          end)                                                     as  coll_start_dt              -- 募集开始日期
       ,(case when t17.trans_way = '0' and t17.reserve1 = '1306' then t18.coll_end_dt
             when tp.trans_way = '0'   and tp.reserve1 = '1401'  then t19.coll_end_dt
             when tp.trans_way = '0'   and tp.reserve1 = 'P920'  and t26.field_value='1' then t21.coll_end_dt
             when tp.trans_way = '0'   and tp.reserve1 in ('1601', '1700', '1307') then (to_date('${batch_date}', 'yyyymmdd') - 1)
             else (nvl(to_date(t17.ipo_end_date, 'yyyymmdd'), tp.coll_end_dt))
         end)                                                      as  coll_end_dt               -- 募集结束日期
       ,nvl(to_date(t17.estab_date, 'yyyymmdd'), tp.prod_found_dt) as  prod_found_dt             -- 产品成立日期
       ,nvl(t20.prod_value_dt,t1.value_dt)                         as  value_dt                  -- 起息日期
       ,nvl(t20.prod_end_dt,t1.exp_dt)                             as  exp_dt                    -- 到期日期
	     ,case when t17.trans_way = '0' and t17.reserve1 = '1306' and t18.actl_value_dt is not null then t18.actl_value_dt
             when tp.trans_way = '0'  and tp.reserve1 = '1401' and tp.actl_value_dt_1 is not null then tp.actl_value_dt_1
             when tp.trans_way = '0'  and tp.reserve1 in ('1601', '1700') and tp.actl_value_dt_2 is not null then tp.actl_value_dt_2
             when tp.trans_way = '0'  and tp.reserve1 = 'P920' and trim(tp.actl_value_dt_3) is not null and t26.field_value='1' then tp.actl_value_dt_3
             else nvl(t20.prod_value_dt,t1.value_dt) end           as  actl_value_dt             -- 实际起息日期
       ,case when t17.trans_way = '0' and t17.reserve1 = '1306' and t18.actl_exp_dt is not null then t18.actl_exp_dt
             when tp.trans_way = '0'  and tp.reserve1 = '1401' and tp.actl_exp_dt_1 is not null then tp.actl_exp_dt_1
             when tp.trans_way = '0'  and tp.reserve1 in ('1601', '1700') and tp.actl_exp_dt_2 is not null then tp.actl_exp_dt_2
             when tp.trans_way = '0'  and tp.reserve1 = 'P920' and t26.field_value='1' and trim(tp.actl_exp_dt_3) is not null then tp.actl_exp_dt_3
             else nvl(t20.prod_end_dt,t1.exp_dt) end               as  actl_exp_dt               -- 实际到期日期
       ,t1.liqd_dt                                                 as  liqd_dt                   -- 清盘日期
       ,t1.prod_tenor                                              as  tenor                     -- 期限
       ,t1.tenor_type_cd                                           as  tenor_kind_cd             -- 期限种类代码
       ,nvl(trim(t1.ped_days),0)                                   as  invest_ped_days           -- 投资周期天数
	     ,nvl(t17.cycle_days, tp.prod_ped_days)                      as  prod_ped_days             -- 产品周期天数
       ,t1.subtn_flg                                               as  subtn_flg                 -- 永续标志
       ,t1.subtn_claus                                             as  subtn_claus_descb         -- 永续条款描述
       ,t1.purch_cfm_tenor                                         as  purch_cfm_tenor           -- 申购确认期限
       ,t1.redem_cfm_tenor                                         as  redem_cfm_tenor           -- 赎回确认期限
       ,t1.inv_port_id                                             as  inv_port_id               -- 投资组合编号
       ,t1.prod_rgst_code                                          as  prod_rgst_code            -- 产品登记编码
       ,t1.cash_mgmt_flg                                           as  cash_mgmt_flg             -- 现金管理标志
       ,t1.ped_prod_flg                                            as  ped_prod_flg              -- 周期型产品标志
       ,decode(t1.oper_mode_cd, '02', '1', '0')                    as  open_flg                  -- 开放式标志
       ,decode(t11.consignment_flag, 'Y', '1', '0')			  	       as  consmted_flg							 -- 可代销标志
       ,decode(t11.red_flag, 'Y', '1', '0')						             as  redembl_flg							 -- 可赎回标志
       ,t1.layered_flg                                             as  layered_flg               -- 分层标志
       ,case when t17.reserve1 = '1306'                            
             then substr(t17.control_flag,3,1)                     
        else substr(tp.control_flag,3,1) end 			           as  indv_allow_buy_flg              -- 个人允许购买标志
       ,t1.layered_type_cd                                         as  layered_type_cd           -- 分层类型代码
       ,t1.invest_char_type_cd                                     as  invest_char_cd            -- 投资性质代码
       ,t1.prft_type_cd                                            as  prft_type_cd              -- 收益类型代码
       ,t1.issue_status_cd                                         as  issue_status_cd           -- 发行状态代码
       ,t1.risk_level_cd                                           as  risk_level_cd             -- 风险等级代码
       ,case when t17.reserve1 = '1306'                            
             then t17.control_flag                                 
        else tp.control_flag end                                   as  ctrl_flg_comb             -- 控制标志组合
       ,t11.sale_channel                                           as  sell_chn_cd_comb			  	 -- 销售渠道代码组合
       ,t11.sale_area													                     as  sell_rg_cd_comb			  	 -- 销售地区代码组合
       ,t11.investor_type											                     as  sell_cust_type_cd_comb		 -- 销售客户类型代码组合
       ,t1.prod_mgr_name                                           as  prod_mgr_id               -- 产品经理编号
       ,nvl(t8.entry_org_id, t17.branch_no)                        as  acct_instit_id            -- 账务机构编号
       ,t3.subject_no                                              as  pric_subj_id              -- 本金科目编号
       ,''                                                         as  prft_adj_subj_id          -- 收益调整科目编号
       ,nvl(trim(t3.b_ccy), 'CNY')                                 as  curr_cd                   -- 币种代码
       ,case when t17.trans_way = '0' and t17.reserve1 = '1306'    
             then t18.tot_vol                                      
             else t3.b_amt                                         
              end                                                  as  curr_pric_bal             -- 当前本金余额
       ,case when t17.trans_way = '0' and t17.reserve1 = '1306'    
             then t18.tot_vol * (nvl(trim(t14.evltion), 1) - 1)    
             else nvl(t4.currt_acru_prft,0)                                         
              end                                                  as  currt_acru_prft           -- 当期应计收益
       ,nvl(t6.int_rat, nvl(trim(t10.evltion), 0))                 as  expe_yld_rat              -- 预期收益率
       ,nvl(t9.evltion,0)                                          as  sevn_aual_yld             -- 七日年化收益率
	     ,nvl(trim(t12.evltion), 0)                                  as  td_cust_yld_rat           -- 当日客户收益率
       ,nvl(t29.prod_fee_rat,0)                                    as  sale_fee_rat              -- 销售费率
       ,nvl(t30.prod_fee_rat,0)                                    as  diff_price_fee_rat        -- 差价费率
	     ,nvl(trim(t13.evltion),1)                                   as  prod_fee_f_unit_nv        -- 产品费前单位净值
	     ,nvl(trim(t14.evltion),1)                                   as  prod_fee_post_corp_nv     -- 产品费后单位净值
	     ,nvl(trim(t15.evltion),1)                                   as  prod_acm_corp_nv          -- 产品累计单位净值
	     ,nvl(trim(t13.evltion),1)                                   as  prod_currt_nv             -- 产品当期净值
		   ,nvl(trim(t23.evltion),1)	                                 as  prod_fee_bf_ten_thous_prft --产品费前万份收益
       ,nvl(trim(t24.evltion),1)                                   as  prod_fee_post_ten_thous_prft  --产品费后万份收益
       ,t1.job_cd                                                  as  job_cd                    -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  as  etl_timestamp             -- etl处理时间戳
  from ${iml_schema}.prd_am_finc_prod t1
  left join ${iml_schema}.prd_name_h t2
    on t1.prod_id = t2.prod_id
   and t1.lp_id = t2.lp_id
   and t2.prod_name_type_cd = '01'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'famsf2'				
  left join (select bbb.src_prod_id,
                    bbb.sob_id as bookset_id,
	          	      bbb.subj_id as subject_no,
	          	      bbb.dc_curr_cd as b_ccy,
	          	      bbb.dc_bal as b_amt	  
               from ${iml_schema}.fin_am_prod_subj_bal_h bbb
              where bbb.subj_id in ('20140103', '20140203', '20140303', '81240101', '81240111', '81240201', '81240211', '81240301', '81240311','81240121','81240103', '81240102')
                and bbb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and bbb.end_dt > to_date('${batch_date}', 'yyyymmdd')
	              and bbb.job_cd = 'famsf2'
              union all
			       select fp.finprod_id as src_prod_id,
			              bb.acct_pkg_id as bookset_id,
			              (case when bb.acct_pkg_id = 'F16_XWYEB001' then '20140203' else '20140103' end ) as subject_no,
			      	      bb.dc_curr_cd as b_ccy,
			      	      bb.dc_bal as b_amt  
			         from ${iml_schema}.fin_am_prod_intnal_subj_bal bb
			        inner join ${iol_schema}.fams_fin_product_add fp  --PRD_RISK_RATING_H
                 on (case when bb.acct_pkg_id like 'F16_%' then bb.acct_pkg_id else 'F16_' || bb.acct_pkg_id end) = fp.finprod_id
                and fp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and fp.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and fp.profit_flag in ('01', '02')
			        where bb.subj_id = '40010101'
                and bb.bal_dt = to_date('${batch_date}', 'yyyymmdd')
			      	  and bb.job_cd = 'famsi2') t3
    on t1.src_prod_id = t3.src_prod_id
  left join (select t.finprod_id as src_prod_id
                   ,case when fp.profit_type = '01' then nvl(t.asset_value, 0) - nvl(t.capital, 0)
                         when fp.profit_type = '03' then nvl(t.pay_profit, 0)
                         else 0 end as currt_acru_prft
               from iol.fams_bok_valbal_table_status t   --暂使用MSL表，待入仓后使用IOL表
              inner join ${iol_schema}.fams_fin_product fp
                 on t.finprod_id = fp.finprod_id
                and fp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and fp.end_dt > to_date('${batch_date}', 'yyyymmdd')
              where t.val_date = to_date('${batch_date}', 'yyyymmdd')
                and t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')) t4
    on t1.src_prod_id = t4.src_prod_id
  left join ${iml_schema}.prd_am_cashflow_info_h  t5
    on t1.src_prod_id = t5.src_prod_id
   and t5.cashflow_type_cd = '200'
   and t5.cashflow_sub_type_cd = '200'
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'famsf2'
  left join ${iml_schema}.prd_am_cashflow_calc_rule_h t6
    on t5.cashflow_id = t6.cashflow_id
   and t6.effect_dt = to_date('${batch_date}', 'yyyymmdd')
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_sob t7
    on t3.bookset_id = t7.sob_id
   and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_subj_info t8
    on t7.tepla_sob_id = t8.tepla_sob_id
   and t3.subject_no = t8.subj_id
   and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_prod_evltion_h t9
    on t3.bookset_id = t9.sob_id
   and t9.evltion_type_cd = '43'
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t9.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_prod_evltion_h t10
    on t3.bookset_id = t10.sob_id
   and t10.evltion_type_cd in ('53', '42')
   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'famsf2'
  left join ${iol_schema}.fams_prd_sale_param t11
  	on t1.src_prod_id = t11.finprod_id
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.fin_am_prod_evltion_h  t12
    on t3.bookset_id =t12.sob_id
   and t12.evltion_type_cd = '48'
   and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t12.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_prod_evltion_h  t13
    on t3.bookset_id =t13.sob_id
   and t13.evltion_type_cd = '09'
   and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t13.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_prod_evltion_h  t14
    on t3.bookset_id =t14.sob_id
   and t14.evltion_type_cd = '10'
   and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t14.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_prod_evltion_h  t15
    on t3.bookset_id =t15.sob_id
   and t15.evltion_type_cd = '27'
   and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t15.job_cd = 'famsf2'
  left join ${iol_schema}.fams_fam_ifm_mapping t16
    on t1.finc_prod_id = t16.fam_prod_code
   and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and exists (select 1
                 from ${iol_schema}.ifms_tbproduct tb
                where tb.prd_code = t16.ifm_prod_code
                  and tb.trans_way = '0'
                  and tb.reserve1 = '1306'
                  and tb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and tb.end_dt > to_date('${batch_date}', 'yyyymmdd'))
  left join ${iol_schema}.ifms_tbproduct t17
    on (t16.ifm_prod_code = t17.prd_code or t1.finc_prod_id = t17.prd_code)
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t17.trans_way = '0'
   and t17.reserve1 = '1306'
  left join ${icl_schema}.cmm_finc_prod_basic_info_02 t18
    on t17.prd_code = t18.prd_code
  left join ${icl_schema}.cmm_finc_prod_basic_info_03 t19
    on t17.prd_code = t19.prd_code
   and t19.rn = 1
  left join ${iml_schema}.prd_finc t20
    on (t16.ifm_prod_code = t20.finc_prod_id or t1.finc_prod_id = t20.finc_prod_id)
   and t20.job_cd = 'ifmsf1'
   and t20.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t20.id_mark <> 'D'
  left join ${icl_schema}.cmm_finc_prod_basic_info_04 t21
    on t17.prd_code = t21.prd_code
   and t21.rn = 1
  left join ${iml_schema}.fin_am_prod_evltion_h  t23
    on t3.bookset_id =t23.sob_id
   and t23.evltion_type_cd = '55'
   and t23.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t23.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t23.job_cd = 'famsf2'
  left join ${iml_schema}.fin_am_prod_evltion_h  t24
    on t3.bookset_id =t24.sob_id
   and t24.evltion_type_cd = '39'
   and t24.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t24.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t24.job_cd = 'famsf2'
  left join ${iol_schema}.ifms_tbprdparamvalue t25
    on (t16.ifm_prod_code = t25.prd_code or t1.finc_prod_id = t25.prd_code)
   and t25.field_code='buy_channel_ctrl'
   and t25.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t25.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ifms_tbprdparamvalue t26
    on (t16.ifm_prod_code = t26.prd_code or t1.finc_prod_id = t26.prd_code)
   and t26.table_name='tbproduct' 
   and t26.field_code='prd_xlx'
   and t26.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t26.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t.*
                        ,row_number() over(partition by prod_id,fee_rat_type_cd order by effect_dt desc) rn
                   from ${iml_schema}.prd_fee_rat_h t 
                  where effect_dt<= to_date('${batch_date}', 'yyyymmdd')
                     and invalid_dt> to_date('${batch_date}', 'yyyymmdd')
                     and job_cd = 'ifmsf1'
                     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and end_dt > to_date('${batch_date}', 'yyyymmdd')) t29
    on t20.finc_prod_id = t29.prod_id
   and t29.fee_rat_type_cd = '100101'   --销售费率
   and t29.rn=1
  left join (select t.*
                        ,row_number() over(partition by prod_id,fee_rat_type_cd order by effect_dt desc) rn
                   from ${iml_schema}.prd_fee_rat_h t 
                  where effect_dt<= to_date('${batch_date}', 'yyyymmdd')
                     and invalid_dt> to_date('${batch_date}', 'yyyymmdd')
                     and job_cd = 'ifmsf1'
                     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and end_dt > to_date('${batch_date}', 'yyyymmdd')) t30
    on t20.finc_prod_id = t30.prod_id
   and t30.fee_rat_type_cd = '100102'   --差价费率
   and t30.rn=1
  left join ${icl_schema}.cmm_finc_prod_basic_info_01 tp
    on t1.finc_prod_id = tp.fam_prod_code
   and tp.rn = 1
  left join ${iol_schema}.fams_fin_product_type fpt
    on t1.src_prod_id = fpt.finprod_id
   and fpt.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and fpt.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'famsf2'
   and t1.id_mark <> 'D'
   and t1.prod_cate_cd in ('F16')
   and t1.src_prod_id <> 'F16_YSHJZXNZH';
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_finc_prod_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_finc_prod_basic_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_finc_prod_basic_info_ex purge;
-- drop table ${icl_schema}.cmm_finc_prod_basic_info_01 purge;
-- drop table ${icl_schema}.cmm_finc_prod_basic_info_02 purge;
-- drop table ${icl_schema}.cmm_finc_prod_basic_info_03 purge;
-- drop table ${icl_schema}.cmm_finc_prod_basic_info_04 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_finc_prod_basic_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
