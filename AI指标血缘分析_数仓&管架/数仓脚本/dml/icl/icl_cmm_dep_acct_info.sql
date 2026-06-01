/*
Purpose:    共性加工层-存款分户信息：包括所有的存款产品的账户基本信息、余额信息、利息计提信息等账户相关信息，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20291128 icl_cmm_dep_acct_info
CreateDate: 20220309
Logs:       20220309 李森辉 1、调整取数源，由旧核心系统调整到新核心系统取数
                            2、新增字段【虚拟账户标志、记账标志、母户标志】
            20220318 李森辉 1、新增字段【客户账户卡号、通存标志】
            20220331 李森辉 1、调整字段【开户OA审批单号、浮动利率标志、利率浮动方式代码、交易渠道状态代码、存款性质代码、基准利率类型代码、基准利率】的取数口径
                            2、置空字段【外部产品编号-EXT_PROD_ID、内部产品编号-INTNAL_PROD_ID、旧账户编号-OLD_ACCT_ID、工资账户标志-SAL_ACCT_FLG、预期最高收益率-EXPE_HIGT_YLD_RAT、最低余额-LOWT_BAL】
            20220408 李森辉 调整字段【折本币账户余额等相关折币字段的取数口径】
            20220418 李森辉 调整字段【储种代码】的取数口径（置空，新核心整合到标准产品）
            20220429 李森辉 1、置空字段【利率调整周期单位代码、利率调整周期频率】的取数口径
                            2、新增字段【核准件编号】
            20220429 李森辉 1、增加【T1-账户基本信息表】的过滤条件（t1.src_module_type_cd = 'RB'）
                            2、调整字段【科目编号、应付利息科目编号、利息支出科目编号、协定存款起存金额、不动户标志、保证金标志、协定存款标志、同业存款标志、网络存款标志、存款基本户标志】的加工口径
                            3、置空字段【应付利息调整科目编号、利息支出调整科目编号】
            20220607 李森辉 1、调整字段【旧账户编号】的取数口径
                            2、新增字段【旧客户账户子户号、转不动户日期】
            20220609 李森辉 1、新增字段【存期期限类型代码】
                            2、调整字段【存期】的加工口径，新一代调整，不再作为代码
            20220624 温旺清 1、调整字段【科目编号、应付利息科目编号、应付利息调整科目编号、利息支出科目编号、协定存款起存金额】的加工口径
            20220705 李森辉 1、调整协定存款标志口径：103010100001-单位活期存款  +  协议（RB_AGREEMENT_ACCORD-协定协议登记簿）
			      20220708 温旺清 1、调整字段【客户类型】的加工口径
            20220721 李森辉 1、调整字段：协定存款标志(删除条件：产品103010100001-单位活期存款)、上次结息日期、下次结息日期、当期余额、可用余额、折本币当期余额及相关积数字段】的加工口径
                            2、调整临时表T21的关联条件，增加【NVL(REPLACE(TRIM(T4.AMOUNT_NATURE), '0000', '*'), '*') = T21.ACCTI_PROD_ATTR_CD1】
		        20220726 温旺清 1、调整字段【存款账户状态代码、睡眠户标志、不动户标志、久悬户标志】的加工口径
		        20220802 翟若平 调整字段【客户账户卡号】的加工口径
		        20220726 温旺清 1、【存款分户信息】：新增字段【期次编号】
		        20220812 曹永茂 1、调整【标准产品编号】的加工口径
		        20220826 翟若平 调整字段【开户日期、开户时间、开户流水号、销户日期、销户时间、销户流水号、激活日期、开户柜员编号、销户柜员编号、开户机构编号、销户机构编号、开户金额】的加工口径
				    20220915 温旺清 调正临时表T5获取产品定义信息的产品状态代码
				    20221011 温旺清 置空字段【首次起息日期】
				    20221013 曹永茂 调整【自动转存标志、转存方式代码、协定存款起息日期、协定存款到期日期、协定存款解约日期】的取数口径，调整t12的过滤条件
				    20221017 曹永茂 1、调整【协定利率】的取数口径，调整t13的过滤条件
				                    2、调整tmp_cmm_dep_acct_info_01：1)新增限制类型‘AS、FT、SW、OW、HA’; 2)调整row_number的排序条件
				                    3、调整【取现标志】的取数口径
				    20220905 温旺清 1、新增字段【通兑机构编号】
		                        2、调整字段【科目编号、应付利息科目编号、当期应计利息、当期余额】的加工口径
                            3、新增置空字段【应付利息调整科目编号、利息支出科目编号、利息支出调整科目编号】
				    20220915 温旺清 新增字段【延期付息标志、延期付息天数】新一代置空
				    20221101 翟若平 调整字段【到期日期、协定存款到期日期、协定存款起息日期、最后动户日期】的加工口径
				    20221103 翟若平 调整字段【首次起息日期】的加工口径
				    20221104 曹永茂 调整字段【当日应计利息】的加工口径，加了对应的“利息调整金额”
				    20221121 曹永茂 调账字段【自动转存标志】的加工口径，保持和旧码值一致
				    20221201 曹永茂 置空【首次起息日期】，新核心在BUG_046547反馈无此信息项
				    20221213 温旺清 调账字段【自动转存标志】的加工口径，保持和旧码值一致
				    20221226 陈伟峰 调整【激活日期】加工逻辑，当为00010101时，取t19.actv_dt
				    20221226 陈伟峰 调整临时表tmp_cmm_dep_acct_info_01加工逻辑，核心新提供逻辑
				    20221227 陈伟峰 调整【协定存款起息日期】加工逻辑，使用valid_dt排序
            20221229 陈伟峰 调整acctno，做首位去0判断
            20230104 陈伟峰 调整【冻结金额】加工逻辑
            20230106 温旺清 调整临时表t8--agt_dep_acct_lmt_info_h 的取数逻辑。
            20230117 陈伟峰 调整【当日应计利息、当期应计利息、当日应计利息调整、当期应计利息调整】取数逻辑。
            20230201 翟若平 调整【起息日期】的加工逻辑
            20230207 陈伟峰 调整【工资账户标志】加工逻辑
            20230213 陈伟峰 调整主表范围，增加开户日期小于跑批日期限制
            20230320 陈伟峰 调整销户信息部分字段加工逻辑，增加账户状态判断
				    20230530 陈伟峰 调整agt_dep_sign_agt_h\agt_agree_dep_agt_h加工逻辑，使用sign_agt_status_cd='A'的数据
				    20230615 陈伟峰 调整tgls_loan_busi_h表取数逻辑，增加tgls_loan_busi表数据，用于支持年批
            20230628 徐子豪 调整【起息日期】加工逻辑，【获取基准利率信息】限制条件,调整【工资账户标志】中台网银代发统计逻辑
            20230724 陈伟峰 调整临时表tmp_cmm_dep_acct_info_04中活期利率的取值逻辑
            20240321 陈伟峰 调整【所属机构编号】取数逻辑，优先取核算中台
            20240523 饶雅   调整【基准利率】取数逻辑
            20240716 陈伟峰 调整ref_bank_int_ladr_h取数逻辑，使用invalid_dt >=跑批日期
	          20240926 陈伟峰 调整字段【协定存款起息日期、协定存款到期日期】取数逻辑，判断日期大于批量日期时，取上一生效日期和上一失效日期
	          20241025 陈伟峰 适配银联旅行通卡取数逻辑
	          20241122 陈伟峰 调整bdps_bail_account取数规则，增加row_number排序取一条
	          20241218 陈伟峰 调整利率加工逻辑，特殊判断当核心产品为101010100005时，指定利率类型为活期
              20240205 陈伟峰 调整协定利率-挂牌利率加工逻辑
			20250205 谢宁 调整【延期付息标志】【延期付息天数】【首次起息日期】字段取数逻辑
              20240319 陈伟峰 调整协定利率中默认值处理逻辑
			20250423 陈伟峰 处理利率阶梯表，去除金额维度
           20250516 陈伟峰 调整evt_dep_acct_oc_acct_rgst_b算法为全量流水
           20250728 陈伟峰 调整【开户时间、销户时间】加工逻辑
           20250825 陈伟峰 调整【当期应付利息调整】加工逻辑,增加核心已销户账户利息调整登记簿数据
           20250826 陈伟峰 调整【睡眠户标志】加工逻辑，对公账户不存在睡眠户，个人账户当账户状态为不动或者久悬时，则为睡眠户
           20251229 陈伟峰 新增字段【最后交易日期FINAL_TRAN_DT】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_acct_info drop partition p_${retain_date};
alter table ${icl_schema}.cmm_dep_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_04 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_05 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_06 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_07 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_08 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_09 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_10 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_11 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_p2p purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_12 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_13 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_14 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_15 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_16 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_17 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_info_18 purge;

-- 1.3 insert data to tmp table
-- 获取账户冻结信息（冻结标志、冻结日期、解冻日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_01
nologging
compress ${option_switch} for query high
as
select t1.acct_id  as acct_id                                                     -- 账户编号
       ,t1.tran_lmt_type_cd as tran_lmt_type_cd                                   -- 冻结标志
       ,t2.lmt_type_descb                                                         -- 限制类型描述
       ,t1.effect_dt as effect_dt                                                 -- 冻结日期
       ,t1.invalid_dt as invalid_dt                                               -- 解冻日期
       ,t1.acct_lmt_status_cd as acct_lmt_status_cd                               -- 账户限制状态代码
       ,t1.lmt_id  as lmt_id                                                      -- 限制编号
       ,t2.lmt_type_cate_cd                                                       -- 限制类型类别代码
       ,row_number() over(partition by t1.acct_id order by t1.effect_dt desc) as rn  -- 排序编号
  from ${iml_schema}.agt_dep_acct_lmt_info_h t1
 inner join ${iml_schema}.ref_acct_lmt_type_para t2
    on t1.tran_lmt_type_cd = t2.lmt_type_cd
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 where t1.acct_lmt_status_cd <> 'E'
   and t1.tran_lmt_type_cd = '005'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsf1'
;

-- 获取账户冻结止付金额信息（冻结金额、止付金额等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_02
nologging
compress ${option_switch} for query high
as
select t1.acct_id as acct_id                                                                                  -- 账户编号
--       ,sum(case when t2.lmt_type_cate_cd in ('FH', 'AH') then t1.tran_amt else 0 end) as froz_amt            -- 冻结金额
       ,sum(case when T1.tran_lmt_type_cd ='005' and T1.ct_froz_flg<>'1' then  t1.begin_amt else 0 end ) as froz_amt  -- 冻结金额
       ,sum(case when t2.lmt_type_cate_cd in ('DA', 'OW', 'SC') then t1.tran_amt else 0 end) as stop_pay_amt  -- 止付金额
  from ${iml_schema}.agt_dep_acct_lmt_info_h t1
  left join ${iml_schema}.ref_acct_lmt_type_para t2
    on t1.tran_lmt_type_cd = t2.lmt_type_cd
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 where t1.acct_lmt_status_cd ='A'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsf1'
 group by t1.acct_id
;

-- 获取渠道控制信息（交易渠道状态代码等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_03
nologging
compress ${option_switch} for query high
as
select t1.agt_id as agt_id                                                          -- 协议编号
       ,t1.ctrl_type_cd as ctrl_type_cd                                             -- 交易渠道状态代码
       ,row_number() over(partition by t1.agt_id order by t1.ova_flow_num desc) as rn  -- 排序编号
  from ${iml_schema}.agt_dep_acct_chn_lmt_info_h t1
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
;


--按机构层级获取账户机构
whenever sqlerror exit sql.sqlcode;

create table ${icl_schema}.tmp_cmm_dep_acct_info_16
nologging
compress ${option_switch} for query high
as
select t1.branch as curr_org_id  --当前机构
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

--临时处理利率阶梯表，去除金额维度
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_18
nologging
compress ${option_switch} for query high
as
select * from (
        select row_number() over(partition by bank_int_int_rat_type_cd,ped_freq_cd,curr_cd,org_id order by ladr_amt,effect_dt) as rn
                    ,t.*
          from ${iml_schema}.ref_bank_int_ladr_h t 
        where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
            and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
			and effect_dt <= to_date('${batch_date}', 'yyyymmdd')
            and invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
            and t.job_cd = 'ncbsf1')
  where rn=1;

-- 获取基准利率信息（基准利率类型代码、基准利率等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_04
nologging
compress ${option_switch} for query high
as
select ra.acct_id,
       ra.cust_acct_num,
       ra.sub_acct_num,
       ra.acct_name,
       ra.prod_id,
       raid.int_rat_type_cd,
       coalesce(mim1.ped_freq_cd,mim2.ped_freq_cd,mim3.ped_freq_cd) as ped_freq_cd,
       coalesce(mim1.base_rat_type_id,mim2.base_rat_type_id,mim3.base_rat_type_id) as base_rat_type_id,
       mib.base_rat_id,
       mib.base_rat_type_descb,
       mbr.base_rat,
       ra.curr_cd,
       ra.dep_term,
       ra.tenor_type_cd
  from ${iml_schema}.agt_dep_acct_info_h ra
  left join ${iml_schema}.agt_dep_acct_int_dtl raid
    on ra.acct_id = raid.acct_id
   and raid.int_cls_cd = 'INT'
   and raid.job_cd = 'ncbsi1'
   and raid.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_dep_acct_info_16 t1
    on ra.open_acct_org_id=t1.curr_org_id --账户机构关联到上一级，假如账户机构是支行，会关联到分行
  left join ${icl_schema}.tmp_cmm_dep_acct_info_16 t2
    on  t1.sup_org_id = t2.curr_org_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim1
    on raid.int_rat_type_cd = mim1.bank_int_int_rat_type_cd
   and ra.tenor_type_cd || ra.dep_term = mim1.ped_freq_cd
   and ra.curr_cd = mim1.curr_cd
   and ra.open_acct_org_id=mim1.org_id --支行机构
   and trim(mim1.base_rat_type_id) is not null
   and mim1.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim1.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim1.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim2
    on raid.int_rat_type_cd = mim2.bank_int_int_rat_type_cd
   and ra.tenor_type_cd || ra.dep_term = mim2.ped_freq_cd
   and ra.curr_cd = mim2.curr_cd
   and t1.sup_org_id=mim2.org_id --分行机构
   and trim(mim2.base_rat_type_id) is not null
   and mim2.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim2.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim2.job_cd = 'ncbsf1'
   left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim3
    on raid.int_rat_type_cd = mim3.bank_int_int_rat_type_cd
   and ra.tenor_type_cd || ra.dep_term = mim3.ped_freq_cd
   and ra.curr_cd = mim3.curr_cd
   and t2.sup_org_id=mim3.org_id
   and trim(mim3.base_rat_type_id) is not null
   and mim3.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim3.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim3.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_base_rat_type_para mib
    on coalesce(mim1.base_rat_type_id,mim2.base_rat_type_id,mim3.base_rat_type_id) = mib.base_rat_id
   and mib.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mib.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mib.job_cd = 'ncbsf1'
  left join (select base_rat_id,
                    curr_cd,
                    base_rat,
                    row_number() over(partition by base_rat_id, curr_cd order by effect_dt desc) rn
               from ${iml_schema}.ref_base_rat_h
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'ncbsf1'
                ) mbr
    on  mib.base_rat_id= mbr.base_rat_id
   and ra.curr_cd = mbr.curr_cd
   and mbr.rn = 1
 where ra.src_module_type_cd = 'RB'
/*   and (case
         when ra.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then
          ra.last_acct_status_cd
         else
          ra.acct_status_cd
       end) <> 'C' */
   and ra.int_accr_flg = '1'
   and trim(ra.tenor_type_cd) <> '-'
   and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and ra.job_cd = 'ncbsf1'
   and ra.prod_id <>'101010100005'
