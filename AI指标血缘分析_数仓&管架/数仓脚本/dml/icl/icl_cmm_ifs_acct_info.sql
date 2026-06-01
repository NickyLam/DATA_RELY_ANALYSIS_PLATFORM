/*
Purpose:    共性加工层-联合存款分户信息：包括微众平台所有存款产品的账户信息，数据来源于联合存款系统IFCS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_ifs_acct_info
CreateDate: 20191220
Logs:       20200110 翟若平 1、调整.ref_cny_fori_exch_mdl_p_h表取数口径
                            2、调整字段[当期余额]的取数逻辑（余额组件类型由005002改为005011）
            20200605 周沁晖 调整字段【当日应计利息、当期应计利息】的取数口径
                            增加字段【上次结息日期、下次结息日期、首次起息日期】
            20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
                            调整字段【标准产品编号】的取数逻辑
            20200828 周沁晖 增加字段【网络存款标志】
            20210218 陈伟峰 调整储种代码逻辑，改从联合存款账户直取
            20210427 陈伟峰 调整M层全量改增量
            20210622 陈伟峰 优化临时表取值逻辑，将销户数据剔除，然后从前一天表将销户数据回插，并计算基数字段
            20210630 陈伟峰 优化脚本
            20220413 李森辉 新一代改造，调整字段【折本币账户余额等相关折币字段的取数口径】，折人民币汇率取数来源：旧核心 -> 新核心
            20220513 李森辉 新一代改造，【CD1323-计息方式代码】代码落标，同步调整字段【计息方式代码】默认代码值，'01' -> 'AB'（积数计息）。
            20220516 李森辉 调整字段【标准产品编号、科目编号】的加工口径
			      20220624 温旺清 调整字段【科目编号、应收利息科目编号】的加工口径
			      20221011 温旺清 1、调整【当期应计利息】的取值逻辑
            20221015 温旺清 调整字段【基准利率类型代码、结息方式代码】的加工口径。
            20221215 曹永茂 调整第二组【开户渠道代码】从上一日取数时要转码落标
            20230502 曹永茂 调整【存款账户状态代码】取数口径，过滤条件 CD2554 -> CD1753
            20230804 徐子豪 调整逻辑【DEP_ACCT_STATUS_CD 存款账户状态代码】 修改码值CD1753 --> CD2554 【FROZ_STATUS_CD 冻结状态代码】 修改码值CD1254 --> CD1342
            20240307 饶雅   调整逻辑【TD_ACRU_INT当日应计利息】取EVT_IFS_SUB_ACCT_PROVI_RGST_B.TD_INT_PAYBL
			20260407 何俊良 临时表创建规则调整
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ifs_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ifs_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_01 purge;
drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_03 purge;
drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_04 purge;
drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_05 purge;
drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_06 purge;

-- 1.2 create acct status info tempoary table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ifs_acct_info_info_01
nologging
compress ${option_switch} for query high
as
select t1.agt_id                               -- 协议编号
       ,t2.agt_status_cd as dep_acct_status_cd -- 存款账户状态代码
       ,t3.agt_status_cd as acpt_pay_status_cd -- 收付状态代码
       ,t4.agt_status_cd as froz_status_cd     -- 冻结状态代码
       ,t5.agt_status_cd as stop_pay_status_cd -- 止付状态代码
  from ${iml_schema}.agt_ifs_sub_acct t1
  left join ${iml_schema}.agt_status_h t2
    on t1.agt_id = t2.agt_id
   and t1.lp_id = t2.lp_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.agt_status_type_cd = 'CD2554'
   and t2.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_status_h t3
    on t1.agt_id = t3.agt_id
   and t1.lp_id = t3.lp_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.agt_status_type_cd = 'CD1754'
   and t3.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_status_h t4
    on t1.agt_id = t4.agt_id
   and t1.lp_id = t4.lp_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.agt_status_type_cd = 'CD1342'
   and t4.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_status_h t5
    on t1.agt_id = t5.agt_id
   and t1.lp_id = t5.lp_id
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.agt_status_type_cd = 'CD1046'
   and t5.job_cd = 'ifcsi1'
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ifcsf1'
   and t1.id_mark <> 'D'
;
commit;

-- 1.3 create acct amt info tempoary table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ifs_acct_info_info_02
nologging
compress ${option_switch} for query high
as
select t1.agt_id                                    -- 协议编号
       ,nvl(t2.bal, 0) as currt_bal                 -- 当期余额
       ,nvl(t3.amt, 0) as froz_amt                  -- 冻结金额
       ,nvl(t2.bal, 0) - nvl(t3.amt, 0) as aval_bal -- 可用余额
       ,nvl(t4.amt, 0) as stop_pay_amt              -- 止付金额
  from ${iml_schema}.agt_ifs_sub_acct t1
  left join ${iml_schema}.agt_bal_h t2
    on t1.agt_id = t2.agt_id
   and t1.lp_id = t2.lp_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.bal_type_cd = '005011'
   and t2.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_amt_h t3
    on t1.agt_id = t3.agt_id
   and t1.lp_id = t3.lp_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.amt_type_cd = '001026'
   and t3.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_amt_h t4
    on t1.agt_id = t4.agt_id
   and t1.lp_id = t4.lp_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.amt_type_cd = '001025'
   and t4.job_cd = 'ifcsi1'
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ifcsf1'
   and t1.id_mark <> 'D'
;
commit;

/*
-- 1.4.1 create acct amt info tempoary table
--联合存款分户信息表（CMM_IFS_ACCT_INFO）过滤掉往年销户（账户状态为销户及销户日期小于当年年初）且当前余额为0的存款分户数据
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ifs_acct_info_info_04
nologging
compress ${option_switch} for query high
as
select t1.dep_acct_id,t1.dep_prod_sub_acct_id
  from ${iml_schema}.agt_ifs_sub_acct t1
  left join ${iml_schema}.agt_status_h t2
    on t1.agt_id = t2.agt_id
   and t1.lp_id = t2.lp_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.agt_status_type_cd = 'CD1753'
   and t2.job_cd = 'ifcsf1'
  left join ${iml_schema}.agt_bal_h t3
    on t1.agt_id = t3.agt_id
   and t1.lp_id = t3.lp_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.bal_type_cd = '005011'
   and t3.job_cd = 'ifcsf1'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ifcsf1'
   and t1.id_mark <> 'D'
   and t3.bal = 0   --余额为0
   and t2.agt_status_cd = '0'   --账户状态为销户
   and t1.clos_acct_dt <= to_date('${last_year_end}', 'yyyymmdd')   --销户日期小于等于上年末
;
commit;
*/

