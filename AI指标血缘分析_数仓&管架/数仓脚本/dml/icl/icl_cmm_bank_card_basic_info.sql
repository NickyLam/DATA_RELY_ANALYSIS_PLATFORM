/*
Purpose:    共性加工层-银行卡基本信息：包括我行借记卡、贷记卡、虚拟卡的基本信息。数据来源于新核心系统NCBS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_bank_card_basic_info
Createdate: 20220309
Logs:       20220309 李森辉 1、调整取数源，由旧核心系统调整到新核心系统取数
            20220401 李森辉 1、新增字段【卡BIN】
                            2、调整字段【卡名称、启用标志、虚拟卡标志、卡等级代码】的取数口径
                            3、置空字段【凭证管理编号-VOUCH_MGMT_ID、写磁控制编号-MAGT_CTRL_ID、使用分行范围-USE_BRCH_RANGE】
            20220429 李森辉 1、调整字段【凭证管理编号、写磁控制编号、启用标志】的取数口径
                            2、新增字段【标准产品编号、主卡卡号、附属卡标志、单位结算卡标志、卡折合一标志、记名卡标志、发卡机构编号、发卡柜员编号、发卡日期、销卡柜员编号、销卡日期、销卡原因描述、换卡次数、制卡申请编号】
            20220519 李森辉 1、调整字段【持卡人名称、持卡人证件类型代码、持卡人证件号码、最后交易日期、最后交易流水、最后脱机交易日期、脱机交易总金额、余额上限、单笔现金交易限额、累计圈存金额、当前余额】的加工口径；
                            2、置空字段【自动圈存阀值、自动圈存金额、累计圈提金额】
			      20220608 温旺清 修改表名iml.evt_make_card_appl_rgst_b -->iml.agt_make_card_appl_info_h 以及其算法	
            20220714 温旺清	调整字段名称【附属卡标志 SUPP_CARD_FLG -》 主卡标志MAIN_CARD_FLG】并调整加工口径							
			      20221123 翟若平 调整字段【虚拟卡标志】的加工口径
            20230128 温旺清 1.调整【制卡流水号、制卡日期】取数逻辑；
                            2.取消关联NCBS_CD_MAKE_CARD_REG，该表存放制卡信息，但是发行了的卡不在该表，即NCBS_CD_CARD_ARCH跟该表无法关联。
			      20240704 陈伟峰 新增字段【失效日期密文】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bank_card_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bank_card_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bank_card_basic_info_ex purge;

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_bank_card_basic_info_01 purge;
drop table ${icl_schema}.tmp_cmm_bank_card_basic_info_02 purge;
drop table ${icl_schema}.tmp_cmm_bank_card_basic_info_03 purge;

-- 1.3 insert data to tmp table
-- 获取产品定义属性信息（卡BIN、启用标志、虚拟卡标志、卡等级代码等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bank_card_basic_info_01
nologging
compress ${option_switch} for query high
as
select t2.prod_id
       ,max(decode(t2.attr_key, 'CD_TYPE', t2.attr_val, '')) as cd_type_value -- 卡类型
       ,max(decode(t2.attr_key, 'CD_CARD_BIN', t2.attr_val, '')) as cd_card_bin_value -- 卡BIN
       ,max(decode(t2.attr_key, 'CD_VALID_FLAG', t2.attr_val, '')) as cd_valid_flag_value -- 有效标志
  from (select t1.prod_id
               ,t1.attr_key
               ,t1.attr_val
               ,t1.seq_num
               ,row_number() over(partition by t1.prod_id, t1.attr_key order by t1.seq_num desc) rn
          from ${iml_schema}.prd_prod_def_h t1
         where t1.prod_status_cd = '1'
           and trim(t1.attr_key) is not null
           and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
           and t1.job_cd = 'ncbsf1') t2
 where t2.rn = 1
 group by t2.prod_id
;

-- 获取IC卡流水信息（最后交易日期、最后交易流水等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bank_card_basic_info_02
nologging
compress ${option_switch} for query high
as
select t1.card_no
       ,t1.ova_flow_num
       ,t1.plat_tran_dt
       ,row_number() over(partition by t1.card_no order by t1.plat_tran_dt desc) rn
  from ${iml_schema}.evt_ic_card_tran_flow t1
 where t1.plat_tran_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
;

-- 获取IC卡脱机交易交易流水信息（最后脱机交易日期、脱机交易总金额等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bank_card_basic_info_03
nologging
compress ${option_switch} for query high
as
select t1.card_no
       ,max(t1.plat_tran_dt) as tran_date
       ,sum(t1.tran_amt) as tran_amt
  from ${iml_schema}.evt_ic_card_offline_tran_flow t1
 where t1.plat_tran_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
 group by t1.card_no
;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bank_card_basic_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_bank_card_basic_info where 0=1;

--第一组（共一组）核心系统
-- 2.2 insert into ex
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bank_card_basic_info_ex(
       etl_dt                      -- 数据日期
       ,lp_id                      -- 法人编号
       ,card_no                    -- 卡号
       ,card_bin                   -- 卡BIN
       ,main_card_card_no          -- 主卡卡号
       ,vouch_no                   -- 凭证号码
       ,vouch_mgmt_id              -- 凭证管理编号
       ,nc_card_no                 -- 无校验位卡号
       ,magt_ctrl_id               -- 写磁控制编号
       ,std_prod_id                -- 标准产品编号
       ,card_name                  -- 卡名称
       ,cust_id                    -- 客户编号
       ,start_use_flg              -- 启用标志
       ,vtual_card_flg             -- 虚拟卡标志
	     ,main_card_flg              -- 主卡标志
       ,corp_stl_card_flg          -- 单位结算卡标志
       ,card_psbook_merge_one_flg  -- 卡折合一标志
       ,nomi_card_flg              -- 记名卡标志
       ,vouch_kind_cd              -- 凭证种类代码
       ,card_type_cd               -- 卡种类代码
       ,co_card_type_cd            -- 合作卡类型代码
       ,card_status_cd             -- 卡状态代码
       ,card_level_cd              -- 卡等级代码
       ,make_card_appl_id          -- 制卡申请编号
       ,make_card_flow_num         -- 制卡流水号
       ,make_card_dt               -- 制卡日期
       ,effect_dt                  -- 生效日期
       ,invalid_dt                 -- 失效日期
       ,invalid_dt_pwd             -- 失效日期密文
       ,card_iss_org_id            -- 发卡机构编号
       ,card_iss_teller_id         -- 发卡柜员编号
       ,card_iss_dt                -- 发卡日期
       ,pin_card_teller_id         -- 销卡柜员编号
       ,pin_card_dt                -- 销卡日期
       ,pin_card_rs_descb          -- 销卡原因描述
       ,change_card_cnt            -- 换卡次数
       ,use_brch_range             -- 使用分行范围
       ,card_holder_name           -- 持卡人名称
       ,card_holder_cert_type_cd   -- 持卡人证件类型代码
       ,card_holder_cert_no        -- 持卡人证件号码
       ,final_tran_dt              -- 最后交易日期
       ,final_tran_flow            -- 最后交易流水
       ,final_offline_tran_dt      -- 最后脱机交易日期
       ,offline_tran_tot_amt       -- 脱机交易总金额
       ,bal_uplmi                  -- 余额上限
       ,sig_cash_tran_lmt          -- 单笔现金交易限额
       ,auto_load_tshold           -- 自动圈存阀值
       ,auto_load_amt              -- 自动圈存金额
       ,acm_load_amt               -- 累计圈存金额
       ,acm_unload_amt             -- 累计圈提金额
       ,curr_bal                   -- 当前余额
       ,job_cd                     -- 任务代码
       ,etl_timestamp              -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                       -- 数据日期
       ,t1.lp_id                                                                 -- 法人编号
       ,t1.card_no                                                               -- 卡号
       ,t6.cd_card_bin_value                                                     -- 卡BIN
       ,t1.main_card_card_no                                                     -- 主卡卡号
       ,nvl(t2.vouch_no,'-')                                                     -- 凭证号码
       ,'A00'                                                                    -- 凭证管理编号
       ,substr(t1.card_no,1,18)                                                  -- 无校验位卡号
       ,t1.card_cvn_info                                                         -- 写磁控制编号
       ,t1.card_prod_id                                                          -- 标准产品编号
       ,t5.prod_name                                                             -- 卡名称
       ,t1.cust_id                                                               -- 客户编号
       ,case when t1.bank_card_status_cd in ('1', '2') then '0' else '1' end     -- 启用标志
       ,decode(t1.card_med_type_cd, '2', '1','0')                                -- 虚拟卡标志
       ,decode(t1.supp_card_flg, '1', '0', '1')                                  -- 主卡标志
       ,t1.stl_card_flg                                                          -- 单位结算卡标志
       ,t1.card_psbook_merge_flg                                                 -- 卡折合一标志
       ,t1.nomi_card_flg                                                         -- 记名卡标志
       ,t2.dep_vouch_cate_cd                                                     -- 凭证种类代码
       ,t1.card_med_type_cd                                                      -- 卡种类代码
       ,t3.card_type_cd                                                          -- 合作卡类型代码
       ,t1.bank_card_status_cd                                                   -- 卡状态代码
       ,decode(t6.cd_type_value, '22', '1','66', '2', '88','3', '99', '4', '0')  -- 卡等级代码
       ,t1.appl_id                                                               -- 制卡申请编号
       ,t1.appl_id                                                               -- 制卡流水号
       ,t1.card_iss_dt                                                           -- 制卡日期
       ,t1.effect_dt                                                             -- 生效日期
       ,t1.invalid_dt                                                            -- 失效日期
       ,t12.valid_thru_date_pwd                                                  -- 失效日期密文
       ,t1.card_iss_org_id                                                       -- 发卡机构编号
       ,t1.card_iss_teller_id                                                    -- 发卡柜员编号
       ,t1.card_iss_dt                                                           -- 发卡日期
       ,t1.pin_card_teller_id                                                    -- 销卡柜员编号
       ,t1.pin_card_dt                                                           -- 销卡日期
       ,t1.pin_card_rs                                                           -- 销卡原因描述
       ,t1.change_card_cnt                                                       -- 换卡次数
       ,''                                                                       -- 使用分行范围
       ,t7.party_name                                                            -- 持卡人名称
       ,t8.cert_type_cd                                                          -- 持卡人证件类型代码
       ,t8.cert_num                                                              -- 持卡人证件号码
       ,t9.plat_tran_dt                                                          -- 最后交易日期
       ,t9.ova_flow_num                                                          -- 最后交易流水
       ,t10.tran_date                                                            -- 最后脱机交易日期
       ,t10.tran_amt                                                             -- 脱机交易总金额
       ,t11.elec_cash_bal_uplmi                                                  -- 余额上限
       ,t11.elec_cash_sig_tran_lmt                                               -- 单笔现金交易限额
       ,''                                                                       -- 自动圈存阀值
       ,''                                                                       -- 自动圈存金额
       ,t11.acm_load_amt                                                         -- 累计圈存金额
       ,''                                                                       -- 累计圈提金额
       ,t11.elec_cash_acct_bal                                                   -- 当前余额
       ,t1.job_cd                                                                -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')          -- 数据处理时间
  from ${iml_schema}.agt_card_basic_info_h t1
  left join ${iml_schema}.agt_vouch_acct_rela_h t2
    on t1.card_no = t2.card_no
   and t1.sub_acct_num = t2.sub_acct_num
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'ncbsf1'
   and t2.vouch_status_cd not in ('DES', 'CAN', 'LCB')
  left join ${iml_schema}.ref_card_bin_para_h t3
    on substr(t1.card_no, 1, 6) = t3.card_bin_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'
  /*left join ${iml_schema}.agt_make_card_appl_info_h t4
    on t1.appl_id = t4.appl_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ncbsf1'*/
  left join ${iml_schema}.prd_std_prod_info_h t5
    on t1.card_prod_id = t5.prod_id
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'ncbsf1'
  left join ${icl_schema}.tmp_cmm_bank_card_basic_info_01 t6
    on t1.card_prod_id = t6.prod_id
  left join ${iml_schema}.pty_party_name_h t7
    on t1.cust_id = t7.party_id
   and t7.party_name_type_cd = '01'
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd='eifsf1'
  left join ${iml_schema}.pty_party_cert_info_h t8
    on t7.party_id = t8.party_id
   and t8.sorc_sys_cd='EIFS'
   and t8.main_cert_no_flg = '1'
   and t8.cert_valid_flg = '1'   --过滤测试数据 modify by wwq at 29-9月 -22 15.07.54.872659 下午
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'eifsf1'
  left join ${icl_schema}.tmp_cmm_bank_card_basic_info_02 t9
    on t1.card_no = t9.card_no
   and t9.rn = 1
  left join ${icl_schema}.tmp_cmm_bank_card_basic_info_03 t10
    on t1.card_no = t10.card_no
  left join ${iml_schema}.agt_ic_card_elec_cash_acct_h t11
    on t1.card_no = t11.card_no
   and t11.elec_cash_acct_status_cd = 'A'
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'ncbsf1'
   left join ${iol_schema}.ncbs_cd_card_arch t12
    on t12.card_no=t1.card_no
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1';
commit;

-- 2.5 exchage ex table and target table
alter table ${icl_schema}.cmm_bank_card_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bank_card_basic_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_bank_card_basic_info_ex purge;
drop table ${icl_schema}.tmp_cmm_bank_card_basic_info_01 purge;
drop table ${icl_schema}.tmp_cmm_bank_card_basic_info_02 purge;
drop table ${icl_schema}.tmp_cmm_bank_card_basic_info_03 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bank_card_basic_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);