union all
select ra.acct_id,
       ra.cust_acct_num,
       ra.sub_acct_num,
       ra.acct_name,
       ra.prod_id,
       raid.int_rat_type_cd,
       coalesce(mim1.ped_freq_cd,mim2.ped_freq_cd,mim3.ped_freq_cd) as ped_freq_cd,
       coalesce(mim1.base_rat_type_id,mim2.base_rat_type_id,mim3.base_rat_type_id) as base_rat_type_id,
       mib.base_rat_id,
       mib.base_rat_type_descb,
       mbr.base_rat,
       ra.curr_cd,
       ra.dep_term,
       ra.tenor_type_cd
  from ${iml_schema}.agt_dep_acct_info_h ra
  left join ${iml_schema}.agt_dep_acct_int_dtl raid
    on ra.acct_id = raid.acct_id
   and raid.int_cls_cd = 'INT'
   and raid.job_cd = 'ncbsi1'
   and raid.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_dep_acct_info_16 t1
    on ra.open_acct_org_id=t1.curr_org_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_16 t2
    on t1.sup_org_id=t2.curr_org_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim1
    on raid.int_rat_type_cd = mim1.bank_int_int_rat_type_cd
--   and ra.tenor_type_cd || ra.dep_term = mim.ped_freq_cd
   and ra.curr_cd = mim1.curr_cd
   and ra.open_acct_org_id=mim1.org_id --支行机构
   and trim(mim1.ped_freq_cd)='-'
   and mim1.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim1.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   AND mim1.job_cd = 'ncbsf1'
   left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim2
    on raid.int_rat_type_cd = mim2.bank_int_int_rat_type_cd
--   and ra.tenor_type_cd || ra.dep_term = mim.ped_freq_cd
   and ra.curr_cd = mim2.curr_cd
   and t1.sup_org_id=mim2.org_id --分行机构
   and trim(mim2.ped_freq_cd)='-'
   and mim2.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim2.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim2.job_cd = 'ncbsf1'
   left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim3
    on raid.int_rat_type_cd = mim3.bank_int_int_rat_type_cd
--   and ra.tenor_type_cd || ra.dep_term = mim.ped_freq_cd
   and ra.curr_cd = mim3.curr_cd
   and t2.sup_org_id=mim3.org_id --总行机构
   and trim(mim3.ped_freq_cd)='-'
   and mim3.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim3.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim3.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_base_rat_type_para mib
    on coalesce(mim1.base_rat_type_id,mim2.base_rat_type_id,mim3.base_rat_type_id) = mib.base_rat_id
   and mib.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mib.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mib.job_cd = 'ncbsf1'
  left join (select base_rat_id,
                    curr_cd,
                    base_rat,
                    row_number() over(partition by base_rat_id, curr_cd order by effect_dt desc) rn
               from ${iml_schema}.ref_base_rat_h
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'ncbsf1'
                ) mbr
    on mib.base_rat_id= mbr.base_rat_id
   and ra.curr_cd = mbr.curr_cd
   and mbr.rn = 1
 where ra.src_module_type_cd = 'RB'