-- 1.42 create prod info tempoary table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ifs_acct_info_info_05
nologging
compress ${option_switch} for query high
as
select * 
  from ${iml_schema}.agt_ifs_sub_acct 
 where create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and job_cd = 'ifcsf1'
   and id_mark <> 'D'
   and (sav_type_cd='S01' or (sav_type_cd='S02' and dep_acct_status_cd <> '0'))
;

-- 1.43 create prod info tempoary table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ifs_acct_info_info_06
nologging
compress ${option_switch} for query high
as
select dep_acct_id, dep_prod_sub_acct_id, sum(a.int_paybl) as currt_acru_int
  from ${iol_schema}.ifcs_dep_current_provi_rgst_b a
 where a.prod_id = 'S02CNY12M00002'
/* yyyy0101<=数据日期<yyyy0322,则开始日期为上一年1222，截止日期为数据日期
yyyy0322<=数据日期<yyyy0622,则开始日期为yyyy0322，截止日期为数据日期
yyyy0622<=数据日期<yyyy0922,则开始日期为yyyy0622，截止日期为数据日期
yyyy0922<=数据日期<yyyy1222,则开始日期为yyyy0922，截止日期为数据日期
yyyy1222<=数据日期<=yyyy1231,则开始日期为yyyy1222，截止日期为数据日期 */
   and a.tran_dt >=(case when '${batch_date}'>= substr('${batch_date}',1,4)||'0101' and '${batch_date}'< substr('${batch_date}',1,4)||'0322' 
                         then substr('${batch_date}',1,4)||'0101' 
                         when '${batch_date}'>= substr('${batch_date}',1,4)||'0322' and '${batch_date}'< substr('${batch_date}',1,4)||'0622' 
                         then substr('${batch_date}',1,4)||'0322' 
                         when '${batch_date}'>= substr('${batch_date}',1,4)||'0622' and '${batch_date}'< substr('${batch_date}',1,4)||'0922' 
                         then substr('${batch_date}',1,4)||'0622' 
                         when '${batch_date}'>= substr('${batch_date}',1,4)||'0922' and '${batch_date}'< substr('${batch_date}',1,4)||'1222' 
                         then substr('${batch_date}',1,4)||'0922' 
                         else substr('${batch_date}',1,4)||'1222'
                         end)
   and a.tran_dt <= '${batch_date}'
 group by dep_acct_id, dep_prod_sub_acct_id;

