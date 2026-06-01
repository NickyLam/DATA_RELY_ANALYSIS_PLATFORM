/*
Purpose:    共性加工层-内部账户：包括所有的内部账户信息，包含所有在核心系统记账的内部账户的基本信息。数据来源于核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_intnal_acct
CreateDate: 20220303
Logs:       20220303 李森辉 1、调整取数源，由旧核心系统调整到新核心系统取数
                            2、新增字段【内部账户性质代码】
            20220318 李森辉 1、新增字段【账户卡号】
            20220401 李森辉 1、调整字段【余额方向代码】的取数口径
                            2、置空字段【上次交易流水号-LAST_TRAN_FLOW_NUM、会计核算代码-ACCTING_CD、表内外标志-IN_OUT_TAB_FLG、业务编码序列号-BUS_CODE_SER_NUM、总账账户标志-GL_ACCT_FLG】
            20220408 李森辉 调整字段【折本币账户余额等相关折币字段的取数口径】
            20220429 李森辉 新增字段【挂销账标志】
            20220519 李森辉 1、增加【T1-账户基本信息表】的过滤条件（t1.src_module_type_cd = 'GL'）
                            2、调整字段【科目编号】的加工口径；
                            3、新增字段【挂账期限、销账方式代码】
            20220607 李森辉 新增字段【旧账户编号、旧子户号】
			      20220624 温旺清 修改【科目编号】加工逻辑
			      20220725 曹永茂 修改科目映射表T10关联条件：t10.accti_prod_attr_cd1 -> nvl(trim(t10.accti_prod_attr_cd1),'*')
			      20220727 温旺清 调整科目编号加工逻辑
			      20220812 刘维勇 调整关联表evt_dep_acct_oc_acct_rgst_b以字段acct_id,oc_acct_rgst_type_cd,etl_dt,job_cd分区按字段tran_tm排序取最新一条数据
			      20220913 温旺清 调整科目编号取数逻辑
			      20221018 温旺清 调整字段【科目编号、当账户余额、折本币账户余额及相关积数字段】的加工口径
            20221124 温旺清 新增字段 【计息标志、账户分类代码、开户渠道类型代码、定期账户类型代码、业务管理分类代码】
            20221214 翟若平 调整字段【所属机构编号】的加工口径
            20221215 陈伟峰 新增字段【账户用途代码】
            20221229 陈伟峰 调整acctno，做首位去0判断
            20221229 温旺清 新增字段【账户属性代码】
            20230529 陈伟峰 新增字段【上次修改柜员编号】
            20230725 陈伟峰 新增字段【当期应计利息】
            20240527 饶雅   新增字段【当日利息支出】、利息支出科目编号】、【账务机构编号】
            20241029 谢  宁 新增字段【旅行通账户标志】、【旅行通卡有效期】
           20250516 陈伟峰 调整evt_dep_acct_oc_acct_rgst_b算法为全量流水
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table icl.cmm_intnal_acct drop partition p_${retain_day};
alter table icl.cmm_intnal_acct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table icl.cmm_intnal_acct_ex purge;
drop table icl.tmp_cmm_intnal_acct_01 purge;
drop table icl.tmp_cmm_intnal_acct_02 purge;
drop table icl.tmp_cmm_intnal_acct_03 purge;

--获取产品科目信息配置表
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_intnal_acct_01
nologging
compress ${option_switch} for query high
as
select sdp.base_prod_id,
         coalesce(pc1.sellbl_prod_id, pc2.sellbl_prod_id, sdp.base_prod_id) as sellbl_prod_id,
         sd.amt_type_cd,
         case when sdp.base_prod_id like '4%' then nvl(trim(sdp.prod_attr_cd), '*') else '*' end as prod_attr_cd,
         sd.bus_type_cd,
         sd.subj_descb,
         sd.status_cd,
         sd.sob_id,
         sd.subj_id
    from ${iml_schema}.fin_accti_subj_rela_h sd
   inner join ${iml_schema}.fin_accti_prod_rela_info sdp
      on sd.accti_id = sdp.accti_id
     and sd.sob_id = sdp.sob_id
     and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
	   and sdp.job_cd = 'tglsi1'
    left join ${iml_schema}.prd_prod_catlg_h pc1
      on sdp.base_prod_id = pc1.sellbl_prod_id
	   and pc1.job_cd = 'ncbsf1'
     and pc1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and pc1.end_dt > to_date('${batch_date}', 'yyyymmdd')
    left join ${iml_schema}.prd_prod_catlg_h pc2
      on sdp.base_prod_id = pc2.base_prod_id
	   and pc2.job_cd = 'ncbsf1'
     and pc2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and pc2.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and trim(pc2.sellbl_prod_id) is not null
     and pc2.sellbl_prod_id not in
         (select distinct pkp.paracd
            from ${iol_schema}.tgls_pcmc_knp_para pkp
           where pkp.subscd = 'RB'
             and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
             and pkp.paracd != '%'
             and pkp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and pkp.end_dt > to_date('${batch_date}', 'yyyymmdd'))
   where sd.sob_id = 2
     and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and sd.status_cd = '1'
	 and sd.job_cd = 'tglsf1';
commit;
	 
	 
--获取产品科目
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_intnal_acct_02
nologging
compress ${option_switch} for query high
as
select distinct case when substr(gdb.acctno,1,1)='0' then substr(gdb.acctno,2) else gdb.acctno end as acctno，
       gdb.assis1 as prod_type, 
	     mp.subj_id, 
	     gdb.captal as acct_bal,
	     gdb.trprcd 
  from ${iol_schema}.tgls_glb_dept_book gdb
 inner join ${iol_schema}.ncbs_rb_acct ra
    on gdb.acctno = ra.base_acct_no || '_' || ra.acct_seq_no
   and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_rb_acct_attach raa
    on ra.internal_key = raa.internal_key
   and raa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and raa.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_intnal_acct_01 mp
    on gdb.assis1 = mp.sellbl_prod_id
   and gdb.trprcd = mp.amt_type_cd
   and mp.bus_type_cd = 'NCBS'
   and mp.prod_attr_cd = decode(substr(gdb.assis1, 1, 1), '4', raa.amount_nature, '*')  --modify by wwq at 2022/9/5 20:30
 where gdb.acctdt = '${batch_date}'
   and gdb.acctno is not null;
commit;

--获取当日利息支出、利息支出科目编号、账务机构编号
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_intnal_acct_03
nologging
compress ${option_switch} for query high
as
select 
       t1.fin_org_id               -- 账务机构编号  
      ,t1.subj_id                  -- 利息支出科目编号  
      ,t1.subj_name                -- 利息支出科目名称  
      ,t1.sellbl_prod_id           -- 产品编号  
      ,t1.curr_cd                  -- 币种代码  
      ,SUM(t1.tran_amt) as tran_amt                 -- 利息支出金额  
      ,t2.bus_acct_id              -- 内部户账号
      ,t1.bus_sys_id               -- 业务系统编号
 from ${iml_schema}.evt_accti_midgrod_acct_ety t1 -- 核算中台传票信息表
 inner join ${iml_schema}.evt_comn_tran_flow t2 --通用交易明细流水归集表 
   on t1.sorc_sys_flow_num = t2.tran_flow_num
   and t1.sorc_sys_dt = t2.tran_dt
   and t1.ova_flow_num = t2.ova_flow_num
   and t1.src_tran_flow_seq_num = t2.charge_doc_id
   and t2.job_cd='tglsi1'
   and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
 where t1.sob_id = '1'
   and substr(t1.subj_id, 1, 4) in ('6411')  --利息支出
   and t1.bus_sys_id = 'NCBS'
   and t1.job_cd='tglsi1'
   and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.tran_amt <> 0
   GROUP BY        
      t1.fin_org_id               -- 账务机构编号  
      ,t1.subj_id                  -- 利息支出科目编号  
      ,t1.subj_name                -- 利息支出科目名称  
      ,t1.sellbl_prod_id           -- 产品编号  
      ,t1.curr_cd                  -- 币种代码  
      ,t2.bus_acct_id              -- 内部户账号
      ,t1.bus_sys_id              -- 业务系统编号
      ;
commit;

whenever sqlerror exit sql.sqlcode;
create table icl.cmm_intnal_acct_ex 
nologging
compress ${option_switch} for query high
as select * from icl.cmm_intnal_acct where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into icl.cmm_intnal_acct_ex(
       etl_dt                    -- 数据日期
       ,lp_id                    -- 法人编号
       ,acct_id                  -- 账户编号
       ,sub_acct_num             -- 子户号
       ,main_acct_id             -- 主账户编号
       ,acct_card_no             -- 账户卡号
       ,old_acct_id              -- 旧账户编号
       ,old_sub_acct_num         -- 旧子户号
       ,prod_id                  -- 产品编号
       ,std_prod_id              -- 标准产品编号
       ,curr_cd                  -- 币种代码
       ,acct_name                -- 账户名称
       ,open_flow_num            -- 开户流水号
       ,clos_acct_flow_num       -- 销户流水号
       ,belong_org_id            -- 所属机构编号
       ,last_tran_dt             -- 上次交易日期
       ,last_tran_flow_num       -- 上次交易流水号
       ,accting_cd               -- 会计核算代码
       ,subj_id                  -- 科目编号
       ,bal_dir_cd               -- 余额方向代码
       ,acct_status_cd           -- 账户状态代码
       ,acct_attr_cd             -- 账户属性代码
       ,open_acct_dt             -- 开户日期
       ,clos_acct_dt             -- 销户日期
       ,in_out_tab_flg           -- 表内外标志
       ,suspd_wrtoff_flg         -- 挂销账标志
	     ,int_accr_flg             -- 计息标志
	     ,travel_card_acct_flg     -- 旅行通账户标志
       ,travel_card_valid_dt     -- 旅行通卡有效期
	     ,acct_cls_cd              -- 账户分类代码
	     ,open_acct_chn_type_cd    -- 开户渠道类型代码
	     ,reg_acct_type_cd         -- 定期账户类型代码
	     ,bus_mgmt_cls_cd          -- 业务管理分类代码	   	   
       ,on_acct_tenor            -- 挂账期限
       ,wrtoff_way_cd            -- 销账方式代码
       ,bus_code_ser_num         -- 业务编码序列号
       ,gl_acct_flg              -- 总账账户标志
       ,intnal_acct_char_cd      -- 内部账户性质代码
       ,cap_char_cd              -- 资金性质代码
       ,acct_usage_cd            -- 账户用途代码
       ,last_modif_teller_id     -- 上次修改柜员编号
       ,acct_bal                 -- 账户余额
       ,cl_curr_acct_bal         -- 折本币账户余额
       ,td_int_expns             -- 当日利息支出
       ,int_expns_subj_id        -- 利息支出科目编号
       ,acct_instit_id           -- 账务机构编号
       ,currt_acru_int           -- 当期应计利息 
       ,ear_d_bal                -- 日初余额
       ,ear_m_bal                -- 月初余额
       ,ear_s_bal                -- 季初余额
       ,ear_y_bal                -- 年初余额
       ,m_acm_bal                -- 月累计余额
       ,s_acm_bal                -- 季累计余额
       ,y_acm_bal                -- 年累计余额
       ,cl_curr_ear_d_bal        -- 折本币日初余额
       ,cl_curr_ear_m_bal        -- 折本币月初余额
       ,cl_curr_ear_s_bal        -- 折本币季初余额
       ,cl_curr_ear_y_bal        -- 折本币年初余额
       ,cl_curr_y_acm_bal        -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal        -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal        -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
       ,y_avg_bal                -- 年日均余额
       ,q_avg_bal                -- 季日均余额
       ,m_avg_bal                -- 月日均余额
       ,cl_curr_y_avg_bal        -- 折本币年日均余额
       ,cl_curr_q_avg_bal        -- 折本币季日均余额
       ,cl_curr_m_avg_bal        -- 折本币月日均余额
       ,job_cd                   -- 任务代码
       ,etl_timestamp            -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                         -- 数据日期
       ,t1.lp_id                                                                   -- 法人编号
       ,t1.acct_id                                                                 -- 账户编号
       ,t1.sub_acct_num                                                            -- 子户号
       ,t1.cust_acct_num                                                           -- 主账户编号
       ,t1.card_no                                                                 -- 账户卡号
       ,t8.acct_id                                                                 -- 旧账户编号
       ,t8.acct_seq_no_o                                                           -- 旧子户号
       ,t1.init_prod_id                                                            -- 产品编号
       ,t1.prod_id                                                                 -- 标准产品编号
       ,t1.curr_cd                                                                 -- 币种代码
       ,t1.acct_name                                                               -- 账户名称
       ,t3.tran_ref_no                                                             -- 开户流水号
       ,t4.tran_ref_no                                                             -- 销户流水号
       ,nvl(trim(t1.open_acct_org_id), t1.belong_org_id)                           -- 所属机构编号
       ,t1.final_tran_dt                                                           -- 上次交易日期
       ,''                                                                         -- 上次交易流水号
       ,''                                                                         -- 会计核算代码
       ,coalesce(t11.subj_id, t6.subj_id, t10.intnal_acct_pric_subj_id, t10.pric_subj_id) as subj_id -- 科目编号 
       /*,(case when '${batch_date}' > '20230501' then t11.subj_id
              else coalesce(t11.subj_id, t10.intnal_acct_pric_subj_id, t10.pric_subj_id) 
         end) as subj_id             */
       ,nvl(trim(t5.acct_bal_dir_cd), 'D')                                         -- 余额方向代码
       ,t1.acct_status_cd                                                          -- 账户状态代码	
       ,t1.core_acct_type_cd                                                       -- 账户属性代码
       ,t1.open_acct_dt                                                            -- 开户日期
       ,t1.clos_acct_dt                                                            -- 销户日期
       ,''                                                                         -- 表内外标志
       ,t5.suspd_wrtoff_flg                                                        -- 挂销账标志
       ,t1.int_accr_flg                                                            -- 计息标志
       ,t1.travel_card_flg                                                         -- 旅行通账户标志
       ,t1.travel_card_valid_dt                                                    -- 旅行通卡有效期
       ,t1.acct_attr_cd                                                            -- 账户分类代码
       ,t1.open_acct_chn_id                                                        -- 开户渠道类型代码
       ,t1.reg_acct_type_cd                                                        -- 定期账户类型代码
       ,t12.attr_val                                                               -- 业务管理分类代码
       ,t5.on_acct_tenor                                                           -- 挂账期限
       ,nvl(trim(t5.wrtoff_way_cd),'-')                                            -- 销账方式代码
       ,''                                                                         -- 业务编码序列号
       ,''                                                                         -- 总账账户标志
       ,t1.acct_char_type_cd                                                       -- 内部账户性质代码
       ,t5.cap_char                                                                -- 资金性质代码
       ,t1.acct_usage_cd                                                           -- 账户用途代码
       ,t1.final_modif_teller_id                                                   -- 上次修改柜员编号
       ,nvl(t11.acct_bal, 0)                                                       -- 账户余额
       ,nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1)                       -- 折本币账户余额
       ,nvl(t14.tran_amt,0)                                                               -- 当日利息支出
       ,t14.subj_id                                                                -- 当日利息支出科目编号
       ,t14.fin_org_id                                                             -- 账务机构编号
       ,nvl(t13.acct_bal, 0)                                                       -- 当期应计利息 
       ,nvl(t6.acct_bal,0)                                                                                                                                  -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.acct_bal,0) else nvl(t6.ear_m_bal,0) end                                                   -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.acct_bal,0) else nvl(t6.ear_s_bal,0) end                         -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.acct_bal,0) else nvl(t6.ear_y_bal,0) end                                                 -- 年初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t11.acct_bal, 0) else nvl(t6.m_acm_bal,0) + nvl(t11.acct_bal, 0) end                                  -- 月累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t11.acct_bal, 0) else nvl(t6.s_acm_bal,0) + nvl(t11.acct_bal, 0) end        -- 季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t11.acct_bal, 0) else nvl(t6.y_acm_bal,0) + nvl(t11.acct_bal, 0) end                                -- 年累计余额   
       ,nvl(t6.cl_curr_acct_bal,0)                                                                                                                          -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.cl_curr_acct_bal,0) else nvl(t6.cl_curr_ear_m_bal,0) end                                   -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.cl_curr_acct_bal,0) else nvl(t6.cl_curr_ear_s_bal,0) end         -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_acct_bal,0) else nvl(t6.cl_curr_ear_y_bal,0) end                                 -- 折本币年初余额  
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_y_acm_bal,0) + nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) end  -- 折本币年累计余额
       ,nvl(t6.cl_curr_y_acm_bal,0)                                                                                                                         -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.cl_curr_y_acm_bal,0) else nvl(t6.cl_curr_ear_m_y_acm_bal,0) end                            -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.cl_curr_y_acm_bal,0) else nvl(t6.cl_curr_ear_s_y_acm_bal,0) end  -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_y_acm_bal,0) else nvl(t6.cl_curr_ear_y_y_acm_bal,0) end                          -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_s_acm_bal,0) + nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) end  -- 折本币季累计余额
       ,nvl(t6.cl_curr_s_acm_bal,0)                                                                                                                         -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t6.cl_curr_s_acm_bal,0) else nvl(t6.cl_curr_ear_s_s_acm_bal,0) end  -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_s_acm_bal,0) else nvl(t6.cl_curr_ear_y_s_acm_bal,0) end                          -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_m_acm_bal,0) + nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) end  -- 折本币月累计余额
       ,nvl(t6.cl_curr_m_acm_bal,0)                                                                                                                         -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t6.cl_curr_m_acm_bal,0) else nvl(t6.cl_curr_ear_m_m_acm_bal,0) end                            -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t6.cl_curr_m_acm_bal,0) else nvl(t6.cl_curr_ear_y_m_acm_bal,0) end                          -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t11.acct_bal, 0) else nvl(t6.y_acm_bal,0) + nvl(t11.acct_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t11.acct_bal, 0) else nvl(t6.s_acm_bal,0) + nvl(t11.acct_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t11.acct_bal, 0) else nvl(t6.m_acm_bal,0) + nvl(t11.acct_bal, 0) end) / to_number(substr('${batch_date}', 7, 2))  -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_y_acm_bal,0) + nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_s_acm_bal,0) + nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) else nvl(t6.cl_curr_m_acm_bal,0) + nvl(t11.acct_bal, 0) * nvl(t7.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))  -- 折本币月日均余额
       ,t1.job_cd                                                                  -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')            -- 数据处理时间
  from ${iml_schema}.agt_dep_acct_info_h t1
  left join ${iml_schema}.agt_dep_acct_bal_h t2
    on t1.agt_id = t2.agt_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ncbsf1'
  left join (select acct_id,tran_ref_no,oc_acct_rgst_type_cd,etl_dt,job_cd,row_number()over(partition by acct_id order by tran_tm desc) rn
               from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b
              where oc_acct_rgst_type_cd='1'  --开户/卡
                and tran_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'ncbsi1') t3
    on t1.acct_id = t3.acct_id
   and t3.rn = 1
  left join (select acct_id,tran_ref_no,oc_acct_rgst_type_cd,etl_dt,job_cd,row_number()over(partition by acct_id order by tran_tm desc) rn
               from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b
              where oc_acct_rgst_type_cd='2'  --开户/卡
                and tran_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'ncbsi1') t4
    on t1.acct_id = t4.acct_id
   and t4.rn = 1 --modify by liuweiyong
  left join ${iml_schema}.agt_dep_acct_assis_info_h t5
    on t1.acct_id = t5.acct_id
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'ncbsf1'
  left join icl.cmm_intnal_acct t6
    on t6.acct_id = t1.acct_id
   and t6.lp_id = t1.lp_id
   and t6.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t7
    on t1.curr_cd = t7.curr_cd
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ncbsf1'
  left join ${iol_schema}.ncbs_new_old_seq_no t8
    on t1.acct_id = t8.internal_key
  left join ${iml_schema}.prd_std_prod_info_h t9
    on t9.prod_id = t1.prod_id
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
   and t9.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t10 
    on t1.prod_id = t10.sellbl_prod_id
   and nvl(decode(trim(t5.cap_char),'0000','*',trim(t5.cap_char)),'*') = nvl(trim(t10.accti_prod_attr_cd1),'*')
   and t10.bus_type_cd in ('NCBS', 'LN')
   and t10.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_intnal_acct_02 t11   
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t11.acctno
   and t11.trprcd = 'BAL'
  left join ${iml_schema}.prd_prod_def_h t12		
    on t1.prod_id = t12.prod_id		
   and t12.job_cd = 'ncbsf1'	
   and t12.attr_key = 'MANAGE_CLASS' 
   and t12.prod_status_cd = '1' --有效
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_intnal_acct_02 t13   
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t13.acctno
   and t13.trprcd = 'INT'
  left join ${icl_schema}.tmp_cmm_intnal_acct_03 t14  
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t14.bus_acct_id
where t1.src_module_type_cd = 'GL'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1';
commit;

-- 2.2 exchage ex table and target table
alter table icl.cmm_intnal_acct exchange partition p_${batch_date} with table icl.cmm_intnal_acct_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table icl.cmm_intnal_acct_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_intnal_acct',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
