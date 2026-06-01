/*
Purpose:  共性加工层-债券评级信息
Author:   Sunline
Usage:   python $ETL_HOME/script/main.py yyyymmdd icl_cmm_bond_rating_info
CreateDate: 20190808
Logs:				20200627 周沁晖 1、第一组中T2的关联方式调整为LEFT JOIN -> INNER JOIN
														2、增加第二组同业系统的评级信息
														3、增加字段【资产类型编号、债券市场类型代码、债券分类名称】
														4、主键增加字段【评级公司中文名称】
						20210916 陈伟峰 调整主键【数据日期、法人编号、债券编号、评级公司编号、评级公司中文名称、评级日期】->【数据日期、法人编号、债券编号、资产类型编号、债券市场类型代码、评级公司编号、评级公司中文名称、评级日期】
						20220509 陈伟峰 调整资金部分的评级加工逻辑，补充债券自定义字段视图V_SECURITY_CUS_FIELD中债券评级部分数据，当同一笔债券在两者都存在时，优先取原加工来源（债券评级视图V_SECURITY_RATING评级数据）
						20220608 陈健聪 字段评级日期添加转换函数
						20231102 徐子豪 调整【评级日期】加工逻辑，优先从TRPT_TBND_EXT取
						20240819 陈伟峰 新增字段【来源系统标识】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bond_rating_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bond_rating_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bond_rating_info_ex purge;



create table ${icl_schema}.cmm_bond_rating_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_bond_rating_info where 0=1;

--第一组（共三组）资金系统-债券评级
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bond_rating_info_ex(
   etl_dt                      -- 数据日期
   ,lp_id                      -- 法人编号
   ,bond_id                    -- 债券编号
   ,asset_type_id							 -- 资产类型编号
   ,bond_market_type_cd				 -- 债券市场类型代码
   ,rating_corp_id             -- 评级公司编号
   ,rating_corp_cn_name        -- 评级公司中文名称
   ,rating_corp_en_name        -- 评级公司英文名称
   ,bond_name                  -- 债券名称
   ,bond_abbr                  -- 债券简称
   ,bond_type_cd               -- 债券类型代码
   ,bond_cls_name							 -- 债券分类名称
   ,issuer_name                -- 发行人名称
   ,rating_rest_cd             -- 评级结果代码
   ,rating_type_cd             -- 评级类型代码
   ,rating_dt                  -- 评级日期
   ,src_sys_idf                -- 来源系统标识
   ,job_cd                     -- 任务代码
   ,etl_timestamp              -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')             -- 数据日期
   ,t1.lp_id                   -- 法人编号
   ,t1.bond_id                 -- 债券编号
   ,t4.asset_type_id					 -- 资产类型编号
   ,t2.market_type_cd					 -- 债券市场类型代码
   ,t1.rating_org_id           -- 评级公司编号
   ,t3.rating_org_cn_name      -- 评级公司中文名称
   ,t3.rating_org_en_name      -- 评级公司英文名称
   ,t2.bond_id                 -- 债券名称
   ,t2.bond_abbr               -- 债券简称
   ,t2.bond_type_cd            -- 债券类型代码
   ,decode(t2.init_bond_type_cd,'1','国债',
                 '4','企业债',
                 '5','央行票据',
                 '6','短期融资券、证券公司短期融资券',
                 '7','次级债',
                 '8','政策性银行',
                 '9','商业银行',
                 'C','非银行金融债',
                 'D','国营企业',
                 'E','公司债',
                 'F','国际机构、外国主权政府人民币债券、外国地方政府人民币债券',
                 'G','项目收益债券',
                 'H','项目收益票据',
                 'I','分离债',
                 'J','绿色债务融资工具',
                 'K','信用联结票据',
                 'L','资产支持债券、资产支持票据',
                 'M','地方政府债',
                 'N','中期票据',
                 'O','超短期融资券',
                 'P','集合票据',
                 'Q','政府支持机构债',
                 'U','混合资本债',
                 'W','同业存单',
                 'X','二级资本工具','')												 -- 债券分类名称
   ,t2.issuer_name             -- 发行人名称
   ,t1.rating_level            -- 评级结果代码
   ,t1.rating_cate_cd          -- 评级类型代码
   ,${iml_schema}.DATEFORMAT_MIN(t1.rating_dt)               -- 评级日期
   ,'CTMS'                     -- 来源系统标识
   ,t1.job_cd                  -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.prd_bond_rating_h t1
 inner join ${iml_schema}.prd_bond_basic_info T2
    on t1.bond_id = t2.bond_id
   and t2.market_type_cd not in ('01', '02')
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.id_mark <> 'D'
   and t2.job_cd = 'ctmsf1'
  left join ${iml_schema}.pty_bond_rating_org t3
    on t1.rating_org_id = t3.rating_org_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.id_mark <> 'D'
   and t3.job_cd = 'ctmsf1'
  left join ${iml_schema}.prd_ibank_bond t4
  	on t1.bond_id = t4.fin_instm_id
   and t4.market_type_id = 'X_CNBD'
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.id_mark <> 'D'
   and t1.job_cd = 'ctmsf1'
;
commit;

--第二组（共三组）资金系统-债券自定义
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bond_rating_info_ex(
   etl_dt                      -- 数据日期
   ,lp_id                      -- 法人编号
   ,bond_id                    -- 债券编号
   ,asset_type_id							 -- 资产类型编号
   ,bond_market_type_cd				 -- 债券市场类型代码
   ,rating_corp_id             -- 评级公司编号
   ,rating_corp_cn_name        -- 评级公司中文名称
   ,rating_corp_en_name        -- 评级公司英文名称
   ,bond_name                  -- 债券名称
   ,bond_abbr                  -- 债券简称
   ,bond_type_cd               -- 债券类型代码
   ,bond_cls_name							 -- 债券分类名称
   ,issuer_name                -- 发行人名称
   ,rating_rest_cd             -- 评级结果代码
   ,rating_type_cd             -- 评级类型代码
   ,rating_dt                  -- 评级日期
   ,src_sys_idf                -- 来源系统标识
   ,job_cd                     -- 任务代码
   ,etl_timestamp              -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')      -- 数据日期
   ,'9999'                     -- 法人编号
   ,t1.bond_id                 -- 债券编号
   ,t4.asset_type_id					 -- 资产类型编号
   ,t2.market_type_cd					 -- 债券市场类型代码
   ,''                         -- 评级公司编号
   ,t1.rating_corp_cn_name     -- 评级公司中文名称
   ,''                         -- 评级公司英文名称
   ,t2.bond_id                 -- 债券名称
   ,t2.bond_abbr               -- 债券简称
   ,t2.bond_type_cd            -- 债券类型代码
   ,decode(t2.init_bond_type_cd,'1','国债',
                 '4','企业债',
                 '5','央行票据',
                 '6','短期融资券、证券公司短期融资券',
                 '7','次级债',
                 '8','政策性银行',
                 '9','商业银行',
                 'C','非银行金融债',
                 'D','国营企业',
                 'E','公司债',
                 'F','国际机构、外国主权政府人民币债券、外国地方政府人民币债券',
                 'G','项目收益债券',
                 'H','项目收益票据',
                 'I','分离债',
                 'J','绿色债务融资工具',
                 'K','信用联结票据',
                 'L','资产支持债券、资产支持票据',
                 'M','地方政府债',
                 'N','中期票据',
                 'O','超短期融资券',
                 'P','集合票据',
                 'Q','政府支持机构债',
                 'U','混合资本债',
                 'W','同业存单',
                 'X','二级资本工具','')												 -- 债券分类名称
   ,t2.issuer_name             -- 发行人名称
   ,t1.rating_rest_cd            -- 评级结果代码
   ,'-'          -- 评级类型代码
   ,${iml_schema}.DATEFORMAT_MIN(t1.rating_dt)              -- 评级日期
   ,'CTMS'       -- 来源系统标识
   ,'ctmsf1'                   -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from (select security_code as bond_id
              ,max(case when field_id = '123' then  field_value else  ' ' end) as rating_corp_cn_name
              ,max(case when field_id = '124' then  field_value else  ' ' end) as rating_rest_cd
              ,max(case when field_id = '181' then  field_value else  ' ' end) as rating_dt
          from ${iol_schema}.ctms_tbs_v_security_cus_field
         where field_id in ('123','124','181')
           and start_dt <= to_date('${batch_date}','yyyymmdd')
           and end_dt > to_date('${batch_date}','yyyymmdd')
         group by security_code) t1
 inner join ${iml_schema}.prd_bond_basic_info T2
    on t1.bond_id = t2.bond_id
   and t2.market_type_cd not in ('01', '02')
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.id_mark <> 'D'
   and t2.job_cd = 'ctmsf1'
  left join ${iml_schema}.prd_ibank_bond t4
  	on t1.bond_id = t4.fin_instm_id
   and t4.market_type_id = 'X_CNBD'
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.id_mark <> 'D'
 where not exists (select 1 from ${icl_schema}.cmm_bond_rating_info_ex t5 
                    where t1.bond_id=t5.bond_id
                      and ${iml_schema}.DATEFORMAT_MIN(t1.rating_dt)=t5.rating_dt)
;
commit;



--第三组（共三组）同业系统
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bond_rating_info_ex(
   etl_dt                      -- 数据日期
   ,lp_id                      -- 法人编号
   ,bond_id                    -- 债券编号
   ,asset_type_id							 -- 资产类型编号
   ,bond_market_type_cd				 -- 债券市场类型代码
   ,rating_corp_id             -- 评级公司编号
   ,rating_corp_cn_name        -- 评级公司中文名称
   ,rating_corp_en_name        -- 评级公司英文名称
   ,bond_name                  -- 债券名称
   ,bond_abbr                  -- 债券简称
   ,bond_type_cd               -- 债券类型代码
   ,bond_cls_name							 -- 债券分类名称
   ,issuer_name                -- 发行人名称
   ,rating_rest_cd             -- 评级结果代码
   ,rating_type_cd             -- 评级类型代码
   ,rating_dt                  -- 评级日期
   ,src_sys_idf                -- 来源系统标识
   ,job_cd                     -- 任务代码
   ,etl_timestamp              -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')             -- 数据日期
   ,t1.lp_id                   -- 法人编号
   ,t1.fin_instm_id		-- 债券编号
   ,t1.asset_type_id	-- 资产类型编号
   ,t1.market_type_id	-- 债券市场类型代码
   ,''								-- 评级公司编号
   ,t1.rating_org_name-- 评级公司中文名称
   ,''								-- 评级公司英文名称
   ,t2.bond_fname			-- 债券名称
   ,t2.bond_name     	-- 债券简称
   ,''								-- 债券类型代码
   ,t2.prod_cls_name	-- 债券分类名称
   ,t2.issuer_name		-- 发行人名称
   ,t1.crdt_rating_cd -- 评级结果代码
   ,'2'        				-- 评级类型代码
   ,nvl(to_date(decode(t2.bond_item_rating_dt,to_date('29991231','yyyymmdd'),'',t2.bond_item_rating_dt)),t1.input_dt)			-- 评级日期
   ,'IBMS'            -- 来源系统标识
   ,t1.job_cd                  -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from (select lp_id,fin_instm_id,asset_type_id,market_type_id,
               rating_org_name,crdt_rating_cd,input_dt,job_cd,
               row_number() over(partition by fin_instm_id,asset_type_id,market_type_id,lp_id,rating_org_name order by effect_dt desc) rn
          from ${iml_schema}.prd_ibank_bond_ext_rating
         where create_dt <= to_date('${batch_date}','yyyymmdd')
           and effect_dt <= to_date('${batch_date}', 'yyyymmdd') 
 					 and invalid_dt > to_date('${batch_date}', 'yyyymmdd')
           and job_cd = 'ibmsf1'
           and id_mark <> 'D') t1
 inner join ${iml_schema}.prd_ibank_bond t2
    on t1.fin_instm_id = t2.fin_instm_id
   and t1.asset_type_id = t2.asset_type_id
   and t1.market_type_id = t2.market_type_id
   and t2.market_type_id <> 'X_CNBD'
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.id_mark <> 'D'
   and t2.job_cd = 'ibmsf1'
 where t1.rn = 1

;
commit;
-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_bond_rating_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bond_rating_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bond_rating_info_ex purge;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bond_rating_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
