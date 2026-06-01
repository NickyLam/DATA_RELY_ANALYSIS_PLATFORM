/*
purpose:    共性加工层-对公客户股东信息：对公客户股东信息，包含我行所有对公客户的股东信息；数据来源于EIFS系统和对公信贷系统（ICMS）。
author:     sunline
usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_corp_cust_shard_info
createdate: 20201013
logs:       20201013新建模型->更新2.0
            20210427 陈伟峰 调整eifs组过滤条件，去掉状态代码过滤
            20210701 何桐金 新增字段【出资人类型代码、出资人身份类别代码】
            20220610 李森辉 1、调整字段【国家和地区代码】的加工口径；
                            2、调整第二组的取数数据源，由原对公信贷系统调整为综合信贷系统
			      20220708 温旺清 1、调整第三组临时表T1的过滤条件【删除T1.RELATIONSHIP LIKE '52%' AND LENGTH(T1.RELATIONSHIP) > 2】
                            2、调整第三组T2的关联类型为【LEFT JOIN -》 INNER JOIN】
                            3、调整第三组T4的关联类型为【 INNER JOIN -》LEFT JOIN】
			      20220718 温旺清 1、调整第三组【出资方式代码】加工口径
			      20220813 曹永茂 1、调整第二组【股东类型代码】加工口径
            20220805 温旺清 1、新增字段【更新日期】，优先取信贷系统
			      20220913 温旺清 1、由于新信贷关联人客户不迁移到customer_info表，因此删除内关联的customer_info表
			      20220921 曹永茂 1、置空第二组信贷的字段【股东客户编号、本行股东标志】
			                      2、调整字段【关联人编号、国家和地区代码】取数口径，原根据客户号取相关信息，新一代后从关联人表取相关信息
            20221008 温旺清 【合版】新增关系代码40101-控股股东、新增主键【关联人编号RELA_PS_ID】
            20230307 温旺清 信贷与ECIF整合部分关联条件取主键进行关联
            20230315 温旺清 新增字段【来源系统代码】
            20230404 陈伟峰 调整字段【持股比例,股东组织机构代码,股东营业执照编号,统一社会信用代码,股东关联人编号,自然人股东证件类型代码,自然人股东证件号码,股东类型代码,股东名称】取数逻辑，仅取ECIF
            20240902 陈伟峰 新增字段【股东出资比例、股东持股数量】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_cust_shard_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_cust_shard_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_corp_cust_shard_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_cust_shard_info_ex purge;
drop table ${icl_schema}.cmm_corp_cust_shard_info_ex01 purge;
drop table ${icl_schema}.cmm_corp_cust_shard_info_ex02 purge;

-- 2.1 create temporary table cmm_corp_cust_shard_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_shard_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_shard_info where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_shard_info_ex01
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_shard_info where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_shard_info_ex02
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_shard_info where 0=1;
-- 2.2 insert into data to temporary table cmm_corp_cust_shard_info_ex

--第一组（共二组）ecif股东信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_shard_info_ex01(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,cust_id                        -- 客户编号
       ,shard_cust_id                  -- 股东客户编号
       ,rela_ps_id                     -- 关联人编号
       ,shard_name                     -- 股东名称
       ,shard_type_cd                  -- 股东类型代码
       ,shard_orgnz_type_cd            -- 股东组织机构类型代码
       ,shard_local_nation_cd          -- 国家和地区代码
       ,shard_orgnz_cd                 -- 股东组织机构代码
       ,shard_bus_lics_id              -- 股东营业执照编号
       ,contrior_econ_compnt_cd        -- 企业出资人经济成分代码
       ,nature_ps_shard_cert_type_cd   -- 自然人股东证件类型代码
       ,nature_ps_shard_cert_no        -- 自然人股东证件号码
       ,ghb_shard_flg                  -- 本行股东标志
       ,unify_soci_crdt_cd             -- 统一社会信用代码
       ,share_ratio                    -- 持股比例
       ,shard_hold_shares_qtty         -- 股东持股数量
       ,shard_contri_ratio             -- 股东出资比例
       ,contri_way_cd                  -- 出资方式代码
       ,contri_curr_cd                 -- 出资币种代码
       ,contri_amt                     -- 出资金额
       ,contrior_type_cd               -- 出资人类型代码
       ,contrior_idti_cate_cd          -- 出资人身份类别代码
       ,hold_dt                        -- 入股日期
       ,shard_valid_flg                -- 股东有效标志
       ,actl_ctrler_flg                -- 实际控制人标志
	     ,update_dt                      -- 更新日期
       ,src_sys_cd                     -- 来源系统代码
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                             -- 数据日期
       ,t1.lp_id                                                                       -- 法人编号
       ,t1.party_id                                                                    -- 客户编号
       ,nvl(trim(t2.src_party_id),t1.rela_party_id)                                    -- 股东客户编号
       ,t1.rela_party_id                                                               -- 关联人编号
       ,t2.party_name                                                                  -- 股东名称
       ,nvl(t3.shard_type_cd,t8.shard_type_cd)                                         -- 股东类型代码
       ,''                                                                             -- 股东组织机构类型代码
       ,t8.cty_rg_cd                                                                   -- 国家和地区代码
       ,t6.organ_num                                                                   -- 股东组织机构代码
       ,t6.oper_licence_num                                                            -- 股东营业执照编号
       ,''                                                                             -- 企业出资人经济成分代码
       ,t7.cert_type_cd                                                                -- 自然人股东证件类型代码
       ,t7.cert_num                                                                    -- 自然人股东证件号码
       ,''                                                                             -- 本行股东标志
       ,t6.bus_lics_num                                                                -- 统一社会信用代码
       ,nvl(t3.share_ratio,t8.share_ratio)                                             -- 持股比例
       ,nvl(t4.hold_stock_amount,t5.hold_stock_amount)                                 -- 股东持股数量
       ,nvl(t4.contri_ratio,t5.contri_ratio)                                           -- 股东出资比例
       ,''                                                                             -- 出资方式代码
       ,'CNY'                                                                          -- 出资币种代码
       ,0                                                                              -- 出资金额     --nvl(trim(t1.contri_amt), 0)
       ,''                                                                             -- 出资人类型代码
       ,''                                                                             -- 出资人身份类别代码
       ,''                                                                             -- 入股日期
       ,t1.valid_flg                                                                   -- 股东有效标志
       ,''                                                                             -- 实际控制人标志
	     ,t15.imp_dt                                                                     -- 更新日期
       ,'EIFS'                                                                         -- 来源系统代码
       ,t1.job_cd                                                                      -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                -- etl处理时间戳
  from ${iml_schema}.pty_party_rela_h t1
  left join ${iml_schema}.pty_party t2
    on t1.rela_party_id = t2.party_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'eifsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.pty_indv t3
    on t2.party_id = t3.party_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'eifsf1'
  left join ${iol_schema}.eifs_t01_corp_rel_corp_info t4
    on t1.rela_party_id = t4.rel_enterp_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.updated_ts=to_date('99991231', 'yyyymmdd')
  left join ${iol_schema}.eifs_t01_corp_rel_per_info t5
    on t1.rela_party_id = t5.rel_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.updated_ts=to_date('99991231', 'yyyymmdd')
  left join (select cc.party_id,
                    max(decode(cc.cert_type_cd, '2020', cc.cert_num)) organ_num,
                    max(decode(cc.cert_type_cd, '2010', cc.cert_num)) oper_licence_num,
                    max(decode(cc.cert_type_cd, '2313', cc.cert_num)) bus_lics_num
               from ${iml_schema}.pty_party_cert_info_h cc
              where cc.main_cert_no_flg = '1'
                and cc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and cc.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and cc.job_cd = 'eifsf1'
              group by cc.party_id) t6
    on t1.rela_party_id = t6.party_id
  left join (select ci.*,
                    row_number() over(partition by ci.party_id order by nvl(trim(main_cert_no_flg), '0') desc, ci.cert_effect_dt desc) rn
               from ${iml_schema}.pty_party_cert_info_h ci
              where ci.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and ci.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and ci.job_cd = 'eifsf1') t7
    on t1.rela_party_id = t7.party_id
   and t7.rn = 1
  left join ${iml_schema}.pty_corp t8
    on t2.party_id = t8.party_id
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'eifsf1'
/*    left join ${iml_schema}.pty_party_status_h t13
        on t1.party_id = t13.party_id
     and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'eifsf1'*/
  left join ${iml_schema}.pty_party_imp_dt_h t15
    on t1.rela_party_id = t15.party_id
   and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t15.end_dt > to_date('${batch_date}','yyyymmdd')
   and t15.job_cd = 'eifsf1'
 where t1.party_rela_type_cd in('40100','40101')