/*   and (case
         when ra.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then
          ra.last_acct_status_cd
         else
          ra.acct_status_cd
       end) <> 'C' */
   and ra.int_accr_flg = '1'
   and trim(ra.tenor_type_cd) = '-'
   and raid.int_rat_type_cd <> 'XYD'
   and ra.prod_id not in ( '401010200001','101010100005')
   and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and ra.job_cd = 'ncbsf1'
union all
select ra.acct_id,
       ra.cust_acct_num,
       ra.sub_acct_num,
       ra.acct_name,
       ra.prod_id,
       raid.int_rat_type_cd,
       coalesce(mim1.ped_freq_cd,mim2.ped_freq_cd,mim3.ped_freq_cd) as ped_freq_cd,
       coalesce(mim1.base_rat_type_id,mim2.base_rat_type_id,mim3.base_rat_type_id) as base_rat_type_id,
       mib.base_rat_id,
       mib.base_rat_type_descb,
       mbr.base_rat,
       ra.curr_cd,
       ra.dep_term,
       ra.tenor_type_cd
  from ${iml_schema}.agt_dep_acct_info_h ra
  left join ${iml_schema}.agt_dep_acct_int_dtl raid
    on ra.acct_id = raid.acct_id
   and raid.int_cls_cd = 'INT'
   and raid.job_cd = 'ncbsi1'
   and raid.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_dep_acct_info_16 t1
    on ra.open_acct_org_id=t1.curr_org_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_16 t2
    on t1.sup_org_id=t2.curr_org_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim1
    on raid.int_rat_type_cd = mim1.bank_int_int_rat_type_cd
--   and ra.tenor_type_cd || ra.dep_term = mim.ped_freq_cd
   and ra.curr_cd = mim1.curr_cd
   and ra.open_acct_org_id=mim1.org_id --支行机构
   and trim(mim1.ped_freq_cd)='-'
   and mim1.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim1.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   AND mim1.job_cd = 'ncbsf1'
   and mim1.base_rat_type_id <>'2122'
   left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim2
    on raid.int_rat_type_cd = mim2.bank_int_int_rat_type_cd
--   and ra.tenor_type_cd || ra.dep_term = mim.ped_freq_cd
   and ra.curr_cd = mim2.curr_cd
   and t1.sup_org_id=mim2.org_id --分行机构
   and trim(mim2.ped_freq_cd)='-'
   and mim2.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim2.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim2.job_cd = 'ncbsf1'
   and mim2.base_rat_type_id <>'2122'
   left join ${icl_schema}.tmp_cmm_dep_acct_info_18 mim3
    on raid.int_rat_type_cd = mim3.bank_int_int_rat_type_cd
--   and ra.tenor_type_cd || ra.dep_term = mim.ped_freq_cd
   and ra.curr_cd = mim3.curr_cd
   and t2.sup_org_id=mim3.org_id --总行机构
   and trim(mim3.ped_freq_cd)='-'
   and mim3.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim3.invalid_dt >= to_date('${batch_date}', 'yyyymmdd')
   and mim3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mim3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mim3.job_cd = 'ncbsf1'
   and mim3.base_rat_type_id <>'2122'
  left join ${iml_schema}.ref_base_rat_type_para mib
    on coalesce(mim1.base_rat_type_id,mim2.base_rat_type_id,mim3.base_rat_type_id) = mib.base_rat_id
   and mib.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mib.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and mib.job_cd = 'ncbsf1'
  left join (select base_rat_id,
                    curr_cd,
                    base_rat,
                    row_number() over(partition by base_rat_id, curr_cd order by effect_dt desc) rn
               from ${iml_schema}.ref_base_rat_h
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'ncbsf1'
                ) mbr
    on mib.base_rat_id= mbr.base_rat_id
   and ra.curr_cd = mbr.curr_cd
   and mbr.rn = 1
 where ra.src_module_type_cd = 'RB'
/*   and (case
         when ra.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then
          ra.last_acct_status_cd
         else
          ra.acct_status_cd
       end) <> 'C' */
   and ra.int_accr_flg = '1'
   and trim(ra.tenor_type_cd) = '-'
   and raid.int_rat_type_cd <> 'XYD'
   and ra.prod_id ='101010100005'
   and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and ra.job_cd = 'ncbsf1'
;
commit;

-- 获取产品定义信息（保证金标志等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_05
nologging
compress ${option_switch} for query high
as
select prod_id
       ,max(decode(attr_key, 'ACCT_NATURE', attr_val, '')) as acct_nature_value
  from (select t1.prod_id
               ,t1.attr_key
               ,t1.attr_val
               ,t1.seq_num
               ,row_number() over(partition by t1.prod_id, t1.attr_key order by t1.seq_num desc) rn
          from ${iml_schema}.prd_prod_def_h t1
         where t1.prod_status_cd = '1'
           and t1.attr_key in ('ACCT_NATURE')
           and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
           and t1.end_dt > to_date('${batch_date}','yyyymmdd')
           and t1.job_cd = 'ncbsf1')
 group by prod_id
;

-- 取开户流水
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_06
nologging
compress ${option_switch} for query high
as
select t1.*,row_number() over(partition by t1.acct_id order by t1.flow_num desc, t1.bus_flow_num desc) rn
from (
select t.*, t1.tran_amt,t1.bus_flow_num
       --row_number() over(partition by t.acct_id order by t.flow_num desc, t1.bus_flow_num desc) rn
  from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b t
  left join ${iml_schema}.evt_dep_fin_tran_flow t1
    on t.tran_ref_no = t1.tran_ref_no
   --and t.acct_id = t1.acct_id
   and t1.job_cd = 'ncbsi1'
   and t1.tran_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.revs_flg = '0'
  left join ${iml_schema}.agt_dep_acct_info_h t2
    on t.acct_id = t2.acct_id
   and t2.src_module_type_cd = 'RB'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 where t.job_cd = 'ncbsi1'
   and t.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t.oc_acct_rgst_type_cd = '1'
   and t2.prod_id not in ('101020300001','103020300001')
--   and t2.core_acct_type_cd <> 'C'
 union all
select t.*, t1.tran_amt,t1.bus_flow_num
      -- row_number() over(partition by t.acct_id order by t.flow_num desc, t1.bus_flow_num desc) rn
  from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b t
  left join ${iml_schema}.evt_dep_fin_tran_flow t1
    on t.tran_ref_no = t1.tran_ref_no
   and t.acct_id = t1.acct_id
   and t1.job_cd = 'ncbsi1'
   and t1.tran_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.revs_flg = '0'
 where t.job_cd = 'ncbsi1'
   and t.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t.oc_acct_rgst_type_cd = '1'
   and t.prod_id in ('101020300001','103020300001')
   ) t1
;
commit;

-- 取销户流水
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_07
nologging
compress ${option_switch} for query high
as
select t.*,
       row_number() over(partition by t.acct_id order by t.tran_ref_no desc) rn
  from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b t
 where t.job_cd = 'ncbsi1'
   and t.tran_dt <= to_date('${batch_date}','yyyymmdd')
   --and t.tran_dt = to_date('${batch_date}','yyyymmdd')
   and t.oc_acct_rgst_type_cd = '2'
;
commit;

-- 取上一天的存款账户信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_08
nologging
compress ${option_switch} for query high
as
select da.acct_id,
       da.cust_acct_id,
       da.cust_acct_sub_acct_num,
       da.cust_id,
       da.subj_id,
       da.cds_liab_acct_num,
       da.int_paybl_subj_id,
       da.open_acct_dt,
       da.open_acct_tm,
       da.open_flow_num,
       da.open_acct_teller_id,
       da.open_acct_org_id,
       da.clos_acct_dt,
       da.clos_acct_tm,
       da.clos_flow_num,
       da.clos_acct_teller_id,
       da.close_acct_org_id,
       da.actv_dt,
       da.open_acct_amt,
       da.corp_supv_acct_flg,
       da.currt_bal,
       da.cl_curr_currt_bal,
       da.ear_d_bal,
       da.ear_m_bal,
       da.ear_s_bal,
       da.ear_y_bal,
       da.y_acm_bal,
       da.s_acm_bal,
       da.m_acm_bal,
       da.cl_curr_ear_d_bal,
       da.cl_curr_ear_m_bal,
       da.cl_curr_ear_s_bal,
       da.cl_curr_ear_y_bal,
       da.cl_curr_y_acm_bal,
       da.cl_curr_ear_d_y_acm_bal,
       da.cl_curr_ear_m_y_acm_bal,
       da.cl_curr_ear_s_y_acm_bal,
       da.cl_curr_ear_y_y_acm_bal,
       da.cl_curr_s_acm_bal,
       da.cl_curr_ear_d_s_acm_bal,
       da.cl_curr_ear_s_s_acm_bal,
       da.cl_curr_ear_y_s_acm_bal,
       da.cl_curr_m_acm_bal,
       da.cl_curr_ear_d_m_acm_bal,
       da.cl_curr_ear_m_m_acm_bal,
       da.cl_curr_ear_y_m_acm_bal,
       da.y_avg_bal,
       da.q_avg_bal,
       da.m_avg_bal,
       da.cl_curr_y_avg_bal,
       da.cl_curr_q_avg_bal,
       da.cl_curr_m_avg_bal
  from ${icl_schema}.cmm_dep_acct_info da
 where da.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
