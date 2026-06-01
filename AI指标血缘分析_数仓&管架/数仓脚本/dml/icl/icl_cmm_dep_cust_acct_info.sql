/*
Purpose:    共性加工层-存款主账户信息：包括新核心系统、联合存款系统中所有主账户的基本信息。数据来源于新核心系统NCBS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_cust_acct_info
CreateDate: 20220304
Logs:       20220304 李森辉 第一组和第二组调整取数源，由旧核心系统和综合账户系统调整到新核心系统取数
            20220318 李森辉 1、新增字段【客户账户卡号】
            20220401 李森辉 1、调整字段【支取方式代码、电子账户类型代码、凭证形式代码、隐私账户标志、无法核实原因描述、交易渠道状态代码】的取数口径
                            2、置空字段【凭证性质代码-VOUCH_CHAR_CD、联网核查结果代码-NETW_VRFCTION_REST_CD、处置方法描述-DISP_METHOD_DESCB】
            20220429 李森辉 调整第一组字段【联网核查结果代码、账户所属机构编号、处置方法描述】的取数口径
            20220713 李森辉 调整字段【对公账户标志】的加工口径
            20220716 温旺清 调整第一组中字段【账户用途代码】的加工口径
            20220724 翟若平 置空字段【联网核查结果代码、处置方法描述】
            20220726 温旺清 1、调整字段【账户状态代码、电子账户状态代码、账户支取方式状态、止付状态代码、收付状态代码、睡眠户标志、不动户标志】的加工口径
            20220812 李森辉 1、调整联合存款主账户【账户等级代码】口径：'9'其它 -> agt_ifs_acct.acct_kind_cd
                            2、调整来源新核心的【电子账户类型代码】口径，赋值'-'
            20220813 翟若平 1、新增第二组【核心单子户信息派生主账户】
                            2、调整第一组字段【收付状态代码、止付状态代码】的加工口径
            20220812 温旺清  1、新增第二组【核心单子户信息派生主账户】
                            2、调整第一组字段【收付状态代码、止付状态代码】的加工口径
                            3、调整第三组字段【账户等级代码】的加工口径
                            4、新增字段【账户属性代码】
            20220816 李森辉 调整存款账户开销户登记簿处理逻辑：开销户信息取最新一笔数据
            20221009 温旺清 1、调整字段【开户机构编号、开户柜员编号、开户渠道代码、开户流水号、开户日期、开户时间、销户机构编号、销户柜员编号、销户流水号、销户日期、销户时间】的加工口径
            20221026 翟若平 调整字段【凭证种类代码】的加工口径
            20230320 陈伟峰 调整销户信息部分字段加工逻辑，增加账户状态判断
            20230505 陈伟峰 新增字段【账户编号、定期账户类型代码、源模块类型代码】
            20231030 徐子豪 调整字段【财政性存款标志】加工逻辑，改为从核心表RB_ACCT_ATTACH.DEPOSIT_NATURE加工
            20240708 陈伟峰 新增字段【通兑标志、通兑机构编号】
            20241029 谢  宁 新增字段【旅行通账户标志、旅行通卡有效期】
            20250516 陈伟峰 调整evt_dep_acct_oc_acct_rgst_b算法为全量流水
            20250826 陈伟峰 调整【睡眠户标志】加工逻辑，对公账户不存在睡眠户，个人账户当账户状态为不动或者久悬时，则为睡眠户
            20251009 陈伟峰 调整字段【财政性存款标志】加工逻辑，使用新的码值判断
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_cust_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_cust_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_dep_cust_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_dep_cust_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_dep_cust_acct_info_03 purge;

-- 1.3 insert data to tmp table
-- 获取账户附加信息（最大子户号、账户等级代码、核实状态代码、隐私账户标志等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_cust_acct_info_01
nologging
compress ${option_switch} for query high
as
select t1.agt_id as agt_id                             -- 协议编号
       ,t1.acct_id as acct_id                          -- 账户编号
       ,t1.cust_acct_num as cust_acct_num              -- 客户账号
       ,t1.sub_acct_num as sub_acct_num                -- 子户号
       ,t1.acct_type_cd as acct_type_cd                -- 账户等级代码
      ,t1.acct_usage_cd as acct_usage_cd              -- 用途代码
       ,t2.acct_vrif_status_cd as acct_vrif_status_cd  -- 核实状态代码
--       ,t1.general_exch_flg as general_exch_flg        -- 通兑标志
       ,t1.travel_card_flg       as travel_card_flg       -- 旅行通账户标志
       ,t1.travel_card_valid_dt  as travel_card_valid_dt  -- 旅行通卡有效期
       ,row_number() over(partition by t1.cust_acct_num order by t1.sub_acct_num asc) as rn  -- 排序编号
       ,max(t1.sub_acct_num) over(partition by t1.cust_acct_num order by t1.sub_acct_num desc) as max_sub_acct_num  -- 最大子户号
  from ${iml_schema}.agt_dep_acct_info_h t1
  left join ${iml_schema}.agt_dep_acct_assis_info_h t2
    on t1.agt_id = t2.agt_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
;

-- 获取存款账户渠道限制信息（交易渠道状态代码等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_cust_acct_info_02
nologging
compress ${option_switch} for query high
as
select t1.agt_id as agt_id                                                             -- 协议编号
       ,t1.ctrl_type_cd as ctrl_type_cd                                                -- 交易渠道状态代码
       ,row_number() over(partition by t1.agt_id order by t1.ova_flow_num desc) as rn  -- 排序编号
  from ${iml_schema}.agt_dep_acct_chn_lmt_info_h t1
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
;

-- 存款账户开销户登记簿预处理，开销户信息取最新一笔数据
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_cust_acct_info_03
nologging
compress ${option_switch} for query high
as
select t1.acct_id                                                           -- 账户编号
       ,t1.oc_acct_rgst_type_cd                                             -- 开销户登记类型代码
       ,t1.tran_teller_id                                                   -- 开户柜员编号
       ,t1.tran_ref_no                                                      -- 开户流水号
       ,t1.tran_tm                                                          -- 开户时间
       ,t1.tran_org_id                                                      -- 销户机构编号
       ,t1.tran_dt                                                          -- 销户日期
       ,row_number() over(partition by t1.acct_id, t1.oc_acct_rgst_type_cd order by t1.tran_tm desc) as rn  -- 排序编号
  from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b t1
 where t1.oc_acct_rgst_type_cd in ('1', '2')
   and t1.tran_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsi1'
;

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_dep_cust_acct_info_ex purge;

-- 2.2 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_cust_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_dep_cust_acct_info where 0=1;

-- 第一组（共三组）核心存款主账户
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_cust_acct_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,acct_id                   -- 账户编号
       ,cust_acct_id              -- 客户账户编号
       ,cust_acct_card_no         -- 客户账户卡号
       ,cust_acct_name            -- 客户账户名称
       ,cust_id                   -- 客户编号
       ,max_sub_acct_num          -- 最大子户号
       ,std_prod_id               -- 标准产品编号
       ,drawdown_way_cd           -- 支取方式代码
       ,acct_status_cd            -- 账户状态代码
       ,acct_type_cd              -- 账户等级代码
       ,acct_attr_cd              -- 账户属性代码
       ,e_acct_type_cd            -- 电子账户类型代码
       ,e_acct_status_cd          -- 电子账户状态代码
       ,acct_drawdown_way_status  -- 账户支取方式状态
       ,froz_status_cd            -- 冻结状态代码
       ,stop_pay_status_cd        -- 止付状态代码
       ,acpt_pay_status_cd        -- 收付状态代码
       ,acct_usage_cd             -- 账户用途代码
       ,vouch_kind_cd             -- 凭证种类代码
       ,vouch_char_cd             -- 凭证性质代码
       ,vouch_form_cd             -- 凭证形式代码
       ,netw_vrfction_rest_cd     -- 联网核查结果代码
       ,vrif_status_cd            -- 核实状态代码
       ,curr_cd                   -- 币种代码
       ,reg_acct_type_cd          -- 定期账户类型代码
       ,src_module_type_cd        -- 源模块类型代码
       ,sleep_acct_flg            -- 睡眠户标志
       ,dormt_acct_flg            -- 不动户标志
       ,privavy_acct_flg          -- 隐私账户标志
       ,corp_acct_flg             -- 对公账户标志
       ,bind_acct_flg             -- 绑定账户标志
       ,fiscal_dep_flg            -- 财政性存款标志
       ,general_exch_flg          -- 通兑标志
       ,general_exch_org_id       -- 通兑机构编号
       ,travel_card_acct_flg      -- 旅行通账户标志
       ,travel_card_valid_dt      -- 旅行通卡有效期
       ,acct_belong_org_id        -- 账户所属机构编号
       ,open_acct_org_id          -- 开户机构编号
       ,open_acct_teller_id       -- 开户柜员编号
       ,open_acct_chn_cd          -- 开户渠道代码
       ,open_acct_flow_num        -- 开户流水号
       ,open_acct_dt              -- 开户日期
       ,open_acct_tm              -- 开户时间
       ,close_acct_org_id         -- 销户机构编号
       ,clos_acct_teller_id       -- 销户柜员编号
       ,clos_acct_flow_num        -- 销户流水号
       ,clos_acct_dt              -- 销户日期
       ,clos_acct_tm              -- 销户时间
       ,unvrif_rs_descb           -- 无法核实原因描述
       ,disp_method_descb         -- 处置方法描述
       ,tran_chn_status_cd        -- 交易渠道状态代码
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)

select to_date('${batch_date}','yyyymmdd')                                  -- 数据日期
       ,t1.lp_id                                                            -- 法人编号
       ,t1.acct_id                                                          -- 账户编号
       ,t1.cust_acct_num                                                    -- 客户账户编号
       ,t1.card_no                                                          -- 客户账户卡号
       ,t1.acct_name                                                        -- 客户账户名称
       ,t1.cust_id                                                          -- 客户编号
       ,t2.max_sub_acct_num                                                 -- 最大子户号
       ,t1.acct_prod_id                                                     -- 标准产品编号
       ,t6.wdraw_way_cd                                                     -- 支取方式代码
       ,(case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
               then t1.last_acct_status_cd 
               else t1.acct_status_cd end)  as acct_status_cd            -- 账户状态代码
       ,nvl(trim(t2.acct_type_cd), '-')                                  -- 账户等级代码
      ,t1.core_acct_type_cd                                                 -- 账户属性代码
       ,'-'                                                                 -- 电子账户类型代码
       ,(case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
             then t1.last_acct_status_cd 
             else t1.acct_status_cd end) as e_acct_status_cd             -- 电子账户状态代码
       ,'' as acct_drawdown_way_status                                      -- 账户支取方式状态
       ,decode(t1.acct_lmt_flg,'1','2','0')                               -- 冻结状态代码
       ,'-' as stop_pay_status_cd                                           -- 止付状态代码
       ,'-' as acpt_pay_status_cd                                           -- 收付状态代码
       ,t2.acct_usage_cd                                                    -- 账户用途代码
       ,nvl(var.dep_vouch_cate_cd, t1.dep_vouch_cate_cd)                    -- 凭证种类代码
       ,''                                                                  -- 凭证性质代码
       ,nvl(t7.vouch_form_cd,'-')                                           -- 凭证形式代码
       ,''                                                                  -- 联网核查结果代码
       ,t8.acct_vrif_status_cd                                              -- 核实状态代码
       ,t1.acct_curr_cd                                                     -- 币种代码
       ,t1.reg_acct_type_cd                                                 -- 定期账户类型代码
       ,t1.src_module_type_cd                                               -- 源模块类型代码
       ,case when t11.cust_type_cd in ('2', '3', '4') then '0'   --对公账户不存在睡眠户
             else decode((case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
                    then t1.last_acct_status_cd else t1.acct_status_cd end), 
                'D','1', 'S', '1', '0') end as sleep_acct_flg              -- 睡眠户标志
       ,decode((case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
                    then t1.last_acct_status_cd else t1.acct_status_cd end), 
                    'D','1', '0') as dormt_acct_flg              -- 不动户标志
       ,t8.privavy_acct_flg                                                 -- 隐私账户标志
       ,case when t11.cust_type_cd in ('2', '3', '4') then '1' 
             else '0' end as corp_acct_flg                                  -- 对公账户标志
       ,'0'                                                                 -- 绑定账户标志
       ,'-'                                                                 -- 财政性存款标志
       ,decode(t1.general_exch_flg,'1','Y','0','N',t1.general_exch_flg)     -- 通兑标志
       ,t8.general_exch_org_id                                              -- 通兑机构编号
       ,t2.travel_card_flg                                                  -- 旅行通账户标志
       ,t2.travel_card_valid_dt                                             -- 旅行通卡有效期
       ,t1.open_acct_org_id                                                 -- 账户所属机构编号
       ,t1.open_acct_org_id                                                 -- 开户机构编号
       ,t4.tran_teller_id                                                   -- 开户柜员编号
       ,t1.open_acct_chn_id                                                 -- 开户渠道代码
       ,t4.tran_ref_no                                                      -- 开户流水号
       ,case when t1.cust_acct_open_acct_dt <> to_date('29991231','yyyymmdd') then t1.cust_acct_open_acct_dt 
           else to_date('00010101','yyyymmdd') end                        -- 开户日期
       ,t4.tran_tm                                                          -- 开户时间
       ,case when (case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then '' 
          else t5.tran_org_id end                                        -- 销户机构编号
       ,t1.clos_acct_teller_id                                              -- 销户柜员编号
       ,case when (case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then '' 
          else t5.tran_ref_no  end                                      -- 销户流水号
       ,case when (case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then to_date('29991231','yyyymmdd') 
          when t5.tran_dt<>to_date('29991231','yyyymmdd') then t5.tran_dt 
           else to_date('29991231','yyyymmdd') end                       -- 销户日期 
       ,case when (case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then to_date('29991231','yyyymmdd')  
          else t5.tran_tm end                                           -- 销户时间
       ,t8.check_fail_rs_descb                                              -- 无法核实原因描述
       ,''                                                                  -- 处置方法描述
       ,t9.ctrl_type_cd                                                     -- 交易渠道状态代码
       ,t1.job_cd                                                           -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间
  from ${iml_schema}.agt_dep_main_acct_info_h t1
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_01 t2
    on t1.cust_acct_num = t2.cust_acct_num
   and t2.rn = 1
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_03 t4
    on t1.acct_id = t4.acct_id
   and t4.oc_acct_rgst_type_cd = '1'
   and t4.rn = 1
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_03 t5
    on t1.acct_id = t5.acct_id
   and t5.oc_acct_rgst_type_cd = '2'
   and t5.rn = 1
  left join ${iml_schema}.ref_acct_wdraw_way_def_para t6
    on t1.cust_acct_num = t6.wdraw_way_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'
  left join (select row_number() over(partition by cust_acct_num, sub_acct_num order by t.vouch_status_cd, t.vouch_no) rn, t.*
               from iml.agt_vouch_acct_rela_h t
              where t.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t.job_cd = 'ncbsf1') var
    on t1.cust_acct_num = var.cust_acct_num
   and t1.acct_sub_acct_num = var.sub_acct_num
   and var.rn = 1
  left join ${iml_schema}.ref_dep_vouch_cate_para t7
    on t7.dep_vouch_cate_cd = nvl(var.dep_vouch_cate_cd, t1.dep_vouch_cate_cd)
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ncbsf1'
  left join ${iml_schema}.agt_dep_acct_assis_info_h t8
    on t1.agt_id = t8.agt_id
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_02 t9
    on t1.agt_id = t9.agt_id
   and t9.rn = 1
  left join ${iml_schema}.pty_cust t11
    on t1.cust_id = t11.cust_id 
   and t11.job_cd = 'eifsf1'
   and t11.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1';
commit;

-- 第二组（共三组）核心单子户信息派生主账户
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_cust_acct_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,acct_id                   -- 账户编号
       ,cust_acct_id              -- 客户账户编号
       ,cust_acct_card_no         -- 客户账户卡号
       ,cust_acct_name            -- 客户账户名称
       ,cust_id                   -- 客户编号
       ,max_sub_acct_num          -- 最大子户号
       ,std_prod_id               -- 标准产品编号
       ,drawdown_way_cd           -- 支取方式代码
       ,acct_status_cd            -- 账户状态代码
       ,acct_type_cd              -- 账户等级代码
       ,acct_attr_cd              -- 账户属性代码
       ,e_acct_type_cd            -- 电子账户类型代码
       ,e_acct_status_cd          -- 电子账户状态代码
       ,acct_drawdown_way_status  -- 账户支取方式状态
       ,froz_status_cd            -- 冻结状态代码
       ,stop_pay_status_cd        -- 止付状态代码
       ,acpt_pay_status_cd        -- 收付状态代码
       ,acct_usage_cd             -- 账户用途代码
       ,vouch_kind_cd             -- 凭证种类代码
       ,vouch_char_cd             -- 凭证性质代码
       ,vouch_form_cd             -- 凭证形式代码
       ,netw_vrfction_rest_cd     -- 联网核查结果代码
       ,vrif_status_cd            -- 核实状态代码
       ,curr_cd                   -- 币种代码
       ,reg_acct_type_cd          -- 定期账户类型代码
       ,src_module_type_cd        -- 源模块类型代码
       ,sleep_acct_flg            -- 睡眠户标志
       ,dormt_acct_flg            -- 不动户标志
       ,privavy_acct_flg          -- 隐私账户标志
       ,corp_acct_flg             -- 对公账户标志
       ,bind_acct_flg             -- 绑定账户标志
       ,fiscal_dep_flg            -- 财政性存款标志
       ,general_exch_flg          -- 通兑标志
       ,general_exch_org_id       -- 通兑机构编号
       ,travel_card_acct_flg      -- 旅行通账户标志
       ,travel_card_valid_dt      -- 旅行通卡有效期
       ,acct_belong_org_id        -- 账户所属机构编号
       ,open_acct_org_id          -- 开户机构编号
       ,open_acct_teller_id       -- 开户柜员编号
       ,open_acct_chn_cd          -- 开户渠道代码
       ,open_acct_flow_num        -- 开户流水号
       ,open_acct_dt              -- 开户日期
       ,open_acct_tm              -- 开户时间
       ,close_acct_org_id         -- 销户机构编号
       ,clos_acct_teller_id       -- 销户柜员编号
       ,clos_acct_flow_num        -- 销户流水号
       ,clos_acct_dt              -- 销户日期
       ,clos_acct_tm              -- 销户时间
       ,unvrif_rs_descb           -- 无法核实原因描述
       ,disp_method_descb         -- 处置方法描述
       ,tran_chn_status_cd        -- 交易渠道状态代码
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)

select to_date('${batch_date}','yyyymmdd')                                  -- 数据日期
       ,t1.lp_id                                                            -- 法人编号
       ,t1.acct_id                                                          -- 账户编号
       ,t1.cust_acct_num                                                    -- 客户账户编号
       ,nvl(trim(t1.card_no), t12.card_no)                                  -- 客户账户卡号
       ,t1.acct_name                                                        -- 客户账户名称
       ,t1.cust_id                                                          -- 客户编号
       ,t1.sub_acct_num                                                     -- 最大子户号
       ,(case when t1.prod_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
             then t1.init_prod_id 
           else t1.prod_id end) as std_prod_id                           -- 标准产品编号
       ,t6.wdraw_way_cd                                                     -- 支取方式代码
       ,(case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')  then t1.last_acct_status_cd 
           else t1.acct_status_cd end)  as acct_status_cd                -- 账户状态代码
       ,nvl(trim(t1.acct_type_cd), '-')                                     -- 账户等级代码
      ,t1.core_acct_type_cd                                                -- 账户属性代码
       ,'-'                                                                 -- 电子账户类型代码
       ,(case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
             then t1.last_acct_status_cd 
           else t1.acct_status_cd end) as e_acct_status_cd               -- 电子账户状态代码
       ,'' as acct_drawdown_way_status                                      -- 账户支取方式状态
       ,decode(t1.lmt_flg,'1','2','0')                                      -- 冻结状态代码
       ,'-' as stop_pay_status_cd                                           -- 止付状态代码
       ,'-' as acpt_pay_status_cd                                           -- 收付状态代码
       ,t1.acct_usage_cd                                                    -- 账户用途代码
       ,var.dep_vouch_cate_cd                                               -- 凭证种类代码
       ,''                                                                  -- 凭证性质代码
       ,nvl(t7.vouch_form_cd,'-')                                           -- 凭证形式代码
       ,''                                                                  -- 联网核查结果代码
       ,t8.acct_vrif_status_cd                                              -- 核实状态代码
       ,t1.curr_cd                                                          -- 币种代码
       ,t1.reg_acct_type_cd                                                 -- 定期账户类型代码
       ,t1.src_module_type_cd                                               -- 源模块类型代码
       ,case when t11.cust_type_cd in ('2', '3', '4') then '0'   --对公账户不存在睡眠户
             else decode((case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
                    then t1.last_acct_status_cd else t1.acct_status_cd end), 
                'D','1', 'S', '1', '0') end as sleep_acct_flg              -- 睡眠户标志
       ,decode((case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd') 
                    then t1.last_acct_status_cd else t1.acct_status_cd end), 
                    'D','1', '0') as dormt_acct_flg              -- 不动户标志
       ,t8.privavy_acct_flg                                                 -- 隐私账户标志
       ,case when t11.cust_type_cd in ('2', '3', '4') then '1' 
             else '0' end as corp_acct_flg                                  -- 对公账户标志
       ,'0'                                                                 -- 绑定账户标志
       ,case when t8.dep_char_cd in ('11','12','21','22','31','32') then '1'
             when t8.dep_char_cd in ('41') then '0'
             else '-'
        end                                                                 -- 财政性存款标志
       ,t1.general_exch_flg                                                 -- 通兑标志
       ,t8.general_exch_org_id                                              -- 通兑机构编号
       ,t1.travel_card_flg                                                  -- 旅行通账户标志
       ,t1.travel_card_valid_dt                                             -- 旅行通卡有效期
       ,t1.belong_org_id                                                    -- 账户所属机构编号
       ,t1.open_acct_org_id                                                 -- 开户机构编号
       ,t4.tran_teller_id                                                   -- 开户柜员编号
       ,t1.open_acct_chn_id                                                 -- 开户渠道代码
       ,t4.tran_ref_no                                                      -- 开户流水号
       ,case when t1.acct_init_open_acct_dt <> to_date('29991231','yyyymmdd') then t1.acct_init_open_acct_dt 
           else to_date('00010101','yyyymmdd') end  as open_acct_dt       -- 开户日期
       ,t4.tran_tm                                                          -- 开户时间
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')  then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then '' 
          else t5.tran_org_id end                                        -- 销户机构编号
       ,t1.clos_acct_teller_id                                              -- 销户柜员编号
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')  then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then '' 
          else t5.tran_ref_no end                                        -- 销户流水号
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')  then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then to_date('29991231','yyyymmdd')
          when t1.clos_acct_dt<>to_date('29991231','yyyymmdd') then t1.clos_acct_dt 
           else to_date('29991231','yyyymmdd') end                        -- 销户日期  
       ,case when (case when t1.status_modif_dt > to_date('${batch_date}', 'yyyymmdd')  then t1.last_acct_status_cd 
                     else t1.acct_status_cd end) ='A' then to_date('29991231','yyyymmdd') 
          else t5.tran_tm end                                            -- 销户时间        
       ,t8.check_fail_rs_descb                                              -- 无法核实原因描述
       ,''                                                                  -- 处置方法描述
       ,t9.ctrl_type_cd                                                     -- 交易渠道状态代码
       ,t1.job_cd                                                           -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间
  from ${iml_schema}.agt_dep_acct_info_h t1
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_03 t4
    on t1.acct_id = t4.acct_id
   and t4.oc_acct_rgst_type_cd = '1'
   and t4.rn = 1
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_03 t5
    on t1.acct_id = t5.acct_id
   and t5.oc_acct_rgst_type_cd = '2'
   and t5.rn = 1
  left join ${iml_schema}.ref_acct_wdraw_way_def_para t6
    on t1.cust_acct_num = t6.wdraw_way_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'
  left join (select row_number() over(partition by cust_acct_num, sub_acct_num order by t.vouch_status_cd, t.vouch_no) rn, t.*
               from iml.agt_vouch_acct_rela_h t
              where t.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t.job_cd = 'ncbsf1') var
    on t1.cust_acct_num = var.cust_acct_num
   and t1.sub_acct_num = var.sub_acct_num
   and var.rn = 1
  left join ${iml_schema}.ref_dep_vouch_cate_para t7
    on t7.dep_vouch_cate_cd = var.dep_vouch_cate_cd
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ncbsf1'
  left join ${iml_schema}.agt_dep_acct_assis_info_h t8
    on t1.acct_id = t8.acct_id
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_dep_cust_acct_info_02 t9
    on t1.agt_id = t9.agt_id
   and t9.rn = 1
  left join ${iml_schema}.pty_cust t11
    on t1.cust_id = t11.cust_id 
   and t11.job_cd = 'eifsf1'
   and t11.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.id_mark <> 'D'
  left join ${iml_schema}.agt_corp_stl_card_rela_info_h t12
    on t1.cust_acct_num = t12.cust_acct_num
   and t1.sub_acct_num = t12.acct_num_sub_acct_num
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'ncbsf1'
   and (t12.card_stop_use_flg = '0' or t12.deflt_acct_num_flg = '1')
   and trim(t12.main_card_card_no) is null
  /*left join ${icl_schema}.cmm_dep_cust_acct_info t13
    on t1.cust_acct_num = t13.cust_acct_id
   and t13.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
  left join (select ue.tellermanagerid, ue.employeeid, 
                    row_number() over(partition by ue.tellermanagerid order by ue.updatedate desc) rn
               from ${iol_schema}.uuss_uus_employee ue
              where ue.start_dt <= to_date('${batch_date}','yyyymmdd')
                and ue.end_dt > to_date('${batch_date}','yyyymmdd')
                and trim(ue.tellermanagerid) is not null) t14
    on t13.open_acct_teller_id = t14.tellermanagerid
   and t14.rn = 1
  left join (select ue.tellermanagerid, ue.employeeid, 
                    row_number() over(partition by ue.tellermanagerid order by ue.updatedate desc) rn
               from ${iol_schema}.uuss_uus_employee ue
              where ue.start_dt <= to_date('${batch_date}','yyyymmdd')
                and ue.end_dt > to_date('${batch_date}','yyyymmdd')
                and trim(ue.tellermanagerid) is not null) t15
    on t13.clos_acct_teller_id = t15.tellermanagerid
   and t15.rn = 1*/
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and t1.main_acct_flg = '1'
   and not exists (select 1 
                     from ${iml_schema}.agt_dep_main_acct_info_h dm
                    where t1.cust_acct_num = dm.cust_acct_num
                      and dm.start_dt <= to_date('${batch_date}','yyyymmdd')
                      and dm.end_dt > to_date('${batch_date}','yyyymmdd')
                      and dm.job_cd = 'ncbsf1');
