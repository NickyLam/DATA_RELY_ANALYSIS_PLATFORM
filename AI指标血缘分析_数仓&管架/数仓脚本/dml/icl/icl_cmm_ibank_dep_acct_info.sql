/*
purpose:    共性加工层-同业存放账户信息:包括同业存放定期存款和同业存放活期存款分户信息。数据主要来源于新核心系统和同业系统，其中同业存放定期的可提前支取信息取自于同业系统。
author:     sunline
usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_ibank_dep_acct_info

logs:       20201225	陈伟峰	新增模型							
            20211222	陈伟峰	新增字段【开户行行号、开户行名称】	
            20220418	翟若平	调整字段【储种代码】的取数口径（置空，新核心整合到标准产品）							
            20220501	翟若平	调整字段【存期天数、上次结息日期、下次结息日期、正常利率、逾期利率、部分提前支取剩余部分利率】的取数口径
            20220519	翟若平	调整字段【部分提前支取利率】的加工口径	
            20220606	温旺清	新增字段【标准产品编号】，调整T3的过滤条件【增加 T3.SIGN_AGT_STATUS_CD = 'A'】	
			      20220608  温旺清  修改【结息方式代码】加工口径
            20220610  李森辉  1、新增字段【存期期限类型代码】
                                2、调整字段【存期代码】的加工口径，新一代改造，不再作为代码
            20220726  温旺清	1、调整字段【账户状态代码】的加工口径
            20220729  徐子豪 1、原统计产品范围与新核心迁移范围不一致，增加保险机构产品。
            20220905  徐子豪 1、调整字段【部分提前支取利率】、【部分提前支取剩余部分利率】加工口径
            20230117  陈伟峰 调整tmp_cmm_ibank_dep_acct_info_01表加工逻辑
            20230706  翟若平 调整tmp_cmm_ibank_dep_acct_info_01表加工逻辑
            20240222  饶雅 新增字段【线上业务标志】
            20250723 陈伟峰 优化【可提前支取标志、最早可提前支取日期】取数逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_dep_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_dep_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create tmp table 
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_ibank_dep_acct_info_01 purge;
whenever sqlerror exit sql.sqlcode; 

create table ${icl_schema}.tmp_cmm_ibank_dep_acct_info_01
nologging
compress ${option_switch} for query high
as
select distinct
       nvl(d.sub_acct, b.sub_acct) as sub_acct,
       ext.h_combobox_02 as advd_draw_flg,
       to_date(trim(ext.h_datefield_02), 'yyyy-mm-dd') as earliest_drawbl_dt,
       ext.online_mark as onl_bus_flg
  from ${iml_schema}.evt_ibank_tran t--${iol_schema}.ibms_ttrd_otc_trade t
  left join ${iol_schema}.ibms_ttrd_otc_trade_ext ext
    on t.tran_num = ext.sysordid
  left join ${iol_schema}.ibms_ttrd_core_sub_acct_temp b
    on t.apv_odd_no=b.order_id
   and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_core_sub_acct_temphis d
    on t.apv_odd_no=d.order_id
   and d.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and d.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t.tran_type_id in ('0134101', '0176101')
   and t.tran_status_cd = '4'
   and t.stl_status_cd = '999'
   and t.dlvy_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t.job_cd ='ibmsi1'
   and nvl(d.sub_acct, b.sub_acct) is not null
;

-- 2.1 insert data to ex table
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_dep_acct_info_ex purge;
whenever sqlerror exit sql.sqlcode;  

create table ${icl_schema}.cmm_ibank_dep_acct_info_ex 
nologging
compress ${option_switch} for query high
as 
select * from ${icl_schema}.cmm_ibank_dep_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_dep_acct_info_ex(
   etl_dt                          -- 数据日期
   ,lp_id                          -- 法人编号
   ,acct_id                        -- 账户编号
   ,cust_acct_id                   -- 客户账户编号
   ,cust_sub_acct_num              -- 客户账户子户号
   ,open_bank_no                   -- 开户行行号
   ,open_bank_name                 -- 开户行名称
   ,cont_id                        -- 合约编号
   ,int_set_way_cd                 -- 结息方式代码
   ,int_accr_way_cd                -- 计息方式代码
   ,acct_status_cd                 -- 账户状态代码
   ,sav_type_cd                    -- 储种代码
   ,std_prod_id                    -- 标准产品编号
   ,dep_term                       -- 存期
   ,dep_term_tenor_type_cd         -- 存期期限类型代码
   ,dep_term_days                  -- 存期天数
   ,seg_int_accr_flg               -- 分段计息标志
   ,onl_bus_flg                    -- 线上业务标志
   ,last_int_set_dt                -- 上次结息日期
   ,next_int_set_dt                -- 下次结息日期
   ,exec_int_rat                   -- 执行利率
   ,nomal_int_rat                  -- 正常利率
   ,ovdue_int_rat                  -- 逾期利率
   ,part_unexp_draw_int_rat        -- 部分提前支取利率
   ,part_unexp_draw_surp_int_rat   -- 部分提前支取剩余部分利率
   ,advd_wdraw_flg                 -- 可提前支取标志
   ,earliest_advd_wdraw_dt         -- 最早可提前支取日期      
   ,job_cd                         -- 任务代码     
   ,etl_timestamp                  -- etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')         -- 数据日期
    ,t1.lp_id                                   -- 法人编号
    ,t1.acct_id                                 -- 账户编号
    ,t1.cust_acct_num                           -- 客户账户编号
    ,t1.sub_acct_num                            -- 客户账户子户号
    ,''                                         -- 开户行行号
    ,''                                         -- 开户行名称
    ,t3.sign_agt_id                             -- 合约编号
    ,case
       when t2.int_set_freq_cd in ('HY', 'YH','6M','M6') then '03'
       when substr(t2.int_set_freq_cd,1,1) = 'Y' then '04'
       when substr(t2.int_set_freq_cd,1,1) = 'Q' then '02'
       when substr(t2.int_set_freq_cd,1,1) = 'M' then '01'
       else '-'
     end as int_set_way_cd                      -- 结息方式代码
    ,t2.int_accr_way_cd                         -- 计息方式代码
    ,(case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
	          then t1.last_acct_status_cd 
		   else t1.acct_status_cd 
	  end) as acct_status_cd                    -- 账户状态代码
    ,''                                         -- 储种代码
	  ,t1.prod_id                                 -- 标准产品编号
    ,t1.dep_term                                -- 存期
    ,t1.tenor_type_cd                           -- 存期期限类型代码
    ,case when t1.core_acct_type_cd='C' then 0 else t1.exp_dt-t1.acct_init_open_acct_dt end       -- 存期天数
    ,decode(t2.int_rat_seg_flg, '1', '1', '0')  -- 分段计息标志
    ,decode(t10.onl_bus_flg, '是', '1', '否','0','')  -- 线上业务标志
    ,t2.last_int_set_dt                         -- 上次结息日期
    ,t2.next_int_set_dt                         -- 下次结息日期
    ,t2.exec_int_rat                            -- 执行利率
    ,t2.exec_int_rat                            -- 正常利率
    ,t4.exec_int_rat                            -- 逾期利率
    ,case when t5.deflt_int_rat=0 then t5.exec_int_rat else t5.deflt_int_rat end     -- 部分提前支取利率
    ,''                                         -- 部分提前支取剩余部分利率
    ,case when t1.core_acct_type_cd='C' then '1' else decode(t10.advd_draw_flg,'是','1','否','0','') end                        -- 可提前支取标志
    ,t10.earliest_drawbl_dt                     -- 最早可提前支取日期      
    ,t1.job_cd                                                       -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳    
   from ${iml_schema}.agt_dep_acct_info_h t1			-- 存款账户信息历史	
  left join ${iml_schema}.agt_dep_acct_int_dtl t2   -- 存款账户利息明细历史
    on t1.acct_id = t2.acct_id
   and t2.int_cls_cd = 'INT'        --利息分类:INT-正常利息 ODI-复利  PDUE-超期利息
   and t2.job_cd = 'ncbsi1'
   and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_dep_sign_agt_h t3  --存款签约协议历史
    on t1.acct_id = t3.agt_key
   and t3.agt_key_type_cd = 'IK'                --协议键类型:IK-INTERNAL_KEY  CN-CLIENT_NO
   and t3.sign_agt_status_cd = 'A'
   and not exists (select 1 from ${iol_schema}.ncbs_rb_agreement_txy txy 
                           where t3.sign_agt_id = txy.agreement_id 
                             and txy.main_agreement_id is not null)
   and t3.job_cd = 'ncbsf1'
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_dep_acct_int_dtl t4 --存款账户利息明细历史
  on t1.acct_id = t4.acct_id
  and t4.int_cls_cd = 'PDUE'         --利息分类:INT-正常利息 ODI-复利  PDUE-超期利息
  and t4.job_cd = 'ncbsi1'
  and t4.etl_dt = to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_dep_acct_int_dtl t5 --存款账户利息明细历史
  on t1.acct_id = t5.acct_id
  and t5.int_cls_cd = 'WYINT'         --利息分类:INT-正常利息 ODI-复利  PDUE-超期利息
  and t5.job_cd = 'ncbsi1'
  and t5.etl_dt = to_date('${batch_date}','yyyymmdd')   
  left join ${icl_schema}.tmp_cmm_ibank_dep_acct_info_01 t10
  on t1.cust_acct_num||'-'||t1.sub_acct_num = t10.sub_acct
 where substr(t1.prod_id, 1, 7) in ('4010101', '4010102','1030104','1030208')
  and t1.job_cd = 'ncbsf1'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_dep_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_dep_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_dep_acct_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_ibank_dep_acct_info_01 purge;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_ibank_dep_acct_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
	