union all
select to_char(mp.internal_key) as acct_id,
       ea.cust_acct_id,
       ea.cust_sub_acct_num as cust_acct_sub_acct_num,
       ea.cust_id,
       ea.subj_id,
       ea.liab_acct_id as cds_liab_acct_num,
       ea.int_paybl_subj_id,
       ea.open_acct_dt,
       ea.open_acct_tm,
       '' as open_flow_num,
       ea.open_acct_teller_id,
       ea.open_acct_org_id,
       ea.clos_acct_dt,
       ea.clos_acct_tm,
       '' as clos_flow_num,
       ea.clos_acct_teller_id,
       ea.close_acct_org_id,
       ea.actv_dt,
       ea.open_amt as open_acct_amt,
       '0' as corp_supv_acct_flg,
       ea.currt_bal,
       ea.cl_curr_currt_bal,
       ea.ear_d_bal,
       ea.ear_m_bal,
       ea.ear_s_bal,
       ea.ear_y_bal,
       ea.y_acm_bal,
       ea.s_acm_bal,
       ea.m_acm_bal,
       ea.cl_curr_ear_d_bal,
       ea.cl_curr_ear_m_bal,
       ea.cl_curr_ear_s_bal,
       ea.cl_curr_ear_y_bal,
       ea.cl_curr_y_acm_bal,
       ea.cl_curr_ear_d_y_acm_bal,
       ea.cl_curr_ear_m_y_acm_bal,
       ea.cl_curr_ear_s_y_acm_bal,
       ea.cl_curr_ear_y_y_acm_bal,
       ea.cl_curr_s_acm_bal,
       ea.cl_curr_ear_d_s_acm_bal,
       ea.cl_curr_ear_s_s_acm_bal,
       ea.cl_curr_ear_y_s_acm_bal,
       ea.cl_curr_m_acm_bal,
       ea.cl_curr_ear_d_m_acm_bal,
       ea.cl_curr_ear_m_m_acm_bal,
       ea.cl_curr_ear_y_m_acm_bal,
       ea.y_avg_bal,
       ea.q_avg_bal,
       ea.m_avg_bal,
       ea.cl_curr_y_avg_bal,
       ea.cl_curr_q_avg_bal,
       ea.cl_curr_m_avg_bal
  from ${icl_schema}.cmm_e_acct_info ea
  left join ${iol_schema}.ncbs_new_old_seq_no mp
    on ea.acct_id = mp.acct_id
 where ea.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
;
commit;

/*
-- 获取协定存款协议信息（起息日期、到期日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_09
nologging
compress ${option_switch} for query high
as
select t.agt_id
      ,t.sign_agt_id
      ,t.sign_org_id
      ,t.agt_key
      ,t.valid_dt
      ,t.invalid_dt
      ,t.rels_dt
      ,t.sign_agt_status_cd
      ,row_number() over(partition by t.agt_key, sign_agt_type_cd, agt_key_type_cd order by t.valid_dt desc) as rn
  from ${iml_schema}.agt_dep_sign_agt_h t
 where t.sign_agt_type_cd = 'ACC'
   and t.agt_key_type_cd = 'IK'
   and t.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t.end_dt > to_date('${batch_date}','yyyymmdd')
   and t.job_cd = 'ncbsf1'
   and t.sign_agt_status_cd='A'
;
commit;
*/
-- 获取P2P账户协议（起息日期、到期日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_p2p
nologging
compress ${option_switch} for query high
as
select t.agt_id
      ,t.sign_agt_id
      ,t.sign_org_id
      ,t.agt_key
      ,t.valid_dt
      ,t.invalid_dt
      ,t.rels_dt
      ,t.sign_agt_status_cd
      ,row_number() over(partition by t.agt_key, sign_agt_type_cd, agt_key_type_cd order by t.invalid_dt desc) as rn
  from ${iml_schema}.agt_dep_sign_agt_h t
 where t.sign_agt_type_cd = 'P2P'
   and t.agt_key_type_cd = 'IK'
   and t.sign_agt_status_cd = 'A'
   and t.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t.end_dt > to_date('${batch_date}','yyyymmdd')
   and t.job_cd = 'ncbsf1'
;
commit;

--获取产品科目信息配置表
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_11
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
/*
create table ${icl_schema}.tmp_cmm_dep_acct_info_10
nologging
compress ${option_switch} for query high
as
select case when substr(gdb.acctno,1,1)='0' then substr(gdb.acctno,2) else gdb.acctno end as acctno,
       gdb.assis1 as prod_type,
	     mp.subj_id,
	     sum(nvl(gdb.captal, 0)) as acct_bal,
	     gdb.trprcd,
	     gdb.brchcd
  from ${iol_schema}.tgls_glb_dept_book gdb
 inner join ${iol_schema}.ncbs_rb_acct ra
    on gdb.acctno = ra.base_acct_no || '_' || ra.acct_seq_no
   and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_rb_acct_attach raa
    on ra.internal_key = raa.internal_key
   and raa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and raa.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_dep_acct_info_11 mp
    on gdb.assis1 = mp.sellbl_prod_id
   and gdb.trprcd = mp.amt_type_cd
   and mp.bus_type_cd = 'NCBS'
   and mp.prod_attr_cd = decode(substr(gdb.assis1, 1, 1), '4', raa.amount_nature, '*')  --modify by wwq at 2022/9/5 20:30
 where gdb.acctdt = '${batch_date}'
   and gdb.acctno is not null
 group by case when substr(gdb.acctno,1,1)='0' then substr(gdb.acctno,2) else gdb.acctno end , gdb.assis1, mp.subj_id, gdb.trprcd,gdb.brchcd;
commit;
*/
create table ${icl_schema}.tmp_cmm_dep_acct_info_10
nologging
compress ${option_switch} for query high
as
select ra.internal_key,
       ra.base_acct_no,
       ra.acct_seq_no,
       mp.subj_id,
       sum(coalesce(gdb.captal,-t1.total_amount_prev,0)) as acct_bal,
       nvl(gdb.trprcd,'BAL') as trprcd,
       gdb.brchcd
  from ${iol_schema}.ncbs_rb_acct ra
  left join ${iol_schema}.tgls_glb_dept_book gdb
    on gdb.acctno = ra.base_acct_no || '_' || ra.acct_seq_no
   and gdb.acctdt = '${batch_date}'
   and gdb.acctno is not null
  left join ${iol_schema}.ncbs_rb_acct_attach raa
    on ra.internal_key = raa.internal_key
   and raa.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and raa.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_rb_acct_balance t1
    on ra.internal_key = t1.internal_key
   and T1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and T1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_dep_acct_info_11 mp
    on gdb.assis1 = mp.sellbl_prod_id
   and gdb.trprcd = mp.amt_type_cd
   and mp.bus_type_cd = 'NCBS'
   and mp.prod_attr_cd = decode(substr(gdb.assis1, 1, 1), '4', raa.amount_nature, '*')  --modify by wwq at 2022/9/5 20:30
 where ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
--   and ra.BASE_ACCT_NO LIKE '%610000003281%'
 group by ra.internal_key, mp.subj_id, gdb.trprcd,gdb.brchcd,ra.base_acct_no,ra.acct_seq_no;



-- 获取存款当日利息支出
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_info_12
nologging
compress ${option_switch} for query high
as
select case when substr(acctno,1,1)='0' then substr(acctno,2) else acctno end as acctno,            -- 核心借据号
       sum(tranam) as td_int_expns  -- 利息支出
  from (select acctno,tranam
          from ${iol_schema}.tgls_loan_busi_h t1
         where etl_dt = to_date('${batch_date}', 'yyyymmdd')
           and trandt = '${batch_date}'
           and status = '1'
           and assis5 in ('ACR'/*, 'CAPT'*/)
         union all
        select acctno,tranam
          from ${iol_schema}.tgls_loan_busi t1
         where etl_dt = to_date('${batch_date}', 'yyyymmdd')
           and trandt = '${batch_date}'
           and status = '1'
           and t1.stacid = 2
           and assis5 in ('ACR'/*, 'CAPT'*/)
           and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt
                            where tt.transq=t1.transq
                              and tt.trandt=t1.trandt
                              and tt.bsnssq=t1.bsnssq
                              and tt.serino=t1.serino
                              and tt.stacid = 1
                              and tt.trandt = '${batch_date}'
                              and tt.assis5 in ('ACR'/*, 'CAPT'*/)))
 group by case when substr(acctno,1,1)='0' then substr(acctno,2) else acctno end
;

-- 获取工资账户数据
create table ${icl_schema}.tmp_cmm_dep_acct_info_13 as (
select distinct(acctno) from (
Select distinct acctno as acctno
  from ${iol_schema}.mpcs_a60projdf_sign
 where projtp='05' --只取代发的签约
   and start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and end_dt >to_date('${batch_date}', 'yyyymmdd')
 union
select distinct acctno as acctno
  from ${iol_schema}.mpcs_a60projdf_sign_detail t1
  left join ${iol_schema}.mpcs_a60projdf_sign_summary t2
    on t1.summsq = t2.summsq
   and t1.trandt = t2.bachdt
 where t2.projtp = '05'
   and t2.transt not in ('0','1')
   and (respcd is null or respcd= '000000') --柜面代发代扣明细表只取代发成功的记录
   and ${iml_schema}.timeformat_min(t1.trandt) <=to_date('${batch_date}', 'yyyymmdd')
 union
select distinct d1.payacctno as acctno
  from ${iol_schema}.mpcs_a01tbatdetail d1 --网银代发明细表只取行内代发成功的记录
  left join ${iol_schema}.mpcs_a01tbatmanage d2
    on d1.batchdt = d2.batchdt
   and d1.batchno = d2.batchno
 where d2.Crossflag <> '1'
   and d1.rspcd in ('cmd0000','000000')
   and ${iml_schema}.timeformat_min(d1.fntdt) <=to_date('${batch_date}', 'yyyymmdd'))
   )
