/*
purpose:    共性加工层-存放同业账户信息:包括非结算性存放同业、同业业务的结算处存放同业账户等存放同业账户的开户、销户，利息计提和收息信息；数据来源于核心系统和同业系统。
author:     sunline
usage:      python $ETL_HOME/script/main.py 20240930 icl_cmm_nostro_acct_info
createdate: 20220324							
logs:       20220501 翟若平	1、调整字段【他行开户机构行政区划、他行国籍、他行开户机构编号、他行银行行号、他行SWIFT编号、他行账户编号、他行账户名称、他行当前余额、他行开户日期、他行销户日期、计息开始日期、计息结束日期、到期日期、账户状态代码、币种代码、基准利率、利率浮动方式代码、计息基准代码、付息频率、利率浮动值、执行利率、应收利息、当期应计利息、当日应计利息、当期余额、折本币当期余额】的取数口径；
                            2、置空字段【使用范围代码】								
            20220519 翟若平	1、调整第一组【新核心存放同业账户】字段【他行开户机构法人名称】的加工口径
                            2、置空第一组【新核心存放同业账户】字段【他行交易对手分类】
            20220601 温旺清 【账户状态代码】修改代码引用为CD2554，因此修改第二组【账户状态代码】的加工口径：
            20220624 温旺清 调整字段【科目编号、应收利息科目编号】的加工口径
            20220706 翟若平 删除第二组同业系统的存放同业账户	
			      20220726 温旺清 1、新增字段【资金性质代码】
                            2、调整字段【当期余额、折本币当期余额】的加工口径
                            3、调整临时表T14的关联条件，增加【NVL(REPLACE(TRIM(T6.AMOUNT_NATURE), '0000', '*'), '*') = T14.ACCTI_PROD_ATTR_CD1】
                            4、调整字段【账户状态代码】的加工口径
			      20220727 温旺清 调整科目编号加工口径
				    20220907 温旺清 调整字段【科目编号、应付利息科目编号、当期应计利息、当期余额、折本币当期余额】的加工口径
				    20221025 翟若平 调整字段【客户编号、他行开户机构编号、他行银行行号、他行账户编号、他行账户名称、他行开户日期、计息开始日期】的加工口径
            20221101 翟若平 调整字段【基准利率】的加工口径
            20221114 温旺清 增加字段【资产唯一标识编号】
            20221215 温旺清 增加字段【账户用途代码】
            20221229 陈伟峰 调整acctno，做首位去0判断
            20230104 温旺清 调整【同业唯一标识号】的加工口径： ordstatus >0 改为 ordstatus = 4
            20230508 新增【当日利息收入】
            20230517 陈伟峰 调整表eifs_t01_corp_cust_ext_info关联逻辑，增加UPDATED_TS字段
				    20230615 陈伟峰 调整tgls_loan_busi_h表取数逻辑，增加tgls_loan_busi表数据，用于支持年批
            20230625 徐子豪 调整【当期应计利息】的加工口径
            20230630 徐子豪 调整【应收利息】的加工口径
            20230719 曹永茂 调整【当日利息收入】的加工口径：放宽产品号的过滤条件 【assis1 = '402010100001'】 -> 【substr(assis1,1,7) in ('4020101', '4020102')】
				    20230814 陈伟峰 调整【他行开户机构法人名称，他行开户机构编号，他行银行行号】加工逻辑，从同业TTRD_OTC_TRADE补充
				    20230102 陈伟峰 调整glb_dept_book,tgls_loan_busi,tgls_loan_busi_h 三表中acctno的取值规则，对首位为0的数据进行判断并去除0
				    20240220 饶雅   新增字段【线上业务标志】
				    20240603 饶雅   修改基准利率得取数逻辑
				    20240621 饶雅  新增字段【账户编号】
				    20240920 陈伟峰 新增字段【利息收入科目编号】
				    20241101 陈伟峰 调整利息相关科目取数逻辑，从cmm_prod_and_subj_map_rela改为从M层取
		    20250306 谢宁 调整tmp_cmm_nostro_acct_info_01本金科目取数逻辑去掉TYJE006、TYJE007
           20250516 陈伟峰 调整evt_dep_acct_oc_acct_rgst_b算法为全量流水
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition  and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_nostro_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_nostro_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_nostro_acct_info_ex purge;
drop table ${icl_schema}.tmp_cmm_nostro_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_nostro_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_nostro_acct_info_04 purge;
drop table ${icl_schema}.tmp_cmm_nostro_acct_info_05 purge;

-- 获取产品科目信息配置表
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_nostro_acct_info_01
nologging
compress ${option_switch} for query high
as
select  sd.bus_type_cd, 
        coalesce(trim(t2.sellbl_prod_id), t3.sellbl_prod_id,sdp.base_prod_id)  as prod_id,
        replace(sdp.prod_attr_cd,'-','*') as accti_prod_attr_cd1,
        max(case when sd.amt_type_cd in ('BAL', 'OSL', 'PRD', 'PRI', 'NCBS018', 'BDMX003', 'ISBX001', 'ISBX002', 'ISBX003', 'ISBX004', 'ISBX006', 'TYJE001') then sd.subj_id else '' end) as pric_subj_id,
        max(case when sd.amt_type_cd in ('DOS') then sd.subj_id else '' end) as intnal_acct_pric_subj_id,
        max(case when sd.amt_type_cd in ('INT', 'TYJE002', 'TYJE003') then sd.subj_id else '' end) as recvbl_int_paybl_subj_id,
        max(case when sd.amt_type_cd in ('NCBS003', 'NCBS007', 'NCBS008', 'NCBS009', 'TYJE004', 'TYJE005') then sd.subj_id else '' end) as int_bal_pay_subj_id
  from ${iml_schema}.fin_accti_subj_rela_h sd
 inner join ${iml_schema}.fin_accti_prod_rela_info sdp
    on sd.accti_id = sdp.accti_id
   and sd.sob_id = sdp.sob_id
   and sdp.etl_dt <=to_date('${batch_date}', 'yyyymmdd')
   and sdp.job_cd = 'tglsi1'
   and sdp.base_prod_id not like '5%' --手续费
  left join ${iml_schema}.prd_prod_catlg_h	t2			 
    on sdp.base_prod_id = t2.sellbl_prod_id	
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')  
   and t2.job_cd = 'ncbsf1'  
   and t2.prod_status_cd not in('0','-')  --过滤测试数据，0-待生效,1-生效,2-停办,3-失效,'-'
  left join ${iml_schema}.prd_prod_catlg_h  t3       
    on sdp.base_prod_id = t3.base_prod_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')  
   and t3.job_cd = 'ncbsf1'     
   and trim(t3.sellbl_prod_id) is not null
   and t3.prod_status_cd not in('0','-')
   and t3.sellbl_prod_id not in (select distinct pkp.paracd
                                  from ${iol_schema}.tgls_pcmc_knp_para pkp
                                 where pkp.subscd = 'RB'
                                   and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                                   and pkp.paracd != '%'
                                   and pkp.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
                                   and pkp.end_dt > to_date('${batch_date}', 'YYYYMMDD')
                                )
 where sd.sob_id = 2
   and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and sd.bus_type_cd in ('NCBS' )
   and sd.job_cd = 'tglsf1'
 --     AND  coalesce(trim(t2.sellbl_prod_id), t3.sellbl_prod_id,sdp.base_prod_id) IN ('402010100001','402010200001','402010100002')
 group by sd.bus_type_cd, t2.sellbl_prod_id，t3.sellbl_prod_id，sdp.base_prod_id,sdp.prod_attr_cd
 ;
commit;
	 
	 

--获取产品科目信息配置表
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_nostro_acct_info_03
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
create table ${icl_schema}.tmp_cmm_nostro_acct_info_04
nologging
compress ${option_switch} for query high
as
select case when substr(gdb.acctno,1,1)='0' then substr(gdb.acctno,2) else gdb.acctno end as acctno,
       gdb.assis1 as prod_type, 
	     mp.subj_id, 
	     gdb.captal as acct_bal,
	     gdb.trprcd 
  from ${iol_schema}.tgls_glb_dept_book gdb
  inner join ${iml_schema}.agt_dep_acct_info_h ra --${iol_schema}.ncbs_rb_acct ra
    on gdb.acctno = ra.cust_acct_num || '_' || ra.sub_acct_num
   and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and ra.job_cd ='ncbsf1'
  left join ${iol_schema}.ncbs_rb_acct_attach raa
    on ra.acct_id = raa.internal_key
   and raa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and raa.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_nostro_acct_info_03 mp
    on gdb.assis1 = mp.sellbl_prod_id
   and gdb.trprcd = mp.amt_type_cd
   and mp.bus_type_cd = 'NCBS'
   and mp.prod_attr_cd = nvl(trim(decode(raa.amount_nature,'0000',' ',raa.amount_nature)),'*')  --modify by wwq at 2022/9/5 20:30
 where gdb.acctdt = '${batch_date}'
   and gdb.acctno is not null;
commit;


--按机构层级获取账户机构
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_nostro_acct_info_05
nologging
compress ${option_switch} for query high
as select t1.branch as curr_org_id  --当前机构
       ,t2.branch as sup_org_id    --上一级机构
   from ${iol_schema}.ncbs_fm_branch t1
   left join ${iol_schema}.ncbs_fm_branch t2
     on t1.attached_to=t2.branch
    and t2.hierarchy_code='02'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  where t1.hierarchy_code='03'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
union all
select t1.branch as curr_org_id  --当前机构
       ,t2.branch as sup_org_id    --上一级机构
   from ${iol_schema}.ncbs_fm_branch t1
   left join ${iol_schema}.ncbs_fm_branch t2
     on t1.attached_to=t2.branch
    and t2.hierarchy_code='01'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  where t1.hierarchy_code='02'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
union all
select t1.branch as curr_org_id  --当前机构
       ,'800001' as sup_org_id    --上一级机构
   from ${iol_schema}.ncbs_fm_branch t1
  where t1.hierarchy_code='01'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;

commit;
-- 2.1 create ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_nostro_acct_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_nostro_acct_info where 0=1;

--第一组（共一组）核心系统存放同业数据
--2.2 insert the first set of date into ex table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_nostro_acct_info_ex(
    etl_dt                      -- 数据日期
    ,lp_id                      -- 法人编号
    ,cust_acct_id               -- 客户账户编号
    ,cust_sub_acct_id           -- 账户子账号
    ,ibank_obj_id               -- 同业对象编号
	  ,asset_uniq_idf_id          -- 资产唯一标识编号
    ,cust_id                    -- 客户编号
    ,subj_id                    -- 科目编号
    ,std_prod_id                -- 标准产品编号
    ,int_recvbl_subj_id         -- 应收利息科目编号
    ,int_income_subj_id         -- 利息收入科目编号
    ,acct_id                    -- 账户编号
    ,acct_name                  -- 账户名称
    ,open_bank_name             -- 开户行名称
    ,open_bank_lp_org_cust_id   -- 开户行法人机构客户编号
    ,open_bank_lp_name          -- 开户行法人名称
    ,open_acct_org_id           -- 开户机构编号
    ,open_dt                    -- 开户日期
    ,open_flow_num              -- 开户流水号
    ,clos_acct_dt               -- 销户日期
    ,clos_acct_flow_num         -- 销户流水号
    ,acct_cls_cd                -- 账户分类代码
    ,acct_char_cd               -- 账户性质代码
    ,acct_char_descb            -- 账户性质描述
    ,acct_attr_descb            -- 账户属性描述
    ,obank_open_org_dist        -- 他行开户机构行政区划
    ,obank_nation               -- 他行国籍
    ,obank_cntpty_cls           -- 他行交易对手分类
    ,obank_open_org_lp_name     -- 他行开户机构法人名称
    ,obank_open_org_id          -- 他行开户机构编号
    ,obank_bank_no              -- 他行银行行号
    ,obank_swift_id             -- 他行swift编号
    ,obank_acct_id              -- 他行账户编号
    ,obank_acct_name            -- 他行账户名称
    ,obank_curr_bal             -- 他行当前余额
    ,obank_open_dt              -- 他行开户日期
    ,obank_clos_acct_dt         -- 他行销户日期
    ,int_start_dt               -- 计息开始日期
    ,int_end_dt                 -- 计息结束日期
    ,exp_dt                     -- 到期日期
    ,onl_bus_flg                -- 线上业务标志
    ,acct_status_cd             -- 账户状态代码
    ,use_range_cd               -- 使用范围代码
    ,acct_usage_cd              -- 账户用途代码
    ,curr_cd                    -- 币种代码
    ,base_rat                   -- 基准利率
    ,int_rat_float_way_cd       -- 利率浮动方式代码
    ,int_accr_base_cd           -- 计息基准代码
	  ,cap_char_cd                -- 资金性质代码
    ,pay_int_freq               -- 付息频率
    ,int_rat_flo_val            -- 利率浮动值
    ,exec_int_rat               -- 执行利率
    ,int_recvbl                 -- 应收利息
    ,currt_acru_int             -- 当期应计利息
    ,td_acru_int                -- 当日应计利息
    ,td_int_income              -- 当日利息收入
    ,currt_bal                  -- 当期余额
    ,cl_curr_currt_bal          -- 折本币当期余额
    ,job_cd                     -- 任务代码
    ,etl_timestamp              -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.cust_acct_num                                                   -- 客户账户编号
       ,t1.sub_acct_num                                                    -- 账户子账号
       ,''                                                                 -- 同业对象编号
	     ,t19.pk_flag                                                        -- 资产唯一标识编号
       ,t18.cntpty_cust_id                                                 -- 客户编号
       /*,(case when '${batch_date}' > '20230501' then t15.subj_id
              else coalesce(t15.subj_id, t14.intnal_acct_pric_subj_id, t14.pric_subj_id) 
         end) as subj_id                                                   -- 科目编号*/
       ,coalesce(t15.subj_id, t14.intnal_acct_pric_subj_id, t14.pric_subj_id, t20.subj_id) as subj_id  -- 科目编号
       ,t1.prod_id                                                         -- 标准产品编号
       /*,(case when '${batch_date}' > '20230501' then t16.subj_id
              else nvl(t16.subj_id, t14.recvbl_int_paybl_subj_id) 
         end)                                                              -- 应收利息科目编号*/
       ,coalesce(t16.subj_id, t14.recvbl_int_paybl_subj_id, t20.int_recvbl_subj_id) as int_recvbl_subj_id     -- 应收利息科目编号
       ,t14.int_bal_pay_subj_id                                            -- 利息收入科目编号
       ,t1.acct_id                                                         -- 账户编号
       ,t1.acct_name                                                       -- 账户名称
       ,''                                                                 -- 开户行名称
       ,t3.legal_cust_num                                                  -- 开户行法人机构客户编号
       ,t3.legal_name                                                      -- 开户行法人名称
       ,t1.open_acct_org_id                                                -- 开户机构编号
       ,nvl(t1.open_acct_dt, t17.open_dt)                                  -- 开户日期
       ,nvl(t4.tran_ref_no, t17.open_flow_num)                             -- 开户流水号
       ,coalesce(t1.clos_acct_dt, t17.clos_acct_dt, to_date('29991231','yyyymmdd'))  -- 销户日期
       ,nvl(t4.tran_ref_no, t17.clos_acct_flow_num)                        -- 销户流水号
       ,t1.acct_attr_cd                                                    -- 账户分类代码
       ,case when substr(t1.prod_id, 1, 7) ='4020101' then '18'  
		         when substr(t1.prod_id, 1, 7) ='4020102' then '19' 
		         else '-' end                                                  -- 账户性质代码
       ,decode(t1.acct_attr_cd, '11002', '一般账户', '11004', '专用账户','39001','内部户专用')    -- 账户性质描述
       ,decode(t1.acct_char_type_cd, 'J', '结算性','T', '投融资类')        -- 账户属性描述
       ,t6.cntpty_bk_open_acct_org_belong_dist_cd                          -- 他行开户机构行政区划
       ,t6.cntpty_bank_belong_cty_rg_cd                                    -- 他行国籍
       ,''                                                                 -- 他行交易对手分类
       ,nvl(t12.legal_name,t19.party_bank_name)                            -- 他行开户机构法人名称
       ,nvl(t6.cntpty_acct_open_acct_org_id,t19.party_bank_code)           -- 他行开户机构编号
       ,nvl(t6.cntpty_acct_open_acct_org_id,t19.party_bank_code)           -- 他行银行行号
       ,t6.bank_inter_id                                                   -- 他行swift编号
       ,t18.cntpty_acct_id                                                 -- 他行账户编号
       ,t18.cntpty_acct_name                                               -- 他行账户名称
       ,t7.curr_bal                                                        -- 他行当前余额
       ,t18.cntpty_acct_open_acct_dt                                       -- 他行开户日期
       ,t1.clos_acct_dt                                                    -- 他行销户日期
       ,t18.cntpty_acct_open_acct_dt                                       -- 计息开始日期
       ,t1.exp_dt                                                          -- 计息结束日期
       ,t1.exp_dt                                                          -- 到期日期
       ,decode(t19.online_mark,'是','1','否','0','')                       -- 线上业务标志
	     ,(case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
	            then t1.last_acct_status_cd 
		      else t1.acct_status_cd end)   as acct_status_cd                  -- 账户状态代码
       ,''                                                                 -- 使用范围代码
       ,t1.acct_usage_cd                                                   -- 账户用途代码
       ,t1.curr_cd                                                         -- 币种代码
       ,t9.base_rat                                                        -- 基准利率
       ,t8.int_rat_float_cate_cd                                           -- 利率浮动方式代码
       ,t8.year_int_accr_base_cd                                           -- 计息基准代码
	     ,t6.cap_char                                                        -- 资金性质代码	
       ,t8.int_set_freq_cd                                                 -- 付息频率
       ,coalesce(t8.int_rat_float_ratio, t8.int_rat_float_point, 0)        -- 利率浮动值
       ,nvl(t8.exec_int_rat, 0)                                            -- 执行利率
       ,coalesce(t16.acct_bal, 0)                                          -- 应收利息
       ,coalesce(t16.acct_bal, 0)                                          -- 当期应计利息
       ,nvl(t8.provi_day_provi_int, 0)                                     -- 当日应计利息
       ,nvl(t22.td_int_expns,0)                                            -- 当日利息收入
       ,nvl(t15.acct_bal, 0)                                               -- 当期余额
       ,nvl(t15.acct_bal, 0) * nvl(t10.convt_cny_exch_rat , 1)             -- 折本币当期余额    
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    -- 数据处理时间
  from ${iml_schema}.agt_dep_acct_info_h t1  --存款账户信息历史表
  left join ${iml_schema}.agt_dep_main_acct_info_h t21
    on t1.cust_acct_num = t21.cust_acct_num
   and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t21.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t21.job_cd = 'ncbsf1' 
 left join ${iml_schema}.agt_inside_acct_cntpty_info_h t18
    on nvl(t21.acct_id, t1.acct_id) = t18.acct_id
   and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t18.job_cd = 'ncbsf1'
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref t2		
    on t2.cust_num = t18.cntpty_cust_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t01_corp_cust_ext_info t3		
    on t2.party_id = t3.party_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.updated_ts =to_date('99991231', 'yyyymmdd')
  left join (select oar.*,
                    row_number() over(partition by oar.acct_id order by flow_num desc) rn
               from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b oar
              where oar.oc_acct_rgst_type_cd = '1'
                and oar.job_cd = 'ncbsi1'
                and oar.tran_dt <= to_date('${batch_date}','yyyymmdd')
              ) t4
    on t1.acct_id = t4.acct_id
   and t4.rn = 1
  left join (select oar.*,
                    row_number() over(partition by oar.acct_id order by flow_num desc) rn
               from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b oar
              where oar.oc_acct_rgst_type_cd = '2'
                and oar.job_cd = 'ncbsi1'
                and oar.tran_dt <= to_date('${batch_date}','yyyymmdd')
              ) t5
    on t1.acct_id = t5.acct_id
   and t5.rn = 1
  left join ${iml_schema}.agt_dep_acct_assis_info_h t6	
    on t1.acct_id=t6.acct_id
   and t6.job_cd = 'ncbsf1'
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_dep_acct_bal_h t7		
    on t1.acct_id=t7.acct_id	
   and t7.job_cd = 'ncbsf1'
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_dep_acct_int_dtl t8		
    on t1.acct_id=t8.acct_id		
   and t8.int_cls_cd = 'INT'
   and t8.job_cd = 'ncbsi1'
   and t8.etl_dt = to_date('${batch_date}','yyyymmdd')
   left join ${icl_schema}.tmp_cmm_nostro_acct_info_05 bra
    on t1.open_acct_org_id=bra.curr_org_id
   left join ${icl_schema}.tmp_cmm_nostro_acct_info_05 bra1
    on bra.sup_org_id=bra1.curr_org_id
   left join ${iml_schema}.ref_bank_int_ladr_h bil1		
    on t8.int_rat_type_cd = bil1.bank_int_int_rat_type_cd 
   --and t7.ped_freq_cd = t3.tenor_type_cd || t3.dep_tenor
   and bil1.curr_cd = t1.curr_cd
   and bil1.org_id=t1.open_acct_org_id --支行
   and bil1.effect_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and bil1.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
   and bil1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and bil1.end_dt > to_date('${batch_date}','yyyymmdd')
   and bil1.job_cd = 'ncbsf1'
   left join ${iml_schema}.ref_bank_int_ladr_h bil2		
    on t8.int_rat_type_cd = bil2.bank_int_int_rat_type_cd 
   --and t7.ped_freq_cd = t3.tenor_type_cd || t3.dep_tenor
   and bil2.curr_cd = t1.curr_cd
   and bra.sup_org_id=bil2.org_id --分行
   and bil2.effect_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and bil2.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
   and bil2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and bil2.end_dt > to_date('${batch_date}','yyyymmdd')
   and bil2.job_cd = 'ncbsf1'
   left join ${iml_schema}.ref_bank_int_ladr_h bil3	
    on t8.int_rat_type_cd = bil3.bank_int_int_rat_type_cd 
   --and t7.ped_freq_cd = t3.tenor_type_cd || t3.dep_tenor
   and bil3.curr_cd = t1.curr_cd
   and bil3.org_id=bra1.sup_org_id --总行
   and bil3.effect_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and bil3.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
   and bil3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and bil3.end_dt > to_date('${batch_date}','yyyymmdd')
   and bil3.job_cd = 'ncbsf1'
   left join(select br.*,			 
                   row_number()over(partition by br.base_rat_id, br.curr_cd order by br.effect_dt desc) rn
              from ${iml_schema}.ref_base_rat_h br 
             where br.job_cd = 'ncbsf1'
               and br.start_dt <= to_date('${batch_date}','yyyymmdd')
	             and br.end_dt > to_date('${batch_date}', 'yyyymmdd')
	          ) t9		
    on coalesce(bil1.base_rat_type_id,bil2.base_rat_type_id,bil3.base_rat_type_id) = t9.base_rat_id 
   and t1.curr_cd = t9.curr_cd		
   and t9.rn = 1	
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t10 
    on t1.curr_cd= t10.curr_cd
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'ncbsf1' 	
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref t11		
    on t11.cust_num = t6.cntpty_cust_id
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t01_corp_cust_ext_info t12		
    on t11.party_id = t12.party_id
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t12.updated_ts =to_date('99991231', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_nostro_acct_info_01 t14 
    on t1.prod_id = t14.prod_id
   and nvl(replace(trim(t6.cap_char), '0000', '*'), '*') = t14.accti_prod_attr_cd1
--   and t14.bus_type_cd in ('NCBS', 'LN')
--   and t14.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_nostro_acct_info_04 t15   
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t15.acctno
   and t15.trprcd = 'BAL'
  left join ${icl_schema}.tmp_cmm_nostro_acct_info_04 t16   
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t16.acctno
   and t16.trprcd = 'INT'
  left join ${icl_schema}.cmm_nostro_acct_info t17   
    on t1.cust_acct_num = t17.cust_acct_id
   and t1.sub_acct_num = t17.cust_sub_acct_id
   and t17.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join (select t.i_code || '_' || t.secu_actgtype || '_' || t.secu_accid as pk_flag, --唯一标识
                    m.core_acct_code as base_acct_no, --母户
                    substr(k.sub_acct, instr(k.sub_acct, '-', -1) + 1) as acct_seq_no --子户
                   ,k.party_bank_code  -- 交易对手开户行号
                   ,k.party_bank_name  -- 交易对手开户行名
                   ,ext.online_mark -- 线上业务标志
               from ${iol_schema}.ibms_ttrd_hx_credit_record t
               left join ${iol_schema}.ibms_ttrd_otc_trade k
                 on t.ord_id = k.ord_id
               left join ${iol_schema}.ibms_ttrd_otc_trade_ext ext
                 on k.sysordid = ext.sysordid
               left join ${iol_schema}.ibms_ttrd_cashlb lb
                 on k.i_code = lb.i_code
                and lb.start_dt <= to_date('${batch_date}','yyyymmdd')
                and lb.end_dt > to_date('${batch_date}','yyyymmdd')
               left join ${iol_schema}.ibms_ttrd_fixedterm_account m
                 on lb.acct_id = m.acct_id
                and m.start_dt <= to_date('${batch_date}','yyyymmdd')
                and m.end_dt > to_date('${batch_date}','yyyymmdd') 
              where lb.acct_id is not null
                and k.ordstatus = 4
                and t.start_dt <= to_date('${batch_date}','yyyymmdd')
                and t.end_dt > to_date('${batch_date}','yyyymmdd') )t19
	  on t1.cust_acct_num = t19.base_acct_no and t1.sub_acct_num = t19.acct_seq_no
	left join ${icl_schema}.cmm_nostro_acct_info t20
	  on t1.cust_acct_num = t20.cust_acct_id
	 and t1.sub_acct_num = t20.cust_sub_acct_id
	 and t20.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
	left join (select acctno as acctno,
                    sum(tranam) as td_int_expns
               from (select case when substr(acctno,1,1)='0' then substr(acctno,2) else acctno end as acctno,tranam
                       from ${iol_schema}.tgls_loan_busi_h t1
                      where etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        and trandt = '${batch_date}'
                        and status = '1'
                        and substr(assis1,1,7) in ('4020101', '4020102')
                        and assis5 in ('ACR', 'CAPT')
                      union all 
                     select case when substr(acctno,1,1)='0' then substr(acctno,2) else acctno end as acctno,tranam
                       from ${iol_schema}.tgls_loan_busi t1
                      where etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        and trandt = '${batch_date}'
                        and status = '1'
                        and t1.stacid = 2
                        and substr(assis1,1,7) in ('4020101', '4020102')
                        and assis5 in ('ACR', 'CAPT')
                        and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt 
                                         where tt.transq=t1.transq 
                                           and tt.trandt=t1.trandt 
                                           and tt.bsnssq=t1.bsnssq 
                                           and tt.serino=t1.serino
                                           and tt.stacid = 1
                                           and tt.trandt = '${batch_date}'
                                           and tt.assis5 in ('ACR', 'CAPT')))
              group by acctno) t22
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t22.acctno
 where t1.src_module_type_cd = 'GL' and substr(t1.prod_id, 1, 7) in ('4020101', '4020102')
   and t1.job_cd = 'ncbsf1'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_nostro_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_nostro_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_nostro_acct_info_ex purge;
-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_nostro_acct_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

