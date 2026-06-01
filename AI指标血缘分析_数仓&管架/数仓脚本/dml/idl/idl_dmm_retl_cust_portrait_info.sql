/*
Purpose:    报表集市层-零售贷款日均余额信息表：包括所有的零售贷款日均余额。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dmm_retl_cust_portrait_info
CreateDate: 20220329
Logs:       ${batch_date} 陈伟峰 手工脚本
                 20260227 陈伟峰 调整【近半年企微触达次数、近半年录音电话触达次数、近半年个人微信触达次数、近半年个人电话触达次数、近半年面访触达次数、客群、TIB、上月TIB、上年TIB、是否a端客户】加工逻辑
				 20260416 陈  凭 调整【管户分行编号、管户支行编号】加工逻辑
				 20260508 谭钧泽 调整【非抵押贷款LUM】加工逻辑、新增【管户机构编号】字段
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter seesion force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${idl_schema}.dmm_retl_cust_portrait_info drop partition p_${retain_day};
alter table ${idl_schema}.dmm_retl_cust_portrait_info drop partition p_${batch_date};
alter table ${idl_schema}.dmm_retl_cust_portrait_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_retl_cust_portrait_info_ex purge;
drop table ${idl_schema}.dmm_retl_cust_portrait_info_ex01 purge;
drop table ${idl_schema}.dmm_retl_cust_portrait_info_ex02 purge;
drop table ${idl_schema}.dmm_retl_cust_portrait_info_ex03 purge;
-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_cust_portrait_info_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.dmm_retl_cust_portrait_info where 0=1;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_cust_portrait_info_ex01
nologging
compress ${option_switch} for query high
as 
select cust_id
        ,sum(case when debit_crdt_dir_cd = 'C' then 1 else 0 end) as half_y_tran_in_cnt
        ,sum(case when debit_crdt_dir_cd = 'C' then tran_amt else 0 end) as half_y_tran_in_amt
        ,sum(case when debit_crdt_dir_cd = 'D' then 1 else 0 end) as half_y_tran_out_cnt
        ,sum(case when debit_crdt_dir_cd = 'D' then tran_amt else 0 end) as half_y_tran_out_amt
        ,sum(case when debit_crdt_dir_cd = 'C' and tran_amt>=100000 then 1 else 0 end) as half_y_bigamt_tran_in_cnt
        ,sum(case when debit_crdt_dir_cd = 'C' and tran_amt>=100000 then tran_amt else 0 end) as half_y_bigamt_tran_in_amt
        ,sum(case when debit_crdt_dir_cd = 'D' and tran_amt>=100000 then 1 else 0 end) as half_y_bigamt_tran_out_cnt
        ,sum(case when debit_crdt_dir_cd = 'D' and tran_amt>=100000 then tran_amt else 0 end) as half_y_bigamt_tran_out_amt
  from ${icl_schema}.cmm_dep_acct_tran_dtl
 where etl_dt between to_date('${batch_date}','yyyymmdd')-180 and to_date('${batch_date}','yyyymmdd')  --需取近半年
    and (tran_descb like '%转账%' or tran_descb like '%入账%')
  group by cust_id;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_cust_portrait_info_ex02
nologging
compress ${option_switch} for query high
as 
select cust_id
         ,sum(case when tran_chn_desc like '%手机银行%' then 1 else 0 end ) as half_y_mbank_prod_cnt
         ,sum(case when tran_chn_desc like '%网上银行%' then 1 else 0 end ) as half_y_onl_bank_prod_cnt
         ,sum(case when tran_chn_desc like '%柜%' then 1 else 0 end ) as half_y_cnter_prod_cnt
         ,sum(case when tran_chn_desc like '%ATM%' then 1 else 0 end ) as half_y_atm_cnt 
         ,sum(case when (tran_chn_desc not like '%手机银行%' 
                        and tran_chn_desc not like '%网上银行%' 
                        and tran_chn_desc not like '%柜%' 
                        and tran_chn_desc not like '%ATM%')
                      then 1 else 0 end ) as half_y_other_chn_prod_cnt
from (select t1.party_id     as cust_id
                ,t1.tran_chn_cd as tran_chn_cd
                ,t2.cd_descb as tran_chn_desc
          from ${iml_schema}.evt_finc_tran_entr_h t1
          left join ${iml_schema}.ref_pub_cd t2
            on t1.tran_chn_cd=t2.cd_val
           and t2.cd_id ='CD1585'
        where t1.tran_cd in ('100200')    --交易代码
           and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
           and t1.end_dt > to_date('${batch_date}','yyyymmdd')
           and t1.tran_dt between to_date('${batch_date}','yyyymmdd')-180 and to_date('${batch_date}','yyyymmdd')
           and t1.job_cd ='ifmsi1'
        union all
       select t1.cust_id
                ,t1.tran_chn_cd  as tran_chn_cd
                ,t2.cd_descb     as tran_chn_desc
         from ${iml_schema}.evt_consmt_fund_tran_entr_h t1
         left join ${iml_schema}.ref_pub_cd t2
            on t1.tran_chn_cd=t2.cd_val
          and t2.cd_id ='CD1751'
        where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
          and t1.end_dt > to_date('${batch_date}','yyyymmdd')
          and t1.job_cd ='nfssf1'
          and t1.appl_dt between to_date('${batch_date}','yyyymmdd')-180 and to_date('${batch_date}','yyyymmdd')
        union all
       select t1.cust_id
               ,t1.tran_chn_cd as tran_chn_cd
               ,t2.cd_descb    as   tran_chn_desc
         from ${iml_schema}.evt_insure_tran_flow t1
         left join ${iml_schema}.ref_pub_cd t2
            on t1.tran_chn_cd=t2.cd_val
           and t2.cd_id ='CD1585'
        where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
           and t1.end_dt > to_date('${batch_date}','yyyymmdd')
           and t1.job_cd ='inssf1'
           and t1.tran_dt between to_date('${batch_date}','yyyymmdd')-180 and to_date('${batch_date}','yyyymmdd')
        union all
       select t1.cust_id
                ,t1.chn_cd     as tran_chn_cd
                ,t2.cd_descb   as tran_chn_desc
         from ${icl_schema}.cmm_dep_acct_tran_dtl t1
         left join ${iml_schema}.ref_pub_cd t2
            on t1.chn_cd=t2.cd_val
           and t2.cd_id ='CD1751'
        where t1.debit_crdt_dir_cd = 'C'
          and t1.tran_dt between to_date('${batch_date}','yyyymmdd')-180 and to_date('${batch_date}','yyyymmdd')
)
group by cust_id;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_cust_portrait_info_ex03
nologging
compress ${option_switch} for query high
as 
select a.khh as cust_id
                       ,sum(a.yrj) as cust_tot_lum
                       ,sum(case when main_guar_way_cd='B' then a.yrj else 0 end ) as mtg_loan_lum
                       ,sum(case when main_guar_way_cd<>'B' or main_guar_way_cd is null then a.yrj else 0 end ) as non_mtg_loan_lum
                       ,'是' as is_hold_zero_lon
                       ,case when max(case when a.cpsjfl = '个人经营性贷款' then 1 else 0 end) = 1
                               then '是' else '否' end as is_hold_indv_opering_loan 
                       ,case when max(case when a.cpsjfl = '个人经营性贷款' then 1 else 0 end) = 0
                               and max(case when a.cpsjfl = '个人消费性贷款' then 1 else 0 end) = 1
                              then '是' else '否' end as is_hold_indv_consm_loan 
                       ,case when max(case when a.cpsjfl = '个人经营性贷款' then 1 else 0 end) = 0
                               and max(case when a.cpsjfl = '个人消费性贷款' then 1 else 0 end) = 0
                               and max(case when a.cpsjfl = '个人按揭性贷款' then 1 else 0 end) = 1
                              then '是' else '否' end as is_hold_indv_mortg_loan  
                 from  ${iol_schema}.pams_jxbb_dkftpmx a
                 left join ${iml_schema}.agt_loan_dubil_info_h t2
                   on a.jjh=t2.dubil_id
                  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
                  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
                  and t2.job_cd ='icmsf1'
                where (a.nrj > 0 or a.nlx <> 0 or a.ljftpzycb <> 0 or a.yqxyss <> 0 or nvl(a.fxjqzcje, 0) <> 0)
                  and a.tjrq = '${batch_date}'
                  and a.etl_dt =to_date('${batch_date}','yyyymmdd')
                  and a.kmh not like '13020402%'
                  and a.kmh not like '8%'
                  and a.kmh not like '3007%'
                  and a.kmh is not null
                  and a.kmh <> ' '
                  and a.kmmc like '%个人%'
                  and a.cpejfl not like '个人平台贷款' 
                  and a.cpsjfl not like '平台贷款'
                  and a.cpzwmc not like '%赎楼%'
                  and a.fptx in ('2') --分配条线选零售2，公司1，同业3
                  and ((a.zhbs = '1' and a.xwdkbs = '1' and nvl(a.gyljrywbz, '否') = '否') or a.zhbs = '2' or nvl(a.xbcxdbs, '否') = '是')
                  and a.cpbh != '201020100061'
                  and a.bwbs <> '1'
                  and not exists (select 1
                                         from ${iol_schema}.pams_jxbb_dkftpmx a1
                                        where a1.sfxw = '是'
                                          and (a1.kmh not like '130301%' and a1.kmh not like '130503%' and a1.zhbs <> '2')
                                          and a1.tjrq = '${batch_date}' 
                                          and a1.etl_dt =to_date('${batch_date}','yyyymmdd')
                                          and a.jjh = a1.jjh
                                          and a.tjrq = a1.tjrq
                                          and a.sfxw = a1.sfxw
                                          and a.kmh = a1.kmh
                                          and a.khjgkhdxdh = a1.khjgkhdxdh)
                 group by khh
;

whenever sqlerror exit sql.sqlcode;
insert into ${idl_schema}.dmm_retl_cust_portrait_info_ex(
        etl_dt                                     --数据日期
       ,lp_id                                      --法人编号
       ,cust_id                                    --客户号
       ,open_acct_tm                               --开户时间
       ,cust_aging                                 --账龄
       ,a_part_cust_flg                            --是否a端客户
       ,l_part_cust_flg                            --是否l端客户
       ,aum_bal                                    --aum余额
       ,aum_m_avg                                  --aum月日均
       ,curr_dep_m_avg                             --活期存款月日均
       ,time_dep_m_avg                             --定期存款月日均
       ,cds_m_avg                                  --大额存单月日均
       ,insure_m_avg                               --保险月日均
       ,fund_m_avg                                 --基金月日均
       ,finc_m_avg                                 --理财月日均
       ,cust_tot_lum                               --客户总lum
       ,mtg_loan_lum                               --抵押贷款lum
       ,non_mtg_loan_lum                           --非抵押贷款lum
       ,lum_hibchy                                 --lum层级
       ,lum_hibchy_subdv                           --lum层级细分
       ,tib_type                                   --tib
       ,last_mon_tib_type                          --上月tib
       ,last_year_tib_type                         --上年tib
       ,execu_brch_id                              --管户分行编号
       ,execu_ps_id                                --管户人编号
       ,execu_ps_name                              --管户人名称
       ,execu_subrch_id                            --管户支行编号
	   ,execu_org_id                               --管户机构编号
       ,co_ps_id                                   --共管人编号
       ,co_ps_name                                 --共管人名称
       ,co_ps_role                                 --共管人角色
       ,co_ps_role_cls                             --共管人角色分类
       ,execu_ps_role_cls                          --管户人角色分类
       ,cust_hibchy                                --客户层级
       ,cust_asset_hibchy_subdv                    --客户资产层级细分
       ,eqty_level                                 --权益等级
       ,eqty_level_subdv                           --权益等级细分
       ,is_sleep_acct                              --是否睡眠户
       ,is_long_hang_acct                          --是否久悬户
       ,is_hold_zero_lon                           --是否持有零贷
       ,is_sign_mbank                              --是否签约手机银行
       ,is_add_cop_tiny                            --是否添加企微
       ,is_agree_camp_st_msg                       --是否同意营销短信
       ,is_sign_finc_risk                          --是否签约风险测评
       ,is_bind_scut_pay                           --是否绑定快捷支付
       ,is_concern_tiny_bank_bd_card               --是否关注微银行并绑卡
       ,is_real_execu                              --是否真实管户
       ,is_hold_loan                               --是否持有贷款
       ,is_hold_curr                               --是否持有活期
       ,is_hold_reg                                --是否持有定期
       ,is_hold_fund                               --是否持有基金
       ,is_hold_finc                               --是否持有理财
       ,is_hold_insure                             --是否持有保险
       ,is_hold_three_deposit                      --是否持有三方存管
       ,is_hold_noble_met                          --是否持有贵金属
       ,is_hold_am_trust                           --是否持有资管信托
       ,is_hold_indv_mortg_loan                    --是否持有个人按揭性贷款
       ,is_hold_indv_consm_loan                    --是否持有个人消费性贷款
       ,is_hold_indv_opering_loan                  --是否持有个人经营性贷款
       ,main_guar_way_crdt                         --主担保方式为信用
       ,main_guar_way_guar                         --主担保方式为保证
       ,main_guar_way_other                        --主担保方式为其他
       ,main_guar_way_pm                           --主担保方式为抵质押
       ,dep_ftp_cust_net_inco                      --存款FTP客户净收入
       ,loan_ftp_cust_net_inco                     --贷款FTP客户净收入
       ,loan_tot_risk_cost                         --贷款总风险成本
       ,dep_tot_eva                                --存款总eva
       ,loan_tot_eva                               --贷款总eva
       ,loan_ftp_net_margin                        --贷款ftp净利润
       ,dep_ftp_net_margin                         --存款ftp净利润
       ,inter_income_amt                           --中收营收
       ,career_cd                                  --职业代码
       ,career_name                                --职业名称
       ,indus_cd                                   --行业代码
       ,indus_name                                 --行业名称
       ,custs                                      --客群
       ,family_mon_inco                            --家庭月收入
       ,indv_mon_inco                              --个人月收入
       ,age                                        --年龄
       ,gender                                     --性别
       ,prov_cd                                    --省代码
       ,prov_name                                  --省名称
       ,city_cd                                    --城市代码
       ,city_name                                  --城市名称
       ,rg_cd                                      --地区代码
       ,rg_name                                    --地区名称
       ,level2_chn_lab                             --二级渠道标签
       ,level3_chn_lab                             --三级渠道标签
       ,eqty_exch_cnt                              --权益星兑换次数
       ,eqty_exch_score                            --权益星兑换分数
       ,point_exch_cnt                             --积分兑换次数
       ,point_exch_score                           --积分兑换分数
       ,half_y_tran_in_cnt                         --近半年转入笔数
       ,half_y_tran_in_amt                         --近半年转入金额
       ,half_y_tran_out_cnt                        --近半年转出笔数
       ,half_y_tran_out_amt                        --近半年转出金额
       ,half_y_bigamt_tran_in_cnt                  --近半年大额转入笔数
       ,half_y_bigamt_tran_in_amt                  --近半年大额转入金额
       ,half_y_bigamt_tran_out_cnt                 --近半年大额转出笔数
       ,half_y_bigamt_tran_out_amt                 --近半年大额转出金额
       ,half_y_mbank_prod_cnt                      --近半年手机银行产品交互次数
       ,half_y_cnter_prod_cnt                      --近半年柜面产品交互次数
       ,half_y_atm_cnt                             --近半年atm交互次数
       ,half_y_onl_bank_prod_cnt                   --近半年网上银行产品交互次数
       ,half_y_other_chn_prod_cnt                  --近半年其他渠道产品交互次数
       ,half_y_tiny_arrive_cnt                     --近半年企微触达次数
       ,half_y_sound_rec_tel_arrive_cnt            --近半年录音电话触达次数
       ,half_y_indv_wx_arrive_cnt                  --近半年个人微信触达次数
       ,half_y_indv_tel_arrive_cnt                 --近半年个人电话触达次数
       ,half_y_arrive_cnt                          --近半年面访触达次数
       ,job_cd                                     --任务代码
       ,etl_timestamp                              --数据处理时间
)
select 
        to_date('${batch_date}','yyyymmdd')               -- 数据日期
        ,'9999'                                             -- 法人编号
       ,t1.cust_id                                          -- 客户号
       ,t15.open_acct_dt                                    -- 开户时间
       ,case when (to_date('${batch_date}', 'yyyymmdd')- t15.open_acct_dt) between 0 and 29 then '<1个月'
               when (to_date('${batch_date}', 'yyyymmdd')- t15.open_acct_dt) between 30 and 89 then '1-3个月'
               when (to_date('${batch_date}', 'yyyymmdd') - t15.open_acct_dt) between 90 and 179 then '3-6个月'
               when (to_date('${batch_date}', 'yyyymmdd') - t15.open_acct_dt) between 180 and 365 then '6-12个月'
               when (to_date('${batch_date}', 'yyyymmdd') - t15.open_acct_dt) > 365 then '12个月以上'
               else '未知' end                                                                          -- 开户账龄
       ,case when t25.if_allacct_close ='0' then '1' else '0' end                                  -- 是否a端客户
       ,case when t7.cust_id is not null then '1' else '0' end                                  -- 是否l端客户
       ,t1.aum_acct_bal                                                                                   -- aum余额
       ,t1.aum_m_avg_bal                                                                                  -- aum月日均
       ,t1.cur_m_avg_bal                                                                                  -- 活期存款月日均
       ,t1.dep_m_avg_bal                                                                                  -- 定期存款月日均
       ,t1.cds_m_avg_bal                                                                                  -- 大额存单月日均
       ,t1.insure_m_avg_bal                                                                               -- 保险月日均
       ,t1.fund_acct_mavg                                                                                 -- 基金月日均
       ,t1.fin_acct_mavg                                                                                  -- 理财月日均
       ,nvl(t7.cust_tot_lum,0)                                                                           -- 客户总lum
       ,nvl(t7.mtg_loan_lum,0)                                                                           -- 抵押贷款lum
       ,nvl(t7.non_mtg_loan_lum,0)                                                                       -- 非抵押贷款lum
       ,case  when t7.cust_tot_lum >= 0 and  t7.cust_tot_lum < 50000 then '7.[0,5万)'
                when t7.cust_tot_lum >= 50000 and  t7.cust_tot_lum < 500000 then '6.[5万,50万)'
                when t7.cust_tot_lum >= 500000 and  t7.cust_tot_lum < 2000000 then '5.[50万,200万)'
                when t7.cust_tot_lum >= 2000000 and t7.cust_tot_lum< 4000000 then '4.[200万,400万)'
                when t7.cust_tot_lum >= 4000000 and t7.cust_tot_lum < 6000000 then '3.[400万,600万)'
                when t7.cust_tot_lum >= 6000000 and t7.cust_tot_lum < 30000000 then '2.[600万,3000万)'
                when t7.cust_tot_lum >= 30000000 then '1.(3000万及以上)'
                else '未知' end                                                                           -- lum层级
       ,case  when t7.cust_tot_lum >= 0 and  t7.cust_tot_lum < 1000 then '9.[0,1000)'
                when t7.cust_tot_lum >= 1000 and  t7.cust_tot_lum < 50000 then '8.[1000,5万)'
                when t7.cust_tot_lum >= 50000 and  t7.cust_tot_lum < 500000 then '7.[5万,50万)'
                when t7.cust_tot_lum >= 500000 and  t7.cust_tot_lum < 1000000 then '6.[50万,100万)'
                when t7.cust_tot_lum >= 1000000 and  t7.cust_tot_lum < 2000000 then '5.[100万,200万)'
                when t7.cust_tot_lum >= 2000000 and t7.cust_tot_lum< 4000000 then '4.[200万,400万)'
                when t7.cust_tot_lum >= 4000000 and t7.cust_tot_lum < 6000000 then '3.[400万,600万)'
                when t7.cust_tot_lum >= 6000000 and t7.cust_tot_lum < 30000000 then '2.[600万,3000万)'
                when t7.cust_tot_lum >= 30000000 then '1.(3000万及以上)'
                else '未知' end                                                                           -- lum层级_细分
       ,case when t3.dk_hold='1' and t3.hq_ck_hold ='1'  then '持有存款与贷款(TB)'
              when t3.dk_hold='1' and t3.dq_ck_hold ='1'  then '持有存款与贷款(TB)'
              when t3.dk_hold='1' and t3.dq_ck_hold ='1' and t3.hq_ck_hold ='1' then '持有存款与贷款(TB)'
              when t3.hq_ck_hold='1' and t3.dk_hold ='0' and t3.dq_ck_hold='0' and t3.jj_hold='0' and t3.lc_hold='0' and t3.bx_hold='0' then '仅持有的活存状态T(H)'
              when t3.dq_ck_hold='1' and t3.dk_hold ='0' and t3.jj_hold='0' and t3.lc_hold='0' and t3.bx_hold='0' then '仅持有的定存状态T(D)'
              when t3.dq_ck_hold='1' and t3.hq_ck_hold ='1' and t3.dk_hold ='0' and t3.jj_hold='0' and t3.lc_hold='0' and t3.bx_hold='0' then '仅持有的定存状态T(D)'
              when t3.hq_ck_hold ='1' and t3.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3.dq_ck_hold ='1' and t3.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3.hq_ck_hold ='1' and t3.dq_ck_hold ='1' and t3.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3.hq_ck_hold ='1' and t3.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3.dq_ck_hold ='1' and t3.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3.hq_ck_hold ='1' and t3.dq_ck_hold ='1' and t3.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3.hq_ck_hold ='1' and t3.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t3.dq_ck_hold ='1' and t3.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t3.hq_ck_hold ='1' and t3.dq_ck_hold ='1' and t3.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t1.aum_m_avg_bal <10 then '准清零客户状态'
              else '' end                                                                                 -- TIB
       ,case when t3_1.dk_hold='1' and t3_1.hq_ck_hold ='1'  then '持有存款与贷款(TB)'
              when t3_1.dk_hold='1' and t3_1.dq_ck_hold ='1'  then '持有存款与贷款(TB)'
              when t3_1.dk_hold='1' and t3_1.dq_ck_hold ='1' and t3_1.hq_ck_hold ='1' then '持有存款与贷款(TB)'
              when t3_1.hq_ck_hold='1' and t3_1.dk_hold ='0' and t3_1.dq_ck_hold='0' and t3_1.jj_hold='0' and t3_1.lc_hold='0' and t3_1.bx_hold='0' then '仅持有的活存状态T(H)'
              when t3_1.dq_ck_hold='1' and t3_1.dk_hold ='0' and t3_1.jj_hold='0' and t3_1.lc_hold='0' and t3_1.bx_hold='0' then '仅持有的定存状态T(D)'
              when t3_1.dq_ck_hold='1' and t3_1.hq_ck_hold ='1' and t3_1.dk_hold ='0' and t3_1.jj_hold='0' and t3_1.lc_hold='0' and t3_1.bx_hold='0' then '仅持有的定存状态T(D)'
              when t3_1.hq_ck_hold ='1' and t3_1.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3_1.dq_ck_hold ='1' and t3_1.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3_1.hq_ck_hold ='1' and t3_1.dq_ck_hold ='1' and t3_1.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3_1.hq_ck_hold ='1' and t3_1.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3_1.dq_ck_hold ='1' and t3_1.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3_1.hq_ck_hold ='1' and t3_1.dq_ck_hold ='1' and t3_1.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3_1.hq_ck_hold ='1' and t3_1.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t3_1.dq_ck_hold ='1' and t3_1.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t3_1.hq_ck_hold ='1' and t3_1.dq_ck_hold ='1' and t3_1.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t1_1.aum_m_avg_bal <10 then '准清零客户状态'
              else '' end                                                                                  -- 上月TIB
       ,case when t3_2.dk_hold='1' and t3_2.hq_ck_hold ='1'  then '持有存款与贷款(TB)'
              when t3_2.dk_hold='1' and t3_2.dq_ck_hold ='1'  then '持有存款与贷款(TB)'
              when t3_2.dk_hold='1' and t3_2.dq_ck_hold ='1' and t3_2.hq_ck_hold ='1' then '持有存款与贷款(TB)'
              when t3_2.hq_ck_hold='1' and t3_2.dk_hold ='0' and t3_2.dq_ck_hold='0' and t3_2.jj_hold='0' and t3_2.lc_hold='0' and t3_2.bx_hold='0' then '仅持有的活存状态T(H)'
              when t3_2.dq_ck_hold='1' and t3_2.dk_hold ='0' and t3_2.jj_hold='0' and t3_2.lc_hold='0' and t3_2.bx_hold='0' then '仅持有的定存状态T(D)'
              when t3_2.dq_ck_hold='1' and t3_2.hq_ck_hold ='1' and t3_2.dk_hold ='0' and t3_2.jj_hold='0' and t3_2.lc_hold='0' and t3_2.bx_hold='0' then '仅持有的定存状态T(D)'
              when t3_2.hq_ck_hold ='1' and t3_2.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3_2.dq_ck_hold ='1' and t3_2.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3_2.hq_ck_hold ='1' and t3_2.dq_ck_hold ='1' and t3_2.lc_hold = '1' then '持有存款与理财(TI(L))'
              when t3_2.hq_ck_hold ='1' and t3_2.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3_2.dq_ck_hold ='1' and t3_2.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3_2.hq_ck_hold ='1' and t3_2.dq_ck_hold ='1' and t3_2.jj_hold = '1' then '持有存款与基金(TI(J))'
              when t3_2.hq_ck_hold ='1' and t3_2.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t3_2.dq_ck_hold ='1' and t3_2.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t3_2.hq_ck_hold ='1' and t3_2.dq_ck_hold ='1' and t3_2.bx_hold = '1' then '持有存款与基金(TI(J))'
              when t1_2.aum_m_avg_bal <10 then '准清零客户状态'
              else '' end                                                                                   -- 上年TIB
       ,t2.gh_brch_org_id                                                                                   -- 管户分行
       ,t2.mag_cst_mgr_id                                                                                   -- 管户人id
       ,t2.mag_cst_mgr                                                                                      -- 管户人
       ,t2.gh_subbrch_org_id                                                                                -- 管户支行
	   ,t2.mag_cst_org_id                                                                                   -- 管户机构编号
       ,t2.sys_user_id                                                                                      -- 共管人id
       ,t2.sys_user                                                                                         -- 共管人
       ,t13.role_ids                                                                                        -- 共管人角色
       ,' '                                                                                                 -- 共管人角色分类
       ,' '                                                                                                 -- 管户人角色分类
       ,case when t1.aum_m_avg_bal = 0 then '6.零（0）' 
              when t1.aum_m_avg_bal > 0 and t1.aum_m_avg_bal < 10 then '5.长尾客户（0,10)' 
              when t1.aum_m_avg_bal >= 10 and t1.aum_m_avg_bal < 50000 then '4.基础客户[10,5万)' 
              when t1.aum_m_avg_bal >= 50000 and t1.aum_m_avg_bal < 500000 then '3.价值客户[5万,50万)' 
              when t1.aum_m_avg_bal >= 500000 and t1.aum_m_avg_bal < 2000000 then '2.财富客户[50万,200万)' 
              when t1.aum_m_avg_bal >= 2000000 then '1.私钻客户（200万及以上)' end                           -- 客户层级
       ,case when t1.aum_m_avg_bal = 0 then '10.零（0）' 
              when t1.aum_m_avg_bal > 0 and t1.aum_m_avg_bal < 10 then '9.长尾客户（0,10)' 
              when t1.aum_m_avg_bal >= 10 and t1.aum_m_avg_bal < 100 then '8.基础-10元客户[10,100)' 
              when t1.aum_m_avg_bal >= 100 and t1.aum_m_avg_bal < 1000 then '7.基础-百元客户[100,1000)' 
              when t1.aum_m_avg_bal >= 1000 and t1.aum_m_avg_bal < 10000 then '6.基础-千元客户[1000,1万)' 
              when t1.aum_m_avg_bal >= 10000 and t1.aum_m_avg_bal < 50000 then '5.基础-万元客户[1万,5万)' 
              when t1.aum_m_avg_bal >= 50000 and t1.aum_m_avg_bal < 200000 then '4.价值-富裕客户[5万，20万）' 
              when t1.aum_m_avg_bal >= 200000 and t1.aum_m_avg_bal < 500000 then '3.价值-准财富客户[20万，50万）' 
              when t1.aum_m_avg_bal >= 500000 and t1.aum_m_avg_bal < 2000000 then '2.财富客户[50万，200万）' 
              when t1.aum_m_avg_bal >= 2000000 then '1.私钻客户（200万及以上）' end                          -- 客户资产层级_细分
       ,case when t1.aum_m_avg_bal >= 0 and t1.aum_m_avg_bal < 50000 then '7.普通客户[0,5万)'
               when t1.aum_m_avg_bal >= 50000 and t1.aum_m_avg_bal < 500000 then '6.黄金客户[5万,50万)'
               when t1.aum_m_avg_bal >= 500000 and t1.aum_m_avg_bal < 2000000 then '5.白金客户[50万,200万)'
               when t1.aum_m_avg_bal >= 2000000 and t1.aum_m_avg_bal < 4000000 then '4.黑金客户[200万,400万)'
               when t1.aum_m_avg_bal >= 4000000 and t1.aum_m_avg_bal < 6000000 then '3.钻石客户[400万,600万)'
               when t1.aum_m_avg_bal >= 6000000 and t1.aum_m_avg_bal < 30000000 then '2.私人银行客户[600万,3000万)'
               when t1.aum_m_avg_bal >= 30000000 then '1.顶级私人银行客户(3000万及以上)'
               else '未知' end                                                                               -- 权益等级
       ,case when t1.aum_m_avg_bal >= 0 and t1.aum_m_avg_bal < 1000 then '9.普通客户[0,1000)'
               when t1.aum_m_avg_bal >= 1000 and t1.aum_m_avg_bal < 50000 then '8.普通客户[1000,5万)'
               when t1.aum_m_avg_bal >= 50000 and t1.aum_m_avg_bal < 500000 then '7.黄金客户[5万,50万)'
               when t1.aum_m_avg_bal >= 500000 and t1.aum_m_avg_bal < 1000000 then '6.白金客户[50万,100万)'
               when t1.aum_m_avg_bal >= 1000000 and t1.aum_m_avg_bal < 2000000 then '5.白金客户[100万,200万)'
               when t1.aum_m_avg_bal >= 2000000 and t1.aum_m_avg_bal < 4000000 then '4.黑金客户[200万,400万)'
               when t1.aum_m_avg_bal >= 4000000 and t1.aum_m_avg_bal < 6000000 then '3.钻石客户[400万,600万)'
               when t1.aum_m_avg_bal >= 6000000 and t1.aum_m_avg_bal < 30000000 then '2.私人银行客户[600万,3000万)'
               when t1.aum_m_avg_bal >= 30000000 then '1.顶级私人银行客户(3000万及以上)'
               else '未知' end                                                                                   -- 权益等级_细分
       ,case when t14.sleep_acct_flg = '是' then '是' when t14.long_hang_acct_flg = '是' then '是' else '否' end -- 是否睡眠户
       ,t14.long_hang_acct_flg                                                            -- 久悬户标识  
       ,nvl (t7.is_hold_zero_lon,'否')                                                   -- 是否持有零贷
       ,case when t12.mobile_bank_open = '1' then '是' else '否' end                  -- 是否签约手机银行
       ,case when t12.bind_remv_flg = '是' then '是' else '否' end                    -- 是否添加企微
       ,case when t12.if_message_sign = '是' then '是' else '否' end                  -- 是否同意营销短信
       ,case when t12.fin_risk_sign = '1' then '是' else '否' end                     -- 是否签约理财风评
       ,case when t12.quick_pay_bind = '1' then '是' else '否' end                    -- 是否绑定快捷支付
       ,case when t12.wct_bank_bind = '1' then '是' else '否' end                     -- 是否绑定微信银行
       ,case when t2.mag_cst_mgr <> ' ' then '是' else '否' end                       -- 是否真实管户
       ,case when t3.dk_hold = '1' then '是' else '否' end                            -- 是否持有贷款
       ,case when t3.hq_ck_hold = '1' then '是' else '否' end                         -- 是否持有活期
       ,case when t3.dq_ck_hold = '1' then '是' else '否' end                         -- 是否持有定期
       ,case when t3.jj_hold = '1' then '是' else '否' end                            -- 是否持有基金
       ,case when t3.lc_hold = '1' then '是' else '否' end                            -- 是否持有理财
       ,case when t3.bx_hold = '1' then '是' else '否' end                            -- 是否持有保险
       ,case when t3.dsf_hold = '1' then '是' else '否' end                           -- 是否持有三方存管
       ,case when t3.gjs_hold = '1' then '是' else '否' end                           -- 是否持有贵金属
       ,case when t3.zg_hold = '1' then '是' else '否' end                            -- 是否持有资管信托
       ,nvl(t7.is_hold_indv_mortg_loan,'否')                                             -- 是否持有个人按揭性贷款
       ,nvl(t7.is_hold_indv_consm_loan,'否')                                             -- 是否持有个人消费性贷款
       ,nvl(t7.is_hold_indv_opering_loan,'否')                                           -- 是否持有个人经营性贷款
       ,decode(t8.main_guar_way_cd,'D','是','否')                                       -- 主担保方式为信用 
       ,decode(t8.main_guar_way_cd,'C','是','否')                                       -- 主担保方式为保证 
       ,case when t8.main_guar_way_cd in ('A','B','C','D') then '否' else '是' end   -- 主担保方式为其他 
       ,decode(t8.main_guar_way_cd,'A','是','B','是','否')                              -- 主担保方式为抵质押
       ,nvl(t10.dep_ftp_cust_net_inco,0)                                                 -- 存款ftp客户净收入
       ,nvl(t11.loan_ftp_cust_net_inco,0)                                                -- 贷款ftp客户净收入
       ,nvl(t11.loan_tot_risk_cost,0)                                                    -- 贷款总风险成本
       ,nvl(t10.dep_tot_eva,0)                                                           -- 存款总eva
       ,nvl(t11.loan_tot_eva,0)                                                          -- 贷款总eva
       ,nvl(t11.loan_ftp_net_margin,0)                                                   -- 贷款ftp净利润
       ,nvl(t10.dep_ftp_net_margin,0)                                                    -- 存款ftp净利润
       ,nvl(t9.inter_income_amt,0)                                                       -- 中收营收
       ,t2.occupation                                                                     -- 职业
       ,t22.cd_descb                                                                      -- 职业名称
       ,t2.industry                                                                       -- 行业
       ,t21.indus_categy_name                                                             -- 行业名称
       ,t12.kqhf                                                                          -- 客群
       ,t2.fim_income                                                                     -- 家庭月收入
       ,t2.per_income                                                                     -- 个人月收入
       ,t2.age                                                                            -- 年龄
       ,t2.sex                                                                            -- 性别
       ,t17.prov_cd                                                                       -- 省代码
       ,t20.prov_name                                                                     -- 省名称
       ,t17.city_cd                                                                       -- 城市代码
       ,t19.city_name                                                                     -- 城市名称
       ,t17.rg_county_cd                                                                  -- 区县代码
       ,t18.rg_name                                                                       -- 地区名称
       ,' '                                                                               -- 渠道标签-二级
       ,' '                                                                               -- 渠道标签-三级
       ,nvl(t6.eqty_exch_cnt,0)                                                          -- 权益星兑换次数
       ,nvl(t6.eqty_exch_score,0)                                                        -- 权益星兑换分数
       ,nvl(t5.point_exch_cnt,0)                                                         -- 积分兑换次数
       ,nvl(t5.point_exch_score,0)                                                       -- 积分兑换分数
       ,nvl(t4.half_y_tran_in_cnt,0)                                                     -- 近半年转入笔数
       ,nvl(t4.half_y_tran_in_amt,0)                                                     -- 近半年转入金额
       ,nvl(t4.half_y_tran_out_cnt,0)                                                    -- 近半年转出笔数
       ,nvl(t4.half_y_tran_out_amt,0)                                                    -- 近半年转出金额
       ,nvl(t4.half_y_bigamt_tran_in_cnt,0)                                              -- 近半年大额转入笔数
       ,nvl(t4.half_y_bigamt_tran_in_amt,0)                                              -- 近半年大额转入金额
       ,nvl(t4.half_y_bigamt_tran_out_cnt,0)                                             -- 近半年大额转出笔数
       ,nvl(t4.half_y_bigamt_tran_out_amt,0)                                             -- 近半年大额转出金额
       ,nvl(t23.half_y_mbank_prod_cnt,0)                                                 -- 近半年手机银行产品交互次数
       ,nvl(t23.half_y_cnter_prod_cnt,0)                                                 -- 近半年柜面产品交互次数
       ,nvl(t23.half_y_atm_cnt,0)                                                        -- 近半年atm交互次数
       ,nvl(t23.half_y_onl_bank_prod_cnt,0)                                              -- 近半年网上银行产品交互次数
       ,nvl(t23.half_y_other_chn_prod_cnt,0)                                             -- 近半年其他渠道产品交互次数
       ,nvl(t24.hxc_contact_cnt,0)                                                       -- 近半年企微触达次数
       ,nvl(t24.pho_contact_cnt,0)                                                       -- 近半年录音电话触达次数
       ,nvl(t24.wxd_contact_cnt,0)                                                       -- 近半年个人微信触达次数
       ,nvl(t24.iph_contact_cnt,0)                                                       -- 近半年个人电话触达次数
       ,nvl(t24.ins_contact_cnt,0)                                                       -- 近半年面访触达次数
       ,'bdws'                                                                             -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                   -- etl处理时间戳
 from ${iol_schema}.bdws_a_cm_aum_info t1
 left join ${iol_schema}.bdws_a_cm_aum_info t1_1   --上月末
   on t1.cust_id=t1_1.cust_id
  and t1_1.etl_dt =to_date('${last_month_end}','yyyymmdd')
 left join ${iol_schema}.bdws_a_cm_aum_info t1_2  --上年同期
   on t1.cust_id=t1_2.cust_id
  and t1_2.etl_dt =last_day(add_months(to_date('${batch_date}','yyyymmdd'),-12))
 left join ${iol_schema}.bdws_a_cm_cust t2
   on t1.cust_id=t2.cust_id
  and t2.etl_dt =to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.bdws_a_cm_hold t3
   on t1.cust_id=t3.cust_id
  and t3.etl_dt =to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.bdws_a_cm_hold t3_1   --上月末
   on t1.cust_id=t3_1.cust_id
  and t3_1.etl_dt =to_date('${last_month_end}','yyyymmdd')
 left join ${iol_schema}.bdws_a_cm_hold t3_2   --上年同期
   on t1.cust_id=t3_2.cust_id
  and t3_2.etl_dt =last_day(add_months(to_date('${batch_date}','yyyymmdd'),-12))
 left join ${idl_schema}.dmm_retl_cust_portrait_info_ex01 t4
   on t1.cust_id=t4.cust_id
 left join (select cust_id, count(1) as point_exch_cnt, sum(txn_bonus) as point_exch_score 
                  from ${iol_schema}.pbms_tbl_bonus_plan_txn 
                 where bonus_plan_type = 'P' 
                   and txn_type ='2' 
                 group by cust_id) T5
   on t1.cust_id=t5.cust_id
 left join (select cust_id, count(1) as eqty_exch_cnt, sum(txn_bonus) as eqty_exch_score 
                  from ${iol_schema}.pbms_tbl_bonus_plan_txn 
                 where bonus_plan_type = 'X' 
                   and txn_type ='2' 
                  group by cust_id) t6
 on t1.cust_id=t6.cust_id
 left join ${idl_schema}.dmm_retl_cust_portrait_info_ex03 t7
   on t1.cust_id=t7.cust_id
 left join (select t.*,row_number() over(partition by cust_id order by curr_bal desc) as rn
                  from (select cust_id,main_guar_way_cd,sum(curr_bal)  as curr_bal
                            from ${iml_schema}.agt_loan_dubil_info_h 
                           where start_dt <= to_date('${batch_date}','yyyymmdd')
                              and end_dt > to_date('${batch_date}','yyyymmdd')
                              and curr_bal >0
                              and job_cd ='icmsf1'
                           group by cust_id,main_guar_way_cd) t) t8
 on t1.cust_id=t8.cust_id
 and t8.rn=1
 left join (select substr (cust_no,1,10) as cust_id
                       ,sum(share_tran_amt_sl_m) as inter_income_amt
                 from ${iol_schema}.cass_r_rpt_rst6202_inc
                where etl_dt >= last_day(trunc(to_date('${batch_date}','yyyymmdd'),'yyyy'))  --取每年第一个月末
                  and etl_dt <= to_date('${batch_date}','yyyymmdd')
                  and bus_line ='2_零售条线'
               group by substr (cust_no,1,10)) t9
 on t1.cust_id=t9.cust_id
 left join (select substr (cust_no,1,10) as cust_id
                        ,sum(share_ftp_net_income) as dep_ftp_cust_net_inco
                        ,sum(share_eva) as dep_tot_eva
                        ,sum(ftp_net_profit) as dep_ftp_net_margin
                  from ${iol_schema}.cass_r_rpt_rst6202_liabilitie
                where etl_dt >= last_day(trunc(to_date('${batch_date}','yyyymmdd'),'yyyy'))  --取每年第一个月末
                  and etl_dt <= to_date('${batch_date}','yyyymmdd')
                  and bus_line ='2_零售条线'
                group by substr (cust_no,1,10)) t10
 on t1.cust_id=t10.cust_id
 left join (select substr (cust_no,1,10) as cust_id
                       ,sum(share_ftp_net_income) as loan_ftp_cust_net_inco
                       ,sum(asset_impair_loss) as loan_tot_risk_cost
                       ,sum(share_eva) as loan_tot_eva
                       ,sum(ftp_net_profit) as loan_ftp_net_margin
                 from ${iol_schema}.cass_r_rpt_rst6202_asset
                where etl_dt >= last_day(trunc(to_date('${batch_date}','yyyymmdd'),'yyyy'))  --取每年第一个月末
                 and etl_dt <= to_date('${batch_date}','yyyymmdd')
                 and bus_line ='2_零售条线'
               group by substr (cust_no,1,10)) t11
  on t1.cust_id=t11.cust_id
 left join ${iol_schema}.bdws_a_chnl_process_index_statis t12
   on t1.cust_id=t12.cust_id
  and t12.etl_dt =to_date('${batch_date}','yyyymmdd')
  and t12.execut_type ='1'
 left join ${iol_schema}.bdws_a_cm_cust_clerk_mapping t13
   on t1.cust_id=t13.cust_id
  and t13.etl_dt =to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.bdws_a_cm_cust_nmb_login t14
   on t1.cust_id=t14.cust_id
  and t14.etl_dt =to_date('${batch_date}','yyyymmdd')
 left join (select cust_id,min(open_acct_dt) as open_acct_dt 
                   from ${icl_schema}.cmm_dep_cust_acct_info 
                  where etl_dt = to_date('${batch_date}', 'yyyymmdd') 
                  group by cust_id) t15
   on t1.cust_id=t15.cust_id
/*  left join (select t2.party_id,count (*) as half_y_indv_tel_arrive_cnt
                   from ${iol_schema}.ccdb_log_ivr_comm c
                  inner join ${iml_schema}.pty_tel_info_h t2
                      on c.receive_no=t2.tel_num
                     and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
                     and t2.end_dt > to_date('${batch_date}','yyyymmdd')
                     and t2.job_cd ='eifsf1'
                  where c.call_in_time between to_date('${batch_date}','yyyymmdd')-180 and to_date('${batch_date}','yyyymmdd') 
                  group by  t2.party_id）t16
  on t1.cust_id=t16.party_id */
 left join ${iml_schema}.pty_party_phys_addr_h t17
   on t1.cust_id=t17.party_id
  and t17.phys_addr_type_cd='02'    --户籍地址
  and t17.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t17.end_dt > to_date('${batch_date}','yyyymmdd')
  and t17.job_cd ='eifsf1'
 left join (select rg_cd,rg_name from ${iml_schema}.ref_dist_cd where trim(rg_cd) is not null group by rg_cd,rg_name) t18   --地区代码
  on t18.rg_cd=t17.rg_county_cd
 left join (select city_cd,city_name from ${iml_schema}.ref_dist_cd where trim(city_cd) is not null group by city_cd,city_name) t19   --城市代码
  on t19.city_cd=t17.city_cd
 left join (select prov_cd,prov_name from ${iml_schema}.ref_dist_cd where trim(prov_cd) is not null group by prov_cd,prov_name) t20   --省代码
  on t20.prov_cd=t17.prov_cd
  left join (select indus_categy_cd,indus_categy_name from ${iml_schema}.ref_indus_type_cd group by indus_categy_cd,indus_categy_name) t21
  on t21.indus_categy_cd=t2.industry 
  left join ${iml_schema}.ref_pub_cd t22
  on t22.cd_val=t2.occupation
  and t22.cd_id ='CD1591'
 left join ${idl_schema}.dmm_retl_cust_portrait_info_ex02 t23
   on t1.cust_id=t23.cust_id
 left join (select t1.cust_id   as cust_id
                     ,sum(case when t1.contact_channel = '1' and bt.hang_up_cause_cd = '1' then 1 else 0 end) as pho_contact_cnt     --录音电话次数
                     ,sum(case when t1.contact_channel = '7' then 1 else 0 end) as iph_contact_cnt     --个人电话次数
                     ,sum(case when t1.contact_channel = '6' and (t1.yd_num = '1' or trim(t1.yd_num) is null) then 1 else 0 end) as hxc_contact_cnt     --华兴云店次数（企微）
                     ,sum(case when t1.contact_channel = '4' then 1 else 0 end) as ins_contact_cnt     --面访次数
                     ,sum(case when t1.contact_channel = '3' then 1 else 0 end) as wxd_contact_cnt     --微信次数
                from ${iol_schema}.bdws_b_t_cm_contact t1
                left join ${iol_schema}.bdws_b_t_cm_contact_call bt 
                  on  t1.contact_id = bt.contact_id 
                 and bt.etl_dt = to_date('${batch_date}','yyyymmdd')
               where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
                 and t1.leave_sts = '3'
                 and t1.contact_channel in ('1','3','4','6','7')
                 and to_date(trim(t1.contact_dt),'yyyy-mm-dd')  between to_date('20260331','yyyymmdd') -180  and to_date('20260331','yyyymmdd')
               group by t1.cust_id )t24 
on t1.cust_id=t24.cust_id
left join ${iol_schema}.bdws_a_cust_acct_status_flg t25
  on t1.cust_id=t25.cust_id
-- and t25.etl_dt =to_date('${batch_date}','yyyymmdd')
 where 1=1
  and t1.etl_dt =to_date('${batch_date}','yyyymmdd');
commit;

-- 2.2 exchage ex table and target table
alter table ${idl_schema}.dmm_retl_cust_portrait_info exchange partition p_${batch_date} with table ${idl_schema}.dmm_retl_cust_portrait_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dmm_retl_cust_portrait_info_ex purge;
--drop table ${idl_schema}.tmp_dmm_retl_cust_portrait_info_01 purge;
--drop table ${idl_schema}.tmp_dmm_retl_cust_portrait_info_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dmm_retl_cust_portrait_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