;

-- 获取工资账户数据-2
create table ${icl_schema}.tmp_cmm_dep_acct_info_14 as
select distinct acct_id from (
select t1.acct_id
  from ${iml_schema}.agt_dep_acct_info_h t1
  left join ${iml_schema}.agt_corp_stl_card_rela_info_h t3
    on t1.cust_acct_num = t3.cust_acct_num
   and t1.sub_acct_num = t3.acct_num_sub_acct_num
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'
   and (t3.card_stop_use_flg = '0' or t3.deflt_acct_num_flg = '1')
   and trim(t3.main_card_card_no) is null
 inner join ${icl_schema}.tmp_cmm_dep_acct_info_13 t2
    on nvl(t1.card_no,t3.card_no) =t2.acctno
 where t1.src_module_type_cd = 'RB'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
 union all
select t1.acct_id
  from ${iml_schema}.agt_dep_acct_info_h t1
 inner join ${icl_schema}.tmp_cmm_dep_acct_info_13 t2
    on t1.cust_acct_num =t2.acctno
 where t1.src_module_type_cd = 'RB'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1')
   ;


-- 获取挂牌利率用于加工协定利率
create table ${icl_schema}.tmp_cmm_dep_acct_info_15 as
select a1.org_id,a1.float_point,a2.base_rat 
  from (select a.org_id ,a.base_rat_type_id,a.curr_cd,a.float_point,a.float_ratio from ${iml_schema}.ref_bank_int_ladr_h a 
         where effect_dt in ( select max(effect_dt) from ${iml_schema}.ref_bank_int_ladr_h t where t.bank_int_int_rat_type_cd='XD1' and ladr_amt=50000 and org_id ='800001' and t.start_dt <=to_date('${batch_date}','yyyymmdd') and t.end_dt >to_date('${batch_date}','yyyymmdd')) 
           and bank_int_int_rat_type_cd='XD1' and ladr_amt=50000 and org_id ='800001'
           and a.start_dt <=to_date('${batch_date}','yyyymmdd') and a.end_dt >to_date('${batch_date}','yyyymmdd')) a1
      ,(select b.base_rat_id,b.curr_cd,b.base_rat from ${iml_schema}.ref_base_rat_h b  
         where effect_dt in ( select max(effect_dt) from ${iml_schema}.ref_base_rat_h t where t.base_rat_id='2140' and t.start_dt <=to_date('${batch_date}','yyyymmdd') and t.end_dt >to_date('${batch_date}','yyyymmdd') ) 
           and base_rat_id='2140' and b.start_dt <=to_date('${batch_date}','yyyymmdd') and b.end_dt >to_date('${batch_date}','yyyymmdd') ) a2  
 where a1.base_rat_type_id=a2.base_rat_id and a1.curr_cd=a2.curr_cd
  ;

-- 延期复息天数
create table ${icl_schema}.tmp_cmm_dep_acct_info_17 as
select t1.acct_id,
       (t1.next_int_set_day - t2.next_int_set_dt) as delay_int_days
  from ${iml_schema}.agt_delay_pay_int_info_h t1
  left join ${iml_schema}.agt_dep_acct_int_dtl t2
    on t1.acct_id = t2.acct_id
   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t2.int_cls_cd = 'INT'
 where t1.status_cd = 'A'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  ;


-- 2.1 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_acct_info_ex purge;

-- 2.2 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_dep_acct_info where 0 = 1;

insert /*+ append */ into ${icl_schema}.cmm_dep_acct_info_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,acct_id                     -- 账户编号
       ,acct_name                   -- 账户名称
       ,cust_acct_id                -- 客户账户编号
       ,cust_acct_sub_acct_num      -- 客户账户子户号
       ,cds_liab_acct_num           -- 负债账户编号
       ,old_acct_id                 -- 旧账户编号
       ,old_cust_acct_sub_acct_num  -- 旧客户账户子户号
       ,cust_acct_card_no           -- 客户账户卡号
       ,cust_id                     -- 客户编号
       ,subj_id                     -- 科目编号
       ,int_paybl_subj_id           -- 应付利息科目编号
       ,int_paybl_adj_subj_id       -- 应付利息调整科目编号
       ,int_expns_subj_id           -- 利息支出科目编号
       ,int_expns_adj_subj_id       -- 利息支出调整科目编号
       ,dep_kind_cd                 -- 储种代码
       ,acct_cls_cd                 -- 账户分类代码
       ,acct_type_cd                -- 账户类型代码
       ,acct_attr_cd                -- 账户属性代码
       ,dep_term                    -- 存期
       ,dep_term_tenor_type_cd      -- 存期期限类型代码
       ,std_prod_id                 -- 标准产品编号
       ,ext_prod_id                 -- 外部产品编号
       ,intnal_prod_id              -- 内部产品编号
	     ,pd_id                       -- 期次编号
       ,open_oa_apv_form_num        -- 开户OA审批单号
       ,approval_id                 -- 核准件编号
       ,dep_acct_status_cd          -- 存款账户状态代码
       ,cust_type_cd                -- 客户类型代码
       ,corp_acct_flg               -- 对公账户标志
       ,stop_pay_status_cd          -- 止付状态代码
       ,general_exch_flg            -- 通兑标志
	     ,general_exch_org_id         -- 通兑机构编号
       ,general_storage_flg         -- 通存标志
       ,advise_dep_flg              -- 通知存款标志
       ,agt_dep_flg                 -- 协议存款标志
       ,float_int_rat_flg           -- 浮动利率标志
       ,int_rat_float_way_cd        -- 利率浮动方式代码
       ,int_rat_adj_ped_corp_cd     -- 利率调整周期单位代码
       ,int_rat_adj_ped_freq        -- 利率调整周期频率
       ,corp_supv_acct_flg          -- 对公监管户标志
       ,rc_flg                      -- 定活标志
       ,margin_flg                  -- 保证金标志
       ,bill_pool_margin_flg        -- 票据池保证金标志
       ,bill_pool_type_cd           -- 票据池类型代码
       ,agree_dep_flg               -- 协定存款标志
       ,ibank_dep_flg               -- 同业存款标志
       ,web_dep_flg                 -- 网络存款标志
       ,dep_basic_acct_flg          -- 存款基本户标志
       ,ec_flg                      -- 钞汇标志
       ,privavy_acct_flg            -- 隐私账户标志
       ,legal_acct_flg              -- 涉案账户标志
       ,auto_redt_flg               -- 自动转存标志
       ,redted_cnt                  -- 已转存次数
       ,itg_dep_earliest_drawbl_dt  -- 智能存款最早可提支日期
       ,sleep_acct_flg              -- 睡眠户标志
       ,dormt_acct_flg              -- 不动户标志
       ,long_hang_acct_flg          -- 久悬户标志
       ,vtual_acct_flg              -- 虚拟账户标志
       ,entry_flg                   -- 记账标志
       ,mater_acct_flg              -- 母户标志
       ,sal_acct_flg                -- 工资账户标志
       ,froz_flg                    -- 冻结标志
       ,advd_draw_flg               -- 可提前支取标志
       ,tranbl_flg                  -- 可转让标志
	     ,delay_pay_int_flg           -- 延期付息标志
       ,delay_pay_int_days          -- 延期付息天数
       ,int_accr_base_cd            -- 计息基准代码
       ,int_accr_flg                -- 计息标志
       ,cash_flg                    -- 取现标志
       ,int_set_way_cd              -- 结息方式代码
       ,int_accr_way_cd             -- 计息方式代码
       ,allow_od_flg                -- 允许透支标志
       ,curr_cd                     -- 币种代码
       ,redt_way_cd                 -- 转存方式代码
       ,open_acct_chn_type_cd       -- 开户渠道类型代码
       ,tran_chn_status_cd          -- 交易渠道状态代码
       ,acct_usage_cd               -- 账户用途代码
       ,dep_char_cd                 -- 存款性质代码
       ,open_acct_dt                -- 开户日期
       ,open_acct_tm                -- 开户时间
       ,open_flow_num               -- 开户流水号
       ,clos_acct_dt                -- 销户日期
       ,clos_acct_tm                -- 销户时间
       ,clos_flow_num               -- 销户流水号
       ,actv_dt                     -- 激活日期
       ,value_dt                    -- 起息日期
       ,exp_dt                      -- 到期日期
       ,turn_dormt_acct_dt          -- 转不动户日期
       ,final_activ_acct_dt         -- 最后动户日期
       ,final_tran_dt               -- 最后交易日期
       ,agree_dep_value_dt          -- 协定存款起息日期
       ,agree_dep_exp_dt            -- 协定存款到期日期
       ,agree_dep_rels_dt           -- 协定存款解约日期
       ,agt_dep_earliest_drawbl_dt  -- 协议存款最早可提支日期
       ,froz_dt                     -- 冻结日期
       ,unfrz_dt                    -- 解冻日期
       ,last_int_set_dt             -- 上次结息日期
       ,next_int_set_dt             -- 下次结息日期
       ,fir_value_dt                -- 首次起息日期
       ,agree_int_rat               -- 协定利率
       ,base_rat_type_cd            -- 基准利率类型代码
       ,base_rat                    -- 基准利率
       ,exec_int_rat                -- 执行利率
       ,over_term_exec_int_rat      -- 超期执行利率
       ,td_acru_int                 -- 当日应计利息
       ,currt_acru_int              -- 当期应计利息
       ,currt_int_paybl_adj         -- 当期应付利息调整
       ,td_int_expns                -- 当日利息支出
       ,td_int_expns_adj            -- 当日利息支出调整
       ,cust_mgr_id                 -- 客户经理编号
       ,open_acct_teller_id         -- 开户柜员编号
       ,clos_acct_teller_id         -- 销户柜员编号
       ,open_acct_org_id            -- 开户机构编号
       ,close_acct_org_id           -- 销户机构编号
       ,belong_org_id               -- 所属机构编号
       ,loc_flg                     -- 开立存款证实书标志
       ,expe_higt_yld_rat           -- 预期最高收益率
       ,agree_dep_init_amt          -- 协定存款起存金额
       ,lowt_bal                    -- 最低余额
       ,open_acct_amt               -- 开户金额
       ,currt_bal                   -- 当期余额
       ,aval_bal                    -- 可用余额
       ,froz_amt                    -- 冻结金额
       ,stop_pay_amt                -- 止付金额
       ,cl_curr_currt_bal           -- 折本币当期余额
       ,ear_d_bal                   -- 日初余额
       ,ear_m_bal                   -- 月初余额
       ,ear_s_bal                   -- 季初余额
       ,ear_y_bal                   -- 年初余额
       ,y_acm_bal                   -- 年累计余额
       ,s_acm_bal                   -- 季累计余额
       ,m_acm_bal                   -- 月累计余额
       ,cl_curr_ear_d_bal           -- 折本币日初余额
       ,cl_curr_ear_m_bal           -- 折本币月初余额
       ,cl_curr_ear_s_bal           -- 折本币季初余额
       ,cl_curr_ear_y_bal           -- 折本币年初余额
       ,cl_curr_y_acm_bal           -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal     -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal     -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal     -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal     -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal           -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal     -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal     -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal     -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal           -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal     -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal     -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal     -- 折本币年初月累计余额
       ,y_avg_bal                   -- 年日均余额
       ,q_avg_bal                   -- 季日均余额
       ,m_avg_bal                   -- 月日均余额
       ,cl_curr_y_avg_bal           -- 折本币年日均余额
       ,cl_curr_q_avg_bal           -- 折本币季日均余额
       ,cl_curr_m_avg_bal           -- 折本币月日均余额
       ,job_cd                      -- 任务代码
       ,etl_timestamp               -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                          -- 数据日期
       ,t1.lp_id                                                                    -- 法人编号
       ,t1.acct_id                                                                  -- 账户编号
       ,t1.acct_name                                                                -- 账户名称
       ,t1.cust_acct_num                                                            -- 客户账户编号
       ,t1.sub_acct_num                                                             -- 客户账户子户号
       ,t19.cds_liab_acct_num                                                       -- 负债账户编号
       ,t24.acct_id                                                                 -- 旧账户编号
       ,t24.acct_seq_no_o                                                           -- 旧客户账户子户号
       ,nvl(trim(t1.card_no), t28.card_no)                                          -- 客户账户卡号
       ,t1.cust_id                                                                  -- 客户编号
       /*,(case when '${batch_date}' <= '20230501' then nvl(t29.subj_id, t25.pric_subj_id)
             else nvl(t29.subj_id, t19.subj_id)
         end) as subj_id                                                            -- 科目编号         t25.pric_subj_id
       ,(case when '${batch_date}' <= '20230501' then nvl(t30.subj_id, t25.recvbl_int_paybl_subj_id)
             else nvl(t30.subj_id, t19.int_paybl_subj_id)
         end) as int_paybl_subj_id                                                  -- 应付利息科目编号*/
       ,coalesce(t29.subj_id,t29_1.subj_id, t25.pric_subj_id, t19.subj_id) as subj_id             -- 科目编号
       ,coalesce(t30.subj_id, t25.recvbl_int_paybl_subj_id, t19.int_paybl_subj_id) as int_paybl_subj_id  -- 应付利息科目编号
       ,''                                                                          -- 应付利息调整科目编号
       ,''                                                                          -- 利息支出科目编号
       ,''                                                                          -- 利息支出调整科目编号
       ,''                                                                          -- 储种代码
       ,t1.acct_attr_cd                                                             -- 账户分类代码
       ,nvl(trim(t1.acct_type_cd), '9')                                             -- 账户类型代码
       ,t1.core_acct_type_cd                                                        -- 账户属性代码
       ,t1.dep_term                                                                 -- 存期
       ,t1.tenor_type_cd                                                            -- 存期期限类型代码
       ,(case when t1.prod_modif_dt > to_date('${batch_date}', 'yyyymmdd')
             then t1.init_prod_id
             else t1.prod_id
         end) as prod_id                                                            -- 标准产品编号
       ,''                                                                          -- 外部产品编号
       ,''                                                                          -- 内部产品编号
	     ,t4.pd_cd                                                                    -- 期次编号
       ,t4.apv_odd_no                                                               -- 开户OA审批单号
       ,t1.approval_id                                                              -- 核准件编号
       ,(case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')
	            then t1.last_acct_status_cd
			        else t1.acct_status_cd
			    end) as dep_acct_status_cd                                                -- 存款账户状态代码
       ,t27.cust_type_cd                                                           -- 客户类型代码
       ,decode(t1.priv_flg, '1', '0', '1')                                          -- 对公账户标志
       ,t1.stop_pay_flg                                                             -- 止付状态代码
       ,t1.general_exch_flg                                                         -- 通兑标志
	     ,t4.general_exch_org_id                                                      -- 通兑机构编号
       ,t1.general_storage_flg                                                      -- 通存标志
       ,decode(t1.reg_acct_type_cd, 'C', '1', '0')                                  -- 通知存款标志
       ,decode(t1.reg_acct_type_cd, 'A', '1', '0')                                  -- 协议存款标志
       ,case when trim(t2.int_rat_float_cate_cd) is null then '0' else '1' end      -- 浮动利率标志
       ,nvl(trim(t2.int_rat_float_cate_cd),'-')                                     -- 利率浮动方式代码
       ,''                                                                          -- 利率调整周期单位代码
       ,''                                                                          -- 利率调整周期频率
       ,(case when p2p.sign_agt_id is not null then '1'
              else t19.corp_supv_acct_flg end) as corp_supv_acct_flg                -- 对公监管户标志
       ,decode(t1.core_acct_type_cd, 'T', '1', '0')                                 -- 定活标志
       ,decode(t23.acct_nature_value, '99001', '1', '0')                            -- 保证金标志
       ,case when t3.bail_account is not null then '1' else '0' end                 -- 票据池保证金标志
       ,t3.pool_type                                                                -- 票据池类型代码
       ,case
          when /* t1.prod_id = '103010100001' and */ trim(t13.agt_id) is not null then '1'
          else '0'
        end                                                                         -- 协定存款标志
       ,case when t1.prod_id like '40101%' then '1' else '0' end                    -- 同业存款标志
       ,decode(t1.prod_id, '102010100001', '1', '102020500001', '1', '0')           -- 网络存款标志
       ,decode(t1.acct_attr_cd, '11001', '1', '0')                                  -- 存款基本户标志
       ,t1.bal_type_cd                                                              -- 钞汇标志
       ,t4.privavy_acct_flg                                                         -- 隐私账户标志
       ,decode(t4.legal_flg, 'YC00', '1', '0')                                      -- 涉案账户标志
       ,t1.redt_way_type_cd                                                         -- 自动转存标志
       ,nvl(t1.aldy_pric_redt_cnt, 0) + nvl(t1.aldy_pric_int_redt_cnt, 0)           -- 已转存次数
       ,t4.unexp_draw_dt                                                            -- 智能存款最早可提支日期
       ,case when t1.priv_flg='0' then '0'   --对公账户不存在睡眠户
               when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')
	                        then t1.last_acct_status_cd else t1.acct_status_cd end) in（'D','S'）
               then '1'
               else '0' end                                                                      -- 睡眠户标志
       ,decode((case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')
	                   then t1.last_acct_status_cd else t1.acct_status_cd end), 'D', '1', '0') -- 不动户标志
       ,decode((case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')
	                   then t1.last_acct_status_cd else t1.acct_status_cd end), 'S', '1', '0') -- 久悬户标志
       ,t1.vtual_acct_flg                                                           -- 虚拟账户标志
       ,decode(t1.core_acct_type_cd, 'A', '0', '1')                                 -- 记账标志
       ,decode(t1.core_acct_type_cd, 'A', '1', '0')                                 -- 母户标志
       ,case when t32.acct_id is not null then '1'
             else '0' end                                                           -- 工资账户标志
       ,decode(t5.acct_lmt_status_cd, 'A', '1', '0')                                -- 冻结标志
       ,nvl(trim(t6.allow_unexp_draw_flg), '1')                                     -- 可提前支取标志
       ,nvl(trim(t7.transf_flg), '0')                                               -- 可转让标志
	   ,t4.delay_pay_int_flg                                                        -- 延期付息标志
	   ,t34.delay_int_days                                                          -- 延期付息天数
       ,nvl(trim(t2.int_accr_base_cd),'-')                                          -- 计息基准代码
       ,t1.int_accr_flg                                                             -- 计息标志
       ,decode(trim(t8.tran_lmt_type_cd),'007','0','1')                             -- 取现标志
       ,nvl(trim(t2.int_set_freq_cd),'-')                                           -- 结息方式代码
       ,nvl(t2.int_accr_way_cd, 'EB')                                               -- 计息方式代码
       ,t4.can_od_flg                                                               -- 允许透支标志
       ,t1.curr_cd                                                                  -- 币种代码
       --,t9.redt_mode_cd                                                           -- 转存方式代码
       ,t1.redt_way_type_cd                                                         -- 转存方式代码
       ,t1.open_acct_chn_id                                                         -- 开户渠道类型代码
       ,t17.ctrl_type_cd                                                            -- 交易渠道状态代码
       ,t1.acct_usage_cd                                                            -- 账户用途代码
       ,nvl(trim(t4.dep_char_cd),'-')                                               -- 存款性质代码
       ,nvl(t1.acct_init_open_acct_dt, t19.open_acct_dt)                            -- 开户日期
       ,nvl(t10.tran_tm, t19.open_acct_tm)                                          -- 开户时间
       ,nvl(t10.tran_ref_no, t19.open_flow_num)                                     -- 开户流水号
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd
                        else t1.acct_status_cd end) ='A' then to_date('29991231','yyyymmdd')
             else coalesce(t1.clos_acct_dt, to_date('29991231','yyyymmdd')) end     -- 销户日期
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd
                        else t1.acct_status_cd end) ='A' then to_date('29991231','yyyymmdd')
             else t11.tran_tm end                                                   -- 销户时间
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd
			                  else t1.acct_status_cd end) ='A' then ''
			       else t11.tran_ref_no end                                               -- 销户流水号
       ,nvl(decode(t10.acct_actv_dt,to_date('00010101','yyyymmdd'),'',t10.acct_actv_dt), t19.actv_dt)  -- 激活日期
       ,(case when t1.prod_id = '401010100001' then t2.value_dt
              when t1.core_acct_type_cd = 'C' and t2.last_int_set_dt <> to_date('00010101','yyyymmdd') then t2.last_int_set_dt
              when t1.effect_dt <> to_date('00010101','yyyymmdd') then t1.effect_dt
              else t1.open_acct_dt
         end ) as value_dt                                                          -- 起息日期
       ,nvl(t13.invalid_dt, t1.exp_dt)                                              -- 到期日期
       ,t1.turn_dormt_acct_dt                                                       -- 转不动户日期
       ,(case when ra.last_change_date = to_date('00010101', 'yyyymmdd')
              then nvl(t1.acct_init_open_acct_dt, t19.open_acct_dt)
              else ra.last_change_date
          end) as final_activ_acct_dt     								                          -- 最后动户日期
       ,t1.final_tran_dt                                                                   -- 最后交易日期
       ,case when t13.effect_dt>to_date('${batch_date}', 'yyyymmdd')
             then t13.last_effect_dt else t13.effect_dt end                         -- 协定存款起息日期
       ,case when t13.effect_dt>to_date('${batch_date}', 'yyyymmdd')
             then t13.last_invalid_dt else t13.invalid_dt end                       -- 协定存款到期日期
       ,t12.rels_dt                                                                 -- 协定存款解约日期
       ,t4.earliest_wdraw_dt                                                        -- 协议存款最早可提支日期
       ,t5.effect_dt                                                                -- 冻结日期
       ,nvl(trim(t5.invalid_dt),to_date('29991231','yyyymmdd'))                     -- 解冻日期
       ,t2.last_int_set_dt                                                          -- 上次结息日期
       ,t2.next_int_set_dt                                                          -- 下次结息日期
      -- ,t1.acct_init_open_acct_dt                                                 -- 首次起息日期
       ,t1.effect_dt                                                                          -- 首次起息日期