-- 1.5 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ifs_acct_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ifs_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_ifs_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ifs_acct_info_ex(
   etl_dt                   -- 数据日期
   ,lp_id                   -- 法人编号
   ,cust_acct_id            -- 客户账户编号
   ,cust_acct_sub_acct_num  -- 客户账户子户号
   ,acct_name               -- 账户名称
   ,cust_id                 -- 客户编号
   ,std_prod_id             -- 标准产品编号
   ,prod_id                 -- 产品编号
   ,bind_webank_card_no     -- 绑定微众银行卡号
   ,subj_id                 -- 科目编号
   ,cust_type_cd            -- 客户类型代码
   ,ext_prod_id             -- 外部产品编号
   ,dep_acct_status_cd      -- 存款账户状态代码
   ,acpt_pay_status_cd      -- 收付状态代码
   ,froz_status_cd          -- 冻结状态代码
   ,stop_pay_status_cd      -- 止付状态代码
   ,dep_term                -- 存期
   ,sav_type_cd             -- 储种代码
   ,exec_int_rat_cate_cd    -- 执行利率类别代码
   ,pa_ext_int_rat_cate_cd  -- 部提利率类别代码
   ,ovdue_int_rat_cate_cd   -- 逾期利率类别代码
   ,base_rat_type_cd        -- 基准利率类型代码
   ,int_set_way_cd          -- 结息方式代码
   ,int_accr_way_cd         -- 计息方式代码
   ,int_accr_base_cd        -- 计息基准代码
   ,corp_acct_flg           -- 对公账户标志
   ,rc_flg                  -- 定活标志
   ,web_dep_flg             -- 网络存款标志
   ,int_accr_flg            -- 计息标志
   ,part_draw_cnt           -- 部分提取次数
   ,acct_instit_id          -- 账务机构编号
   ,open_acct_org_id        -- 开户机构编号
   ,open_acct_teller_id     -- 开户柜员编号
   ,open_acct_flow_num      -- 开户流水号
   ,open_acct_chn_cd        -- 开户渠道代码
   ,open_acct_dt            -- 开户日期
   ,open_acct_tm            -- 开户时间
   ,close_acct_org_id       -- 销户机构编号
   ,clos_acct_teller_id     -- 销户柜员编号
   ,clos_acct_flow_num      -- 销户流水号
   ,clos_acct_dt            -- 销户日期
   ,clos_acct_tm            -- 销户时间
   ,acct_dt                 -- 账务日期
   ,value_dt                -- 起息日期
   ,exp_dt                  -- 到期日期
   ,final_activ_acct_dt     -- 最后动户日期
   ,last_int_set_dt         -- 上次结息日期
   ,next_int_set_dt         -- 下次结息日期
   ,fir_value_dt            -- 首次起息日期
   ,base_rat                -- 基准利率
   ,exec_int_rat            -- 执行利率
   ,int_rat_flo_val         -- 利率浮动值
   ,curr_cd                 -- 币种代码
   ,td_acru_int             -- 当日应计利息
   ,currt_acru_int          -- 当期应计利息
   ,currt_bal               -- 当期余额
   ,froz_amt                -- 冻结金额
   ,aval_bal                -- 可用余额
   ,stop_pay_amt            -- 止付金额
   ,cl_curr_currt_bal       -- 折本币当期余额
   ,ear_d_bal               -- 日初余额
   ,ear_m_bal               -- 月初余额
   ,ear_s_bal               -- 季初余额
   ,ear_y_bal               -- 年初余额
   ,y_acm_bal               -- 年累计余额
   ,s_acm_bal               -- 季累计余额
   ,m_acm_bal               -- 月累计余额
   ,cl_curr_ear_d_bal       -- 折本币日初余额
   ,cl_curr_ear_m_bal       -- 折本币月初余额
   ,cl_curr_ear_s_bal       -- 折本币季初余额
   ,cl_curr_ear_y_bal       -- 折本币年初余额
   ,cl_curr_y_acm_bal       -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal       -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal       -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal -- 折本币年初月累计余额
   ,y_avg_bal               -- 年日均余额
   ,q_avg_bal               -- 季日均余额
   ,m_avg_bal               -- 月日均余额
   ,cl_curr_y_avg_bal       -- 折本币年日均余额
   ,cl_curr_q_avg_bal       -- 折本币季日均余额
   ,cl_curr_m_avg_bal       -- 折本币月日均余额
   ,job_cd                  -- 任务代码
   ,etl_timestamp           -- ETL处理时间戳
)
select to_date('${batch_date}', 'yyyymmdd')            -- 数据日期
       ,t1.lp_id                                       -- 法人编号
       ,t1.dep_acct_id                                 -- 客户账户编号
       ,t1.dep_prod_sub_acct_id                        -- 客户账户子户号
       ,t1.acct_name                                   -- 账户名称
       ,t1.cust_id                                     -- 客户编号
       ,t10.prod_id                                    -- 标准产品编号
       ,t1.prod_id                                     -- 产品编号
       ,t1.webank_card_no                              -- 绑定微众银行卡号
       ,t12.pric_subj_id                               -- 科目编号  --t7.pric_accting_code
       ,'1' as cust_type_cd                           -- 客户类型代码
       ,t1.ext_prod_id                                 -- 外部产品编号
       ,t2.dep_acct_status_cd                          -- 存款账户状态代码
       ,t2.acpt_pay_status_cd                          -- 收付状态代码
       ,t2.froz_status_cd                              -- 冻结状态代码
       ,t2.stop_pay_status_cd                          -- 止付状态代码
       ,t1.dep_tenor                                   -- 存期
       ,t1.sav_type_cd                                 -- 储种代码
       ,t7.exec_int_rat_cate_cd                        -- 执行利率类别代码
       ,t7.pa_ext_int_rat_cate_cd                      -- 部提利率类别代码
       ,t7.ovdue_int_rat_cate_cd                       -- 逾期利率类别代码
       ,decode(t1.prod_id,'S02CNY12M00001','2120','S02CNY12M00002','2110','2110') as base_rat_type_cd  -- 基准利率类型代码
       ,'A0'                                           -- 结息方式代码
       ,'AB' as int_accr_way_cd                        -- 计息方式代码
       ,'A/365' as int_accr_base_cd                    -- 计息基准代码
       ,'0' as corp_acct_flg                           -- 对公账户标志
       ,decode(t1.prod_id,'S02CNY12M00001','1','S02CNY12M00002','0','0') as rc_flg                  -- 定活标志
       ,case when t11.prod_gen_id = '1' AND t11.prod_sclass_id = '02' then '1' else '0' end -- 网络存款标志
       ,t1.int_accr_flg                                -- 计息标志
       ,t1.pa_ext_cnt                                  -- 部分提取次数
       ,t1.acct_instit_id                              -- 账务机构编号
       ,t1.open_acct_org_id                            -- 开户机构编号
       ,'MB001' as open_acct_teller_id                 -- 开户柜员编号
       ,t1.open_acct_flow_num                          -- 开户流水号
       ,t1.open_acct_chn_cd                            -- 开户渠道代码
       ,t1.open_acct_dt                                -- 开户日期
       ,t1.open_acct_tm                                -- 开户时间
       ,(case when t1.clos_acct_dt <> ${iml_schema}.dateformat_max('') then t1.open_acct_org_id else '' end) as close_acct_org_id -- 销户机构编号
       ,(case when t1.clos_acct_dt <> ${iml_schema}.dateformat_max('') then 'MB001' else '' end) as clos_acct_teller_id           -- 销户柜员编号
       ,t1.clos_acct_flow_num                          -- 销户流水号
       ,t1.clos_acct_dt                                -- 销户日期
       ,t1.clos_acct_tm                                -- 销户时间
       ,t1.adu_bk_acct_dt                              -- 账务日期
       ,t1.value_dt                                    -- 起息日期
       ,t1.exp_dt                                      -- 到期日期
       ,t5.imp_dt as final_activ_acct_dt               -- 最后动户日期
       ,t5.imp_dt                                      -- 上次结息日期
       ,t1.exp_dt                                      -- 下次结息日期
       ,t1.value_dt                                    -- 首次起息日期
       ,t6.base_int_rat                                -- 基准利率
       ,t6.exec_int_rat                                -- 执行利率
       ,t6.int_rat_float_point                         -- 利率浮动值
       ,t7.curr_cd                                     -- 币种代码
       ,(case when (t5.imp_dt <> to_date('${batch_date}', 'yyyymmdd') + 1 or t1.open_acct_dt = to_date('${batch_date}', 'yyyymmdd') + 1)
           then t4.td_int_paybl
           else 0 end) as td_acru_int                  -- 当日应计利息
       ,nvl(t38.currt_acru_int,0)                      -- 当期应计利息
       ,t3.currt_bal                                   -- 当期余额
       ,t3.froz_amt                                    -- 冻结金额
       ,t3.currt_bal - t3.froz_amt                     -- 可用余额
       ,t3.stop_pay_amt                                -- 止付金额
       ,t3.currt_bal * nvl(t8.convt_cny_exch_rat, 1)   -- 折本币当期余额
       ,nvl(t9.currt_bal, 0)                           -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t9.currt_bal, 0) else nvl(t9.ear_m_bal, 0) end                                                   -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.currt_bal, 0) else nvl(t9.ear_s_bal, 0) end                         -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.currt_bal, 0) else nvl(t9.ear_y_bal, 0) end                                                 -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t3.currt_bal, 0) else nvl(t9.y_acm_bal, 0) + nvl(t3.currt_bal, 0) end                          -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t3.currt_bal, 0) else nvl(t9.s_acm_bal, 0) + nvl(t3.currt_bal, 0) end  -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t3.currt_bal, 0) else nvl(t9.m_acm_bal, 0) + nvl(t3.currt_bal, 0) end                            -- 月累计余额
       ,nvl(t9.cl_curr_currt_bal, 0)                                                                                                                           -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t9.cl_curr_currt_bal, 0) else nvl(t9.cl_curr_ear_m_bal, 0) end                                   -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.cl_curr_currt_bal, 0) else nvl(t9.cl_curr_ear_s_bal, 0) end         -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.cl_curr_currt_bal, 0) else nvl(t9.cl_curr_ear_y_bal, 0) end                                 -- 折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) else nvl(t9.cl_curr_y_acm_bal, 0) + nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) end  -- 折本币年累计余额
       ,nvl(t9.cl_curr_y_acm_bal, 0)                                                                                                                           -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t9.cl_curr_y_acm_bal, 0) else nvl(t9.cl_curr_ear_m_y_acm_bal, 0) end                             -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.cl_curr_y_acm_bal, 0) else nvl(t9.cl_curr_ear_s_y_acm_bal, 0) end   -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.cl_curr_y_acm_bal, 0) else nvl(t9.cl_curr_ear_y_y_acm_bal, 0) end                           -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) else nvl(t9.cl_curr_s_acm_bal, 0) + nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) end  -- 折本币季累计余额
       ,nvl(t9.cl_curr_s_acm_bal, 0)                                                                                                                           -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t9.cl_curr_s_acm_bal, 0) else nvl(t9.cl_curr_ear_s_s_acm_bal, 0) end   -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.cl_curr_s_acm_bal, 0) else nvl(t9.cl_curr_ear_y_s_acm_bal, 0) end                           -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) else nvl(t9.cl_curr_m_acm_bal, 0) + nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) end  -- 折本币月累计余额
       ,nvl(t9.cl_curr_m_acm_bal, 0)                                                                                                                           -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t9.cl_curr_m_acm_bal, 0) else nvl(t9.cl_curr_ear_m_m_acm_bal, 0) end                             -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t9.cl_curr_m_acm_bal, 0) else nvl(t9.cl_curr_ear_y_m_acm_bal, 0) end                           -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t3.currt_bal, 0) else nvl(t9.y_acm_bal, 0) + nvl(t3.currt_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t3.currt_bal, 0) else nvl(t9.s_acm_bal, 0) + nvl(t3.currt_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t3.currt_bal, 0) else nvl(t9.m_acm_bal, 0) + nvl(t3.currt_bal, 0) end) / to_number(substr('${batch_date}', 7, 2))  -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) else nvl(t9.cl_curr_y_acm_bal, 0) + nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) else nvl(t9.cl_curr_s_acm_bal, 0) + nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) else nvl(t9.cl_curr_m_acm_bal, 0) + nvl(t3.currt_bal, 0) * nvl(t8.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))  -- 折本币月日均余额
       ,t1.job_cd                    -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${icl_schema}.tmp_cmm_ifs_acct_info_info_05 t1
  left join ${icl_schema}.tmp_cmm_ifs_acct_info_info_01 t2
    on t1.agt_id = t2.agt_id
  left join ${icl_schema}.tmp_cmm_ifs_acct_info_info_02 t3
    on t1.agt_id = t3.agt_id
  left join ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b t4
    on t1.dep_acct_id = t4.dep_acct_id
   and t1.dep_prod_sub_acct_id = t4.dep_prod_sub_acct_id
   and t4.tran_status_cd ='1'
   and t4.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_imp_dt_h t5
    on t1.agt_id = t5.agt_id
   and t1.lp_id = t5.lp_id
   and t5.dt_type_cd = '32'
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_int_rat_h t6
    on t1.agt_id = t6.agt_id
   and t1.lp_id = t6.lp_id
   and t6.int_rat_type_cd = '001001'
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ifcsi1'
  left join ${iml_schema}.prd_ifs_prod t7
    on t1.prod_id = t7.prod_id
   and t1.lp_id = t7.lp_id
   and t7.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ifcsf1'
   and t7.id_mark <> 'D'
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t8
    on t7.curr_cd = t8.curr_cd
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_ifs_acct_info t9
    on t1.dep_acct_id = t9.cust_acct_id
   and t1.dep_prod_sub_acct_id = t9.cust_acct_sub_acct_num
   and t1.lp_id = t9.lp_id
   and t9.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join ${iml_schema}.agt_prod_rela_h t10
    on t1.agt_id = t10.agt_id
   and t1.lp_id = t10.lp_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'ifcsi1'
  /*left join ${icl_schema}.tmp_cmm_ifs_acct_info_info_03 t37
    on t10.prod_id = t37.prod_id
   and t10.lp_id = t37.lp_id
   and t37.prod_rela_type_cd = '01'
   and t37.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t37.end_dt > to_date('${batch_date}','yyyymmdd')*/
  left join ${iml_schema}.prd_prod_catlg_h t11
    on t11.prod_id = (case when t7.sav_type_cd = 'S01' and t7.prod_id = 'S02CNY12M00002' then '102010100001' 
                     when t7.sav_type_cd = 'S02' and t7.prod_id = 'S02CNY12M00001' then '102020500001'
                     else  '' end)
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t11.job_cd = 'ncbsf1' 
left join ${icl_schema}.cmm_prod_and_subj_map_rela t12 
    on t11.base_prod_id = t12.accti_prod_id
   and t12.bus_type_cd = 'IFSX'
   and t12.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ifs_acct_info_info_06 t38
    on t1.dep_acct_id = t38.dep_acct_id
   and t1.dep_prod_sub_acct_id = t38.dep_prod_sub_acct_id
 where 1=1