--   and t1.valid_flg = '1'
--    and t13.party_status_cd = 'A'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'eifsf1';

commit;

--第二组（共二组）对公信贷股东信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_shard_info_ex02(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,cust_id                        -- 客户编号
       ,shard_cust_id                  -- 股东客户编号
       ,rela_ps_id                     -- 关联人编号
       ,shard_name                     -- 股东名称
       ,shard_type_cd                  -- 股东类型代码
       ,shard_orgnz_type_cd            -- 股东组织机构类型代码
       ,shard_local_nation_cd          -- 国家和地区代码
       ,shard_orgnz_cd                 -- 股东组织机构代码
       ,shard_bus_lics_id              -- 股东营业执照编号
       ,contrior_econ_compnt_cd        -- 企业出资人经济成分代码
       ,nature_ps_shard_cert_type_cd   -- 自然人股东证件类型代码
       ,nature_ps_shard_cert_no        -- 自然人股东证件号码
       ,ghb_shard_flg                  -- 本行股东标志
       ,unify_soci_crdt_cd             -- 统一社会信用代码
       ,share_ratio                    -- 持股比例
       ,shard_hold_shares_qtty         -- 股东持股数量
       ,shard_contri_ratio             -- 股东出资比例
       ,contri_way_cd                  -- 出资方式代码
       ,contri_curr_cd                 -- 出资币种代码
       ,contri_amt                     -- 出资金额
       ,contrior_type_cd               -- 出资人类型代码
       ,contrior_idti_cate_cd          -- 出资人身份类别代码
       ,hold_dt                        -- 入股日期
       ,shard_valid_flg                -- 股东有效标志
       ,actl_ctrler_flg                -- 实际控制人标志
       ,update_dt                      -- 更新日期
       ,src_sys_cd                     -- 来源系统代码
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                               -- 数据日期
       ,'9999'                                                                           -- 法人编号
       ,t1.customerid                                                                    -- 客户编号
       ,''                                                                               -- 股东客户编号
       ,t2.serialno                                                                      -- 关联人编号
       ,t2.customername                                                                  -- 股东名称
       ,(case when t2.certType like '2%' then '1' else '6' end)                          -- 股东类型代码
       ,''                                                                               -- 股东组织机构类型代码
       ,nvl(trim(t2.countryorregion), 'XXX')                                             -- 国家和地区代码
       ,(case when t2.certtype = '2020' then t2.certid else '' end)                      -- 股东组织机构代码
       ,(case when t2.certtype = '2010' then t2.certid else '' end)                      -- 股东营业执照编号
       ,''                                                                               -- 企业出资人经济成分代码
       ,(case when t2.certtype like '1%' then t2.certtype else '' end)                   -- 自然人股东证件类型代码
       ,(case when t2.certtype like '1%' then t2.certid else '' end)                     -- 自然人股东证件号码
       ,''                                                                               -- 本行股东标志
       ,(case when t2.certtype = '2313' then t2.certid else '' end)                      -- 统一社会信用代码
       ,t2.investmentprop                                                                -- 持股比例
       ,0                                                                                -- 股东持股数量
       ,0                                                                                -- 股东出资比例
       ,(case when t2.relationship = '0401' then '100'
              when t2.relationship = '0402' then '200'
              when t2.relationship = '0403' then '300'
              when t2.relationship = '0404' then '500'
              else '999'
         end)                                                                            -- 出资方式代码
       ,t2.currencytype                                                                  -- 出资币种代码
       ,t2.oughtsum                                                                      -- 出资金额
       ,t2.investmentype                                                                 -- 出资人类型代码
       ,t2.investmentmensftype                                                           -- 出资人身份类别代码
       ,t2.holdstartdate                                                                 -- 入股日期
       ,decode(t2.effstatus, '1', '1', '0')                                              -- 股东有效标志
       ,decode(t2.actualcontroller, '1', '1', '0')                                       -- 实际控制人标志
       ,t2.updatedate                                                                    -- 更新日期
       ,'ICMS'                                                                           -- 来源系统代码
       ,'icmsf1'                                                                         -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                  -- etl处理时间戳
  from ${iol_schema}.icms_customer_relative t1
 /*inner join ${iol_schema}.icms_customer_info t3
    on t1.customerid = t3.customerid
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')*/
 inner join ${iol_schema}.icms_customer_ship_sharehold t2
    on t1.relativeid = t2.serialno
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 /*inner join ${iol_schema}.icms_customer_info t4
    on t2.customerid = t4.customerid
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_ent_info t5
    on t2.customerid = t5.customerid
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_ind_info t6
    on t2.customerid = t6.customerid
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')*/
 where t1.customerid <> 'undefined'
   and t1.relativeid <> 'undefined'
   and t1.customerid not in ('2015090700000114',
                               '2014060300000006',
                               '2013041000000004',
                               '2013120300000025',
                               '2013061300000012',
                               '2013022800000015',
                               '2014061000000019',
                               '2014101700000011',
                               '#OwnerID',
                               '2015081300000033',
                               '5000012272',
                               '5000008154')
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.relationship = '02';
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_shard_info_ex(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,cust_id                        -- 客户编号
       ,shard_cust_id                  -- 股东客户编号
       ,rela_ps_id                     -- 关联人编号
       ,shard_name                     -- 股东名称
       ,shard_type_cd                  -- 股东类型代码
       ,shard_orgnz_type_cd            -- 股东组织机构类型代码
       ,shard_local_nation_cd          -- 国家和地区代码
       ,shard_orgnz_cd                 -- 股东组织机构代码
       ,shard_bus_lics_id              -- 股东营业执照编号
       ,contrior_econ_compnt_cd        -- 企业出资人经济成分代码
       ,nature_ps_shard_cert_type_cd   -- 自然人股东证件类型代码
       ,nature_ps_shard_cert_no        -- 自然人股东证件号码
       ,ghb_shard_flg                  -- 本行股东标志
       ,unify_soci_crdt_cd             -- 统一社会信用代码
       ,share_ratio                    -- 持股比例
       ,shard_hold_shares_qtty         -- 股东持股数量
       ,shard_contri_ratio             -- 股东出资比例
       ,contri_way_cd                  -- 出资方式代码
       ,contri_curr_cd                 -- 出资币种代码
       ,contri_amt                     -- 出资金额
       ,contrior_type_cd               -- 出资人类型代码
       ,contrior_idti_cate_cd          -- 出资人身份类别代码
       ,hold_dt                        -- 入股日期
       ,shard_valid_flg                -- 股东有效标志
       ,actl_ctrler_flg                -- 实际控制人标志
	     ,update_dt                      -- 更新日期
       ,src_sys_cd                     -- 来源系统代码
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select
        t1.etl_dt                                                                    -- 数据日期
        ,t1.lp_id                                                                    -- 法人编号
        ,nvl(trim(t2.cust_id),t1.cust_id)                                            -- 客户编号
        ,nvl(trim(t2.shard_cust_id),t1.shard_cust_id)                                -- 股东客户编号
        ,t1.rela_ps_id                                                               -- 关联人编号
        ,t1.shard_name                                                               -- 股东名称
        ,t1.shard_type_cd                                                            -- 股东类型代码
        ,nvl(trim(t2.shard_orgnz_type_cd),t1.shard_orgnz_type_cd)                    -- 股东组织机构类型代码
        ,coalesce(trim(replace(t2.shard_local_nation_cd,'XXX','')),trim(t1.shard_local_nation_cd),'XXX') -- 国家和地区代码
        ,t1.shard_orgnz_cd                                                           -- 股东组织机构代码
        ,t1.shard_bus_lics_id                                                        -- 股东营业执照编号
        ,nvl(trim(t2.contrior_econ_compnt_cd),t1.contrior_econ_compnt_cd)            -- 企业出资人经济成分代码
        ,t1.nature_ps_shard_cert_type_cd                                             -- 自然人股东证件类型代码
        ,t1.nature_ps_shard_cert_no                                                  -- 自然人股东证件号码
        ,nvl(trim(t2.ghb_shard_flg),t1.ghb_shard_flg)                                -- 本行股东标志
        ,t1.unify_soci_crdt_cd                                                       -- 统一社会信用代码
        ,t1.share_ratio                                                              -- 持股比例
        ,t1.shard_hold_shares_qtty                                                   -- 股东持股数量
        ,t1.shard_contri_ratio                                                       -- 股东出资比例
        ,coalesce(trim(replace(t2.contri_way_cd,'999','')),trim(t1.contri_way_cd),'999') -- 出资方式代码
        ,coalesce(trim(replace(t2.contri_curr_cd,'null','')),trim(t1.contri_curr_cd),'OTH') -- 出资币种代码
        ,nvl(trim(t2.contri_amt),t1.contri_amt)                                      -- 出资金额
        ,nvl(trim(t2.contrior_type_cd),t1.contrior_type_cd)                          -- 出资人类型代码
        ,nvl(trim(t2.contrior_idti_cate_cd),t1.contrior_idti_cate_cd)                -- 出资人身份类别代码
        ,nvl(trim(t2.hold_dt),t1.hold_dt)                                            -- 入股日期
        ,nvl(trim(t2.shard_valid_flg),t1.shard_valid_flg)                            -- 股东有效标志
        ,nvl(trim(t2.actl_ctrler_flg),t1.actl_ctrler_flg)                            -- 实际控制人标志
	    	,nvl(trim(t2.update_dt),t1.update_dt)                                        -- 更新日期
        ,nvl(trim(t2.src_sys_cd),t1.src_sys_cd)                                      -- 来源系统代码
        ,nvl(trim(t2.job_cd),t1.job_cd)                                              -- 任务代码
        ,t1.etl_timestamp                                                            -- 数据处理时间
    from ${icl_schema}.cmm_corp_cust_shard_info_ex01 t1
  left join ${icl_schema}.cmm_corp_cust_shard_info_ex02 t2
       on t1.cust_id = t2.cust_id
      and t1.shard_cust_id = t2.shard_cust_id
      and t1.rela_ps_id =  t2.rela_ps_id
  where 1 = 1 ;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_shard_info_ex(
         etl_dt                         -- 数据日期
        ,lp_id                          -- 法人编号
        ,cust_id                        -- 客户编号
        ,shard_cust_id                  -- 股东客户编号
        ,rela_ps_id                     -- 关联人编号
        ,shard_name                     -- 股东名称
        ,shard_type_cd                  -- 股东类型代码
        ,shard_orgnz_type_cd            -- 股东组织机构类型代码
        ,shard_local_nation_cd          -- 国家和地区代码
        ,shard_orgnz_cd                 -- 股东组织机构代码
        ,shard_bus_lics_id              -- 股东营业执照编号
        ,contrior_econ_compnt_cd        -- 企业出资人经济成分代码
        ,nature_ps_shard_cert_type_cd   -- 自然人股东证件类型代码
        ,nature_ps_shard_cert_no        -- 自然人股东证件号码
        ,ghb_shard_flg                  -- 本行股东标志
        ,unify_soci_crdt_cd             -- 统一社会信用代码
        ,share_ratio                    -- 持股比例
        ,shard_hold_shares_qtty         -- 股东持股数量
        ,shard_contri_ratio             -- 股东出资比例
        ,contri_way_cd                  -- 出资方式代码
        ,contri_curr_cd                 -- 出资币种代码
        ,contri_amt                     -- 出资金额
        ,hold_dt                        -- 入股日期
        ,contrior_type_cd               -- 出资人类型代码
        ,contrior_idti_cate_cd          -- 出资人身份类别代码
        ,shard_valid_flg                -- 股东有效标志
        ,actl_ctrler_flg                -- 实际控制人标志
		    ,update_dt                      -- 更新日期
        ,src_sys_cd                     -- 来源系统代码
        ,job_cd                         -- 任务代码
        ,etl_timestamp                  -- 数据处理时间
)
select
         t1.etl_dt                         -- 数据日期
        ,t1.lp_id                          -- 法人编号
        ,t1.cust_id                        -- 客户编号
        ,t1.shard_cust_id                  -- 股东客户编号
        ,t1.rela_ps_id                     -- 关联人编号
        ,t1.shard_name                     -- 股东名称
        ,t1.shard_type_cd                  -- 股东类型代码
        ,t1.shard_orgnz_type_cd            -- 股东组织机构类型代码
        ,t1.shard_local_nation_cd          -- 国家和地区代码
        ,t1.shard_orgnz_cd                 -- 股东组织机构代码
        ,t1.shard_bus_lics_id              -- 股东营业执照编号
        ,t1.contrior_econ_compnt_cd        -- 企业出资人经济成分代码
        ,t1.nature_ps_shard_cert_type_cd   -- 自然人股东证件类型代码
        ,t1.nature_ps_shard_cert_no        -- 自然人股东证件号码
        ,t1.ghb_shard_flg                  -- 本行股东标志
        ,t1.unify_soci_crdt_cd             -- 统一社会信用代码
        ,t1.share_ratio                    -- 持股比例
        ,t1.shard_hold_shares_qtty         -- 股东持股数量
        ,t1.shard_contri_ratio             -- 股东出资比例
        ,t1.contri_way_cd                  -- 出资方式代码
        ,t1.contri_curr_cd                 -- 出资币种代码
        ,t1.contri_amt                     -- 出资金额
        ,t1.hold_dt                        -- 入股日期
        ,t1.contrior_type_cd               -- 出资人类型代码
        ,t1.contrior_idti_cate_cd          -- 出资人身份类别代码
        ,t1.shard_valid_flg                -- 股东有效标志
        ,t1.actl_ctrler_flg                -- 实际控制人标志
		    ,t1.update_dt                      --更新日期
        ,t1.src_sys_cd                     -- 来源系统代码
        ,t1.job_cd                         -- 任务代码
        ,t1.etl_timestamp                  -- 数据处理时间
  from ${icl_schema}.cmm_corp_cust_shard_info_ex02 t1
 where not exists (select 1 from ${icl_schema}.cmm_corp_cust_shard_info_ex01 t2
                    where t1.cust_id = t2.cust_id
                      and t1.shard_cust_id = t2.shard_cust_id
							        and t1.rela_ps_id =  t2.rela_ps_id);
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_cust_shard_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_cust_shard_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_corp_cust_shard_info_ex purge;
--drop table ${icl_schema}.cmm_corp_cust_shard_info_ex01 purge;
--drop table ${icl_schema}.cmm_corp_cust_shard_info_ex02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_cust_shard_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);