--       ,case when trim(t13.agt_id) is not null
--             then case when t13.bank_int_int_rat <>0 then t13.bank_int_int_rat
--                       else (t13.sub_acct_int_rat_float_point/100)+t33.base_rat end
--             else 0 end                                                           -- 协定利率
,case when trim(t13.agt_id) is not null 
     then case when t13.int_rat_apv_form_num is not null and trim(t13.sub_acct_int_rat_float_point) is not null then (t13.sub_acct_int_rat_float_point/100)+t33.base_rat 
               when t13.int_rat_apv_form_num is not null and trim(t13.sub_acct_int_rat_float_ratio) is not null then (t13.sub_acct_int_rat_float_ratio/100+1)*t33.base_rat
               else (nvl(t33.float_point,0)/100)+t33.base_rat end
     else  0 end  -- -- 协定利率
       ,t18.base_rat_id                                                             -- 基准利率类型代码
       ,nvl(t18.base_rat, 0)                                                        -- 基准利率
       ,(case when nvl(t2.sub_acct_fix_int_rat, 0) <> 0 then nvl(t2.sub_acct_fix_int_rat, 0)
              else nvl(t2.exec_int_rat, 0)
         end) as exec_int_rat                                                       -- 执行利率
       ,nvl(pdue.exec_int_rat, 0)  as over_term_exec_int_rat                        -- 超期执行利率
       ,nvl(t2a.provi_day_provi_int, 0) + nvl(t2a.provi_day_int_adj_amt, 0)         -- 当日应计利息
    --   ,nvl(t2.ld_acm_provi_int, 0) + nvl(t2.ld_acm_int_adj_amt, 0)                 -- 当期应计利息
       ,nvl(t30.acct_bal, 0)                                                        -- 当期应计利息
       ,nvl(t2a.ld_acm_int_adj_amt, 0)+nvl(t35.acm_provi_int,0)                   -- 当期应付利息调整
       ,nvl(t31.td_int_expns, 0) as td_int_expns                                    -- 当日利息支出
       ,0 as td_int_expns_adj                                                       -- 当日利息支出调整
       ,t1.cust_mgr_id                                                              -- 客户经理编号
       ,coalesce(t10.tran_teller_id, t19.open_acct_teller_id, 'S####')              -- 开户柜员编号
       ,nvl(trim(t1.clos_acct_teller_id), t19.clos_acct_teller_id)                  -- 销户柜员编号
       ,nvl(trim(t1.open_acct_org_id), t19.open_acct_org_id)                        -- 开户机构编号
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd
			                  else t1.acct_status_cd end) ='A' then ''
			       else nvl(t11.tran_org_id, t19.close_acct_org_id) end                   -- 销户机构编号
       ,coalesce(trim(t29.brchcd),trim(t30.brchcd),trim(t1.open_acct_org_id), t1.belong_org_id)      -- 所属机构编号
       ,decode(t1.vouch_type_cd, '772', '1', '0')                                   -- 开立存款证实书标志
       ,null                                                                        -- 预期最高收益率
       ,nvl(t13.file_amt, 0)                                                        -- 协定存款起存金额
       ,null                                                                        -- 最低余额
       ,coalesce(t19.open_acct_amt, t10.tran_amt, 0)                                -- 开户金额
       ,nvl(t29.acct_bal, 0)                                                        -- 当期余额
       ,nvl(t29.acct_bal, 0) - nvl(t15.acct_inpwn_amt, 0)                           -- 可用余额
       ,nvl(t16.froz_amt, 0)                                                        -- 冻结金额
       ,nvl(t16.stop_pay_amt, 0)                                                    -- 止付金额
       ,nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1)                       -- 折本币当期余额
       ,nvl(t19.currt_bal, 0)                                                       -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t19.currt_bal, 0)  else nvl(t19.ear_m_bal, 0) end                                                 -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t19.currt_bal, 0) else nvl(t19.ear_s_bal, 0) end                        -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t19.currt_bal, 0) else nvl(t19.ear_y_bal, 0) end                                                -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t29.acct_bal, 0) else nvl(t19.y_acm_bal, 0) + nvl(t29.acct_bal, 0) end                              -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t29.acct_bal, 0) else nvl(t19.s_acm_bal, 0) + nvl(t29.acct_bal, 0) end      -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t29.acct_bal, 0) else nvl(t19.m_acm_bal, 0) + nvl(t29.acct_bal, 0) end                                -- 月累计余额
       ,nvl(t19.cl_curr_currt_bal, 0)                                                                                                                           -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t19.cl_curr_currt_bal, 0) else nvl(t19.cl_curr_ear_m_bal, 0) end                                  -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t19.cl_curr_currt_bal, 0) else nvl(t19.cl_curr_ear_s_bal, 0) end        -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t19.cl_curr_currt_bal, 0) else nvl(t19.cl_curr_ear_y_bal, 0) end                                -- 折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) else nvl(t19.cl_curr_y_acm_bal, 0) + nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) end  -- 折本币年累计余额
       ,nvl(t19.cl_curr_y_acm_bal, 0)                                                                                                                           -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t19.cl_curr_y_acm_bal, 0) else nvl(t19.cl_curr_ear_m_y_acm_bal, 0) end                            -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t19.cl_curr_y_acm_bal, 0) else nvl(t19.cl_curr_ear_s_y_acm_bal, 0) end  -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t19.cl_curr_y_acm_bal, 0) else nvl(t19.cl_curr_ear_y_y_acm_bal, 0) end                          -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) else nvl(t19.cl_curr_s_acm_bal, 0) + nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) end  -- 折本币季累计余额
       ,nvl(t19.cl_curr_s_acm_bal, 0)                                                                                                                           -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t19.cl_curr_s_acm_bal, 0) else nvl(t19.cl_curr_ear_s_y_acm_bal, 0) end  -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t19.cl_curr_s_acm_bal, 0) else nvl(t19.cl_curr_ear_y_s_acm_bal, 0) end                          -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) else nvl(t19.cl_curr_m_acm_bal, 0) + nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) end  -- 折本币月累计余额
       ,nvl(t19.cl_curr_m_acm_bal, 0)                                                                                                                           -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t19.cl_curr_m_acm_bal, 0) else nvl(t19.cl_curr_ear_m_m_acm_bal, 0) end                            -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t19.cl_curr_m_acm_bal, 0) else nvl(t19.cl_curr_ear_y_m_acm_bal, 0) end                          -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t29.acct_bal, 0) else nvl(t19.y_acm_bal, 0) + nvl(t29.acct_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t29.acct_bal, 0) else nvl(t19.s_acm_bal, 0) + nvl(t29.acct_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t29.acct_bal, 0) else nvl(t19.m_acm_bal, 0) + nvl(t29.acct_bal, 0) end) / to_number(substr('${batch_date}', 7, 2))  -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) else nvl(t19.cl_curr_y_acm_bal, 0) + nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) else nvl(t19.cl_curr_s_acm_bal, 0) + nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) else nvl(t19.cl_curr_m_acm_bal, 0) + nvl(t29.acct_bal, 0) * nvl(t20.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))  -- 折本币月日均余额
       ,t1.job_cd                                                                   -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')             -- 数据处理时间
  from ${iml_schema}.agt_dep_acct_info_h t1
  left join ${iml_schema}.agt_dep_acct_int_dtl t2
    on t1.agt_id = t2.agt_id
   and t2.int_cls_cd = 'INT'
   and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ncbsi1'
  left join ${iml_schema}.agt_dep_acct_int_dtl t2a
    on t1.agt_id = t2a.agt_id
   and t2a.int_cls_cd = 'INT'
   and t2a.etl_dt = to_date('${batch_date}','yyyymmdd')
   and decode(t2a.exp_dt,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),t2a.exp_dt) >to_date('${batch_date}','yyyymmdd')   --存款到期后，核心的利息字段不会清0，需要通过利息结束日过滤，否则会取到历史利息
   and t2a.job_cd = 'ncbsi1'
  left join ${iml_schema}.agt_dep_acct_int_dtl pdue
    on t1.agt_id = pdue.agt_id
   and pdue.int_cls_cd = 'PDUE'
   and pdue.etl_dt = to_date('${batch_date}','yyyymmdd')
   and pdue.job_cd = 'ncbsi1'
  left join (select t.*,row_number() over(partition by t.bail_account,t.bail_sub_no order by t.bail_amount desc) as rn 
               from ${iol_schema}.bdps_bail_account t
              where t.valid_flag = '1'
                and t.start_dt <= to_date('${batch_date}','yyyymmdd')
                and t.end_dt > to_date('${batch_date}','yyyymmdd')) t3
    on t1.cust_acct_num = t3.bail_account
   and t1.sub_acct_num = t3.bail_sub_no
   and t3.rn=1
  left join ${iml_schema}.agt_dep_acct_assis_info_h t4
    on t1.agt_id = t4.agt_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_01 t5
    on t1.acct_id = t5.acct_id
   and t5.rn = 1
  left join ${iml_schema}.ref_dep_pd_def_para t6
    on t4.pd_cd = t6.pd_cd
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_dep_pd_para_addit_info t7
    on t4.pd_cd = t7.pd_cd
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ncbsf1'
   left join (select lm.acct_id,
               	     lm.tran_lmt_type_cd,
                     row_number() over(partition by lm.acct_id order by lm.effect_dt desc) as rn
                 from iml.agt_dep_acct_lmt_info_h lm
                where lm.acct_lmt_status_cd <> 'F'
                  and lm.tran_lmt_type_cd = '007'  -- 不允许现金支取
                  and lm.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and lm.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and lm.job_cd = 'ncbsf1') t8
    on t1.acct_id=t8.acct_id
   and t8.rn = 1
  left join ${icl_schema}.tmp_cmm_dep_acct_info_06 t10
    on t1.acct_id = t10.acct_id
   and t10.rn = 1
  left join ${icl_schema}.tmp_cmm_dep_acct_info_07 t11
    on t1.acct_id = t11.acct_id
   and t11.rn = 1
  left join ${iml_schema}.agt_dep_sign_agt_h t12  --${icl_schema}.tmp_cmm_dep_acct_info_09 t12
    on t1.acct_id = t12.agt_key
   and t12.sign_agt_type_cd = 'ACC'
   and t12.agt_key_type_cd = 'IK'
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'ncbsf1'
   and t12.sign_agt_status_cd='A'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_p2p p2p
    on t1.acct_id = p2p.agt_key
   and p2p.rn=1
  left join ${iml_schema}.agt_agree_dep_agt_h t13
    on t12.agt_id = t13.agt_id
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'ncbsf1'
   and t13.sign_agt_status_cd ='A'
  left join ${iml_schema}.agt_dep_acct_bal_h t15
    on t1.agt_id = t15.agt_id
   and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t15.end_dt > to_date('${batch_date}','yyyymmdd')
   and t15.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_02 t16
    on t1.acct_id = t16.acct_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_03 t17
    on t1.agt_id = t17.agt_id
   and t17.rn = 1
  left join ${icl_schema}.tmp_cmm_dep_acct_info_04 t18
    on t1.acct_id = t18.acct_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_08 t19
    on t19.acct_id = t1.acct_id
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t20
    on t1.curr_cd = t20.curr_cd
   and t20.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t20.end_dt > to_date('${batch_date}','yyyymmdd')
   and t20.job_cd = 'ncbsf1'
  left join ${iml_schema}.prd_std_prod_info_h t21
    on t21.prod_id = t1.prod_id
   and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t21.end_dt > to_date('${batch_date}','yyyymmdd')
   and t21.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_05 t23
    on t23.prod_id = t1.prod_id
  left join ${iol_schema}.ncbs_new_old_seq_no t24
    on t1.acct_id = t24.internal_key
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t25
    on t1.prod_id = t25.sellbl_prod_id
   and nvl(replace(trim(t4.cap_char), '0000', '*'),'*') = t25.accti_prod_attr_cd1
   and t25.bus_type_cd in ('NCBS', 'LN')
   and t25.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_cust t27
    on t1.cust_id = t27.cust_id
   and t27.job_cd = 'eifsf1'
   and t27.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t27.id_mark <> 'D'
  left join ${iol_schema}.ncbs_rb_acct ra
    on t1.acct_id = ra.internal_key
   and ra.start_dt <= to_date('${batch_date}','yyyymmdd')
   and ra.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_corp_stl_card_rela_info_h t28
    on t1.cust_acct_num = t28.cust_acct_num
   and t1.sub_acct_num = t28.acct_num_sub_acct_num
   and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t28.end_dt > to_date('${batch_date}','yyyymmdd')
   and t28.job_cd = 'ncbsf1'
   and (t28.card_stop_use_flg = '0' OR t28.deflt_acct_num_flg = '1')
   and trim(t28.main_card_card_no) is null
  left join ${icl_schema}.tmp_cmm_dep_acct_info_10 t29
    on t1.acct_id = t29.internal_key
   and t29.trprcd = 'BAL'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_10 t29_1  
    on regexp_substr(t1.cust_acct_num,'^[0-9]+')  = t29_1.base_acct_no --处理旅行通卡科目，使用主账户的科目处理分户科目
   and t29_1.trprcd = 'BAL'
   and t1.travel_card_flg='1'   
  left join ${icl_schema}.tmp_cmm_dep_acct_info_10 t30
    on t1.acct_id = t30.internal_key
   and t30.trprcd = 'INT'
  left join ${icl_schema}.tmp_cmm_dep_acct_info_12 t31
    on t1.cust_acct_num || '_' || t1.sub_acct_num = t31.acctno
  left join ${icl_schema}.tmp_cmm_dep_acct_info_14 t32
    on t1.acct_id = t32.acct_id
  left join ${icl_schema}.tmp_cmm_dep_acct_info_15 t33
    on 1=1  --无需关联字段，直接获取挂牌利率
  left join ${icl_schema}.tmp_cmm_dep_acct_info_17 t34
    on t1.acct_id = t34.acct_id
  left join ${iml_schema}.agt_close_dep_acct_int_h t35
    on t1.acct_id = t35.acct_id
   and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t35.end_dt > to_date('${batch_date}','yyyymmdd')
   and t35.job_cd = 'ncbsf1'
 where t1.src_module_type_cd = 'RB'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and nvl(t1.acct_init_open_acct_dt, t19.open_acct_dt) <=to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_acct_info_ex purge;

-- 3.2 drop temp table
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_05 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_06 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_07 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_08 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_09 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_10 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_11 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_12 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_13 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_14 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_15 purge;
--drop table ${icl_schema}.tmp_cmm_dep_acct_info_16 purge;
-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_dep_acct_info',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);