;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ifs_acct_info_ex(
   etl_dt                   -- 数据日期
   ,lp_id                   -- 法人编号
   ,cust_acct_id            -- 客户账户编号
   ,cust_acct_sub_acct_num  -- 客户账户子户号
   ,acct_name               -- 账户名称
   ,cust_id                 -- 客户编号
   ,std_prod_id             -- 标准产品编号
   ,prod_id                 -- 产品编号
   ,bind_webank_card_no     -- 绑定微众银行卡号
   ,subj_id                 -- 科目编号
   ,cust_type_cd            -- 客户类型代码
   ,ext_prod_id             -- 外部产品编号
   ,dep_acct_status_cd      -- 存款账户状态代码
   ,acpt_pay_status_cd      -- 收付状态代码
   ,froz_status_cd          -- 冻结状态代码
   ,stop_pay_status_cd      -- 止付状态代码
   ,dep_term                -- 存期
   ,sav_type_cd             -- 储种代码
   ,exec_int_rat_cate_cd    -- 执行利率类别代码
   ,pa_ext_int_rat_cate_cd  -- 部提利率类别代码
   ,ovdue_int_rat_cate_cd   -- 逾期利率类别代码
   ,base_rat_type_cd        -- 基准利率类型代码
   ,int_set_way_cd          -- 结息方式代码
   ,int_accr_way_cd         -- 计息方式代码
   ,int_accr_base_cd        -- 计息基准代码
   ,corp_acct_flg           -- 对公账户标志
   ,rc_flg                  -- 定活标志
   ,web_dep_flg             -- 网络存款标志
   ,int_accr_flg            -- 计息标志
   ,part_draw_cnt           -- 部分提取次数
   ,acct_instit_id          -- 账务机构编号
   ,open_acct_org_id        -- 开户机构编号
   ,open_acct_teller_id     -- 开户柜员编号
   ,open_acct_flow_num      -- 开户流水号
   ,open_acct_chn_cd        -- 开户渠道代码
   ,open_acct_dt            -- 开户日期
   ,open_acct_tm            -- 开户时间
   ,close_acct_org_id       -- 销户机构编号
   ,clos_acct_teller_id     -- 销户柜员编号
   ,clos_acct_flow_num      -- 销户流水号
   ,clos_acct_dt            -- 销户日期
   ,clos_acct_tm            -- 销户时间
   ,acct_dt                 -- 账务日期
   ,value_dt                -- 起息日期
   ,exp_dt                  -- 到期日期
   ,final_activ_acct_dt     -- 最后动户日期
   ,last_int_set_dt         -- 上次结息日期
   ,next_int_set_dt         -- 下次结息日期
   ,fir_value_dt            -- 首次起息日期
   ,base_rat                -- 基准利率
   ,exec_int_rat            -- 执行利率
   ,int_rat_flo_val         -- 利率浮动值
   ,curr_cd                 -- 币种代码
   ,td_acru_int             -- 当日应计利息
   ,currt_acru_int          -- 当期应计利息
   ,currt_bal               -- 当期余额
   ,froz_amt                -- 冻结金额
   ,aval_bal                -- 可用余额
   ,stop_pay_amt            -- 止付金额
   ,cl_curr_currt_bal       -- 折本币当期余额
   ,ear_d_bal               -- 日初余额
   ,ear_m_bal               -- 月初余额
   ,ear_s_bal               -- 季初余额
   ,ear_y_bal               -- 年初余额
   ,y_acm_bal               -- 年累计余额
   ,s_acm_bal               -- 季累计余额
   ,m_acm_bal               -- 月累计余额
   ,cl_curr_ear_d_bal       -- 折本币日初余额
   ,cl_curr_ear_m_bal       -- 折本币月初余额
   ,cl_curr_ear_s_bal       -- 折本币季初余额
   ,cl_curr_ear_y_bal       -- 折本币年初余额
   ,cl_curr_y_acm_bal       -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal       -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal       -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal -- 折本币年初月累计余额
   ,y_avg_bal               -- 年日均余额
   ,q_avg_bal               -- 季日均余额
   ,m_avg_bal               -- 月日均余额
   ,cl_curr_y_avg_bal       -- 折本币年日均余额
   ,cl_curr_q_avg_bal       -- 折本币季日均余额
   ,cl_curr_m_avg_bal       -- 折本币月日均余额
   ,job_cd                  -- 任务代码
   ,etl_timestamp           -- ETL处理时间戳
)
select  to_date('${batch_date}', 'yyyymmdd')    -- 数据日期
       ,t1.lp_id                   -- 法人编号
       ,t1.cust_acct_id            -- 客户账户编号
       ,t1.cust_acct_sub_acct_num  -- 客户账户子户号
       ,t1.acct_name               -- 账户名称
       ,t1.cust_id                 -- 客户编号
       ,(case when t1.sav_type_cd = 'S01' and t1.prod_id = 'S02CNY12M00002' then '102010100001' 
              when t1.sav_type_cd = 'S02' and t1.prod_id = 'S02CNY12M00001' then '102020500001'
              else  '' 
          end) as std_prod_id      -- 标准产品编号
       ,t1.prod_id                 -- 产品编号
       ,t1.bind_webank_card_no     -- 绑定微众银行卡号
       ,t1.subj_id                 -- 科目编号
       ,t1.cust_type_cd            -- 客户类型代码
       ,t1.ext_prod_id             -- 外部产品编号
       ,'C'                        -- 存款账户状态代码
       ,t1.acpt_pay_status_cd      -- 收付状态代码
       ,t1.froz_status_cd          -- 冻结状态代码
       ,t1.stop_pay_status_cd      -- 止付状态代码
       ,t1.dep_term                -- 存期
       ,t1.sav_type_cd             -- 储种代码
       ,t1.exec_int_rat_cate_cd    -- 执行利率类别代码
       ,t1.pa_ext_int_rat_cate_cd  -- 部提利率类别代码
       ,t1.ovdue_int_rat_cate_cd   -- 逾期利率类别代码
       ,decode(t1.base_rat_type_cd,'220','2120','214','2110','2110') as base_rat_type_cd  -- 基准利率类型代码