commit;

-- 第三组（共三组）联合存款主账户
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_cust_acct_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,acct_id                   -- 账户编号
       ,cust_acct_id              -- 客户账户编号
       ,cust_acct_card_no         -- 客户账户卡号
       ,cust_acct_name            -- 客户账户名称
       ,cust_id                   -- 客户编号
       ,max_sub_acct_num          -- 最大子户号
       ,std_prod_id               -- 标准产品编号
       ,drawdown_way_cd           -- 支取方式代码
       ,acct_status_cd            -- 账户状态代码
       ,acct_type_cd              -- 账户等级代码
      ,acct_attr_cd              -- 账户属性代码
       ,e_acct_type_cd            -- 电子账户类型代码
       ,e_acct_status_cd          -- 电子账户状态代码
       ,acct_drawdown_way_status  -- 账户支取方式状态
       ,froz_status_cd            -- 冻结状态代码
       ,stop_pay_status_cd        -- 止付状态代码
       ,acpt_pay_status_cd        -- 收付状态代码
       ,acct_usage_cd             -- 账户用途代码
       ,vouch_kind_cd             -- 凭证种类代码
       ,vouch_char_cd             -- 凭证性质代码
       ,vouch_form_cd             -- 凭证形式代码
       ,netw_vrfction_rest_cd     -- 联网核查结果代码
       ,vrif_status_cd            -- 核实状态代码
       ,curr_cd                   -- 币种代码
       ,reg_acct_type_cd          -- 定期账户类型代码
       ,src_module_type_cd        -- 源模块类型代码
       ,sleep_acct_flg            -- 睡眠户标志
       ,dormt_acct_flg            -- 不动户标志
       ,privavy_acct_flg          -- 隐私账户标志
       ,corp_acct_flg             -- 对公账户标志
       ,bind_acct_flg             -- 绑定账户标志
       ,fiscal_dep_flg            -- 财政性存款标志
       ,general_exch_flg          -- 通兑标志
       ,general_exch_org_id       -- 通兑机构编号
       ,travel_card_acct_flg      -- 旅行通账户标志
       ,travel_card_valid_dt      -- 旅行通卡有效期
       ,acct_belong_org_id        -- 账户所属机构编号
       ,open_acct_org_id          -- 开户机构编号
       ,open_acct_teller_id       -- 开户柜员编号
       ,open_acct_chn_cd          -- 开户渠道代码
       ,open_acct_flow_num        -- 开户流水号
       ,open_acct_dt              -- 开户日期
       ,open_acct_tm              -- 开户时间
       ,close_acct_org_id         -- 销户机构编号
       ,clos_acct_teller_id       -- 销户柜员编号
       ,clos_acct_flow_num        -- 销户流水号
       ,clos_acct_dt              -- 销户日期
       ,clos_acct_tm              -- 销户时间
       ,unvrif_rs_descb           -- 无法核实原因描述
       ,disp_method_descb         -- 处置方法描述
       ,tran_chn_status_cd        -- 交易渠道状态代码
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)
select to_date('${batch_date}', 'yyyymmdd')     -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.acct_id                              -- 账户编号
       ,t1.acct_id                              -- 客户账户编号
       ,''                                      -- 客户账户卡号
       ,t1.acct_name                            -- 客户账户名称
       ,t1.cust_id                              -- 客户编号
       ,t1.final_sub_acct_seq_num               -- 最大子户号
       ,decode(t1.sav_type_cd, 'S01', '102010100001', 'S02', '102020500001') as std_prod_id  -- 标准产品编号
       ,'-' as drawdown_way_cd                  -- 支取方式代码
       ,t2.agt_status_cd                        -- 账户状态代码
       ,t1.acct_kind_cd                         -- 账户等级代码
      ,''                                      -- 账户属性代码
       ,t1.acct_type_cd                         -- 电子账户类型代码
       ,t2.agt_status_cd                        -- 电子账户状态代码
       ,'-' as acct_drawdown_way_status         -- 账户支取方式状态
       ,t3.agt_status_cd                        -- 冻结状态代码
       ,t2.agt_status_cd                        -- 止付状态代码
       ,t5.agt_status_cd                        -- 收付状态代码
       ,t1.acct_usage_cd                        -- 账户用途代码
       ,'737'                                   -- 凭证种类代码
       ,'1'                                     -- 凭证性质代码
       ,'DCT'                                   -- 凭证形式代码
       ,''                                      -- 联网核查结果代码
       ,''                                      -- 核实状态代码
       ,''                                      -- 币种代码
       ,'-'                                     -- 定期账户类型代码
       ,'-'                                     -- 源模块类型代码
       ,t1.sleep_acct_flg                       -- 睡眠户标志
       ,t1.dormt_acct_flg                       -- 不动户标志
       ,'0' as privavy_acct_flg                 -- 隐私账户标志
       ,'0'                                     -- 对公账户标志
       ,'0'                                     -- 绑定账户标志 
       ,'-'                                     -- 财政性存款标志
       ,'-'                                     -- 通兑标志
       ,' '                                     -- 通兑机构编号
       ,'0'                                     -- 旅行通账户标志
       ,null                                    -- 旅行通卡有效期
       ,t1.open_acct_org_id                     -- 账户所属机构编号    
       ,t1.open_acct_org_id                     -- 开户机构编号
       ,'MB001' as open_acct_teller_id          -- 开户柜员编号
       ,t1.open_acct_chn_cd                     -- 开户渠道代码
       ,t1.open_acct_flow_id                    -- 开户流水号
       ,case when t1.open_acct_dt <> to_date('29991231','yyyymmdd') then t1.open_acct_dt 
           else to_date('00010101','yyyymmdd') 
       end  as open_acct_dt                   -- 开户日期
       ,t1.open_acct_cmplt_tm                   -- 开户时间
       ,(case when t1.clos_acct_dt <> ${iml_schema}.dateformat_max('') then t1.open_acct_org_id 
              else '' 
          end) as close_acct_org_id             -- 销户机构编号
       ,(case when t1.clos_acct_dt <> ${iml_schema}.dateformat_max('') then 'MB001' 
              else '' 
          end) as clos_acct_teller_id           -- 销户柜员编号
       ,t1.clos_acct_flow_num                   -- 销户流水号
       ,case when t1.clos_acct_dt<>to_date('29991231','yyyymmdd') then t1.clos_acct_dt 
           else to_date('29991231','yyyymmdd') 
       end as clos_acct_dt                    -- 销户日期  
       ,t1.clos_acct_tm                         -- 销户时间   
       ,''                                      -- 无法核实原因描述
       ,''                                      -- 处置方法描述
       ,'-'                                     -- 交易渠道状态代码
       ,t1.job_cd                               -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')      -- 数据处理时间
  from ${iml_schema}.agt_ifs_acct t1
  left join ${iml_schema}.agt_status_h t2
    on t1.agt_id = t2.agt_id
   and t1.lp_id = t2.lp_id
   and t2.agt_status_type_cd = 'CD2554'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ifcsf1'
  left join ${iml_schema}.agt_status_h t3
    on t1.agt_id = t3.agt_id
   and t1.lp_id = t3.lp_id
   and t3.agt_status_type_cd = 'CD1254'
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_status_h t4
    on t1.agt_id = t2.agt_id
   and t1.lp_id = t2.lp_id
   and t2.agt_status_type_cd = 'CD1046'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ifcsi1'
  left join ${iml_schema}.agt_status_h t5
    on t1.agt_id = t5.agt_id
   and t1.lp_id = t5.lp_id
   and t5.agt_status_type_cd = 'CD1754'
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'ifcsi1'
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.id_mark <> 'D'
   and t1.job_cd = 'ifcsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_cust_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_cust_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_cust_acct_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_dep_cust_acct_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_dep_cust_acct_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_dep_cust_acct_info_03 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_dep_cust_acct_info',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);