--       ,t1.base_rat_type_cd        -- 基准利率类型代码
       ,t1.int_set_way_cd          -- 结息方式代码
       ,t1.int_accr_way_cd         -- 计息方式代码
       ,t1.int_accr_base_cd        -- 计息基准代码
       ,t1.corp_acct_flg           -- 对公账户标志
       ,t1.rc_flg                  -- 定活标志
       ,t1.web_dep_flg             -- 网络存款标志
       ,t1.int_accr_flg            -- 计息标志
       ,t1.part_draw_cnt           -- 部分提取次数
       ,t1.acct_instit_id          -- 账务机构编号
       ,t1.open_acct_org_id        -- 开户机构编号
       ,t1.open_acct_teller_id     -- 开户柜员编号
       ,t1.open_acct_flow_num      -- 开户流水号
       ,case when t1.open_acct_chn_cd = '9017' then '404001' else t1.open_acct_chn_cd end       -- 开户渠道代码
       ,t1.open_acct_dt            -- 开户日期
       ,t1.open_acct_tm            -- 开户时间
       ,t1.close_acct_org_id       -- 销户机构编号
       ,t1.clos_acct_teller_id     -- 销户柜员编号
       ,t1.clos_acct_flow_num      -- 销户流水号
       ,nvl(trim(t1.clos_acct_dt),to_date('${batch_date}', 'yyyymmdd'))   -- 销户日期
       ,''                         -- 销户时间
       ,t1.acct_dt                 -- 账务日期
       ,t1.value_dt                -- 起息日期
       ,t1.exp_dt                  -- 到期日期
       ,t1.final_activ_acct_dt     -- 最后动户日期
       ,t1.last_int_set_dt         -- 上次结息日期
       ,t1.next_int_set_dt         -- 下次结息日期
       ,t1.fir_value_dt            -- 首次起息日期
       ,t1.base_rat                -- 基准利率
       ,t1.exec_int_rat            -- 执行利率
       ,t1.int_rat_flo_val         -- 利率浮动值
       ,t1.curr_cd                 -- 币种代码
       ,0                          -- 当日应计利息
       ,0                          -- 当期应计利息
       ,0                          -- 当期余额
       ,0                          -- 冻结金额
       ,0                          -- 可用余额
       ,0                          -- 止付金额
       ,0                          -- 折本币当期余额
       ,0                          -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then 0 else t1.ear_m_bal end                                                -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.ear_s_bal end                      -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.ear_y_bal end                                              -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.y_acm_bal end                                              -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.s_acm_bal end                      -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then 0 else t1.m_acm_bal end                                                -- 月累计余额
       , 0                                                                                                                        -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then 0 else t1.cl_curr_ear_m_bal end                                        -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.cl_curr_ear_s_bal end              -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.cl_curr_ear_y_bal end                                      -- 折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.cl_curr_y_acm_bal end                                      -- 折本币年累计余额
       , 0                                                                                                                        -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then 0 else t1.cl_curr_ear_m_y_acm_bal end                                  -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.cl_curr_ear_s_y_acm_bal end        -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.cl_curr_ear_y_y_acm_bal end                                -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.cl_curr_s_acm_bal end              -- 折本币季累计余额
       , 0                                                                                                                        -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.cl_curr_ear_s_s_acm_bal end        -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.cl_curr_ear_y_s_acm_bal end                                -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then 0 else t1.cl_curr_m_acm_bal end                                        -- 折本币月累计余额
       , 0                                                                                                                        -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then 0 else t1.cl_curr_ear_m_m_acm_bal end                                  -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then 0 else t1.cl_curr_ear_y_m_acm_bal end                                -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then 0 else t1.y_acm_bal end)/ (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                  -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.s_acm_bal end)/ (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)         -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then 0 else t1.m_acm_bal end) / to_number(substr('${batch_date}', 7, 2))    -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then 0 else t1.cl_curr_y_acm_bal end)/ (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then 0 else t1.cl_curr_s_acm_bal end)/ (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then 0 else t1.cl_curr_m_acm_bal end)/ to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
       ,t1.job_cd                                                                                                                -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                                          -- etl处理时间戳
  from ${icl_schema}.cmm_ifs_acct_info t1
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')-1
   and not exists (select 1 from ${icl_schema}.cmm_ifs_acct_info_ex ifs
                    where t1.cust_acct_id=ifs.cust_acct_id
                      and t1.cust_acct_sub_acct_num=ifs.cust_acct_sub_acct_num )
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_ifs_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_ifs_acct_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_ifs_acct_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_05 purge;
--drop table ${icl_schema}.tmp_cmm_ifs_acct_info_info_06 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_ifs_acct_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

